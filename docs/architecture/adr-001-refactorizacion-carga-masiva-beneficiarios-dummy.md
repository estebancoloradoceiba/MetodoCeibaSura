# ADR-001: Refactorización del flujo de carga masiva de beneficiarios con soporte para contactos Dummy

**Estado:** Aprobado  
**Fecha:** 2025-12-22  
**Autor:** esteban.colorado (Arquitecto)  
**Historia Relacionada:** #825041

---

## Contexto

El sistema de Vida Grupo permite carga masiva de beneficiarios mediante un flujo asíncrono de 2 fases (Azure Data Factory + PolicyCenter Workqueues). Actualmente, todos los beneficiarios cargados requieren identificación completa (tipo y número de documento).

### Problema

Los expedidores de pólizas de Vida Grupo necesitan agilizar la emisión de pólizas colectivas sin detenerse por documentos faltantes de beneficiarios. El proceso actual bloquea la emisión si falta identificación de algún beneficiario, causando:

- Retrasos en emisión de pólizas (promedio 2-3 días adicionales por gestión de documentos)
- Reprocesos manuales cuando eventualmente se obtienen los documentos
- Pérdida de eficiencia operativa en departamento de expedición

### Necesidad Adicional

Aprovechar la implementación de esta funcionalidad para **refactorizar el flujo completo de carga masiva** y eliminar deuda técnica acumulada:

1. **Código deprecado**: Referencia a `TC_ADDITIONALINTEREST` (versión antigua) duplicada en 3 componentes
2. **Escalabilidad limitada**: Lógica de creación de contactos hardcodeada en transformador
3. **Mantenibilidad baja**: Condicionales anidados dificultan extensión y testing
4. **Reutilización nula**: Flujo uno-a-uno de contactos Dummy (UI) no es aprovechado por flujo masivo

---

## Decisión

Se decide implementar **Strategy Pattern + Factory Pattern** para separar responsabilidades de creación de contactos, permitiendo:

1. Soportar beneficiarios sin identificación (Dummy) mediante reutilización de entidades existentes (PersonDummy_Ext, CompanyDummy_Ext)
2. Refactorizar componentes clave para mejorar escalabilidad y mantenibilidad
3. Eliminar código deprecado (TC_ADDITIONALINTEREST)
4. Reutilizar infraestructura del flujo uno-a-uno (ContactUtil.createNewContactDummy())

### Arquitectura Propuesta

