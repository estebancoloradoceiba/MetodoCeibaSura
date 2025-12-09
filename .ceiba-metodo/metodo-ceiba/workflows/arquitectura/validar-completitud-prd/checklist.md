# Checklist de Validación - Validar Completitud PRD

## Información General

**Workflow:** validar-completitud-prd  
**Propósito:** Validar completitud del PRD para determinar viabilidad de generar definición de arquitectura  
**Fecha de validación:** _______________  
**Validador:** _______________  
**Proyecto:** _______________

---

## Paso 0.1: Verificar Disponibilidad Documentación Comercial

### Identificación de Documentos

- [ ] **PRD principal localizado** - Archivo PRD.md encontrado en {output_folder}/propuesta/03-prd/
- [ ] **Épicas documentadas** - Archivo epicas.md encontrado en {output_folder}/propuesta/03-prd/
- [ ] **Brief de alcance localizado** - Archivo brief-alcance.md encontrado en {output_folder}/propuesta/02-brief-alcance/
- [ ] **Otros documentos identificados** - Documentos adicionales relevantes localizados
- [ ] **Documentos alternativos** - Si PRD no disponible, rutas alternativas proporcionadas por usuario

### Carga y Revisión de Documentación

- [ ] **Todos los documentos cargados** - Todos los archivos identificados fueron leídos completamente
- [ ] **Búsqueda recursiva ejecutada** - Exploración completa de rutas especificadas
- [ ] **Nombre del proyecto identificado** - Nombre del proyecto extraído de la documentación
- [ ] **Nombre del proyecto confirmado** - Usuario validó el nombre del proyecto identificado

### Output Generado

- [ ] **`{{disponibilidad_documentacion_comercial}}`** - Sección de disponibilidad documentada en template
- [ ] **Lista de documentos encontrados** - Inventario completo de archivos disponibles
- [ ] **Rutas de documentos** - Ubicaciones exactas documentadas
- [ ] **Estado de disponibilidad** - Claridad sobre qué está disponible y qué falta

---

## Paso 0.2: Análisis de Completitud Documentación Comercial

### Introducción y Objetivos

- [ ] **Resumen de requisitos funcionales** - Requisitos funcionales identificados y documentados
- [ ] **Objetivos de calidad/NFRs** - Requerimientos no funcionales presentes
- [ ] **Stakeholders definidos** - Interesados y sus expectativas documentadas

### Restricciones

- [ ] **Restricciones técnicas** - Limitaciones técnicas documentadas
- [ ] **Limitaciones organizacionales** - Restricciones organizativas identificadas
- [ ] **Políticas y compliance** - Requerimientos de cumplimiento especificados

### Contexto y Alcance

- [ ] **Usuarios y sistemas externos** - Actores externos al sistema definidos
- [ ] **Integraciones requeridas** - Necesidades de integración identificadas
- [ ] **Entradas y salidas del sistema** - Interfaces del sistema especificadas

### Especificaciones de Diseño Técnico

- [ ] **Volúmenes de datos/usuarios** - Información cuantitativa sobre cargas esperadas
- [ ] **Casos de uso principales** - Flujos principales del sistema documentados
- [ ] **Requerimientos de despliegue** - Especificaciones de infraestructura y deployment

### Escenarios de Calidad y Riesgos

- [ ] **Escenarios de calidad** - Situaciones específicas para validar atributos de calidad
- [ ] **Riesgos conocidos** - Riesgos identificados y documentados
- [ ] **Criterios de éxito medibles** - Métricas y KPIs definidos

### Output Generado

- [ ] **`{{analisis_completitud_documentacion_comercial}}`** - Análisis detallado documentado
- [ ] **Elementos críticos evaluados** - Cada categoría revisada y documentada
- [ ] **Hallazgos iniciales registrados** - Observaciones preliminares documentadas

---

## Paso 0.3: Resumen Completitud Documentación Comercial

### Matriz de Mapeo Generada

- [ ] **Tabla de mapeo completa** - Matriz con todas las secciones de arquitectura
- [ ] **Estado por sección definido** - Cada sección marcada como ✅/⚠️/❌/🔍
- [ ] **Información disponible documentada** - Detalles de qué información existe
- [ ] **Información faltante identificada** - Gaps específicos por sección
- [ ] **Impacto evaluado** - Nivel de impacto (Alto/Medio/Bajo) asignado

