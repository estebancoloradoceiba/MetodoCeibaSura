-- ==================================================================================
-- QUERIES DE WORKQUEUE 2 PARA DEBUGGING DE REGISTROS CON VALORES NEGATIVOS
-- ==================================================================================
-- ACTUALIZADO: Ahora incluye UNION ALL para devoluciones (disbursements)
-- ==================================================================================

-- PARÁMETROS DE EJEMPLO (reemplazar con valores reales de un registro problemático):
-- :invoice_number = '123456789'  (invoice_number del registro atascado)
-- :tax_id = '900123456'          (tax_id del registro)
-- :collective_invoice_number = 'COLL-2024-001'  (collective_invoice_number)

-- ==================================================================================
-- 1. CÁLCULO DE PRIMA DE VIDA (GetLifePremiumService) - ACTUALIZADO
-- ==================================================================================

-- 1.1 Query: getCoverageTotalAmountFromInvoiceNumber
-- NOTA: Ahora busca en BC_INVOICE (facturas) Y BC_DISBURSEMENT (devoluciones)
-- Los valores de devoluciones se multiplican por -1 para convertirlos a positivos
SELECT SUM(amount_amt) AS COVERAGE_TOTAL_AMOUNT
FROM (
    -- Facturas (valores positivos)
    SELECT bic.amount_amt 
    FROM adm_gwbc.bcx_bicoverage_ext bic
    JOIN adm_gwbc.bc_billinginstruction bi ON bic.billinginstruction = bi.id
    JOIN adm_gwbc.bc_charge c ON bi.id = c.billinginstructionid
    JOIN adm_gwbc.bc_chargepattern cp ON cp.id = c.chargepatternid
    JOIN adm_gwbc.bc_invoiceitem ii ON ii.chargeid = c.id
    JOIN adm_gwbc.bc_invoice i ON ii.invoiceid = i.id
    WHERE i.invoicenumber = :invoice_number
      AND cp.category = 3
    
    UNION ALL
    
    -- Devoluciones (valores negativos convertidos a positivos)
    SELECT bic.amount_amt * -1 as amount_amt 
    FROM adm_gwbc.bcx_bicoverage_ext bic
    JOIN adm_gwbc.bc_billinginstruction bi ON bic.billinginstruction = bi.id
    JOIN adm_gwbc.bc_basenonrecdistitem bnd ON bi.id = bnd.billinginstructionid
    JOIN adm_gwbc.bc_disbursement disb ON disb.id = bnd.disbursement_ext
    WHERE disb.invoiceassociated_ext = :invoice_number
      AND bnd.retired = 0
      AND bnd.subtype = 7
      AND bnd.charge_ext = 3
);

-- 1.2 Query: getInvoiceItemAmountsFromInvoiceNumber
-- NOTA: Ahora incluye BASENONRECDISTITEM para devoluciones
SELECT invoiceItemAmount, originalGrossAmount
FROM (
    -- Facturas
    SELECT 
        ii.amount AS invoiceItemAmount,
        ii.originalgrossamont_ext_amt AS originalGrossAmount
    FROM adm_gwbc.bc_invoiceitem ii
    JOIN adm_gwbc.bc_invoice i ON ii.invoiceid = i.id
    JOIN adm_gwbc.bc_charge c ON ii.chargeid = c.id
    JOIN adm_gwbc.bc_chargepattern cp ON cp.id = c.chargepatternid
    WHERE i.invoicenumber = :invoice_number
      AND cp.category = 3
    
    UNION ALL
    
    -- Devoluciones
    SELECT 
        bnd.grossamounttoapply * -1 AS invoiceItemAmount,
        bnd.grossamounttoapply * -1 AS originalGrossAmount
    FROM adm_gwbc.bc_basenonrecdistitem bnd
    JOIN adm_gwbc.bc_disbursement disb ON disb.id = bnd.disbursement_ext
    WHERE disb.invoiceassociated_ext = :invoice_number
      AND bnd.retired = 0
      AND bnd.subtype = 7
      AND bnd.charge_ext = 3
);

