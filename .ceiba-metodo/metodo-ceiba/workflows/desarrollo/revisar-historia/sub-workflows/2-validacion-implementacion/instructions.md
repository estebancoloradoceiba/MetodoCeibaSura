# Validación de Implementación

```xml
<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>Communicate all responses in {communication_language}</critical>
<critical>Este es un SUB-WORKFLOW invocado por revisar-historia - NO standalone</critical>
<critical>Output: Tabla Markdown directa (NO JSON)</critical>
```

Este sub-workflow consolida la verificación de **Criterios de Aceptación** y **Coherencia Arquitectónica** en un solo análisis.

## Parte A: Criterios de Aceptación

### Step A1: Extraer ACs de la historia

1. Leer `{{story_context.criterios_aceptacion}}`
2. Para cada AC extraer: ID, descripción, tasks relacionadas
3. Almacenar en `{{ac_list}}`

### Step A2: Clasificar archivos

Separar `{{staged_files}}` en:
- **Implementación**: `.java`, `.ts`, `.js`, `.py` (excluyendo tests)
- **Tests**: `*.test.*`, `*.spec.*`, `*Test.java`

### Step A3: Evaluar cobertura por AC

Para cada AC:
1. Buscar evidencia de implementación (keywords en archivos)
2. Buscar tests correspondientes
3. Determinar status:
   - ✅ **CUBIERTO**: Implementación + tests encontrados
   - ⚠️ **PARCIAL**: Implementación sin tests completos
   - ❌ **NO_CUBIERTO**: Sin evidencia de implementación

### Output Parte A

```markdown
### Criterios de Aceptación

| AC | Estado | Implementación | Tests | Gaps |
|----|--------|----------------|-------|------|
| AC#1 | ✅ | archivo.java | archivoTest.java | - |
| AC#2 | ⚠️ | archivo2.java | - | Faltan tests |

**Resumen**: X/Y ACs cubiertos
```

---

## Parte B: Coherencia Arquitectónica

### Step B1: Verificar interfaces y contratos

1. Identificar interfaces/types en `{{staged_files}}`
2. Buscar implementaciones
3. Verificar que signatures coinciden

**Hallazgo si inconsistencia**: `interface_mismatch` (ALTA)

### Step B2: Verificar capas arquitectónicas

Usando `{{manual_context.gps_arquitectonico}}`:
1. Clasificar archivos por capa (Controller, Service, Repository)
2. Verificar dependencias válidas:
   - Controller → Service ✅
   - Controller → Repository ❌
   - Service → Repository ✅

**Hallazgo si violación**: `layer_violation` (ALTA)

### Step B3: Verificar flujo de datos

1. Rastrear DTOs entre capas
2. Verificar validaciones en cada capa
3. Detectar pérdida de datos en transformaciones

**Hallazgos posibles**: `validation_gap` (MEDIA), `data_loss` (ALTA)

### Step B4: Verificar manejo de errores

1. Detectar estrategia de errores (excepciones vs códigos)
2. Verificar consistencia entre archivos
3. Verificar logging de errores

**Hallazgo si inconsistencia**: `error_handling_inconsistent` (MEDIA)

### Step B5: Detectar duplicación y naming

1. Buscar lógica duplicada entre archivos
2. Verificar naming consistente de conceptos

**Hallazgos posibles**: `code_duplication` (BAJA), `naming_inconsistent` (BAJA)

### Output Parte B

```markdown
### Coherencia Arquitectónica

| Severidad | Tipo | Issue | Archivos |
|-----------|------|-------|----------|
| ALTA | layer_violation | Controller accede a Repository | ctrl.java, repo.java |
| MEDIA | validation_gap | Validación faltante en service | svc.java |

**Resumen**: N issues (X ALTA, Y MEDIA, Z BAJA)
```

---

## Output Final Consolidado

```markdown
## [2/5] Validación de Implementación

### Criterios de Aceptación
[tabla de ACs]
**Resumen**: X/Y ACs cubiertos

### Coherencia Arquitectónica  
[tabla de issues]
**Resumen**: N issues arquitectónicos

### Hallazgos Totales
- Severidad ALTA: X
- Severidad MEDIA: Y
- Severidad BAJA: Z
```
