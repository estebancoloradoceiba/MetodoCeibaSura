---
last-redoc-date: 2025-11-20
---

# Crear Arquitectura Solución

## Propósito

Workflow integral para generar documentación de arquitectura de solución de alto nivel basada en la plantilla arc42, diseñado específicamente para proyectos en etapa de propuesta comercial o que están iniciando su fase de construcción. Produce una definición arquitectónica completa y estructurada que incluye contexto de negocio, decisiones técnicas fundamentales, vistas estáticas y dinámicas del sistema, y evaluación de riesgos.

## Características Distintivas

### Arquitectura Basada en arc42

Implementa la metodología arc42, un estándar de facto en Europa para documentación arquitectónica:

- **12 secciones estructuradas** que cubren todos los aspectos arquitectónicos relevantes
- **Separación clara entre vistas** (estática, dinámica, despliegue) para diferentes audiencias
- **Énfasis en decisiones y justificaciones** no solo en diagramas
- **Lenguaje común** entre stakeholders técnicos y de negocio

### Validación Obligatoria de Completitud PRD

**Paso 0 crítico** que garantiza la calidad de los inputs antes de iniciar el diseño:

- Invoca automáticamente el workflow `validar-completitud-prd` si no existe reporte previo
- **Bloquea la generación de arquitectura** si el PRD no alcanza umbral mínimo (readiness_score < 70% O critical_gaps > 2)
- Previene arquitecturas basadas en requisitos ambiguos o incompletos
- Usuario puede optar por re-ejecutar validación aunque exista reporte previo

Este gate de calidad obligatorio diferencia este workflow de enfoques tradicionales que asumen inputs completos.

### Modelado con C4 y Mermaid

Genera diagramas arquitectónicos usando:

- **C4 Model** (Context, Container, Component, Code) para estructurar vistas
- **Mermaid syntax** para facilitar versionado y colaboración
- **Notación de proveedores cloud** (AWS/Azure/GCP) para contexto técnico de soluciones cloud
- **UML Sequence Diagrams** para flujos dinámicos

Ventajas sobre herramientas tradicionales:
- Diagramas como código (versionables, reviewables)
- Generación automática desde texto
- No requiere herramientas gráficas especializadas

### Elicitación Avanzada Integrada

Activa el modo `elicitation_mode: "advanced"` en puntos críticos del workflow:

- **Tag `<elicit-required>`** en cada paso para profundización automática
- AI analiza contexto y hace preguntas de seguimiento inteligentes
- Descubre requisitos ocultos o no especificados
- Valida supuestos y resuelve ambigüedades en tiempo real

Esto transforma el workflow de un proceso de documentación pasivo a una **sesión colaborativa de discovery arquitectónico**.

### Architecture Decision Records (ADR)

Documenta decisiones arquitectónicas usando ADR estándar:

- **Plantillas oficiales**: MADR (Markdown Architecture Decision Records) o Nygard ADR
- **Contexto, decisión, consecuencias** explícitos
- **Alternativas consideradas** y razones de descarte
- **Trazabilidad** entre decisiones y objetivos de calidad

Facilita auditorías, onboarding de nuevos arquitectos y revisión de decisiones pasadas.

### Escenarios de Calidad Concretos

Transforma atributos de calidad abstractos en escenarios verificables:

**Estructura de escenario**:
- Fuente del estímulo (quién genera el evento)
- Estímulo (qué acción ocurre)
- Entorno/contexto (bajo qué condiciones)
- Artefacto afectado (qué parte del sistema)
- Respuesta esperada (qué debe hacer el sistema)
- **Medida de respuesta** (métricas cuantificables)

Ejemplo: En lugar de "el sistema debe ser rápido" → "Cuando un usuario consulta su saldo (estímulo) en horas pico (contexto), el sistema debe responder en <2 segundos (medida)"