### Categorización de Estados

- [ ] **✅ Información COMPLETA** - Secciones con suficiente detalle identificadas
- [ ] **⚠️ Información PARCIAL** - Secciones que necesitan profundización marcadas
- [ ] **❌ Información FALTANTE** - Secciones sin información identificadas
- [ ] **🔍 Información INFERIBLE** - Secciones que pueden deducirse marcadas

### Secciones de Arquitectura Evaluadas

- [ ] **Resumen de Requisitos** - Estado y gaps documentados
- [ ] **Objetivos de Calidad** - Estado y gaps documentados
- [ ] **Interesados** - Estado y gaps documentados
- [ ] **Restricciones** - Estado y gaps documentados
- [ ] **Contexto de Negocio** - Estado y gaps documentados
- [ ] **Contexto Técnico** - Estado y gaps documentados
- [ ] **Estrategia de Solución** - Estado y gaps documentados
- [ ] **Vista Estática** - Estado y gaps documentados
- [ ] **Vista Dinámica** - Estado y gaps documentados
- [ ] **Vista de Despliegue** - Estado y gaps documentados
- [ ] **Aspectos Transversales** - Estado y gaps documentados
- [ ] **Decisiones de Arquitectura** - Estado y gaps documentados
- [ ] **Requerimientos de Calidad** - Estado y gaps documentados
- [ ] **Riesgos y Deuda Técnica** - Estado y gaps documentados
- [ ] **Glosario** - Estado y gaps documentados

### Output Generado

- [ ] **`{{resumen_completitud_documentacion_comercial}}`** - Resumen completo en template
- [ ] **Matriz legible y clara** - Tabla formateada correctamente
- [ ] **Gaps específicos por sección** - Detalles de información faltante

---

## Paso 0.4: Análisis de Gaps Identificados

### Evaluación de Criterios CRÍTICOS (C1-C6)

#### C1: Contexto de Negocio Fundamental

- [ ] **C1.1 - Usuarios objetivo** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C1.2 - Objetivos de negocio** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C1.3 - Flujos de negocio críticos** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C1.4 - Volúmenes de transacciones** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### C2: Requerimientos No Funcionales Críticos

- [ ] **C2.1 - Performance** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C2.2 - Disponibilidad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C2.3 - Escalabilidad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C2.4 - Seguridad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### C3: Integraciones y Dependencias Externas

- [ ] **C3.1 - Sistemas externos críticos** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C3.2 - Fuentes de datos principales** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C3.3 - Servicios de terceros** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### C4: Restricciones Técnicas y Operacionales

- [ ] **C4.1 - Plataformas de despliegue** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C4.2 - Dispositivos y navegadores** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C4.3 - Restricciones regulatorias** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C4.4 - Limitaciones de infraestructura** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### C5: Alcance y Límites del Sistema

- [ ] **C5.1 - Fronteras del sistema** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C5.2 - Responsabilidades del sistema** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C5.3 - Fases de implementación** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### C6: Arquitectura de Datos Fundamental

- [ ] **C6.1 - Entidades de datos principales** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **C6.2 - Volúmenes de datos** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

**Total Criterios Críticos:** 20 subcriterios

### Evaluación de Criterios IMPORTANTES (I1-I6)

#### I1: Requerimientos Funcionales Completamente Especificados

- [ ] **I1.1 - Casos de uso principales** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I1.2 - Comportamientos de error** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I1.3 - Validaciones de negocio** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I1.4 - Estados y transiciones** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### I2: Requerimientos No Funcionales Cualitativos

- [ ] **I2.1 - Usabilidad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I2.2 - Mantenibilidad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I2.3 - Observabilidad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I2.4 - Testabilidad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### I3: Contexto Técnico Organizacional

- [ ] **I3.1 - Tecnologías y estándares** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I3.2 - Capacidades del equipo** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I3.3 - Restricciones presupuestarias** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I3.4 - Políticas corporativas** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### I4: Características de Datos Detalladas

