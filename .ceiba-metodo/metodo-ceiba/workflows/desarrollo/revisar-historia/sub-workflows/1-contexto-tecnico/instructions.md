# Contexto Técnico - Instrucciones del Sub-Workflow

```xml
<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>Communicate all responses in {communication_language}</critical>
<critical>Este es un SUB-WORKFLOW invocado por revisar-historia - NO standalone</critical>
<critical>CONTEXT BUDGET: Máximo 500 tokens de salida al padre para prevenir context exhaustion</critical>

<workflow>

  <step n="1" goal="Cargar análisis arquitectónico de la historia">
    <action>Abrir archivo de historia desde {{story_context.story_path}}</action>
    <action>Buscar sección "## Análisis Arquitectónico (Arquitecto)"</action>
    
    <check if="sección encontrada">
      <action>Leer contenido completo de la sección</action>
      <action>Extraer: decisiones arquitectónicas, componentes afectados, patrones a seguir, consideraciones técnicas</action>
      <action>Almacenar en {{architectural_analysis}}</action>
    </check>
    
    <check if="sección NO encontrada">
      <action>Registrar en {{warnings}}: "No se encontró análisis arquitectónico previo en la historia"</action>
      <action>Continuar con {{architectural_analysis}} = null</action>
    </check>
  </step>

  <step n="2" goal="Cargar GPS arquitectónico y estándares de código">
    <action>Construir ruta completa: {{architecture_location}}/{{architecture_file}}</action>
    <action>Típicamente: {{architecture_sharded_location}}/index.md</action>
    
    <check if="archivo existe">
      <action>Leer GPS arquitectónico (index.md) - LÍMITE: 2000 tokens máximo</action>
      <action>Extraer resumen: visión general (1 párrafo), componentes principales (lista), patrones clave (lista)</action>
      <action>Almacenar en {{gps_arquitectonico}}</action>
      <action>Incrementar {{architecture_docs_count}}</action>
    </check>
    
    <check if="archivo NO existe">
      <action>Registrar en {{warnings}}: "No se encontró GPS arquitectónico (index.md). Revisión arquitectónica será limitada"</action>
      <action>{{gps_arquitectonico}} = null</action>
    </check>

    <action>Buscar estándares de código: {{architecture_location}}/{{coding_standards_file}}</action>
    
    <check if="coding-standards.md existe">
      <action>Leer estándares de código - LÍMITE: 1500 tokens máximo</action>
      <action>Extraer solo: naming rules, patrones prohibidos, límites de complejidad</action>
      <action>Almacenar en {{coding_standards}}</action>
      <action>Marcar {{coding_standards_loaded}} = true</action>
      <action>Incrementar {{architecture_docs_count}}</action>
    </check>
    
    <check if="coding-standards.md NO existe">
      <action>Registrar en {{warnings}}: "No se encontró documento de estándares de código. Revisión se basará en mejores prácticas generales"</action>
      <action>{{coding_standards}} = null</action>
      <action>{{coding_standards_loaded}} = false</action>
    </check>
  </step>

  <step n="3" goal="Cargar documentación de componentes relevantes">
    <action>Obtener lista de archivos modificados desde {{story_context.dev_agent_record.lista_archivos}}</action>
    <action>Extraer componentes/módulos únicos de los paths (ej: "src/orders/" → componente "orders")</action>
    
    <action>Buscar documentos de componentes usando comodines en {{architecture_location}}:</action>
    <action>- architecture-*.md</action>
    <action>- component-*.md</action>
    
    <action>Para cada documento encontrado:</action>
    <action>1. Verificar si el nombre del documento coincide con algún componente modificado</action>
    <action>2. Si coincide: leer resumen del documento - LÍMITE: 500 tokens por componente</action>
    <action>3. Extraer solo: responsabilidades (1 línea), interfaces públicas (lista)</action>
    <action>4. Almacenar en {{component_docs}} array - máximo 3 componentes</action>
    
    <check if="no se encontraron documentos de componentes">
      <action>{{component_docs}} = []</action>
      <action>No es warning - es opcional</action>
    </check>
  </step>

  <step n="4" goal="Cargar flujos de negocio relevantes">
    <action>Analizar {{story_context.criterios_aceptacion}} para identificar flujos mencionados</action>
    <action>Buscar keywords como: "flujo", "proceso", "workflow", nombres de features</action>
    
    <action>Buscar documentos de flujos usando comodines en {{architecture_location}}:</action>
    <action>- flujo-*.md</action>
    <action>- flow-*.md</action>
    <action>- proceso-*.md</action>
    
    <action>Para cada documento encontrado:</action>
    <action>1. Verificar si el nombre coincide con keywords identificados en ACs</action>
    <action>2. Si coincide: leer resumen del flujo - LÍMITE: 400 tokens por flujo</action>
    <action>3. Extraer solo: pasos principales (lista numerada), validaciones críticas</action>
    <action>4. Almacenar en {{flow_docs}} array - máximo 2 flujos</action>
    
    <check if="no se encontraron documentos de flujos">
      <action>{{flow_docs}} = []</action>
      <action>No es warning - es opcional</action>
    </check>
  </step>

  <step n="5" goal="Detectar tech stack del proyecto">
    <action>Escanear manifiestos de dependencias en el directorio raíz del proyecto:</action>
    <action>- package.json (Node.js/JavaScript/TypeScript)</action>
    <action>- pyproject.toml / requirements.txt (Python)</action>
    <action>- go.mod (Go)</action>
    <action>- Dockerfile (Docker)</action>
    <action>- pom.xml (Java/Maven)</action>
    <action>- Gemfile (Ruby)</action>
    <action>- composer.json (PHP)</action>
    
    <action>Para cada manifiesto encontrado:</action>
    <action>1. Parsear contenido</action>
    <action>2. Identificar lenguaje primario y versión</action>
    <action>3. Identificar frameworks clave (ej: Express, React, FastAPI, Django, Spring, Rails)</action>
    <action>4. Identificar versiones de frameworks</action>
    <action>5. Identificar base de datos (si está en dependencias o conexiones)</action>
    <action>6. Almacenar en {{tech_stack}}</action>
    
    <action>Detectar ecosistema primario:</action>
    <action>- Node.js: Express, Nest, Koa, Fastify</action>
    <action>- Frontend: React, Vue, Angular, Svelte, Next.js, Nuxt</action>
    <action>- Python: FastAPI, Django, Flask, Tornado</action>
    <action>- Java: Spring Boot, Spring, Jakarta EE</action>
    <action>- Go: Gin, Echo, Fiber</action>
    <action>- Ruby: Rails, Sinatra</action>
    
    <action>Almacenar en {{stack_detected}} el ecosistema principal detectado</action>
  </step>

  <step n="6" goal="Sintetizar mejores prácticas según stack">
    <action>Basado en {{stack_detected}} y {{tech_stack}}, generar nota concisa de mejores prácticas:</action>
    
    <action>Node.js + Express: async/await, middleware patterns, error handling, validation (joi/zod)</action>
    <action>React: hooks, component composition, state management (Context/Redux), memoization</action>
    <action>Python + FastAPI: type hints, async def, dependency injection, Pydantic models</action>
    <action>Python + Django: ORM best practices, querysets, signals, middleware</action>
    <action>Java + Spring: dependency injection, @Transactional, exception handling, Bean lifecycle</action>
    <action>Go: error handling, goroutines, channels, defer patterns</action>
    
    <action>Incluir consideraciones de versión:</action>
    <action>- Features obsoletas (ej: class components en React 18)</action>
    <action>- Vulnerabilidades conocidas en versiones detectadas</action>
    <action>- Patrones recomendados para la versión específica</action>
    
    <action>Almacenar en {{best_practices_note}}</action>
  </step>

  <step n="7" goal="Generar resumen de contexto para el padre">
    <critical>NO generar JSON completo - SOLO resumen conciso para prevenir context exhaustion</critical>
    
    <action>Construir RESUMEN de contexto (máximo 500 tokens):</action>
    
    <output format="markdown">
## Contexto Técnico Cargado

**Stack**: {{stack_detected}} ({{tech_stack.primary_framework}} {{tech_stack.framework_version}})
**Docs cargados**: {{architecture_docs_count}} documentos
**Estándares**: {{coding_standards_loaded ? "✅ Disponibles" : "⚠️ No encontrados"}}

### Puntos clave para revisión:
- {{gps_arquitectonico.main_components | join(", ")}}
- Patrones: {{coding_standards.patterns | take(3) | join(", ")}}

### Warnings:
{{warnings | join("\n- ")}}
    </output>
    
    <action>Este resumen se pasa al workflow padre como {{manual_context}}</action>
  </step>

</workflow>
```