```
┌─────────────────────────────────────────────────────────────────┐
│ DefaultBeneficiaryTransformer                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ createInterestContingent()                                 │ │
│  │   ↓                                                        │ │
│  │   ContactCreationStrategyFactory.getStrategy()             │ │
│  │   ↓                                                        │ │
│  │   Strategy.createContact() ──────────┬─────────────────┐  │ │
│  │                                      │                 │  │ │
│  │                            ┌─────────▼────────┐  ┌─────▼──────┐ │
│  │                            │ DummyStrategy    │  │ CompleteStr │ │
│  │                            │ (ContactUtil)    │  │ (IContactPl)│ │
│  │                            └──────────────────┘  └─────────────┘ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Componentes Nuevos

| Componente | Responsabilidad | Justificación |
|------------|-----------------|---------------|
| **ContactCreationStrategy** (Interface) | Contrato para estrategias de creación | Define API común, permite tests independientes |
| **DummyContactCreationStrategy** | Crear PersonDummy_Ext o CompanyDummy_Ext | Encapsula lógica Dummy, reutiliza ContactUtil |
| **CompleteContactCreationStrategy** | Crear contactos completos | Encapsula comportamiento actual, facilita testing |
| **ContactCreationStrategyFactory** | Seleccionar estrategia basándose en datos | Centraliza tabla de decisión, separa validación |

### Decisiones Técnicas Clave

1. **Determinación automática Persona vs Compañía:**
   - **Decisión:** Si PRIMER_APELLIDO_BENEFICIARIO_X vacío → CompanyDummy, sino → PersonDummy
   - **Alternativa descartada:** Campo adicional en CSV
   - **Razón:** Mantener plantilla sin cambios (requisito de negocio)

2. **Validación de integridad en Fase 2 (no Fase 1):**
   - **Decisión:** Azure valida formato, PolicyCenter valida negocio
   - **Alternativa descartada:** Validar en Azure con regex complejo
   - **Razón:** Separación de responsabilidades, facilita debugging

3. **Reutilizar ContactUtil del flujo uno-a-uno:**
   - **Decisión:** DummyContactCreationStrategy usa ContactUtil.createNewContactDummy()
   - **Alternativa descartada:** Reimplementar lógica en transformador
   - **Razón:** DRY, coherencia entre flujos, mantenibilidad

4. **Eliminar TC_ADDITIONALINTEREST como paso inicial:**
   - **Decisión:** Limpiar código deprecado antes de agregar funcionalidad
   - **Alternativa descartada:** Eliminar después de implementar Dummy
   - **Razón:** Evitar conflictos, reducir superficie de testing

---

## Consecuencias

### Positivas ✅

1. **Escalabilidad mejorada:**
   - Agregar nuevos tipos de contactos solo requiere implementar nueva Strategy (sin modificar core)
   - Factory centraliza decisiones, facilitando extensión

2. **Mantenibilidad aumentada:**
   - Código modular y testeable independientemente
   - Eliminación de 200+ líneas de código deprecado
   - Reducción de complejidad ciclomática en DefaultBeneficiaryTransformer

3. **Reutilización efectiva:**
   - ContactUtil del flujo uno-a-uno aprovechado en flujo masivo
   - Entidades PersonDummy_Ext y CompanyDummy_Ext consistentes entre flujos

4. **Deuda técnica reducida:**
   - TC_ADDITIONALINTEREST eliminado completamente
   - Lógica duplicada consolidada en Factory

5. **Testing mejorado:**
   - Cada Strategy es unit-testeable independientemente
   - Factory permite tests parameterizados con tabla de decisión

### Negativas ⚠️

1. **Complejidad inicial aumentada:**
   - Agregar Factory Pattern aumenta número de clases (4 nuevas)
   - Curva de aprendizaje para desarrolladores nuevos
   - **Mitigación:** Documentación exhaustiva, diagramas de secuencia

2. **Refactorización requiere testing exhaustivo:**
   - Eliminar TC_ADDITIONALINTEREST impacta 3 componentes
   - Tests de regresión críticos para cargas de Riesgos existentes
   - **Mitigación:** Suite de 50+ tests automatizados, despliegue gradual con feature flag

3. **Performance overhead mínimo:**
   - Factory Pattern agrega 1 llamada adicional por registro (~<1ms)
   - Type checking en CommonTransformer agrega validaciones
   - **Mitigación:** Negligible en contexto de procesamiento batch (miles de registros)

4. **Modificación de Azure regex es crítica:**
   - Regex complejo (4000+ caracteres) - alto riesgo de error
   - Sin este cambio, todo el desarrollo es inútil
   - **Mitigación:** Validación exhaustiva con dataset de 100+ variaciones, backup de regex anterior

### Riesgos Identificados

| Riesgo | Impacto | Probabilidad | Mitigación |
|--------|---------|--------------|------------|
| Refactorización rompe cargas de Riesgos | CRÍTICO | Media | Tests regresión 50+ casos, feature flag para rollback rápido |
| Regex modificado rechaza casos válidos | Alto | Baja | Dataset de validación 100+ variaciones, fallback a regex anterior |
| Strategy Pattern agrega complejidad innecesaria | Medio | Baja | ADR documenta decisión, diagramas clarifican arquitectura |
| ContactUtil falla en procesamiento batch | Alto | Muy Baja | Validación thread-safety, logs detallados, pruebas de volumen |

---

## Alternativas Consideradas

### Alternativa 1: Implementación Mínima sin Refactorización

**Descripción:** Solo agregar condicional inline en DefaultBeneficiaryTransformer para detectar campos vacíos y llamar ContactUtil.

**Pros:**
- Cambio mínimo (5-10 líneas de código)
- Menor riesgo de regresión
- Tiempo de implementación más corto (1-2 días vs 5-7 días)

**Contras:**
- No elimina deuda técnica (TC_ADDITIONALINTEREST permanece)
- Agrega más condicionales anidados (mantenibilidad peor)
- No escala para futuros tipos de contactos
- Testing más difícil (múltiples branches en un método)

**Razón de Descarte:** Enfoque cortoplacista. Genera más deuda técnica sin resolver problemas estructurales. Próxima historia similar requerirá otra refactorización.

---

### Alternativa 2: Crear Flujo Paralelo para Dummy

**Descripción:** Duplicar flujo de carga masiva completo (PCF, JavaScript, Azure pipelines, Workqueues) específico para Dummy.

**Pros:**
- Aislamiento total (sin riesgo de afectar flujo actual)
- Libertad completa de diseño

**Contras:**
- Duplicación masiva de infraestructura (20+ archivos)
- Mantenimiento duplicado (bugs deben arreglarse en 2 lugares)
- Confusión para usuarios (¿cuál flujo usar?)
- Costo de infraestructura Azure (pipelines adicionales)

**Razón de Descarte:** Viola principio DRY. Genera deuda técnica exponencial. Insostenible a largo plazo.

---

### Alternativa 3: Modificar Plantilla CSV para columna explícita "TIPO_CONTACTO"

**Descripción:** Agregar columna en CSV donde usuario especifica "DUMMY" o "COMPLETO" explícitamente.

**Pros:**
- Eliminación de lógica de inferencia (apellido vacío = compañía)
- Control total del usuario
- Sin ambigüedad en casos edge

**Contras:**
- Cambio visible a usuarios (capacitaciones, documentación)
- Validación de 1000+ archivos CSV históricos
- Resistencia de negocio (plantilla "funciona bien así")
- Complejidad adicional en UI de descarga de plantilla

**Razón de Descarte:** Requisito de negocio explícito: "No modificar plantilla existente". Determinación automática es suficiente para casos de uso reales.

---

## Orden de Implementación

### Fase 1: Habilitar Azure (CRÍTICO)
1. Modificar `VidaGrupoIAC/modules/datafactory/controlSchema/Beneficiaries/regex.csv`
2. Validar con dataset de 100+ variaciones

### Fase 2: Limpieza
3. Eliminar TC_ADDITIONALINTEREST de TransformerFactoryProducer, OperationValidationFactory, EnrichmentProcessing
4. Tests de regresión completos

### Fase 3: Estrategias
5. Crear ContactCreationStrategy (interface)
6. Implementar DummyContactCreationStrategy
7. Implementar CompleteContactCreationStrategy
8. Implementar ContactCreationStrategyFactory

### Fase 4: Refactorización
9. Refactorizar DefaultBeneficiaryTransformer
10. Extender CommonTransformer.contactToAdditionalInterest()

### Fase 5: Testing
11. Suite E2E con 6 escenarios de aceptación

---

## Métricas de Éxito

| Métrica | Baseline | Target | Método de Medición |
|---------|----------|--------|-------------------|
| **Cobertura de tests** | 65% | 85%+ | JaCoCo en transformadores y estrategias |
| **Complejidad ciclomática DefaultBeneficiaryTransformer** | 15 | <8 | SonarQube analysis |
| **Líneas de código deprecado** | 200+ | 0 | Búsqueda de TC_ADDITIONALINTEREST |
| **Tiempo de procesamiento Fase 2** | 5 min/100 registros | <6 min/100 registros | Logs de Workqueue Enrichment |
| **Tasa de error regresión** | N/A | 0% | Tests de cargas Riesgos existentes |

---

## Referencias

- [Historia #825041](../stories/825041.habilitar-creacion-de-beneficiarios-dummy-por-carga-masiva-en-vida-grupo.story.md)
- [Flujo de Carga Masiva](./flujo-carga-masiva-riesgos-beneficiarios.md)
- [GPS Arquitectónico](./index.md)
- [ContactUtil.gs](../../PolicyCenter/modules/configuration/gsrc/sura/pc/util/ContactUtil.gs)

---

## Aprobación

| Rol | Nombre | Fecha | Firma |
|-----|--------|-------|-------|
| **Arquitecto** | esteban.colorado | 2025-12-22 | ✅ Aprobado |
| **Tech Lead** | - | Pendiente | - |
| **Product Owner** | - | Pendiente | - |

---

## Notas de Revisión

**2025-12-22 (esteban.colorado):**
- Decisión tomada después de análisis exhaustivo de código existente (paso 1.5 de workflow)
- Validación de 10+ archivos de código fuente confirmó viabilidad de refactorización
- Enfoque exploratorio con consideraciones técnicas específicas del arquitecto
- Todos los riesgos identificados tienen mitigaciones claras
- Orden de implementación validado con dependencias técnicas reales

---

_Este ADR documenta la decisión arquitectónica para la Historia #825041. Para cambios futuros a esta decisión, crear un nuevo ADR que superseda este._