- [ ] **I4.1 - Tipos y estructuras** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I4.2 - Volúmenes de almacenamiento** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I4.3 - Políticas de gestión de datos** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I4.4 - Clasificación de sensibilidad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### I5: Integración y Conectividad Detallada

- [ ] **I5.1 - Patrones de integración** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I5.2 - Requerimientos de conectividad** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### I6: Consideraciones de Evolución y Crecimiento

- [ ] **I6.1 - Capacidad de evolución** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **I6.2 - Estrategia de migración** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

**Total Criterios Importantes:** 20 subcriterios

### Evaluación de Criterios MENORES (M1-M5)

#### M1: Detalles de Implementación Específicos

- [ ] **M1.1 - Validaciones de campos** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M1.2 - Formatos de intercambio** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M1.3 - Textos de interfaz** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M1.4 - Configuraciones menores** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### M2: Funcionalidades de Conveniencia Opcionales

- [ ] **M2.1 - Features "nice-to-have"** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M2.2 - Reportes y consultas** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M2.3 - Notificaciones simples** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M2.4 - Mejoras incrementales UX** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### M3: Aspectos Operacionales Menores

- [ ] **M3.1 - Procedimientos operacionales** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M3.2 - Manuales de usuario** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M3.3 - Procesos de soporte** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M3.4 - Configuraciones administrativas** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### M4: Refinamientos Estéticos y de Presentación

- [ ] **M4.1 - Elementos estéticos** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M4.2 - Diseño responsivo detallado** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

#### M5: Optimizaciones Menores de Performance

- [ ] **M5.1 - Optimizaciones específicas** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)
- [ ] **M5.2 - Configuraciones de performance** - Evaluación objetiva: ✅/⚠️/❌/🔍 + Puntuación (0-18)

**Total Criterios Menores:** 16 subcriterios

### Categorización de Gaps

- [ ] **Gaps críticos identificados** - Lista completa con nivel 🔴
- [ ] **Gaps importantes identificados** - Lista completa con nivel 🟡
- [ ] **Gaps menores identificados** - Lista completa con nivel 🟢
- [ ] **Matriz de evaluación aplicada** - Puntuación calculada por criterio
- [ ] **Preguntas de validación respondidas** - Verificación de categorización correcta

### Recomendaciones por Gap

- [ ] **Recomendaciones para gaps críticos** - Acciones específicas definidas
- [ ] **Recomendaciones para gaps importantes** - Acciones específicas definidas
- [ ] **Recomendaciones para gaps menores** - Acciones específicas definidas

### Output Generado

- [ ] **`{{analisis_gaps_identificados}}`** - Análisis completo documentado en template
- [ ] **56 subcriterios evaluados** - Todos los criterios revisados objetivamente
- [ ] **Puntuaciones asignadas** - Valor numérico (0-18) por cada subcriterio
- [ ] **Categorización justificada** - Razones claras para cada nivel asignado

---

## Paso 0.5: Generar Recomendaciones Específicas

### Recomendaciones por Gap

- [ ] **Pregunta específica por gap** - Qué debe responderse para cada gap
- [ ] **Tipo de información requerida** - Naturaleza de la información faltante
- [ ] **Fuente sugerida** - De dónde obtener la información (stakeholder, análisis, investigación)
- [ ] **Prioridad asignada** - Crítico/Importante/Menor
- [ ] **Impacto arquitectónico** - Consecuencias si no se resuelve

### Agrupación de Recomendaciones

#### Por Stakeholder Responsable

- [ ] **Recomendaciones para Product Owner** - Lista específica de acciones
- [ ] **Recomendaciones para Negocio** - Lista específica de acciones
- [ ] **Recomendaciones para Técnico** - Lista específica de acciones

#### Por Fase de Resolución

- [ ] **Antes de arquitectura** - Gaps bloqueantes que deben resolverse ahora
- [ ] **Durante diseño** - Gaps que pueden clarificarse durante diseño arquitectónico
- [ ] **Posterior** - Gaps que pueden posponerse sin riesgo

#### Por Esfuerzo Requerido

