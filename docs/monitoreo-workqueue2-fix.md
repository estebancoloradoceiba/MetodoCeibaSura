# Monitoreo de Fix WorkQueue 2 - Manejo de Errores por Item

## 🎯 Problema Resuelto

**Antes:** Cuando un item individual fallaba en el cálculo de valores (primas, coberturas), el WorkQueue 2 completo se detenía con .stop() y TODOS los registros permanecían en estado=2.

**Después:** Cada item se procesa independientemente. Si uno falla, se marca como ERROR (estado=-1) en la base de datos y el procesamiento continúa con los demás items.

---

## 📝 Cambios Implementados

### 1. **WorkQueueTwoRoute.java** (Línea ~28)
**Antes:**
```java
private void handleExceptions() {
    onException(Exception.class)
        .handled(true)
        .log(HANDLER_EXCEPTION_ERROR)
        .log(HANDLER_EXCEPTION_CAUSE)
        .log(HANDLER_EXCEPTION_STACKTRACE)
        .setBody(constant(WORK_QUEUE_TWO_ERROR_PROCESSING))
        .stop();  // ❌ Detenía TODO el procesamiento
}
```

**Después:**
```java
private void handleExceptions() {
    onException(Exception.class)
        .handled(true)
        .log(HANDLER_EXCEPTION_ERROR)
        .log(HANDLER_EXCEPTION_CAUSE)
        .log(HANDLER_EXCEPTION_STACKTRACE)
        .setBody(constant(WORK_QUEUE_TWO_ERROR_PROCESSING));
    // ✅ Sin .stop() - permite que otros items continúen
}
```

### 2. **CompleteDetailChargeItemProcessor.java**
**Agregado:** Try-catch individual con logging detallado y actualización de estado ERROR en BD.

```java
@Override
public void process(Exchange exchange) {
    var detailChargeItemData = exchange.getIn().getBody(DetailChargeItemDTO.class);
    String itemId = detailChargeItemData.getId();

    try {
        // Procesamiento normal...
        ReportLine reportLine = completeDetailChargeItemService.completeItem(...);
        exchange.getIn().setBody(reportLine, ReportLine.class);

    } catch (Exception e) {
        // ✅ Log detallado con información del item fallido
        LOGGER.error("Error procesando item {}: Invoice={}, TaxId={}, Amount={}, Error: {}",
                itemId,
                detailChargeItemData.getInvoiceNumber(),
                detailChargeItemData.getTaxId(),
                detailChargeItemData.getAmount(),
                e.getMessage(), e);

        // ✅ Marcar item como ERROR en BD
        try {
            detailChargeItemCommand.updateStatus(ERROR.getCode(), itemId);
            LOGGER.info("Item {} marcado como ERROR en base de datos", itemId);
        } catch (Exception updateError) {
            LOGGER.error("Error al actualizar estado ERROR para item {}: {}", 
                itemId, updateError.getMessage());
        }

        // ✅ No propagar excepción - permite que otros items continúen
        exchange.getIn().setBody(null);
    }
}
```

### 3. **ApplicationServiceRegistry.java** (Línea ~183)
**Antes:**
```java
var wq2CompleteItemProcessor = new CompleteDetailChargeItemProcessor(wq2CompleteItemService);
```

**Después:**
```java
var wq2CompleteItemProcessor = new CompleteDetailChargeItemProcessor(
    wq2CompleteItemService, 
    commandPortItem  // ✅ Inyectar comando para actualizar BD
);
```

---

## 🔍 Cómo Monitorear el Fix

### 1. **Revisar Logs de Aplicación**
Buscar logs con el nuevo formato:

```log
ERROR - Error procesando item <UUID>: Invoice=123456, TaxId=900123456, Amount=-150000, Error: ...
INFO  - Item <UUID> marcado como ERROR en base de datos
```

**Información crítica en cada log:**
- **itemId**: UUID del registro fallido
- **Invoice**: Número de factura
- **TaxId**: Identificación tributaria
- **Amount**: Monto (verificar si es negativo)
- **Error**: Mensaje de la excepción raíz

### 2. **Query SQL para Monitorear Items con ERROR**
```sql
-- Items que fueron marcados como ERROR por el nuevo fix
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
ORDER BY lock_date DESC
FETCH FIRST 100 ROWS ONLY;
```

### 3. **Query para Verificar que Items Exitosos Avanzan**
```sql
-- Items que avanzaron exitosamente después del fix
SELECT 
    status,
    COUNT(*) AS total_items
FROM detail_charge_items
WHERE lock_date >= TRUNC(SYSDATE)  -- Hoy
GROUP BY status
ORDER BY status;
```

**Resultado esperado:**
- Estado 2 (PROGRESO): Debería bajar drásticamente
- Estado 3 (LISTO_PARA_ENVIAR): Debería aumentar
- Estado 4 (ENVIADO): Debería aumentar
- Estado -1 (ERROR): Items con valores negativos u otros problemas

