# Revisar Historia (Peer Review) Workflow

El workflow `revisar-historia` es un meta-workflow que coordina **5 sub-workflows consolidados** para realizar una revisión de código completa tipo peer review. Genera un reporte estructurado en Markdown que se persiste en el archivo de historia.

## Estructura v4.0.0

```
revisar-historia/
├── workflow.yaml           # Configuración principal
├── instructions.xml        # Orquestador (5 steps)
├── checklist.md           # Validación
├── README.md              # Este archivo (incluye algoritmos de agregación)
│
├── sub-workflows/         # Los 5 sub-workflows
│   ├── 1-contexto-tecnico/
│   ├── 2-validacion-implementacion/   # Invoca tasks inline
│   ├── 3-analisis-codigo/             # Invoca tasks XML
│   ├── 4-validacion-testing/          # Invoca tasks XML
│   └── 5-decision-outcome/
│
└── tasks/                 # Tasks XML con lógica de evaluación
    ├── diagnostic-seguridad.xml      # BOLA + OWASP Top 10
    ├── diagnostic-backend.xml        # Arquitectura, errores
    ├── diagnostic-frontend.xml       # Arquitectura frontend
    ├── diagnostic-unit-tests.xml     # AAA, mocks, data builder
    └── diagnostic-integration-tests.xml  # NO mocks internos
```

## Uso

```bash
bmad reviewer *revisar-historia
```

El workflow ejecuta automáticamente los 5 sub-workflows en secuencia.

## Los 5 Sub-workflows

| # | Sub-workflow | Consolida | Output |
|---|--------------|-----------|--------|
| 1 | `contexto-tecnico` | - | Stack, docs, GPS arquitectónico |
| 2 | `validacion-implementacion` | criterios-aceptacion + coherencia-general | Tabla ACs + issues arquitectónicos |
| 3 | `analisis-codigo` | seguridad + backend + frontend | Hallazgos OWASP, backend, frontend |
| 4 | `validacion-testing` | pruebas-unitarias + pruebas-integracion | Métricas y gaps de tests |
| 5 | `decision-outcome` | - | Decisión: Aprobado/Cambios/Bloqueado |

## Formato de Output

Cada sub-workflow genera output en **Markdown con tablas**:

```markdown
## [2/5] Validación de Implementación

### Criterios de Aceptación
| AC | Estado | Implementación | Tests | Gaps |
|----|--------|----------------|-------|------|
| AC#1 | ✅ | ServicioX.java | ServicioXTest.java | - |
| AC#2 | ⚠️ | ControladorY.java | - | Faltan tests |

**Resumen**: 3/4 ACs cubiertos

### Coherencia Arquitectónica
| Severidad | Tipo | Issue | Archivos |
|-----------|------|-------|----------|
| ALTA | layer_violation | Controller → Repository directo | Ctrl.java, Repo.java |

**Resumen**: 1 issue arquitectónico
```

## Decisiones de Revisión

El sub-workflow `decision-outcome` aplica estas reglas:

| Decisión | Condición |
|----------|-----------|
| **BLOQUEADO** | >3 hallazgos ALTA, AC crítico sin implementar, vulnerabilidad OWASP crítica |
| **CAMBIOS SOLICITADOS** | 1-3 hallazgos ALTA, ACs parciales, tests faltantes |
| **APROBADO** | 0 hallazgos ALTA, todos los ACs cubiertos |

## Variables de Configuración

Desde `config.yaml`:

| Variable | Descripción |
|----------|-------------|
| `dev_story_location` | Directorio con historias |
| `architecture_sharded_location` | Docs de arquitectura |
| `communication_language` | Idioma de comunicación |
| `document_output_language` | Idioma de documentos |

## Migración v3 → v4

| Antes (v3) | Ahora (v4) |
|------------|------------|
| 9 sub-workflows | 5 sub-workflows |
| Output JSON intermedio | Output Markdown directo |
| ~50-100 tool calls | ~20-30 tool calls |
| 3 carpetas (diagnosticos/, manual-reviews/, sub-workflows/) | 1 carpeta (sub-workflows/) |
| Nombres sin orden | Prefijo numérico (1-, 2-, 3-, 4-, 5-) |

---

## Algoritmos de Agregación

### mergeAllFindings()

Consolida hallazgos de los 5 sub-workflows en tablas Markdown.

**Esquema de hallazgo**:
| Archivo | Línea | Severidad | Categoría | Problema | Solución |
|---------|-------|-----------|-----------|----------|----------|

**Categorías válidas**: `implementacion`, `seguridad`, `backend`, `frontend`, `testing`

### deduplicateFindings()

Elimina duplicados usando fingerprint: `hash(archivo + línea + primeras 50 chars del problema)`.
- Si duplicados: mantener el de mayor severidad
- Prioridad: ALTA > MEDIA > BAJA

### generateStatistics()

Genera resumen ejecutivo después de cada sub-workflow:
- Total hallazgos: X
- Por severidad: ALTA(n) | MEDIA(n) | BAJA(n)
- Top 3 archivos afectados

### Obtención de Archivos Modificados

Usa `get_changed_files` con filtros de exclusión:
- `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
- `node_modules/`, `dist/`, `build/`, `.next/`
- `coverage/`, `.nyc_output/`, `.cache/`

### Manejo de Errores

| Error | Acción |
|-------|--------|
| Sub-workflow no encuentra archivos | Warning, continuar |
| Archivo no accesible | Skip archivo, log warning |
| Git blame falla | Usar "unknown" como usuario |

---

_Part of the BMAD Method v6 — Método Ceiba Implementation Phase_