-- 1.3 Query: getLifeCoverageAmountFromInvoiceNumber
-- NOTA: Ahora busca LifeCov en facturas Y devoluciones
SELECT coverageCode, amount
FROM (
    -- Facturas
    SELECT 
        bic.code AS coverageCode,
        bic.amount_amt AS amount
    FROM adm_gwbc.bcx_bicoverage_ext bic
    JOIN adm_gwbc.bc_billinginstruction bi ON bic.billinginstruction = bi.id
    JOIN adm_gwbc.bc_charge c ON bi.id = c.billinginstructionid
    JOIN adm_gwbc.bc_chargepattern cp ON cp.id = c.chargepatternid
    JOIN adm_gwbc.bc_invoiceitem ii ON ii.chargeid = c.id
    JOIN adm_gwbc.bc_invoice i ON ii.invoiceid = i.id
    WHERE i.invoicenumber = :invoice_number
      AND cp.category = 3
      AND bic.code = 'LifeCov'
    
    UNION ALL
    
    -- Devoluciones
    SELECT 
        bic.code AS coverageCode,
        bic.amount_amt * -1 AS amount
    FROM adm_gwbc.bcx_bicoverage_ext bic
    JOIN adm_gwbc.bc_billinginstruction bi ON bic.billinginstruction = bi.id
    JOIN adm_gwbc.bc_basenonrecdistitem bnd ON bi.id = bnd.billinginstructionid
    JOIN adm_gwbc.bc_disbursement disb ON disb.id = bnd.disbursement_ext
    WHERE disb.invoiceassociated_ext = :invoice_number
      AND bnd.retired = 0
      AND bnd.subtype = 7
      AND bnd.charge_ext = 3
      AND bic.code = 'LifeCov'
)
FETCH FIRST 1 ROW ONLY;

-- ==================================================================================
-- 2. CÁLCULO DE TOTAL AFILIADO PREMIUM (GetTotalAffiliatePremiumService - Criterio 4)
-- ==================================================================================
SELECT TOTAL_VALUE_PER_INSURED AS TOTAL_AFFILIATE_PREMIUM
FROM detail_charge_items
WHERE TAX_ID = :tax_id
  AND COLLECTIVE_INVOICE_NUMBER = :collective_invoice_number;

-- ==================================================================================
-- 3. CÁLCULO DE INFORMACIÓN DE COBERTURAS (GetInfoCoverageService)
-- ==================================================================================
SELECT DISTINCT 
    offering_type.TYPECODE AS OFFERING,
    pc_lcov.CHOICETERM1,
    pc_lcov.CHOICETERM2,
    pc_lcov.CHOICETERM3,
    pc_lcov.CHOICETERM4,
    pc_lcov.CHOICETERM5,
    pc_lcov.DIRECTTERM1,
    pc_lcov.DIRECTTERM2,
    pc_lcov.DIRECTTERM3,
    pc_lcov.DIRECTTERM4,
    pc_lcov.DIRECTTERM5,
    pc_lcov.DIRECTTERM6,
    pc_lcov.DIRECTTERM7,
    pc_lcov.PERCENTAGETERM1,
    pc_lcov.PERCENTAGETERM2,
    pc_lcov.PERCENTAGETERM3,
    pc_pl.SALARY,
    pc_lcov.PATTERNCODE AS COVERAGE_TERM,
    ple.CAPITALMAX AS MAXIMUM_CAPITAL