- [ ] **Bajo esfuerzo** - Recomendaciones de resolución rápida
- [ ] **Medio esfuerzo** - Recomendaciones que requieren análisis moderado
- [ ] **Alto esfuerzo** - Recomendaciones que requieren investigación significativa

### Output Generado

- [ ] **`{{recomendaciones_específicas_accionables}}`** - Recomendaciones documentadas
- [ ] **Recomendaciones priorizadas** - Orden de ejecución sugerido
- [ ] **Plan de acción claro** - Pasos concretos para completar PRD

---

## Paso 0.6: Cálculo Objetivo del Nivel de Completitud

### Recopilación de Puntuaciones

- [ ] **Puntuaciones criterios críticos** - 20 puntuaciones individuales recopiladas
- [ ] **Puntuaciones criterios importantes** - 20 puntuaciones individuales recopiladas
- [ ] **Puntuaciones criterios menores** - 16 puntuaciones individuales recopiladas
- [ ] **Total: 56 subcriterios** - Todas las puntuaciones documentadas

### Cálculo por Categoría

- [ ] **Puntuación_Críticos calculada** - Σ(Puntuación_Ci) / (20 × 18) × 100
- [ ] **Puntuación_Importantes calculada** - Σ(Puntuación_Ii) / (20 × 18) × 100
- [ ] **Puntuación_Menores calculada** - Σ(Puntuación_Mi) / (16 × 18) × 100

### Aplicación de Ponderación

- [ ] **Peso críticos aplicado** - Puntuación_Críticos × 3.0
- [ ] **Peso importantes aplicado** - Puntuación_Importantes × 2.0
- [ ] **Peso menores aplicado** - Puntuación_Menores × 1.0
- [ ] **Puntuación ponderada total** - Suma de puntuaciones ponderadas

### Normalización Final

- [ ] **Nivel de completitud calculado** - Puntuación_Ponderada / 6.0 × 100
- [ ] **readiness_score redondeado** - Valor con 1 decimal
- [ ] **Porcentaje final: {{readiness_score}}%** - Resultado documentado

### Métricas Adicionales

- [ ] **critical_gaps_count** - Número de criterios C1-C6 con puntuación < 12
- [ ] **important_gaps_count** - Número de criterios I1-I6 con puntuación < 13
- [ ] **minor_gaps_count** - Número de criterios M1-M5 con puntuación < 16

### Determinación de Estado General

- [ ] **Estado calculado según fórmula** - Algoritmo aplicado correctamente
- [ ] **Criterios de aprobación verificados** - Umbrales evaluados
- [ ] **{{overall_status}} determinado** - Estado final asignado

**Posibles estados:**
- ✅ APTO PARA ARQUITECTURA (readiness_score ≥ 85 Y critical_gaps = 0)
- ⚠️ APTO CON RESERVAS (readiness_score ≥ 70 Y critical_gaps ≤ 2)
- ⚠️ PARCIALMENTE APTO (readiness_score ≥ 50)
- ❌ NO APTO (readiness_score < 50)

### Tabla de Cálculo Detallado

- [ ] **Tabla generada** - Puntuaciones por categoría documentadas

| Categoría | Subcriterios | Puntuación Obtenida | Máxima | % Categoría | Peso | Contribución |
|-----------|--------------|---------------------|--------|-------------|------|--------------|
| Críticos | 20 | ___/360 | 360 | ___% | 3.0 | ___ |
| Importantes | 20 | ___/360 | 360 | ___% | 2.0 | ___ |
| Menores | 16 | ___/288 | 288 | ___% | 1.0 | ___ |
| **TOTAL** | **56** | **___/1008** | **1008** | **___% | **6.0** | **___** |

### Output Generado

- [ ] **`{{calculo_objetivo_nivel_completitud}}`** - Cálculo completo documentado
- [ ] **Metodología transparente** - Fórmulas y procedimiento claramente explicados
- [ ] **Tabla incluida en reporte** - Información visible para auditoría

---

## Paso 0.7: Generar Reporte de Validación

### Compilación de Información

- [ ] **Toda la información analizada compilada** - Datos de todos los pasos anteriores
- [ ] **Reporte estructurado generado** - Formato consistente y profesional
- [ ] **Información detallada incluida** - NO resumida, con nivel de detalle apropiado
- [ ] **Tabla de cálculo incluida** - Del paso 0.6, completa y legible

