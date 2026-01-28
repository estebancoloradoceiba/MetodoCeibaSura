# Revisar Historia (Peer Review) Workflow

El workflow `revisar-historia` utiliza una **estrategia de subagentes especializados** para realizar una revisión de código completa tipo peer review. Cada subagente tiene contexto limpio y foco total en su especialidad. El agente principal solo coordina y consolida resultados.

## Estructura v5.0.0

```
revisar-historia/
├── workflow.yaml           # Configuración principal
├── instructions.xml        # Orquestador (5 steps con subagentes)
└── README.md              # Este archivo
```

> **Rol del Reviewer**: Solo detecta problemas, NO implementa fixes. Si el usuario pide implementar → rechazar y sugerir `*desarrollar-historia-usuario`

## Uso

```bash
bmad reviewer *revisar-historia
```

El workflow solicita el número o ruta de la historia/incidente y ejecuta automáticamente todos los subagentes aplicables.

## Los 5 Steps del Workflow

| Step | Goal | Descripción |
|------|------|-------------|
| 1 | Localizar historia y preparar archivos | Busca documento, valida status, obtiene diffs, clasifica archivos |
| 2 | Lanzar subagentes especializados | Ejecuta runSubagent por cada tipo de revisión con archivos aplicables |
| 3 | Consolidar resultados | Parsea JSON de subagentes, unifica hallazgos, elimina duplicados |
| 4 | Decidir | Aplica reglas de decisión según conteo de severidades |
| 5 | Persistir | Agrega sección "Revisión de Código" y actualiza Status |

## Clasificación de Archivos

El Step 1 clasifica los archivos modificados en estas categorías:

| Tipo | Patrón | Exclusiones |
|------|--------|-------------|
| `story_file` | `.story.md`, `.incident.md` | - |
| `backend_files` | `.java`, `.py`, `.go`, `.cs`, `.rb` | `Test`, `test_` |
| `frontend_files` | `.ts`, `.tsx`, `.js`, `.jsx`, `.vue`, `.svelte` | `.spec.`, `.test.` |
| `test_integracion_files` | `IT.java`, `*IntegrationTest`, `integration` | - |
| `test_unitarios_files` | `Test`, `test_`, `.spec.` | archivos de integración |
| `cicd_files` | `.github/workflows/*.yml`, `azure-pipelines`, `Jenkinsfile`, `.gitlab-ci*` | - |
| `config_files` | `*.yaml`, `*.yml`, `*.json`, `*.env`, `Dockerfile` | - |

## Los 10 Subagentes Especializados

Cada subagente retorna JSON con formato estándar:
```json
{
  "tipo": "BACKEND|SEGURIDAD|...",
  "hallazgos": [
    {"archivo": "...", "linea": N, "severidad": "ALTA|MEDIA|BAJA", "problema": "...", "sugerencia": "..."}
  ]
}
```

| # | Subagente | Condición de Ejecución | Foco |
|---|-----------|------------------------|------|
| 1 | **FLUJO_METODO_CEIBA** | Siempre | Valida secciones obligatorias del documento |
| 2 | **IMPLEMENTACION_VS_REQUISITOS** | `ac_list` + código | Cada AC cumplido, manejo de errores, casos borde |
| 3 | **BACKEND** | `backend_files` | Arquitectura, manejo de errores, tolerancia a fallos |
| 4 | **SEGURIDAD (BOLA)** | `backend_files` o `config_files` | Broken Object Level Authorization |
| 5 | **PENTESTING** | `backend_files` o `frontend_files` | OWASP Top 10 (excepto BOLA) |
| 6 | **FRONTEND** | `frontend_files` | Arquitectura, estabilidad, manejo de errores |
| 7 | **TESTS_INTEGRACION** | `test_integracion_files` | AAA, Data Builder, NO mocks internos |
| 8 | **TESTS_UNITARIOS** | `test_unitarios_files` | AAA, Data Builder, verify() en Assert |
| 9 | **CICD** | `cicd_files` | Tareas obligatorias del pipeline |
| 10 | **FINOPS_GREENOPS** | `backend_files` o `frontend_files` | N+1, recursos, eficiencia |

