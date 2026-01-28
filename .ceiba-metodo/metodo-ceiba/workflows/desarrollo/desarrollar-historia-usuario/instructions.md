# Desarrollar Historia de Usuario - Instructions

<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>ALWAYS communicate STRICTLY in {communication_language}</critical>
<critical>Generate all documents in {document_output_language}</critical>
<workflow>
<step n="0" goal="Validar Prerrequisitos">
<invoke-protocol name="validate_project_prerequisites" />
</step>

<step n="1" goal="Cargar Historia y Validar Estado">
<ask>¿Qué historia o incidente deseas desarrollar? (número, INC-XXX, o ruta completa)</ask>
<action>Resolver ruta del archivo:</action>
<action>- Si contiene "INC-" → buscar en {incident_location}</action>
<action>- Si no → buscar en {dev_story_location}</action>
<action>Almacenar en {{story_file_path}}</action>
<check if="archivo no existe">
<output>❌ Archivo no encontrado</output>
<action>HALT</action>
</check>
<action>Leer archivo completo y extraer: Estado (Status), Tareas de Implementación, sección Peer Review si existe</action>

<!-- Detectar modo de trabajo basado en Status -->
<check if="estado IN ['Cambios Solicitados', 'Aprobada con Observaciones']">
  <action>Establecer {{modo}} = "CORRECCIONES"</action>
  <action>Extraer TODOS los hallazgos de la sección "Revisión de Código (Peer Review)"</action>
</check>

<check if="estado IN ['Estimado (Developer)', 'En Desarrollo (Developer)']">
  <action>Establecer {{modo}} = "DESARROLLO"</action>
</check>

<check if="estado NOT IN ['Estimado (Developer)', 'En Desarrollo (Developer)', 'Cambios Solicitados', 'Aprobada con Observaciones']">
  <output>❌ Estado inválido: {{estado}}. Estados válidos: "Estimado (Developer)", "En Desarrollo (Developer)", "Cambios Solicitados", "Aprobada con Observaciones"</output>
  <action>HALT</action>
</check>

<check if="{{modo}} == 'DESARROLLO' AND sección 'Tareas de Implementación' vacía o inexistente">
  <output>❌ Sin tareas. Ejecuta *refinamiento-tecnico primero.</output>
  <action>HALT</action>
</check>

<output>✅ Historia cargada: {{story_file_path}}
📋 Modo: {{modo}}</output>

</step>

<step n="2" goal="Crear TODO List">

<critical>La descripción de cada TODO debe contener TODA la información necesaria para ejecutarlo.</critical>
<action>Actualizar estado del archivo a "En Desarrollo (Developer)"</action>

<mandate>CREAR TODO LIST usando manage_todo_list:</mandate>

<check if="{{modo}} == 'CORRECCIONES'">
  <action>Crear TODO por cada hallazgo ALTA/MEDIA (ALTA primero)</action>
  <action>Título: "{{tipo_revision}} - {{archivo}}" | Descripción: problema + sugerencia</action>
  <critical>ANTES de implementar cada corrección: proponer solución al usuario y esperar OK o solicitar al usuario si quiere proponer otra solución</critical>
</check>

<check if="{{modo}} == 'DESARROLLO'">
  <action>Parsear "Tareas de Implementación" y crear un TODO por cada Fase con tareas pendientes [ ]</action>
  <action>Inferir título y descripción de la fase. Incluir en descripción: lista de tareas y subtareas, que implemente siguiendo las buenas prácticas de {architecture_sharded_location}/{coding_standards_file}, marque [x], ejecute build/tests/linting, y pida confirmación al usuario antes de continuar</action>
</check>

<mandate>SIEMPRE agregar estos 3 TODOs finales:</mandate>
<action>1. "Marcar Tareas Completadas": Re-escanear archivo, verificar checkboxes [x], corregir olvidados, guardar</action>
<action>2. "Actualizar Dev Agent Record": Agregar Completion Notes (componentes, decisiones, archivos), actualizar Change Log, guardar</action>
<action>3. "Actualizar Estado": Ejecutar tests regresión, verificar ACs, cambiar estado a "Lista para Revisión", guardar</action>

</step>

<step n="3" goal="Ejecutar TODO List">

<critical>Ejecutar cada TODO en orden. La descripción del TODO contiene qué hacer.</critical>

<action>Tomar siguiente TODO pendiente (not-started)</action>
<action>Marcar como "in-progress"</action>
<action>Ejecutar lo indicado en la descripción del TODO</action>
<action>Marcar como "completed"</action>

<check if="quedan TODOs pendientes">
  <goto step="3">Siguiente TODO</goto>
</check>

</step>

</workflow>
