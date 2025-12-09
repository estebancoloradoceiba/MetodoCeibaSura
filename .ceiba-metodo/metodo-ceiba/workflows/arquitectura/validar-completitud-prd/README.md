---
last-redoc-date: 2025-11-20
---

# Validar Completitud PRD

## Propósito

Workflow de validación objetiva y sistemática que evalúa la completitud de la documentación de requisitos de producto (PRD) para determinar la viabilidad de generar una definición de arquitectura. Utiliza una metodología de evaluación basada en 56 subcriterios distribuidos en tres categorías ponderadas (Críticos, Importantes, Menores) para producir un score objetivo de preparación arquitectónica.

## Características Distintivas

### Evaluación Objetiva Multi-Criterio

A diferencia de las revisiones tradicionales de PRD que dependen de juicio subjetivo, este workflow implementa:

- **56 subcriterios específicos** organizados en 3 categorías de impacto arquitectónico
- **Sistema de puntuación matemática**: (Presencia + Completitud + Claridad) × Impacto Arquitectónico = 0-18 puntos por criterio
- **Ponderación diferenciada**: Críticos (3.0) > Importantes (2.0) > Menores (1.0)
- **Cálculo transparente y auditable** del nivel de completitud final

### Categorización Arquitectónica Explícita

**Criterios Críticos (C1-C6, 20 subcriterios)**
- Contexto de Negocio, NFRs críticos, Integraciones, Restricciones técnicas, Alcance del sistema, Arquitectura de datos
- **Bloquean la arquitectura si están ausentes** - Peso máximo 3.0

**Criterios Importantes (I1-I6, 20 subcriterios)**
- Requerimientos funcionales detallados, NFRs cualitativos, Contexto organizacional, Datos detallados, Integración/Conectividad, Evolución
- **Complican significativamente el diseño** si faltan - Peso medio 2.0

**Criterios Menores (M1-M5, 16 subcriterios)**
- Detalles de implementación, Features opcionales, Aspectos operacionales, Refinamientos estéticos, Optimizaciones menores
- **Pueden definirse durante la implementación** - Peso bajo 1.0

### Umbral de Aprobación Automatizado

El workflow calcula automáticamente el estado de preparación:

```
✅ APTO PARA ARQUITECTURA:     readiness_score ≥ 85% Y 0 gaps críticos
⚠️ APTO CON RESERVAS:          readiness_score ≥ 70% Y ≤2 gaps críticos
⚠️ PARCIALMENTE APTO:          readiness_score ≥ 50%
❌ NO APTO:                     readiness_score < 50%
```

**Bloqueo obligatorio**: Si `readiness_score < 70%` O `critical_gaps > 2`, el workflow **impide proceder con arquitectura** hasta completar gaps críticos.

### Matriz de Mapeo Arquitectónico

Genera una tabla de correspondencia que mapea cada sección arquitectónica esperada contra:
- ✅ **Información COMPLETA** - PRD contiene detalle suficiente
- ⚠️ **Información PARCIAL** - Existe pero requiere profundización
- ❌ **Información FALTANTE** - No documentada en PRD
- 🔍 **Información INFERIBLE** - Puede deducirse de otros elementos

### Recomendaciones Específicas y Accionables

Para cada gap identificado:
- Pregunta específica que debe responderse
- Tipo de información requerida (cuantitativa, cualitativa, técnica, de negocio)
- Fuente sugerida (Product Owner, Negocio, Técnico, Investigación)
- Prioridad clara (Crítico/Importante/Menor)
- Impacto arquitectónico si no se resuelve

Recomendaciones agrupadas por:
- **Stakeholder responsable** (facilita delegación)
- **Fase de resolución** (Antes de arquitectura / Durante diseño / Posterior)
- **Esfuerzo requerido** (Bajo / Medio / Alto)

## Uso

### Invocación

**Desde agente de Arquitectura:**
```
*validar-completitud-prd
```

**Vía workflow directo:**
```
/validar-completitud-prd
```

### Prerrequisitos

1. **Documentación comercial disponible** (preferiblemente):
   - `{output_folder}/propuesta/03-prd/PRD.md`
   - `{output_folder}/propuesta/03-prd/epicas.md`
   - `{output_folder}/propuesta/02-brief-alcance/brief-alcance.md`

2. **Alternativa**: Si no existe PRD formal, el usuario proporciona rutas a documentos equivalentes

3. **Acceso**: Permisos de lectura en carpeta de propuesta

### Entradas

**Automáticas** (si existen):
- PRD generado por proceso comercial
- Épicas con historias de usuario
- Brief de alcance
- Cualquier otro documento en carpeta `/propuesta`

