
<workflow>
<critical>Este workflow orquesta el ciclo completo de desarrollo de una historia de usuario. La historia debe existir como archivo .story.md en la carpeta de desarrollo.</critical>
<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>ALWAYS communicate STRICTLY in {communication_language} regardless of the language used by the user</critical>
<critical>HTML COMMENTS HANDLING: El template contiene comentarios HTML como guías. Al generar el output final, REMOVER comentarios HTML de secciones completas y MANTENER comentarios de secciones vacías/incompletas</critical>
<critical>Generate all documents in {document_output_language}</critical>
<critical>NUNCA modificar archivos template - deben permanecer inmutables para reutilización</critical>

<step n="1" goal="Validar historia de usuario existe">
  <action>Saludar: "Hola {user_name}, vamos a ejecutar el ciclo completo de desarrollo para una historia de usuario."</action>
  <action>Verificar que el archivo {{target_story_file}} existe</action>
  <check if="archivo no existe">
    <action>Mostrar error: "La historia {{story_number}} no existe en {{dev_story_location}}"</action>
    <action>Sugerir crear la historia primero con el workflow crear-historia-usuario</action>
    <goto step="fin">Terminar workflow</goto>
  </check>
  <action>Leer estado actual de la historia</action>
  <action>Mostrar resumen de la historia al usuario</action>
</step>

<step n="2" goal="Confirmar ejecución del ciclo completo">
  <action>Explicar al usuario el proceso completo:</action>
  <action>- **Fase 1**: Análisis Arquitectónico - Diseño de solución y decisiones arquitectónicas</action>
  <action>- **Fase 2**: Refinamiento Técnico - Análisis profundo y descomposición en tareas</action>
  <action>- **Fase 3**: Estimación - Cálculo de tiempos de desarrollo por perfil</action>
  <action>- **Fase 4**: Desarrollo - Implementación iterativa siguiendo las tareas</action>
  <action>- **Fase 5**: Revisión - Code review exhaustivo por peer reviewer</action>
  
  <ask>¿Desea ejecutar el ciclo completo para la historia {{story_number}}? 
Opciones:
  [s] - Sí, ejecutar todo el ciclo
  [a] - Solo análisis arquitectónico
  [r] - Solo refinamiento (requiere análisis previo)
  [e] - Solo estimación (requiere refinamiento previo)
  [d] - Solo desarrollo (requiere refinamiento y estimación previos)
  [v] - Solo revisión (requiere desarrollo completo)
  [n] - Cancelar
  </ask>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Cancelar workflow</goto>
  </check>
  
  <check if="respuesta == 'a'">
    <action>Establecer skip_refinamiento = true</action>
    <action>Establecer skip_estimacion = true</action>
    <action>Establecer skip_desarrollo = true</action>
    <action>Establecer skip_revision = true</action>
  </check>
  
  <check if="respuesta == 'r'">
    <action>Establecer skip_analisis = true</action>
    <action>Establecer skip_estimacion = true</action>
    <action>Establecer skip_desarrollo = true</action>
    <action>Establecer skip_revision = true</action>
  </check>
  
  <check if="respuesta == 'e'">
    <action>Establecer skip_analisis = true</action>
    <action>Establecer skip_refinamiento = true</action>
    <action>Establecer skip_desarrollo = true</action>
    <action>Establecer skip_revision = true</action>
  </check>
  
  <check if="respuesta == 'd'">
    <action>Establecer skip_analisis = true</action>
    <action>Establecer skip_refinamiento = true</action>
    <action>Establecer skip_estimacion = true</action>
    <action>Establecer skip_revision = true</action>
  </check>
  
  <check if="respuesta == 'v'">
    <action>Establecer skip_analisis = true</action>
    <action>Establecer skip_refinamiento = true</action>
    <action>Establecer skip_estimacion = true</action>
    <action>Establecer skip_desarrollo = true</action>
  </check>
</step>

<step n="3" goal="Fase 1: Análisis Arquitectónico" if="not skip_analisis">
  <action>═══════════════════════════════════════════════════════════════</action>
  <action>FASE 1: ANÁLISIS ARQUITECTÓNICO</action>
  <action>═══════════════════════════════════════════════════════════════</action>
  <action>Iniciando análisis arquitectónico de la historia {{story_number}}...</action>
  
  <invoke-workflow path="{{analisis_workflow}}" critical="true">
    <input name="story_number">{{story_number}}</input>
  </invoke-workflow>
  
  <action>✓ Análisis arquitectónico completado</action>
  <action>La historia ahora incluye decisiones arquitectónicas y diseño de solución</action>
  
  <ask>Análisis arquitectónico completado. ¿Continuar con refinamiento? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar del análisis arquitectónico:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones al análisis arquitectónico en {{target_story_file}}</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="3">Volver a mostrar resultado de análisis arquitectónico con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de análisis arquitectónico</goto>
  </check>
</step>