FROM ADM_GWPC.PC_JOB pc_jb
JOIN ADM_GWPC.PC_POLICYPERIOD pc_pp ON pc_pp.JOBID = pc_jb.ID
JOIN ADM_GWBC.BC_POLICYPERIOD bc_pp ON pc_pp.POLICYNUMBER = bc_pp.POLICYNUMBER
JOIN ADM_GWPC.PC_POLICYLINE pc_pl ON pc_pp.ID = pc_pl.BRANCHID
JOIN ADM_GWPC.PCX_LIFECOV pc_lcov ON pc_pl.BRANCHID = pc_lcov.BRANCHID
JOIN ADM_GWBC.BCTL_CPPOFFERINGTYPE_EXT offering_type ON offering_type.TYPECODE = bc_pp.OFFERING_EXT
LEFT JOIN ADM_GWPC.PC_POLICYPERIOD pc_ppm ON pc_ppm.POLICYNUMBER = :master_policy_number
LEFT JOIN ADM_GWPC.PCX_LFMASTERPARTCONDITION_EXT ple ON ple.BRANCHID = pc_ppm.ID 
    AND ple.COVERAGECODE = pc_lcov.PATTERNCODE
WHERE pc_jb.JOBNUMBER = :job_number;

-- ==================================================================================
-- 4. QUERY PARA IDENTIFICAR REGISTROS ATASCADOS EN ESTADO=2
-- ==================================================================================
SELECT 
    id,
    invoice_number,
    collective_invoice_number,
    tax_id,
    amount,
    total_value_per_insured,
    status,
    creation_date,
    lock_date,
    lock_id
FROM detail_charge_items
WHERE status = 2
ORDER BY creation_date ASC;

-- ==================================================================================
-- 5. QUERY PARA VER REGISTROS CON VALORES NEGATIVOS
-- ==================================================================================
SELECT 
    id,
    invoice_number,
    collective_invoice_number,
    tax_id,
    amount,
    total_value_per_insured,
    status,
    creation_date
FROM detail_charge_items
WHERE amount < 0
   OR total_value_per_insured < 0
ORDER BY creation_date DESC;

-- ==================================================================================
-- 6. QUERY PARA VERIFICAR SI UN INVOICE_NUMBER ES FACTURA O DEVOLUCIÓN
-- ==================================================================================
-- Este query ayuda a identificar si el invoice_number pertenece a una factura
-- o a una devolución (disbursement)

-- Buscar en BC_INVOICE (facturas)
SELECT 'FACTURA' AS TIPO, i.invoicenumber, i.amount
FROM adm_gwbc.bc_invoice i
WHERE i.invoicenumber = :invoice_number
  AND i.retired = 0

UNION ALL

-- Buscar en BC_DISBURSEMENT (devoluciones)
SELECT 'DEVOLUCIÓN' AS TIPO, disb.invoiceassociated_ext AS invoicenumber, disb.amount
FROM adm_gwbc.bc_disbursement disb
WHERE disb.invoiceassociated_ext = :invoice_number
  AND disb.retired = 0;

-- ==================================================================================
-- 7. QUERY PARA VER ITEMS MARCADOS COMO ERROR POR EL FIX
-- ==================================================================================
SELECT 
    id,
    invoice_number,
    collective_invoice_number,
    tax_id,
    amount,
    total_value_per_insured,
    status,
    creation_date,
    lock_date
FROM detail_charge_items
WHERE status = -1  -- ERROR
  AND lock_date >= TRUNC(SYSDATE)  -- Hoy
ORDER BY lock_date DESC;

-- ==================================================================================
-- INSTRUCCIONES DE USO ACTUALIZADAS:
-- ==================================================================================
-- 1. Ejecutar query #4 para obtener lista de registros atascados en estado=2
-- 2. Copiar un invoice_number de un registro problemático
-- 3. Ejecutar query #6 para verificar si es FACTURA o DEVOLUCIÓN
-- 4. Ejecutar queries 1.1, 1.2, 1.3 reemplazando :invoice_number
-- 5. ESPERADO PARA DEVOLUCIONES:
--    - Los queries ahora deben retornar datos (antes retornaban NULL/vacío)
--    - Los valores de amount_amt se multiplican por -1 para convertir negativos en positivos
-- 6. Si aún retornan NULL/vacío, revisar:
--    - bnd.subtype = 7 (correcto?)
--    - bnd.charge_ext = 3 (correcto?)
--    - bic.code = 'LifeCov' (existe para devoluciones?)
-- ==================================================================================