**Interactivas**:
- Rutas alternativas a documentación (si PRD no existe)
- Confirmación del nombre del proyecto
- Decisión sobre visualización del reporte completo
- Decisión de continuar o no con arquitectura

## Salidas

### Documento Principal

**Archivo**: `{output_folder}/propuesta/04-arquitectura/reporte-validacion-completitud-prd.md`

**Estructura del reporte**:

1. **📋 Información del Proyecto** - Metadata y contexto
2. **🎯 Resumen Ejecutivo** - Score de completitud y estado general
3. **📂 Documentación Analizada** - Inventario de documentos encontrados y su calidad
4. **🔍 Análisis Detallado de Completitud** - Evaluación exhaustiva por secciones arquitectónicas
5. **📊 Resumen de Completitud** - Matriz de mapeo con estados por sección
6. **🚨 Análisis de Gaps Identificados** - Categorización detallada de gaps (Críticos/Importantes/Menores)
7. **🔢 Cálculo Objetivo del Nivel de Completitud** - Tabla transparente con metodología matemática, puntuaciones por categoría y fórmulas aplicadas
8. **📋 Recomendaciones Específicas y Accionables** - Plan de acción priorizado con dueños y esfuerzos
9. **🎯 Próximos Pasos Priorizados** - Top 3 acciones críticas

### Variables Clave Generadas

- `{{readiness_score}}` - Porcentaje de completitud (0-100%)
- `{{overall_status}}` - Estado calculado (APTO / APTO CON RESERVAS / PARCIALMENTE APTO / NO APTO)
- `{{critical_gaps_count}}` - Número de gaps críticos de 20 posibles
- `{{important_gaps_count}}` - Número de gaps importantes de 20 posibles
- `{{minor_gaps_count}}` - Número de gaps menores de 16 posibles
- `{{priority_action_1}}`, `{{priority_action_2}}`, `{{priority_action_3}}` - Acciones prioritarias

### Métricas Transparentes

El reporte incluye una tabla detallada del cálculo:

| Categoría | Subcriterios | Puntuación Obtenida | Máxima | % Categoría | Peso | Contribución |
|-----------|--------------|---------------------|--------|-------------|------|--------------|
| Críticos | 20 | XXX/360 | 360 | XX.X% | 3.0 | XX.X |
| Importantes | 20 | XXX/360 | 360 | XX.X% | 2.0 | XX.X |
| Menores | 16 | XXX/288 | 288 | XX.X% | 1.0 | XX.X |
| **TOTAL** | **56** | **XXX/1008** | **1008** | **XX.X%** | **6.0** | **100%** |

## Flujo de Trabajo

### Paso 0.1: Verificar Disponibilidad Documentación Comercial
- Buscar PRD.md, epicas.md, brief-alcance.md en rutas esperadas
- Si no existen, solicitar rutas alternativas al usuario
- Cargar **TODOS** los documentos encontrados recursivamente
- Confirmar nombre del proyecto con el usuario

### Paso 0.2: Análisis de Completitud Documentación Comercial
- Evaluar presencia de elementos críticos en:
  - Introducción y objetivos (Requisitos funcionales, NFRs, Stakeholders)
  - Restricciones (Técnicas, Organizacionales, Regulatorias)
  - Contexto y alcance (Usuarios, Integraciones, Entradas/Salidas)
  - Diseño técnico (Volumetría, Casos de uso, Despliegue)
  - Calidad y riesgos (Escenarios de calidad, Riesgos, Criterios de éxito)

### Paso 0.3: Resumen Completitud Documentación Comercial
- Generar matriz de mapeo con estado (✅/⚠️/❌/🔍) por sección arquitectónica
- Identificar información disponible vs faltante
- Evaluar impacto (Alto/Medio/Bajo) de cada gap

### Paso 0.4: Análisis de Gaps Identificados
- **Evaluación sistemática de 56 subcriterios** con matriz de puntuación:
  - **Presencia (0-2)**: No existe / Mencionado vagamente / Documentado específicamente
  - **Completitud (0-2)**: Insuficiente / Básico / Detallado y completo
  - **Claridad (0-2)**: Ambiguo / Parcialmente claro / Completamente claro
  - **Impacto Arquitectónico (1-3)**: Bajo / Medio / Alto
- Calcular puntuación por criterio: (P + C + C) × I = 0-18 puntos
- Categorizar según fórmulas y umbrales establecidos
- Generar recomendaciones por cada gap

### Paso 0.5: Generar Recomendaciones Específicas
- Para cada gap: pregunta específica, tipo de información, fuente, prioridad, impacto
- Agrupar por stakeholder responsable, fase de resolución, esfuerzo requerido
- Identificar top 3 acciones prioritarias más críticas