### Detalle de Subagentes

#### FLUJO_METODO_CEIBA
Valida que el documento tenga todas las secciones obligatorias:

**Para Historias:**
- Sección 'Análisis Arquitectónico' presente y completada
- Sección 'Refinamiento Técnico' o 'Tareas de Implementación' presente
- Sección 'Estimación' con valores de complejidad
- Sección 'Dev Agent Record' o evidencia de desarrollo completado

**Para Incidentes:**
- Sección 'Recepción del Error' (PO) - Status: Triaged
- Sección 'Diagnóstico' (Architect) - Root Cause Analysis completado
- Sección 'Refinamiento Técnico' o 'Tareas de Implementación' presente
- Sección 'Dev Agent Record' o evidencia de desarrollo completado

#### SEGURIDAD (BOLA)
Superficies auditadas: REST, GraphQL, SOAP, gRPC, WebSocket, colas/eventos, jobs, archivos/URLs prefirmadas, buscadores/reportes, repositorios/ORM.

Proceso:
1. Verificar autorización a nivel de recurso
2. Seguir cadena controller → service → repository
3. Buscar validaciones de ownership
4. Clasificar: SEGURO / VULNERABLE

#### CICD
Tareas obligatorias en pipeline:
- `build`, `test`
- `sonar` (debe detener si quality gate falla)
- Análisis de vulnerabilidades (dependency track o similar)
- Análisis de licencias
- Análisis de secretos (git leaks o similar)
- Despliegue a producción Y (pruebas O desarrollo)

**Backend adicional:** pruebas carga, DAST, mutation testing, pruebas arquitectura  
**Frontend adicional:** pruebas funcionales, NO `--legacy-peer-deps`

#### FINOPS_GREENOPS
Problemas críticos buscados:
- Queries N+1, llamadas redundantes
- Recursos no liberados (conexiones, streams)
- Algoritmos de complejidad alta evitable
- Cacheo ausente donde beneficiaría
- Llamadas síncronas que podrían ser async/batch
- Procesamiento redundante
- Uso ineficiente de memoria

## Decisiones de Revisión

| Decisión | Condición | Status Resultante |
|----------|-----------|-------------------|
| **BLOQUEADO** | `alta_count > 3` OR vulnerabilidad crítica de seguridad | Bloqueada |
| **CAMBIOS SOLICITADOS** | `alta_count >= 1` OR `media_count > 5` | Cambios Solicitados |
| **APROBADO CON OBSERVACIONES** | `alta_count == 0` AND `media_count` entre 1-5 | Aprobada con Observaciones |
| **APROBADO** | `alta_count == 0` AND `media_count == 0` | Aprobada |

## Validación de Status

El Step 1 verifica que el documento tenga uno de estos estados válidos para revisión:
- Lista para Revisión
- Ready for Review
- Desarrollo Completado
- En Revisión

## Variables de Configuración

Desde `config.yaml`:

| Variable | Descripción |
|----------|-------------|
| `dev_story_location` | Directorio con historias |
| `incident_location` | Directorio con incidentes |
| `communication_language` | Idioma de comunicación |
| `document_output_language` | Idioma de documentos |

## Obtención de Archivos Modificados

Proceso en Step 1:
1. Intentar: `git diff --name-only` (staged + unstaged)
2. Si falla o vacío → Preguntar rama y commit
3. Con rama/commit: `git diff --name-only {{commit}}..HEAD` o `git diff --name-only main..{{rama}}`
4. Mostrar lista y solicitar confirmación del usuario
5. Para cada archivo confirmado: `git diff main -- {{filepath}}`

## Migración v4 → v5

| Antes (v4) | Ahora (v5) |
|------------|------------|
| 5 sub-workflows con archivos separados | 10 subagentes inline en instructions.xml |
| Carpetas sub-workflows/ y tasks/ | Sin carpetas adicionales |
| Ejecución secuencial de sub-workflows | runSubagent por especialidad |
| Tasks XML externos | Prompts especializados inline |

---

_Part of the BMAD Method v6 — Método Ceiba Implementation Phase_