Estos escenarios sirven como:
- Criterios de aceptación para validación arquitectónica
- Input para diseño de pruebas de calidad
- Base para discusiones técnicas entre equipos

## Uso

### Invocación

**Desde agente de Arquitectura:**
```
*crear-arquitectura-solucion
```

**Vía workflow directo:**
```
/crear-arquitectura-solucion
```

### Prerrequisitos

1. **Validación PRD exitosa** (o disposición a ejecutarla):
   - Idealmente existe `{output_folder}/propuesta/04-arquitectura/reporte-validacion-completitud-prd.md`
   - Si no existe, el workflow lo generará automáticamente en el Paso 0

2. **Documentación de requisitos disponible**:
   - PRD: `{output_folder}/propuesta/03-prd/PRD.md`
   - Épicas: `{output_folder}/propuesta/03-prd/epicas.md`
   - Brief: `{output_folder}/propuesta/02-brief-alcance/brief-alcance.md`

3. **Conocimiento arquitectónico**: El usuario (arquitecto) debe tener:
   - Comprensión del dominio de negocio
   - Capacidad de tomar decisiones técnicas fundamentales
   - Conocimiento de patrones y estilos arquitectónicos

### Entradas

**Requeridas**:
- `{{project_name}}` - Nombre del proyecto (solicitado en Paso 1)

**Recomendadas** (cargadas automáticamente si existen):
- PRD con requisitos funcionales y no funcionales
- Épicas con historias de usuario
- Brief de alcance
- Reporte de validación de completitud del PRD

**Interactivas**:
- Confirmación o refinamiento de análisis en cada paso
- Decisiones arquitectónicas fundamentales
- Priorización de objetivos de calidad
- Validación de diagramas y estructuras propuestas

## Salidas

### Documento Principal

**Archivo**: `{output_folder}/propuesta/04-arquitectura/arquitectura-solucion-comercial.md`

**Estructura completa** (basada en arc42):

#### 1. Introducción y Objetivos
- **Resumen de Requisitos** - Extracto conciso de FR y motivaciones del sistema
- **Objetivos de Calidad** - 3-5 ASR (Architecturally Significant Requirements) prioritarios
- **Interesados** - Roles, expectativas y necesidades documentadas

#### 2. Restricciones
- **Técnicas** - Tecnologías, infraestructura, seguridad obligatorias
- **Organizativas** - Directrices corporativas, procesos establecidos
- **Políticas** - Normativas legales, acuerdos contractuales
- **Convenciones** - Guías de programación, versionado, documentación

#### 3. Contexto y Alcance
- **Contexto de Negocio** - Diagrama C4 Context + tabla descriptiva de interfaces
- **Contexto Técnico** - Diagrama C4 Deployment (o notación cloud) + mapeo de canales técnicos

#### 4. Estrategia de Solución
- Decisiones tecnológicas fundamentales
- Patrones arquitectónicos seleccionados
- Estrategias para alcanzar objetivos de calidad
- Decisiones organizativas relevantes

#### 5. Vista Estática
- **Diagrama C4 Container** - Descomposición en aplicaciones, servicios, bases de datos
- **Descripción de elementos** - Propósito, responsabilidad e interfaces de cada contenedor

#### 6. Vista Dinámica
- **Diagramas de secuencia** - Flujos críticos y representativos
- Casos de uso importantes ejecutados por el sistema
- Interacciones en interfaces externas críticas
- Operación, administración y manejo de errores

#### 7. Vista de Despliegue
- **Diagrama C4 Deployment detallado** - Infraestructura técnica completa
- Ubicaciones geográficas, entornos, computadoras, redes
- Asignación de bloques de construcción a infraestructura

#### 8. Aspectos Transversales
- Seguridad (autenticación, autorización, cifrado)
- Observabilidad (logs, métricas, trazas)
- Manejo de errores y excepciones
- Persistencia y transacciones
- UX/UI y patrones de diseño
- Referencias a documentos externos aplicables

