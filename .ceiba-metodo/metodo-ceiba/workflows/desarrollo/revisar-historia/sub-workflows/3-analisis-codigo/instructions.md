# Análisis de Código

```xml
<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>Communicate all responses in {communication_language}</critical>
<critical>Este es un SUB-WORKFLOW invocado por revisar-historia - NO standalone</critical>
<critical>Output: Tablas Markdown de cada task (NO JSON)</critical>
```

Este sub-workflow consolida los diagnósticos de **Seguridad**, **Backend** y **Frontend** ejecutando los tasks XML especializados.

## Step 0: Clasificar archivos

Separar `{{staged_files}}` en:

| Tipo | Extensiones |
|------|-------------|
| **Backend** | `.java`, `.py`, `.go`, `.rb`, `.cs`, `.sql`, `.xml` (config) |
| **Frontend** | `.html`, `.js`, `.jsx`, `.ts`, `.tsx`, `.vue`, `.svelte`, `.css`, `.scss` |

Almacenar en `{{backend_files}}` y `{{frontend_files}}`

---

## Parte A: Análisis de Seguridad

<task-invoke file="{parent_path}/tasks/diagnostic-seguridad.xml">
  <input name="staged_files" value="{{staged_files}}" />
  <input name="story_number" value="{{story_number}}" />
  <input name="manual_context" value="{{manual_context}}" />
</task-invoke>

**El task ejecuta**:
1. Checklist inicial de 6 puntos
2. Inventario exhaustivo de TODAS las interfaces (REST, GraphQL, WebSocket, colas, jobs, etc.)
3. Análisis BOLA por cada interfaz (validación de ownership)
4. Análisis OWASP Top 10 (A01-A10)
5. Validación cruzada con conteo exacto
6. Git blame para atribución

**Output esperado**: Tabla Markdown con hallazgos de seguridad

```markdown
### Seguridad (OWASP/BOLA)

| Severidad | Categoría | Issue | Archivo | Línea | Usuario |
|-----------|-----------|-------|---------|-------|---------|
| ALTA | BOLA | Endpoint sin validación de ownership | UserCtrl.java | 45 | dev@email.com |

**Resumen**: N hallazgos seguridad (X ALTA, Y MEDIA, Z BAJA)
```

---

## Parte B: Análisis Backend

<task-invoke file="{parent_path}/tasks/diagnostic-backend.xml">
  <input name="staged_files" value="{{backend_files}}" />
  <input name="story_number" value="{{story_number}}" />
  <input name="manual_context" value="{{manual_context}}" />
</task-invoke>

**El task ejecuta**:
1. Filtrado de archivos backend (controllers, services, repositories, etc.)
2. Identificación de arquitectura del proyecto
3. Análisis por archivo: arquitectura, manejo de errores, mantenibilidad
4. Validación cruzada con conteo exacto
5. Git blame para atribución

**Output esperado**: Tabla Markdown con hallazgos de backend

```markdown
### Backend

| Severidad | Tipo | Issue | Archivo | Línea | Usuario |
|-----------|------|-------|---------|-------|---------|
| MEDIA | arquitectura | Servicio accede directo a otro servicio | SvcA.java | 78 | dev@email.com |

**Resumen**: N hallazgos backend
```

---

## Parte C: Análisis Frontend (Condicional)

```
SI {{frontend_files.length}} == 0:
  → Escribir "### Frontend\n⚪ **No Aplica** - 0 archivos frontend detectados"
  → Saltar a Output Final
```

<task-invoke file="{parent_path}/tasks/diagnostic-frontend.xml" condition="frontend_files.length > 0">
  <input name="staged_files" value="{{frontend_files}}" />
  <input name="story_number" value="{{story_number}}" />
  <input name="manual_context" value="{{manual_context}}" />
</task-invoke>

**El task ejecuta**:
1. Identificación de arquitectura frontend
2. Análisis por archivo: arquitectura, mantenibilidad, manejo de errores
3. Validación cruzada con conteo exacto
4. Git blame para atribución

**Output esperado**: Tabla Markdown con hallazgos de frontend

```markdown
### Frontend

| Severidad | Tipo | Issue | Archivo | Línea | Usuario |
|-----------|------|-------|---------|-------|---------|
| ALTA | arquitectura | Componente sin cleanup de subscripciones | List.tsx | 23 | dev@email.com |

**Resumen**: N hallazgos frontend
```

---

## Output Final Consolidado

Escribir al story file:

```markdown
## [3/5] Análisis de Código

### Seguridad (OWASP/BOLA)
[resultado del task diagnostic-seguridad]

### Backend
[resultado del task diagnostic-backend]

### Frontend
[resultado del task diagnostic-frontend o "No Aplica"]

### Totales por Severidad
- **ALTA**: A (Seguridad: a1, Backend: a2, Frontend: a3)
- **MEDIA**: B
- **BAJA**: C
```