<step n="4" goal="Fase 2: Refinamiento Técnico" if="not skip_refinamiento">
  <action>═══════════════════════════════════════════════════════════</action>
  <action>FASE 2: REFINAMIENTO TÉCNICO</action>
  <action>═══════════════════════════════════════════════════════════</action>
  <action>Iniciando análisis técnico de la historia {{story_number}}...</action>
  
  <invoke-workflow path="{{refinamiento_workflow}}" critical="true">
    <input name="story_number">{{story_number}}</input>
  </invoke-workflow>
  
  <action>✓ Refinamiento técnico completado</action>
  <action>La historia ahora incluye análisis técnico y descomposición en tareas</action>
  
  <ask>Refinamiento completado. ¿Continuar con estimación? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar del refinamiento técnico:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones al refinamiento técnico en {{target_story_file}}</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="4">Volver a mostrar resultado de refinamiento con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de refinamiento</goto>
  </check>
</step>

<step n="5" goal="Fase 3: Estimación de Tiempos" if="not skip_estimacion">
  <action>═════════════════════════════════════════════════════════════════</action>
  <action>FASE 3: ESTIMACIÓN DE TIEMPOS</action>
  <action>═════════════════════════════════════════════════════════════════</action>
  <action>Iniciando estimación de tiempos para la historia {{story_number}}...</action>
  
  <invoke-workflow path="{{estimacion_workflow}}" critical="true">
    <input name="story_number">{{story_number}}</input>
  </invoke-workflow>
  
  <action>✓ Estimación completada</action>
  <action>La historia ahora incluye estimaciones de tiempo por perfil de desarrollador</action>
  
  <ask>Estimación completada. ¿Continuar con desarrollo? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar de la estimación:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones a la estimación en {{target_story_file}}</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="5">Volver a mostrar resultado de estimación con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de estimación</goto>
  </check>
</step>

<step n="6" goal="Fase 4: Desarrollo e Implementación" if="not skip_desarrollo">
  <action>═══════════════════════════════════════════════════════════════</action>
  <action>FASE 4: DESARROLLO E IMPLEMENTACIÓN</action>
  <action>═══════════════════════════════════════════════════════════════</action>
  <action>Iniciando implementación de la historia {{story_number}}...</action>
  
  <invoke-workflow path="{{desarrollo_workflow}}" critical="true">
    <input name="story_number">{{story_number}}</input>
  </invoke-workflow>
  
  <action>✓ Desarrollo completado</action>
  <action>La historia ha sido implementada siguiendo las tareas definidas</action>
  
  <ask>Desarrollo completado. ¿Continuar con revisión de código? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar del desarrollo:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones al código implementado</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="6">Volver a mostrar resultado de desarrollo con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de desarrollo</goto>
  </check>
</step>

<step n="7" goal="Fase 5: Revisión de Código (Peer Review)" if="not skip_revision">
  <action>═════════════════════════════════════════════════════════════════</action>
  <action>FASE 5: REVISIÓN DE CÓDIGO (PEER REVIEW)</action>
  <action>═════════════════════════════════════════════════════════════════</action>
  <action>Iniciando revisión exhaustiva de la historia {{story_number}}...</action>
  
  <invoke-workflow path="{{revision_workflow}}" critical="true">
    <input name="story_number">{{story_number}}</input>
  </invoke-workflow>
  
  <action>✓ Revisión completada</action>
  <action>Se ha generado el reporte de peer review</action>
</step>

<step n="8" goal="Verificar resultado de revisión">
  <action if="not skip_revision">Leer la sección de Peer Review en {{target_story_file}}</action>
  <action if="not skip_revision">Extraer el resultado: APROBADA o RECHAZADA</action>
  
  <check if="resultado == 'RECHAZADA'">
    <action>⚠️  La revisión encontró problemas que requieren correcciones</action>
    <ask>¿Desea ejecutar un ciclo de corrección?
    [s] - Sí, volver al desarrollo para corregir
    [n] - No, revisar manualmente
    </ask>
    
    <check if="respuesta == 's'">
      <action>Configurar skip_analisis = true</action>
      <action>Configurar skip_refinamiento = true</action>
      <action>Configurar skip_estimacion = true</action>
      <action>Configurar skip_revision = false</action>
      <goto step="6">Volver a fase de desarrollo con correcciones</goto>
    </check>
  </check>
  
  <check if="resultado == 'APROBADA'">
    <action>✅ Historia aprobada - Lista para merge/deploy</action>
  </check>
</step>

<step n="9" goal="Resumen final" id="fin">
  <action>═══════════════════════════════════════════════════════════════</action>
  <action>CICLO COMPLETO FINALIZADO</action>
  <action>═══════════════════════════════════════════════════════════════</action>
  
  <action>Historia procesada: {{story_number}}</action>
  <action>Archivo: {{target_story_file}}</action>
  
  <action>Fases completadas:</action>
  <action if="not skip_analisis">  ✓ Análisis Arquitectónico</action>
  <action if="not skip_refinamiento">  ✓ Refinamiento Técnico</action>
  <action if="not skip_estimacion">  ✓ Estimación de Tiempos</action>
  <action if="not skip_desarrollo">  ✓ Desarrollo e Implementación</action>
  <action if="not skip_revision">  ✓ Revisión de Código</action>
  
  <action>La historia está ahora en el archivo actualizado con todas las secciones.</action>
</step>
</workflow>