#### 9. Decisiones de Arquitectura
- **ADR (Architecture Decision Records)** usando plantilla MADR o Nygard
- Decisiones costosas, a gran escala o arriesgadas
- Contexto, alternativas consideradas, consecuencias
- Justificaciones técnicas y de negocio

#### 10. Requerimientos de Calidad
- **Otros Objetivos de Calidad** - Atributos secundarios (referencia arc42 quality model)
- **Escenarios de Calidad** - 2-3 escenarios concretos por objetivo principal
  - Estructura: Fuente, Estímulo, Entorno, Artefacto, Respuesta, Medida
  - Métricas cuantificables y verificables

#### 11. Riesgos y Deuda Técnica
- Riesgos técnicos identificados (descripción, impacto, probabilidad, área)
- Deudas técnicas presentes o potenciales
- Priorización según severidad e impacto
- Medidas para evitar, mitigar o reducir

#### 12. Glosario
- Términos del dominio de negocio
- Términos técnicos específicos
- Acrónimos y abreviaturas
- Definiciones claras y consensuadas con stakeholders

### Variables Clave Generadas

Cada paso del workflow genera variables que se integran en el template:

- `{{resumen_requisitos}}` - Extracto de requisitos funcionales
- `{{objetivos_calidad}}` - 3-5 ASR principales
- `{{tabla_interesados}}` - Stakeholders y expectativas
- `{{restricciones}}` - Restricciones técnicas/organizativas/políticas
- `{{contexto_negocio}}` - Diagrama C4 Context + descripciones
- `{{contexto_tecnico}}` - Diagrama C4 Deployment + justificaciones
- `{{estrategia_solucion}}` - Decisiones fundamentales
- `{{vista_estatica}}` - Diagrama C4 Container + descripciones
- `{{vista_dinamica}}` - Diagramas de secuencia de flujos críticos
- `{{vista_despliegue}}` - Diagrama de infraestructura detallado
- `{{aspectos_transversales}}` - Conceptos cross-cutting
- `{{decisiones_arquitectura}}` - ADRs documentados
- `{{otros_objetivos_calidad}}` - Atributos de calidad secundarios
- `{{escenarios_calidad}}` - Escenarios concretos con métricas
- `{{riesgos_deuda_tecnica}}` - Riesgos priorizados con medidas
- `{{glosario}}` - Términos clave con definiciones

## Flujo de Trabajo

### Paso 0: Preparación y Contexto Inicial

**Paso 0.1: Validar Completitud Información Requisitos de Producto**

- Verificar existencia de `{output_folder}/propuesta/04-arquitectura/reporte-validacion-completitud-prd.md`
- Si existe: Ofrecer opciones al usuario
  1. Continuar con creación de arquitectura (ir a Paso 1)
  2. Re-ejecutar validación de completitud del PRD
  3. Salir
- Si NO existe O usuario selecciona opción 2:
  - **Invocar workflow**: `validar-completitud-prd`
  - Esperar a que complete completamente
  - Si validación resulta en NO APTO o PARCIALMENTE APTO → **DETENER workflow**
  - No continuar con generación de arquitectura hasta resolver gaps críticos

**Criticidad**: Este paso NO puede omitirse. Es un gate de calidad obligatorio.

### Paso 1: Definir Introducción y Objetivos

**1.1: Realizar Resumen de Requisitos**
- Extraer o resumir requisitos funcionales clave del PRD
- Identificar motivaciones y fuerzas impulsoras del sistema
- Mantener extracto breve (balance legibilidad vs redundancia)
- Referenciar documentos de requisitos detallados
- Generar `{{resumen_requisitos}}` para template

