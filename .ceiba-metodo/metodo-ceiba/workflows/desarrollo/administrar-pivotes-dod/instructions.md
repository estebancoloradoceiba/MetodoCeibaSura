# Administrar Pivotes DoD - Instructions

<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>ALWAYS communicate STRICTLY in {communication_language} regardless of the language used by the user</critical>
<critical>This workflow manages the Definition of Done estimation pivots table</critical>

<workflow>

<step n="1" goal="Cargar o Crear Archivo">

<action>Verificar si existe: {dod_pivots_file}</action>

<check if="archivo NO existe">
<action>Preparar array tareas_dod con 3 tareas ejemplo:</action>
<action>  1. Ejecutar agente peer reevier</action>
<action>  2. Crear Pull Request y ejecutar pipeline deployment DEV</action>
<action>  3. Diseñar y ejecutar pruebas manuales</action>
<action>Preparar array pivotes_tecnicos vacío</action>

<critical>Generar archivo usando template: {template_file}</critical>
<template-output>tareas_dod</template-output>
<template-output>pivotes_tecnicos</template-output>
<template-output>date</template-output>

<action>Guardar archivo generado en: {dod_pivots_file}</action>
<output>✅ Archivo creado (3 tareas DoD ejemplo, 0 pivotes)</output>
</check>

<check if="archivo existe">
<action>Cargar y parsear ambas tablas</action>
<output>📋 DoD: {{num_dod}} tareas | Pivotes: {{num_pivotes}} tareas</output>
</check>

</step>

<step n="2" goal="Seleccionar Operación">

<ask>Operación:
1. AGREGAR a DoD
2. AGREGAR a Pivotes
3. EDITAR DoD
4. EDITAR Pivotes
5. ELIMINAR de DoD
6. ELIMINAR de Pivotes
7. VER archivo
8. SALIR

Opción:</ask>

<check if="1"><goto step="3" tabla="dod"/></check>
<check if="2"><goto step="3" tabla="pivotes"/></check>
<check if="3"><goto step="4" tabla="dod"/></check>
<check if="4"><goto step="4" tabla="pivotes"/></check>
<check if="5"><goto step="5" tabla="dod"/></check>
<check if="6"><goto step="5" tabla="pivotes"/></check>
<check if="7"><goto step="6"/></check>
<check if="8"><action>HALT</action></check>

</step>

<step n="3" goal="Agregar Tarea">

<action>Identificar tabla objetivo: {{tabla}}</action>

<check if="{{tabla}} == 'pivotes'">
<output>📌 IMPORTANTE: Para Pivotes Técnicos, ingresa tiempos YA CON Método Ceiba aplicado (tiempo real de desarrollo con IA).</output>
</check>

<ask>Nombre:</ask>
<action>Capturar nombre</action>

<ask>Minutos BAJA:</ask>
<action>Capturar y convertir a horas</action>

<ask>Minutos MEDIA:</ask>
<action>Capturar y convertir a horas</action>

<ask>Minutos ALTA:</ask>
<action>Capturar y convertir a horas</action>

<ask>Notas:</ask>
<action>Capturar notas</action>

<action>Agregar fila a tabla {{tabla}}</action>
<action>Guardar</action>

<output>✅ Agregado a {{tabla}}</output>

<ask>Continuar? (1=Sí, 2=No)</ask>
<check if="1"><goto step="2"/></check>

</step>

<step n="4" goal="Editar Tarea">

<action>Identificar tabla: {{tabla}}</action>
<action>Listar tareas con números</action>

<ask>Número:</ask>
<action>Identificar tarea</action>

<output>BAJA={{tb}}h MEDIA={{tm}}h ALTA={{ta}}h</output>

<ask>Editar:
1. BAJA
2. MEDIA  
3. ALTA
4. Notas
5. Todo

Opción:</ask>

<action>Capturar nuevos valores</action>
<action>Actualizar tabla</action>
<action>Guardar</action>

<output>✅ Actualizado</output>

<ask>Continuar? (1=Sí, 2=No)</ask>
<check if="1"><goto step="2"/></check>

</step>

<step n="5" goal="Eliminar Tarea">

<action>Identificar tabla: {{tabla}}</action>
<action>Listar tareas</action>

<ask>Número:</ask>
<action>Identificar tarea</action>

<ask>Confirmar "{{nombre}}"? (1=Sí, 2=No)</ask>

<check if="1">
<action>Remover de tabla</action>
<action>Guardar</action>
<output>✅ Eliminado</output>
</check>

<ask>Continuar? (1=Sí, 2=No)</ask>
<check if="1"><goto step="2"/></check>

</step>

<step n="6" goal="Ver Archivo">

<action>Cargar archivo</action>

<output>
📋 PIVOTES Y DOD

DoD: {{num_dod}} tareas
{{tabla_dod}}

Pivotes: {{num_pivotes}} tareas  
{{tabla_pivotes}}

</output>

<goto step="2"/>

</step>

</workflow>
