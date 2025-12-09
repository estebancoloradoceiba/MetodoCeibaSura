# Ciclo Completo de Incidente

## Descripción
Meta-workflow que ejecuta el ciclo técnico de resolución de incidentes en el Método Ceiba, adaptándose automáticamente según la prioridad del incidente. Orquesta los workflows técnicos necesarios para resolver el incidente desde el diagnóstico hasta la documentación del conocimiento adquirido.

**IMPORTANTE**: Este workflow requiere que el incidente haya sido previamente recibido y clasificado con `po *recibir-error`. El PO debe ejecutar primero la recepción del incidente de forma independiente.

## Flujos Adaptativos

Este meta-workflow implementa dos flujos distintos según la prioridad del incidente:

### 🚨 Flujo Crítico (P0-P1) - Resolución Urgente

```
Incidente Crítico (Ya Recibido por PO)
       ↓
┌──────────────────────┐
│ 1. Diagnóstico       │ → Metodología 5 Whys
└──────────────────────┘ → Causa raíz identificada
       ↓
┌──────────────────────┐
│ 2. Refinamiento      │ → Rápido y enfocado
│    Urgente           │ → Sin estimación formal
└──────────────────────┘
       ↓
┌──────────────────────┐
│ 3. Desarrollo        │ → Fix urgente
│    Urgente           │ → Con tests
└──────────────────────┘
       ↓
┌──────────────────────┐
│ 4. Revisión          │ → Expedita
│    Expedita          │ → Enfocada en no-regresión
└──────────────────────┘
       ↓
┌──────────────────────┐
│ 5. Post-Mortem       │ → Obligatorio
│    (Obligatorio)     │ → Actualización de KB
└──────────────────────┘
       ↓
    ✅ Resuelto
```

**Características**:
- ⚡ Proceso expedito sin pasos opcionales
- 🚫 NO incluye análisis arquitectónico profundo
- 🚫 NO requiere estimación formal
- ✅ Revisión rápida pero obligatoria
- ✅ Post-mortem obligatorio

### 🔧 Flujo Normal (P2-P4) - Proceso Completo

```
Incidente Normal (Ya Recibido por PO)
       ↓
┌──────────────────────┐
│ 1. Diagnóstico       │ → Metodología 5 Whys
└──────────────────────┘ → Causa raíz identificada
       ↓
┌──────────────────────┐
│ 2. Análisis          │ → OPCIONAL
│    Arquitectónico    │ → Solo si hay impacto
└──────────────────────┘   significativo
       ↓
┌──────────────────────┐
│ 3. Refinamiento      │ → Detallado
│    Técnico           │ → Descomposición en tareas
└──────────────────────┘
       ↓
┌──────────────────────┐
│ 4. Estimación        │ → OPCIONAL
│                      │ → Según políticas del equipo
└──────────────────────┘
       ↓
┌──────────────────────┐
│ 5. Desarrollo        │ → Implementación completa
│                      │ → Con tests
└──────────────────────┘
       ↓
┌──────────────────────┐
│ 6. Revisión          │ → Completa
│    Completa          │ → Calidad y seguridad
└──────────────────────┘
       ↓
┌──────────────────────┐
│ 7. Post-Mortem       │ → Documentación
│                      │ → Actualización de KB
└──────────────────────┘
       ↓
    ✅ Resuelto
```

**Características**:
- 🔄 Proceso completo con pasos opcionales
- ✅ Análisis arquitectónico cuando se requiere
- ✅ Estimación opcional según políticas
- ✅ Revisión completa de calidad
- ✅ Post-mortem para aprendizaje

## Workflows Invocados

### Workflows de Soporte
1. **diagnosticar-error**: Diagnóstico de causa raíz con 5 Whys
2. **post-mortem**: Documentación post-mortem y actualización de KB

### Workflows de Desarrollo (Reutilizados)
4. **analizar-disenar-historia-usuario**: Análisis arquitectónico (P2-P4 opcional)
5. **refinamiento-tecnico**: Refinamiento técnico del fix
6. **estimar-historia-usuario**: Estimación de esfuerzo (P2-P4 opcional)
7. **desarrollar-historia-usuario**: Implementación de la solución
8. **revisar-historia**: Revisión de calidad del fix

## Variables Requeridas

- `incident_number`: Identificador del incidente (ej: 2025-01-15-login-error)
  - Si el incidente ya fue recibido, proporcionar el identificador
  - Si no, el workflow ejecutará primero la recepción

## Variables Calculadas Automáticamente

- `incident_priority`: Extraída del archivo del incidente (P0, P1, P2, P3, P4)
- `flujo_critico`: Determinado automáticamente
  - `true` para P0-P1 → Flujo expedito
  - `false` para P2-P4 → Flujo completo
- `skip_analisis`: true para P0-P1, preguntado para P2-P4
- `skip_estimacion`: true para P0-P1, preguntado para P2-P4

## Modo de Uso

### Modo Interactivo (Recomendado)

**Prerequisito**: El incidente debe ser recibido primero por el PO
```bash
# Paso 1: PO recibe y clasifica el incidente
po *recibir-error
# (El PO obtiene el identificador, ej: 2025-01-15-login-error)

# Paso 2: Ejecutar ciclo técnico de resolución
architect *ciclo-completo-incidente
# O desde developer:
dev *ciclo-completo-incidente
# (Proporcionar el identificador del incidente)
```