**1.2: Definir Objetivos de Calidad**
- Identificar 3-5 atributos de calidad más críticos
- Formular cada uno como ASR (Architecturally Significant Requirement)
- Basar priorización en expectativas de stakeholders
- Referenciar modelo de calidad arc42 (https://quality.arc42.org/)
- Justificar relevancia: por qué es crucial y cómo influirá en diseño
- Evitar términos ambiguos o de moda (usar definiciones concretas)
- Generar `{{objetivos_calidad}}` para template
- **Tag**: `<elicit-required>` - Elicitación avanzada activa

**1.3: Identificar Interesados**
- Listar personas, roles u organizaciones que:
  - Deben conocer la arquitectura
  - Deben aprobar o dar visto bueno
  - Trabajarán con arquitectura o código
  - Necesitan documentación para su trabajo
  - Tomarán decisiones sobre el sistema
- Documentar expectativas de cada interesado
- Generar `{{tabla_interesados}}` para template
- **Tag**: `<elicit-required>`

### Paso 2: Identificar Restricciones

- Documentar requisitos que limitan libertad de diseño e implementación
- Clasificar restricciones:
  - **Técnicas**: Tecnologías obligatorias, infraestructura, seguridad
  - **Organizativas**: Directrices corporativas, procesos de desarrollo
  - **Políticas**: Normativas legales, acuerdos contractuales
  - **Convenciones**: Guías de programación, versionado, documentación
- **Importante**: Restricciones NO son supuestos
- Documentar en lista simple con explicaciones
- Generar `{{restricciones}}` para template
- **Tag**: `<elicit-required>`

### Paso 3: Contexto y Alcance

**3.1: Contexto de Negocio**
- Identificar todos los sistemas y personas con los que interactúa el sistema
- Especificar entradas y salidas propias del dominio
- Usar **Mermaid C4Context** para diagrama
- Crear tabla descriptiva: elemento, entradas, salidas
- Enfoque: Comprensible para personas sin conocimientos técnicos
- Generar `{{contexto_negocio}}` para template
- **Tag**: `<elicit-required>`

**3.2: Contexto Técnico**
- Identificar canales técnicos que enlazan sistema con entorno
- Mapear entradas/salidas a canales técnicos
- Usar **Mermaid C4Deployment** o notación del proveedor cloud (AWS/Azure/GCP)
- Listar servicios/componentes con descripción y justificación de uso
- Nivel de detalle: Alto nivel (detalle viene en Paso 7)
- Generar `{{contexto_tecnico}}` para template
- **Tag**: `<elicit-required>`

### Paso 4: Estrategia de Solución

- Resumir decisiones fundamentales que configuran la arquitectura
- Incluir:
  - **Decisiones tecnológicas**: Elecciones de tecnologías
  - **Descomposición de alto nivel**: Patrones arquitectónicos/diseño
  - **Cumplimiento objetivos de calidad**: Estrategias concretas
  - **Decisiones organizativas**: Procesos, delegación a terceros
- Mantener explicación breve: qué decidiste y por qué
- Basar en declaración del problema, objetivos de calidad y restricciones
- Lista sin agrupar (decisiones individuales)
- Generar `{{estrategia_solucion}}` para template
- **Tag**: `<elicit-required>`

### Paso 5: Vista Estática

- Mostrar descomposición del sistema en bloques de construcción (módulos, componentes, subsistemas)
- Usar **Mermaid C4Container**: aplicaciones, servicios, bases de datos
- Mantener abstracción apropiada (comprensible, sin detalles de implementación)
- Describir propósito, responsabilidad e interfaces de cada elemento
- Vista obligatoria para toda documentación arquitectónica
- Generar `{{vista_estatica}}` para template
- **Tag**: `<elicit-required>`

### Paso 6: Vista Dinámica (Iterativo - for-each-flujo)

- Criterio de selección: **Relevancia arquitectónica** (no cantidad)
- Documentar escenarios críticos/representativos:
  - Casos de uso o características importantes
  - Interacciones en interfaces externas críticas
  - Operación y administración (inicio, detención, errores)
- Usar **Mermaid sequenceDiagram** para cada flujo
- Identificar nombre del flujo
- Mostrar cómo bloques realizan su trabajo y se comunican en runtime
- Repetir para cada flujo relevante
- Generar `{{vista_dinamica}}` para template
- **Tag**: `<elicit-required>`

### Paso 7: Vista de Despliegue

- Identificar elementos de infraestructura:
  - Ubicaciones geográficas, entornos, computadoras, procesadores, redes
- Asignar bloques de construcción a elementos de infraestructura
- Mostrar lista al usuario y solicitar confirmación/modificaciones
- Profundizar configuración y consideraciones de despliegue
- Usar **Mermaid C4Deployment** para diagrama detallado
- **Importante**: Nivel más detallado que Contexto Técnico (Paso 3.2)
- Generar `{{vista_despliegue}}` para template
- **Tag**: `<elicit-required>`

### Paso 8: Aspectos Transversales

- Describir regulaciones e ideas de solución relevantes en múltiples partes (cross-cutting)
- Áreas típicas:
  - Modelos de dominio
  - Manejo de excepciones
  - Persistencia y transacciones
  - Experiencia de Usuario (UX)
  - Seguridad (autenticación, autorización, cifrado)
  - Observabilidad (logs, métricas, trazas)
  - Patrones arquitectónicos/diseño
  - Decisiones técnicas principales
- **No hay estructura obligatoria**: Depende de proyecto, lineamientos y criterio del arquitecto
- Preguntar al usuario si estructura propuesta es apropiada antes de continuar
- Referenciar documentos externos con definiciones transversales
- Generar `{{aspectos_transversales}}` para template
- **Tag**: `<elicit-required>`

### Paso 9: Decisiones de Arquitectura

- Documentar decisiones arquitectónicas importantes, costosas, a gran escala o arriesgadas
- Usar **ADR (Architecture Decision Records)**:
  - **MADR**: Plantilla completa o simplificada (https://adr.github.io/madr/)
  - **Nygard ADR**: Plantilla clásica (https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- Incluir:
  - Contexto de la decisión
  - Alternativas consideradas
  - Decisión tomada
  - Consecuencias (positivas y negativas)
- Evitar redundancia: Referenciar Sección 4 (Estrategia de Solución) cuando corresponda
- Criterio: ¿Es comprensible para los stakeholders?
- Generar `{{decisiones_arquitectura}}` para template
- **Tag**: `<elicit-required>`

### Paso 10: Requerimientos de Calidad

**10.1: Otros Objetivos de Calidad**
- Verificar que objetivos principales están en Paso 1.2
- Documentar requerimientos de calidad **secundarios** (menor prioridad)
- Usar modelo de calidad arc42 (https://quality.arc42.org/) como referencia
- Identificar requerimientos por stakeholder
- Evaluar impacto arquitectónico de cada requerimiento
- Documentar correlación entre requerimientos y decisiones arquitectónicas
- Generar `{{otros_objetivos_calidad}}` para template
- **Tag**: `<elicit-required>`

**10.2: Escenarios de Calidad**
- Para cada objetivo de calidad (Paso 1.2), crear 2-3 escenarios concretos
- Estructura de escenario:
  - **Fuente del estímulo**: Quién/qué genera el evento
  - **Estímulo**: Qué acción ocurre
  - **Entorno/Contexto**: Bajo qué condiciones
  - **Artefacto afectado**: Qué parte del sistema
  - **Respuesta esperada**: Qué debe hacer el sistema
  - **Medida de respuesta**: Métricas cuantificables
- Transformar requisitos abstractos en escenarios medibles
- Asegurar que sean específicos, verificables, relevantes, detallados
- Usar como criterios de aceptación y validación arquitectónica
- Generar `{{escenarios_calidad}}` para template
- **Tag**: `<elicit-required>`

### Paso 11: Riesgos y Deuda Técnica

- Identificar todos los riesgos técnicos y deudas técnicas (presentes o potenciales)
- Para cada elemento documentar:
  - Descripción clara
  - Impacto (consecuencias si se materializa)
  - Probabilidad (para riesgos)
  - Área afectada (componentes, módulos)
  - Prioridad (alta, media, baja)
- Ordenar lista por prioridad (impacto × probabilidad)
- Definir medidas concretas:
  - Evitar, mitigar, minimizar (para riesgos)
  - Reducir deuda (plan de acción)
- Comunicar riesgos críticos a stakeholders relevantes
- Generar `{{riesgos_deuda_tecnica}}` para template
- **Tag**: `<elicit-required>`

### Paso 12: Glosario

- Identificar términos clave:
  - Términos del dominio de negocio
  - Términos técnicos específicos
  - Conceptos arquitectónicos particulares
  - Acrónimos y abreviaturas
- Para cada término crear entrada:
  - Término (nombre exacto usado en proyecto)
  - Definición clara y precisa
  - Sinónimos (si existen)
  - Traducción (entornos multilingües/offshore)
  - Contexto de uso
- Eliminar ambigüedades (homónimos, sinónimos innecesarios)
- Ordenar alfabéticamente
- Validar con stakeholders para consenso
- Generar `{{glosario}}` para template
- **Tag**: `<elicit-required>`

## Integración con Método Ceiba

### Posición en el Proceso

Este workflow se ejecuta **después de la validación de completitud del PRD y antes del desarrollo**:

1. **Previo**: Proceso comercial genera PRD + Validación de completitud
2. **Este workflow**: Creación de arquitectura de solución
3. **Posterior**: Inicio de fase de construcción con arquitectura definida

### Dependencia Obligatoria con Validación PRD

- El **Paso 0** invoca `validar-completitud-prd` si no existe reporte previo
- Si validación falla (score < 70% o >2 gaps críticos), workflow se **detiene**
- Usuario debe completar gaps críticos antes de continuar
- Este acoplamiento garantiza calidad de inputs arquitectónicos

### Relación con Fase de Construcción

La arquitectura generada sirve como:
- **Blueprint** para equipos de desarrollo
- **Guía de decisiones** durante implementación
- **Documentación de referencia** para onboarding
- **Baseline** para evolución arquitectónica posterior

### Salidas para Gestión de Proyectos

Los ADRs y escenarios de calidad se utilizan como:
- Input para estimación de esfuerzo
- Criterios de aceptación en historias técnicas
- Base para planes de prueba de calidad

## Configuración

**Variables desde config.yaml**:
- `output_folder` - Carpeta de salida para arquitectura
- `user_name` - Nombre del arquitecto responsable
- `communication_language` - Idioma de interacción (español por defecto)
- `document_output_language` - Idioma del documento generado
- `date` - Fecha de generación (system-generated)

**Rutas esperadas**:
- Documentación comercial: `{output_folder}/propuesta/`
- Arquitectura de salida: `{output_folder}/propuesta/04-arquitectura/`

**Modo de elicitación**:
- `elicitation_mode: "advanced"` - Activado para profundización automática en cada paso

## Limitaciones y Consideraciones

### Lo que NO hace este workflow

- **No implementa código** - Solo documenta arquitectura
- **No valida viabilidad técnica exhaustiva** - Supone que arquitecto tiene expertise
- **No genera estimaciones de esfuerzo** - Eso requiere análisis adicional
- **No sustituye diseño detallado** - Arquitectura de alto nivel solamente

### Supuestos

- Arquitecto tiene conocimiento técnico suficiente para tomar decisiones fundamentales
- Documentación de requisitos está en formato Markdown
- Estructura de carpetas sigue convención del Método Ceiba
- Usuario puede generar diagramas Mermaid (el workflow genera sintaxis, no renderiza)

### Escenarios de Uso

**Escenario ideal - Greenfield**:
1. Proceso comercial completo con PRD validado (score ≥85%)
2. Arquitecto ejecuta workflow completo en 2-4 horas de sesión colaborativa
3. Documento de arquitectura listo para revisión de stakeholders
4. Aprobación y inicio de fase de construcción

**Escenario con iteración - PRD incompleto**:
1. Ejecutar workflow, Paso 0 detecta PRD incompleto
2. Validación muestra gaps críticos (score 60%, 5 gaps críticos)
3. Workflow se detiene, arquitecto trabaja con comercial para completar PRD
4. Re-ejecución alcanza validación exitosa
5. Continúa con definición arquitectónica

**Escenario Brownfield - Sistema existente**:
1. Arquitecto usa workflow para documentar arquitectura actual
2. Secciones como Contexto y Vistas se completan basándose en sistema existente
3. Riesgos y Deuda Técnica se enfocan en problemas actuales
4. Documento sirve como baseline para evolución futura

**Escenario híbrido - Arquitectura parcial existente**:
1. Sistema tiene algunos componentes ya implementados
2. Workflow se usa para formalizar decisiones pasadas (ADRs retrospectivos)
3. Completar vistas faltantes (ej: vista dinámica no documentada)
4. Definir arquitectura de nuevos componentes a construir

## Mejores Prácticas

1. **Ejecutar validación PRD primero** - No saltarse el Paso 0, garantiza calidad de inputs

2. **Sesión colaborativa continua** - Dedicar 2-4 horas ininterrumpidas con stakeholders clave, mejor que múltiples sesiones fragmentadas

3. **Usar elicitación avanzada** - Aprovechar `<elicit-required>` tags para profundizar en cada sección, no solo llenar templates

4. **Diagramas como código** - Comprometer Mermaid source en repositorio junto con documento, facilita versionado y revisión

5. **ADRs tempranos** - Documentar decisiones mientras se toman, no después, captura contexto y razones frescas

6. **Escenarios de calidad medibles** - Incluir siempre métricas cuantificables, evitar términos ambiguos como "rápido" o "escalable" sin números

7. **Iteración sobre secciones críticas** - Invertir más tiempo en Estrategia de Solución, Vistas y Decisiones, son el corazón de la arquitectura

8. **Revisión con stakeholders** - Validar secciones críticas con stakeholders antes de finalizar, especialmente Objetivos de Calidad y Restricciones

9. **Mantener template inmutable** - No modificar archivos de template, garantiza reutilización consistente

10. **Documentar riesgos temprano** - Identificar y comunicar riesgos críticos desde el inicio, no al final

## Extensiones y Personalizaciones

### Adaptación de Template

El template `solution-architecture-template.md` puede personalizarse para necesidades específicas:
- Agregar secciones adicionales (ej: Plan de Migración, Estrategia de Testing)
- Modificar estructura de Aspectos Transversales según estándares corporativos
- Agregar campos específicos de la organización

### Integración con Herramientas

El documento generado puede integrarse con:
- **Wikis corporativos** (Confluence, Notion) - Importar Markdown directamente
- **Herramientas de diagramado** (Mermaid Live, PlantUML) - Renderizar diagramas
- **Sistemas de gestión de ADR** (adr-tools, log4brains) - Extraer y versionar ADRs
- **Plataformas de gestión de requisitos** (Jira, Azure DevOps) - Enlazar escenarios de calidad con historias

### Web Bundle

Workflow incluye configuración `web_bundle` para portabilidad:
- Empaqueta todos los archivos necesarios (workflow.yaml, instructions.md, template, checklist)
- Incluye workflow de validación PRD como dependencia
- Permite ejecución en plataformas web sin instalación local

---

**Última actualización**: 2025-11-20  
**Versión del workflow**: 1.0.0  
**Módulo**: metodo-ceiba  
**Categoría**: Arquitectura - Generación  
**Basado en**: arc42 architecture template v8.0