### 4. **Verificar Correlación entre Valores Negativos y Errores**
```sql
-- Verificar si los items con ERROR tienen valores negativos
SELECT 
    CASE 
        WHEN amount < 0 OR total_value_per_insured < 0 THEN 'Valores Negativos'
        ELSE 'Valores Positivos'
    END AS tipo_valor,
    COUNT(*) AS total_items
FROM detail_charge_items
WHERE status = -1
  AND lock_date >= TRUNC(SYSDATE)
GROUP BY 
    CASE 
        WHEN amount < 0 OR total_value_per_insured < 0 THEN 'Valores Negativos'
        ELSE 'Valores Positivos'
    END;
```

---

## 🧪 Testing del Fix

### Test 1: Procesamiento Paralelo Exitoso
**Objetivo:** Verificar que items buenos se procesan aunque haya items con error.

1. Ejecutar query para ver estado inicial:
```sql
SELECT status, COUNT(*) FROM detail_charge_items GROUP BY status;
```

2. Esperar 1 hora (siguiente ejecución de WQ2)

3. Verificar que:
   - Items con valores positivos avanzan a estado 3 o 4
   - Items con valores negativos quedan en estado -1
   - NO hay items atascados en estado 2

### Test 2: Logs Detallados
**Objetivo:** Verificar que cada error se loguea con información completa.

1. Revisar logs de aplicación
2. Buscar patrón: "Error procesando item"
3. Verificar que cada log contiene:
   - UUID del item
   - Invoice number
   - Tax ID
   - Amount
   - Stack trace completo

### Test 3: Actualización de Base de Datos
**Objetivo:** Confirmar que items con error se marcan correctamente.

```sql
-- Verificar items marcados como ERROR en última hora
SELECT 
    id,
    invoice_number,
    amount,
    status,
    lock_date
FROM detail_charge_items
WHERE status = -1
  AND lock_date >= SYSDATE - INTERVAL '1' HOUR
ORDER BY lock_date DESC;
```

---

## 🐛 Debugging de Items con ERROR

### Paso 1: Identificar Item Problemático
```sql
SELECT * FROM detail_charge_items 
WHERE status = -1 
ORDER BY lock_date DESC 
FETCH FIRST 1 ROW ONLY;
```

### Paso 2: Ejecutar Queries de Diagnóstico
Ver archivo: **queries-calculo-workqueue2.sql**

Reemplazar parámetros con valores del item problemático:
- :invoice_number
- :tax_id
- :collective_invoice_number

### Paso 3: Identificar Causa Raíz

**Posibles causas:**

1. **Query 1.1 retorna NULL:** Factura no tiene coberturas en BillingCenter
2. **Query 1.2 retorna vacío:** No hay invoice items con category=3
3. **Query 1.3 retorna vacío:** No existe cobertura 'LifeCov'
4. **Query 2 retorna NULL:** No hay otros registros con mismo TAX_ID
5. **Query 3 retorna vacío:** JobNumber no existe en PolicyCenter

### Paso 4: Correlacionar con Logs

```bash
# Buscar en logs el UUID del item problemático
grep "<UUID_DEL_ITEM>" application.log
```

---

## 📊 Métricas de Éxito

### Antes del Fix:
- ❌ 100% items atascados en estado=2 cuando 1 item fallaba
- ❌ Sin información de qué item causaba el error
- ❌ Procesamiento bloqueado indefinidamente

### Después del Fix:
- ✅ Solo items con error quedan en estado=-1
- ✅ Items exitosos avanzan a estado=3 y 4
- ✅ Logs detallados con Invoice, TaxId, Amount de cada error
- ✅ Procesamiento continúa sin bloquearse

### KPIs a Monitorear:

```sql
-- Dashboard de estado del WorkQueue 2
SELECT 
    CASE status
        WHEN 1 THEN 'PENDIENTE'
        WHEN 2 THEN 'PROGRESO (⚠️ atascado si permanece)'
        WHEN 3 THEN 'LISTO_PARA_ENVIAR'
        WHEN 4 THEN 'ENVIADO'
        WHEN 5 THEN 'CERRADO'
        WHEN -1 THEN 'ERROR'
    END AS estado_descripcion,
    COUNT(*) AS total_items,
    MIN(creation_date) AS item_mas_antiguo,
    MAX(creation_date) AS item_mas_reciente
FROM detail_charge_items
GROUP BY status
ORDER BY status;
```

**Alerta si:**
- Estado 2 (PROGRESO) > 10 items durante más de 2 horas
- Estado -1 (ERROR) aumenta drásticamente (>50% de items procesados)

---

## 🔄 Próximos Pasos

1. **Análisis de Causa Raíz:**
   - Ejecutar queries de diagnóstico en items con ERROR
   - Identificar patrón común (valores negativos, facturas específicas, etc.)

2. **Decisión de Negocio:**
   - ¿Items con valores negativos deben marcarse como CERRADO en lugar de ERROR?
   - ¿Se necesita validación previa antes de calcular valores?
   - ¿Devoluciones deben procesarse con lógica diferente?

3. **Mejora Futura (Opcional):**
   - Agregar campo rror_message en tabla para almacenar causa específica
   - Implementar retry con backoff exponencial para errores transitorios
   - Crear endpoint REST para re-procesar items en ERROR manualmente

---

**Archivo creado:** 2025-11-28 15:01:14