### Contenido del Reporte

- [ ] **Sección de disponibilidad** - Paso 0.1 integrado
- [ ] **Sección de análisis de completitud** - Paso 0.2 integrado
- [ ] **Sección de resumen** - Paso 0.3 integrado con matriz
- [ ] **Sección de análisis de gaps** - Paso 0.4 integrado con 56 criterios
- [ ] **Sección de recomendaciones** - Paso 0.5 integrado
- [ ] **Sección de cálculo** - Paso 0.6 integrado con tabla detallada
- [ ] **Métricas de completitud** - readiness_score y gaps counts
- [ ] **Recomendaciones priorizadas** - Plan de acción claro

### Verificación de Variables

- [ ] **{{project_name}} reemplazado** - Nombre del proyecto en todos los lugares
- [ ] **{{disponibilidad_documentacion_comercial}} reemplazado** - Contenido del paso 0.1
- [ ] **{{analisis_completitud_documentacion_comercial}} reemplazado** - Contenido del paso 0.2
- [ ] **{{resumen_completitud_documentacion_comercial}} reemplazado** - Contenido del paso 0.3
- [ ] **{{analisis_gaps_identificados}} reemplazado** - Contenido del paso 0.4
- [ ] **{{recomendaciones_específicas_accionables}} reemplazado** - Contenido del paso 0.5
- [ ] **{{calculo_objetivo_nivel_completitud}} reemplazado** - Contenido del paso 0.6
- [ ] **{{readiness_score}} reemplazado** - Valor numérico calculado
- [ ] **{{critical_gaps_count}} reemplazado** - Número de gaps críticos
- [ ] **{{important_gaps_count}} reemplazado** - Número de gaps importantes
- [ ] **{{minor_gaps_count}} reemplazado** - Número de gaps menores
- [ ] **{{overall_status}} reemplazado** - Estado final determinado
- [ ] **{{date}} reemplazado** - Fecha actual del sistema
- [ ] **{{user_name}} reemplazado** - Nombre del usuario/validador

### Revisión Final

- [ ] **NO quedan variables sin reemplazar** - Revisión exhaustiva del documento
- [ ] **Todas las secciones completas** - Sin placeholders vacíos
- [ ] **Formato consistente** - Markdown correcto y legible
- [ ] **Tablas bien formateadas** - Todas las tablas renderizables

### Archivo Generado

- [ ] **Archivo creado en ubicación correcta** - {output_folder}/propuesta/04-arquitectura/reporte-validacion-completitud-prd.md
- [ ] **Permisos de archivo correctos** - Archivo accesible
- [ ] **Contenido verificado** - Archivo contiene información completa

---

## Paso 0.8: Recomendaciones Finales y Próximos Pasos

### Resumen Ejecutivo Mostrado

- [ ] **Nivel de completitud** - {{readiness_score}}% mostrado al usuario
- [ ] **Gaps críticos** - {{critical_gaps_count}} de 20 criterios
- [ ] **Gaps importantes** - {{important_gaps_count}} de 20 criterios
- [ ] **Gaps menores** - {{minor_gaps_count}} de 16 criterios
- [ ] **Estado general** - {{overall_status}} comunicado claramente

### Metodología Explicada

- [ ] **Evaluación objetiva documentada** - 56 subcriterios en 3 categorías
- [ ] **Ponderación explicada** - Críticos (3.0) + Importantes (2.0) + Menores (1.0)
- [ ] **Fórmula matemática compartida** - Transparencia en el cálculo

### Próximos Pasos Definidos

- [ ] **{{priority_action_1}} comunicado** - Primera acción prioritaria
- [ ] **{{priority_action_2}} comunicado** - Segunda acción prioritaria
- [ ] **{{priority_action_3}} comunicado** - Tercera acción prioritaria

### Interacción con Usuario

- [ ] **Opciones presentadas al usuario** - Ver reporte / Proceder / Salir
- [ ] **Respuesta del usuario capturada** - Elección registrada

### Validación Obligatoria (si proceder con arquitectura)

