# Validación de Testing

```xml
<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>Communicate all responses in {communication_language}</critical>
<critical>Este es un SUB-WORKFLOW invocado por revisar-historia - NO standalone</critical>
<critical>Output: Tablas Markdown de cada task (NO JSON)</critical>
```

Este sub-workflow consolida el análisis de **Tests Unitarios** y **Tests de Integración** ejecutando los tasks XML especializados.

## Step 0: Clasificar archivos

Separar `{{staged_files}}` en tres grupos:

| Tipo | Patrones |
|------|----------|
| **Implementación** | `.java`, `.ts`, `.js`, `.py` (excluir config, migrations, interfaces puras) |
| **Tests Unitarios** | `*.test.*`, `*.spec.*`, `*Test.java`, `test_*.py` en `__tests__/`, `test/`, `spec/` |
| **Tests Integración** | `*IntegrationTest.*`, `*IT.*`, `*E2E.*` en `integration/`, `e2e/` |

Almacenar en `{{impl_files}}`, `{{unit_test_files}}`, `{{integration_test_files}}`

---

## Parte A: Tests Unitarios

<task-invoke file="{parent_path}/tasks/diagnostic-unit-tests.xml">
  <input name="staged_files" value="{{staged_files}}" />
  <input name="story_number" value="{{story_number}}" />
  <input name="manual_context" value="{{manual_context}}" />
</task-invoke>

**El task ejecuta**:
1. Búsqueda exhaustiva de archivos con pruebas unitarias
2. Exclusión de pruebas de integración
3. Análisis por archivo:
   - Patrón AAA (Arrange-Act-Assert)
   - Patrón test data builder
   - Uso adecuado de mocks con validación de invocación
4. Validación cruzada con conteo exacto
5. Git blame para atribución

### Métricas adicionales (calcular en este sub-workflow)

```
coverage_ratio = unit_test_files.length / impl_files.length

SI impl_files.length > 0 AND unit_test_files.length == 0:
  → HALLAZGO ALTA: "No existen tests unitarios para N archivos de implementación"

SI coverage_ratio < 0.5:
  → HALLAZGO MEDIA: "Cobertura insuficiente: X tests para Y archivos (Z%)"
```

**Output esperado**: Tabla Markdown con hallazgos de tests unitarios

```markdown
### Tests Unitarios

**Métricas**:
- Archivos de implementación: X
- Archivos de test: Y
- Ratio cobertura: Y/X (Z%)

| Severidad | Issue | Archivo | Detalle | Usuario |
|-----------|-------|---------|---------|---------|
| ALTA | Sin tests | ServicioX.java | 0 tests para 5 métodos públicos | dev@email.com |
| MEDIA | AAA incompleto | ServicioTest.java | Test sin assertions claras | dev@email.com |

**Resumen**: N hallazgos tests unitarios
```

---

## Parte B: Tests de Integración

<task-invoke file="{parent_path}/tasks/diagnostic-integration-tests.xml">
  <input name="staged_files" value="{{staged_files}}" />
  <input name="story_number" value="{{story_number}}" />
  <input name="manual_context" value="{{manual_context}}" />
</task-invoke>

**El task ejecuta**:
1. Búsqueda de archivos con pruebas de integración a endpoints
2. Análisis por archivo:
   - Patrón AAA
   - Patrón test data builder
   - **NO mocks de servicios/repositorios internos** (ALTA severidad si los hay)
   - Solo permitido mockear boundaries externos (APIs terceros, email, storage)
3. Validación cruzada con conteo exacto
4. Git blame para atribución

### Validación adicional de documentación

```
Buscar documentación de estrategia de testing:
- {{story_number}}-testing-strategy.md
- docs/testing/*.md

SI tests_documentados > 0 AND tests_implementados == 0:
  → HALLAZGO ALTA: "Tests de integración documentados pero NO implementados"

SI tests_documentados > tests_implementados:
  → HALLAZGO MEDIA: "Cobertura parcial: X/Y tests implementados"
```

**Output esperado**: Tabla Markdown con hallazgos de tests de integración

```markdown
### Tests de Integración

**Métricas**:
- Estrategia documentada: Sí/No
- Tests esperados (doc): X
- Tests implementados: Y
- Gap: X - Y

| Severidad | Issue | Archivo | Detalle | Usuario |
|-----------|-------|---------|---------|---------|
| ALTA | Mock interno | UserIT.java | Mock de UserRepository (debe ser real) | dev@email.com |
| ALTA | Tests no implementados | - | 3 tests documentados, 0 implementados | - |

**Resumen**: N hallazgos tests integración
```

---

## Output Final Consolidado

Escribir al story file:

```markdown
## [4/5] Validación de Testing

### Tests Unitarios
**Métricas**: X impl, Y tests, Z% cobertura
[resultado del task diagnostic-unit-tests + métricas]

### Tests de Integración
**Métricas**: Documentados: X, Implementados: Y
[resultado del task diagnostic-integration-tests + validación docs]

### Totales por Severidad
- **ALTA**: N (ausencia de tests, mocks internos en integración, tests documentados no implementados)
- **MEDIA**: M (cobertura baja, calidad de tests)
- **BAJA**: L (mejoras menores)
```
