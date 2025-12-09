# Ciclo Completo de Historia

## Descripción
Meta-workflow que ejecuta el ciclo completo de desarrollo de una historia de usuario en el Método Ceiba, orquestando los cinco workflows principales en secuencia.

## Flujo de Trabajo

```
Historia de Usuario
       ↓
┌──────────────────────┐
│ 1. Análisis          │ → Diseño arquitectónico
│    Arquitectónico    │ → Decisiones de solución
└──────────────────────┘ → Validación del arquitecto
       ↓
┌──────────────────────┐
│ 2. Refinamiento      │ → Análisis técnico profundo
│    Técnico           │ → Descomposición en tareas
└──────────────────────┘ → Preparación para desarrollo
       ↓
┌──────────────────────┐
│ 3. Estimación de     │ → Cálculo de tiempos
│    Tiempos           │ → Por perfil de desarrollador
└──────────────────────┘ → Planificación realista
       ↓
┌──────────────────────┐
│ 4. Desarrollo e      │ → Implementación iterativa
│    Implementación    │ → Testing completo
└──────────────────────┘ → Actualización de estado
       ↓
┌──────────────────────┐
│ 5. Revisión de       │ → Code review exhaustivo
│    Código            │ → Validación de calidad
└──────────────────────┘ → Decisión: Aprobada/Rechazada
       ↓
    ✅ Historia Lista
```

## Workflows Invocados

1. **analizar-disenar-historia-usuario**: Análisis arquitectónico y diseño de solución
2. **refinamiento-tecnico**: Añade contexto técnico, análisis de implementación y descomposición en tareas
3. **estimar-historia-usuario**: Calcula estimaciones de tiempo por perfil de desarrollador
4. **desarrollar-historia-usuario**: Implementa la historia siguiendo las tareas definidas
5. **revisar-historia**: Realiza peer review exhaustivo de código, tests y arquitectura

## Variables Requeridas

- `story_number`: Número de la historia a procesar (ej: 6)

## Variables Opcionales

- `skip_analisis`: true para omitir fase de análisis arquitectónico (default: false)
- `skip_refinamiento`: true para omitir fase de refinamiento (default: false)
- `skip_estimacion`: true para omitir fase de estimación (default: false)
- `skip_desarrollo`: true para omitir fase de desarrollo (default: false)
- `skip_revision`: true para omitir fase de revisión (default: false)

## Modo de Uso

### Modo Interactivo (Único)
```bash
# Ejecutar ciclo completo con validación entre fases
bmad workflow ciclo-completo-historia
```

El workflow preguntará en cada fase si desea continuar, permitiendo revisar resultados antes de proceder. La validación es obligatoria y garantiza control total sobre el proceso.

### Ejecución Parcial
Al iniciar el workflow, puede elegir ejecutar solo ciertas fases:
- `[a]` - Solo análisis arquitectónico
- `[r]` - Solo refinamiento (requiere análisis previo)
- `[e]` - Solo estimación (requiere refinamiento previo)
- `[d]` - Solo desarrollo (requiere refinamiento y estimación previos)
- `[v]` - Solo revisión (requiere desarrollo completo)
- `[s]` - Ciclo completo (análisis + refinamiento + estimación + desarrollo + revisión)

## Ciclo de Correcciones

Si la revisión resulta en **RECHAZADA**, el workflow ofrece:
1. Volver automáticamente a la fase de desarrollo
2. Implementar las correcciones solicitadas
3. Re-ejecutar la revisión

Este ciclo puede repetirse hasta que la historia sea **APROBADA**.

## Archivo de Salida

El workflow modifica **in-place** el archivo de la historia:
```
{dev_story_location}/{story_number}.story.md
```

Cada fase añade o actualiza secciones específicas:
- **Análisis**: Añade sección de análisis arquitectónico y diseño
- **Refinamiento**: Añade análisis técnico, contexto, tareas
- **Estimación**: Añade tabla de estimaciones por perfil
- **Desarrollo**: Actualiza registros de desarrollo, checklist, changelog
- **Revisión**: Añade reporte de peer review al final

## Dependencias

Requiere que los siguientes workflows estén instalados:
- `analizar-disenar-historia-usuario`
- `refinamiento-tecnico`
- `estimar-historia-usuario`
- `desarrollar-historia-usuario`
- `revisar-historia`

## Casos de Uso

### 1. Nueva Historia
```bash
# Crear historia → Refinar → Desarrollar → Revisar
bmad workflow crear-historia-usuario
bmad workflow ciclo-completo-historia
```

### 2. Historia Ya Refinada y Estimada
```bash
# Saltar refinamiento y estimación, solo desarrollar y revisar
bmad workflow ciclo-completo-historia
# Elegir opción [d] o [s] según necesidad
```

### 3. Re-revisión Después de Correcciones
```bash
# Solo ejecutar revisión
bmad workflow ciclo-completo-historia
# Elegir opción [v]
```

## Beneficios

✅ **Orquestación automática**: Un solo comando para todo el ciclo  
✅ **Control granular**: Opción de ejecutar fases individuales  
✅ **Ciclo de correcciones**: Manejo automático de rechazos y re-trabajo  
✅ **Trazabilidad completa**: Todo documentado en un solo archivo  
✅ **Control total**: Validación interactiva obligatoria en cada fase  

## Tags
`meta-workflow` `full-cycle` `orchestration` `metodo-ceiba` `development`