- [ ] **Umbral verificado** - readiness_score ≥ 70
- [ ] **Gaps críticos verificados** - critical_gaps_count ≤ 2
- [ ] **Bloqueo aplicado si necesario** - Flujo detenido si no cumple criterios
- [ ] **Mensaje de bloqueo mostrado** - Razones claras si no puede continuar

### Archivo de Reporte

- [ ] **Ubicación del reporte comunicada** - Ruta completa proporcionada al usuario
- [ ] **Reporte accesible** - Usuario puede abrir y revisar el archivo

---

## Validación General del Workflow

### Variables y Consistencia

- [ ] **Todas las variables de config usadas** - {communication_language}, {document_output_language}, {output_folder}, {user_name}, {date}
- [ ] **Variables reemplazadas correctamente** - Ningún placeholder sin valor
- [ ] **Coherencia en nomenclatura** - Nombres de variables consistentes

### Estructura y Formato del Reporte

- [ ] **Markdown válido** - Sintaxis correcta en todo el documento
- [ ] **Tablas completas** - Todas las tablas con datos
- [ ] **Enlaces funcionales** - Si hay referencias internas
- [ ] **Jerarquía de encabezados** - Niveles H1, H2, H3 apropiados
- [ ] **Listas formateadas** - Bullets y numeraciones correctas

### Completitud del Análisis

- [ ] **56 subcriterios evaluados** - Todos los criterios revisados
- [ ] **Puntuaciones asignadas** - Cada criterio con valor 0-18
- [ ] **Categorización justificada** - Niveles crítico/importante/menor con razones
- [ ] **Gaps identificados** - Lista completa y priorizada
- [ ] **Recomendaciones accionables** - Pasos concretos para mejorar PRD

### Cálculo Matemático

- [ ] **Fórmulas aplicadas correctamente** - Matemática del paso 0.6 verificada
- [ ] **Ponderaciones correctas** - Pesos 3.0, 2.0, 1.0 aplicados
- [ ] **Normalización correcta** - División por 6.0 para porcentaje final
- [ ] **Redondeo apropiado** - 1 decimal en readiness_score

### Salida Final

- [ ] **Archivo generado en ubicación correcta** - {output_folder}/propuesta/04-arquitectura/
- [ ] **Nombre de archivo correcto** - reporte-validacion-completitud-prd.md
- [ ] **Contenido completo y legible** - Documento profesional y útil
- [ ] **Usuario informado** - Opciones y próximos pasos claros

---

## Criterios de Aprobación del Workflow

**✅ WORKFLOW EXITOSO** - Todos los elementos del checklist completados y reporte generado con éxito

**Condiciones de éxito:**
- [ ] 8 pasos ejecutados completamente
- [ ] 56 subcriterios evaluados objetivamente
- [ ] Nivel de completitud calculado matemáticamente (readiness_score)
- [ ] Todas las variables reemplazadas en el reporte
- [ ] Reporte generado y guardado correctamente
- [ ] Usuario informado de resultados y próximos pasos

**⚠️ WORKFLOW CON ADVERTENCIAS** - Workflow completado pero con gaps significativos identificados

**Condiciones:**
- [ ] readiness_score < 70 O critical_gaps_count > 2
- [ ] Usuario advertido que no es recomendable proceder con arquitectura
- [ ] Reporte generado con recomendaciones para mejorar PRD

**❌ WORKFLOW FALLIDO** - No se pudo completar el análisis

**Condiciones de fallo:**
- [ ] No se encontró documentación base (PRD o alternativas)
- [ ] Variables críticas no pudieron reemplazarse
- [ ] Error en generación del archivo de reporte
- [ ] Cálculo de completitud no pudo ejecutarse

---

## Notas de Validación

```
[Espacio para notas del validador]

Fecha de ejecución: _______________
Proyecto: _______________
Nivel de completitud: _______________
Estado final: _______________

Observaciones:
- 
- 
- 

Recomendaciones prioritarias:
1. 
2. 
3. 

```

---

**Checklist v1.0** - Método Ceiba - Validación Completitud PRD  
**Basado en:** 56 subcriterios objetivos distribuidos en 3 categorías con ponderación matemática