El workflow:
1. Preguntará si el incidente ya fue recibido
2. Leerá la prioridad del incidente
3. Seleccionará automáticamente el flujo apropiado (crítico vs normal)
4. Ejecutará las fases correspondientes con validación obligatoria entre pasos

### Ejecución Parcial

Al iniciar, puede elegir ejecutar solo ciertas fases:
- `[s]` - Ciclo completo (flujo adaptativo según prioridad)
- `[p]` - Solo desarrollo (requiere diagnóstico y refinamiento previos)
- `[r]` - Solo revisión (requiere desarrollo completo)
- `[m]` - Solo post-mortem (requiere incidente resuelto)

## Clasificación de Prioridades

| Prioridad | Descripción | Flujo | Impacto |
|-----------|-------------|-------|---------|
| **P0** | Sistema caído, impacto total | 🚨 Crítico | Resolución inmediata |
| **P1** | Funcionalidad crítica afectada | 🚨 Crítico | Impacto alto |
| **P2** | Funcionalidad importante con workaround | 🔧 Normal | Impacto medio |
| **P3** | Funcionalidad menor afectada | 🔧 Normal | Impacto bajo |
| **P4** | Mejora o issue cosmético | 🔧 Normal | Sin impacto funcional |

## Ciclo de Correcciones

Si la revisión resulta en **FAIL**, el workflow ofrece:
1. Volver automáticamente a la fase de desarrollo
2. Implementar las correcciones solicitadas
3. Re-ejecutar la revisión

Este ciclo puede repetirse hasta que la revisión sea **PASS**, **CONCERNS** o **WAIVED**.

## Archivo de Salida

El workflow modifica **in-place** el archivo del incidente:
```
{incident_location}/{incident_number}.incident.md
```

Cada fase añade o actualiza secciones específicas:
- **Recepción**: Clasificación inicial y descripción
- **Diagnóstico**: Análisis de causa raíz (5 Whys)
- **Análisis**: Decisiones arquitectónicas (P2-P4 opcional)
- **Refinamiento**: Detalles técnicos de implementación
- **Estimación**: Esfuerzo estimado (P2-P4 opcional)
- **Desarrollo**: Registros de desarrollo, checklist, changelog
- **Revisión**: Reporte de QA
- **Post-mortem**: Enlace al documento de post-mortem en KB

## Dependencias

Requiere que los siguientes workflows estén instalados:
- `diagnosticar-error`
- `analizar-disenar-historia-usuario`
- `refinamiento-tecnico`
- `estimar-historia-usuario`
- `desarrollar-historia-usuario`
- `revisar-historia`
- `post-mortem`

## Casos de Uso

### 1. Incidente Crítico en Producción (P0-P1)
```bash
# Sistema caído - Requiere acción inmediata
po ciclo-completo-incidente

# El workflow:
# 1. Detecta prioridad P0/P1
# 2. Activa flujo crítico automáticamente
# 3. Omite pasos opcionales (análisis profundo, estimación)
# 4. Ejecuta revisión expedita
# 5. Genera post-mortem obligatorio
```

### 2. Bug Importante con Workaround (P2)
```bash
# Bug importante pero no bloqueante
po ciclo-completo-incidente

# El workflow:
# 1. Detecta prioridad P2
# 2. Activa flujo normal
# 3. Pregunta si requiere análisis arquitectónico
# 4. Pregunta si requiere estimación
# 5. Ejecuta revisión completa
# 6. Genera post-mortem
```

### 3. Continuar Incidente Parcialmente Procesado
```bash
# Incidente ya diagnosticado, continuar con desarrollo
po ciclo-completo-incidente
# Elegir opción [p] para solo desarrollo
```

### 4. Solo Documentar Post-Mortem
```bash
# Incidente ya resuelto, solo falta documentación
po ciclo-completo-incidente
# Elegir opción [m] para solo post-mortem
```

## Diferencias Entre Flujos

| Aspecto | Flujo Crítico (P0-P1) | Flujo Normal (P2-P4) |
|---------|----------------------|---------------------|
| **Análisis arquitectónico** | ❌ Omitido | ✅ Opcional según complejidad |
| **Estimación** | ❌ Omitida | ✅ Opcional según políticas |
| **Refinamiento** | ⚡ Rápido y enfocado | 📋 Detallado con tareas |
| **Revisión** | ⚡ Expedita (no-regresión) | 🔍 Completa (calidad + seguridad) |
| **Post-mortem** | ✅ Obligatorio | ✅ Recomendado |
| **Tiempo estimado** | Minutos a horas | Horas a días |

## Beneficios

✅ **Adaptación automática**: El flujo se ajusta a la urgencia  
✅ **Proceso estandarizado**: Garantiza que no se omitan pasos críticos  
✅ **Trazabilidad completa**: Todo documentado desde causa raíz hasta KB  
✅ **Aprendizaje organizacional**: Post-mortem captura conocimiento  
✅ **Flexibilidad**: Permite ejecución parcial cuando se requiere  
✅ **Calidad garantizada**: Revisión obligatoria en ambos flujos  

## Tags
`meta-workflow` `full-cycle` `orchestration` `metodo-ceiba` `support` `incident-management` `diagnostico` `post-mortem`