### Paso 0.6: Cálculo Objetivo del Nivel de Completitud
- Aplicar fórmula de ponderación:
  ```
  Puntuación_Ponderada = (Críticos × 3.0) + (Importantes × 2.0) + (Menores × 1.0)
  Nivel_Completitud = Puntuación_Ponderada / 6.0 × 100
  ```
- Contar gaps por categoría (puntuación < umbrales)
- Determinar estado general según criterios automatizados
- Generar tabla de cálculo detallado transparente

### Paso 0.7: Generar Reporte de Validación
- Compilar toda la información de pasos anteriores
- Integrar tabla de cálculo detallado del paso 0.6
- **Garantizar que todas las variables estén reemplazadas** (verificación exhaustiva)
- Generar reporte completo sin resumenes ejecutivos (información detallada)

### Paso 0.8: Recomendaciones Finales y Próximos Pasos
- Mostrar resumen ejecutivo con métricas clave
- Presentar opciones al usuario: Ver reporte / Proceder con arquitectura / Salir
- **Validación obligatoria**: Si readiness_score < 70% O critical_gaps > 2, **BLOQUEAR** continuación con arquitectura
- Comunicar ruta del reporte generado

## Integración con Método Ceiba

### Posición en el Proceso

Este workflow se ejecuta **entre el proceso comercial y el diseño arquitectónico**:

1. **Previo**: Proceso comercial genera PRD, épicas, brief de alcance
2. **Este workflow**: Validación de completitud
3. **Posterior**: Creación de arquitectura de solución (solo si validación es exitosa)

### Bloqueo de Arquitectura

El workflow actúa como **gate de calidad obligatorio**:
- Si validación indica "NO APTO" o "PARCIALMENTE APTO", **se detiene el flujo**
- El arquitecto no puede proceder con `crear-arquitectura-solucion` hasta resolver gaps críticos
- Esto previene arquitecturas basadas en requisitos incompletos o ambiguos

### Ciclo de Retroalimentación

Recomendaciones generadas pueden enviarse al área comercial para:
- Sesiones adicionales con el cliente
- Clarificación de requisitos ambiguos
- Profundización en áreas críticas faltantes
- Re-ejecución del workflow después de completar gaps

## Configuración

**Variables desde config.yaml**:
- `output_folder` - Carpeta de salida para reporte
- `user_name` - Nombre del validador
- `communication_language` - Idioma de interacción (español por defecto)
- `document_output_language` - Idioma del reporte generado

**Rutas esperadas**:
- Documentación comercial: `{output_folder}/propuesta/`
- Reporte de salida: `{output_folder}/propuesta/04-arquitectura/`

## Limitaciones y Consideraciones

### Lo que NO hace este workflow

- **No genera arquitectura** - Solo valida viabilidad de crearla
- **No corrige gaps** - Solo los identifica y recomienda acciones
- **No garantiza éxito arquitectónico** - Un PRD completo no asegura una buena arquitectura, pero un PRD incompleto dificulta significativamente el proceso

### Supuestos

- Documentación está en formato Markdown
- Estructura de carpetas sigue convención del Método Ceiba
- Usuario tiene conocimiento de arquitectura para interpretar recomendaciones

### Escenarios de Uso

**Escenario ideal**:
1. Proceso comercial completo con PRD detallado
2. Workflow valida con score ≥ 85% y 0 gaps críticos
3. Arquitecto procede directamente a `crear-arquitectura-solucion`

**Escenario con iteración**:
1. Validación inicial muestra score 65% con 4 gaps críticos
2. Recomendaciones enviadas al área comercial
3. Sesiones adicionales con cliente para completar información
4. Re-ejecución del workflow alcanza score 87% con 0 gaps críticos
5. Arquitecto procede con confianza a diseño

**Escenario sin PRD formal**:
1. Cliente proporciona documentación informal (emails, presentaciones, notas)
2. Usuario indica rutas alternativas al workflow
3. Validación muestra gaps significativos pero identifica qué información crítica existe
4. Arquitecto usa reporte como checklist para sesiones de discovery con cliente

## Mejores Prácticas

1. **Ejecutar antes de comprometer tiempo de arquitectura** - Evita retrabajo significativo
2. **Usar recomendaciones como checklist** - Para sesiones de discovery con clientes
3. **Re-ejecutar después de completar gaps** - Validar mejoras objetivamente
4. **Compartir reporte con stakeholders** - Transparencia sobre estado de preparación
5. **No forzar continuación si score < 70%** - Respetar el bloqueo del workflow por razones técnicas sólidas

---

**Última actualización**: 2025-11-20  
**Versión del workflow**: Compatible con BMAD v6  
**Módulo**: metodo-ceiba  
**Categoría**: Arquitectura - Validación
