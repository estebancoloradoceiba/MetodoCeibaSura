# Ciclo Completo de Incidente - Instrucciones

Este meta-workflow orquesta el ciclo técnico de resolución de incidentes en el Método Ceiba, adaptándose automáticamente según la prioridad del incidente (P0-P1 crítico vs P2-P4 normal).


<workflow>
<critical>Este workflow requiere que el incidente haya sido previamente recibido y clasificado con `po *recibir-error`. El usuario debe proporcionar el identificador del incidente existente.</critical>
<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>ALWAYS communicate STRICTLY in {communication_language} regardless of the language used by the user</critical>
<critical>HTML COMMENTS HANDLING: El template contiene comentarios HTML como guías. Al generar el output final, REMOVER comentarios HTML de secciones completas y MANTENER comentarios de secciones vacías/incompletas</critical>
<critical>Generate all documents in {document_output_language}</critical>
<critical>NUNCA modificar archivos template - deben permanecer inmutables para reutilización</critical>

<step n="1" goal="Solicitar identificador del incidente">
  <action>Saludar: "Hola {user_name}, vamos a procesar el ciclo completo de un incidente."</action>
  <action>El incidente debe haber sido previamente recibido y clasificado por el PO</action>
  <ask>Proporcionar el identificador del incidente a resolver (ej: 2025-01-15-login-error):</ask>
  <action>Establecer incident_number con el valor proporcionado</action>
</step>

<step n="2" goal="Leer y analizar prioridad del incidente">
  <action>Verificar que el archivo {{target_incident_file}} existe</action>
  <check if="archivo no existe">
    <action>Mostrar error: "El incidente {{incident_number}} no existe en {{incident_location}}"</action>
    <goto step="fin">Terminar workflow</goto>
  </check>
  
  <action>Leer el archivo del incidente</action>
  <action>Extraer la prioridad del incidente (P0, P1, P2, P3, P4)</action>
  <action>Establecer incident_priority con el valor extraído</action>
  
  <check if="incident_priority == 'P0' or incident_priority == 'P1'">
    <action>Establecer flujo_critico = true</action>
    <action>Establecer skip_analisis = true (no hay tiempo para análisis profundo)</action>
    <action>Establecer skip_estimacion = true (no se requiere estimación)</action>
  </check>
  
  <check if="incident_priority == 'P2' or incident_priority == 'P3' or incident_priority == 'P4'">
    <action>Establecer flujo_critico = false</action>
    <action>Establecer skip_analisis = "preguntar" (opcional según complejidad)</action>
    <action>Establecer skip_estimacion = "preguntar" (opcional según políticas)</action>
  </check>
  
  <action>Mostrar resumen del incidente al usuario</action>
  <action>Indicar qué flujo se seguirá (CRÍTICO P0-P1 o NORMAL P2-P4)</action>
</step>

<step n="3" goal="Confirmar ejecución del ciclo completo">
  <check if="flujo_critico == true">
    <action>═══════════════════════════════════════════════════════════</action>
    <action>FLUJO CRÍTICO (P0-P1) - RESOLUCIÓN URGENTE</action>
    <action>═══════════════════════════════════════════════════════════</action>
    <action>Este incidente requiere atención inmediata con flujo expedito:</action>
    <action>- Diagnóstico → Refinamiento → Desarrollo → Revisión Rápida → Post-Mortem</action>
    <action>- NO incluye: Análisis arquitectónico profundo ni estimación formal</action>
    <action>- Revisión expedita enfocada en no-regresión</action>
  </check>
  
  <check if="flujo_critico == false">
    <action>═══════════════════════════════════════════════════════════</action>
    <action>FLUJO NORMAL (P2-P4) - PROCESO COMPLETO</action>
    <action>═══════════════════════════════════════════════════════════</action>
    <action>Este incidente seguirá el proceso completo de desarrollo:</action>
    <action>- Diagnóstico → [Análisis] → Refinamiento → [Estimación] → Desarrollo → Revisión → Post-Mortem</action>
    <action>- Incluye pasos opcionales según complejidad</action>
  </check>
  
  <ask>¿Desea ejecutar el ciclo completo para el incidente {{incident_number}}? 
Opciones:
  [s] - Sí, ejecutar el flujo completo
  [p] - Solo desarrollo (requiere diagnóstico y refinamiento previos)
  [r] - Solo revisión (requiere desarrollo completo)
  [m] - Solo post-mortem (requiere incidente resuelto)
  [n] - Cancelar
  </ask>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Cancelar workflow</goto>
  </check>
  
  <check if="respuesta == 'p'">
    <action>Saltar a desarrollo</action>
    <goto step="7">Ir a desarrollo</goto>
  </check>
  
  <check if="respuesta == 'r'">
    <action>Saltar a revisión</action>
    <goto step="8">Ir a revisión</goto>
  </check>
  
  <check if="respuesta == 'm'">
    <action>Saltar a post-mortem</action>
    <goto step="10">Ir a post-mortem</goto>
  </check>
</step>

<step n="4" goal="Diagnóstico de Causa Raíz">
  <action>═══════════════════════════════════════════════════════════</action>
  <action if="flujo_critico == true">PASO 2A: DIAGNÓSTICO (CRÍTICO)</action>
  <action if="flujo_critico == false">PASO 2B: DIAGNÓSTICO</action>
  <action>═══════════════════════════════════════════════════════════</action>
  <action>Iniciando diagnóstico con metodología 5 Whys...</action>
  
  <invoke-workflow path="{{diagnosticar_workflow}}" critical="true">
    <input name="incident_number">{{incident_number}}</input>
  </invoke-workflow>
  
  <action>✓ Diagnóstico de causa raíz completado</action>
  <action>El incidente ahora incluye análisis de causa raíz</action>
  
  <ask>Diagnóstico completado. ¿Continuar con el siguiente paso? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar del diagnóstico:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones al diagnóstico en {{target_incident_file}}</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="4">Volver a mostrar resultado de diagnóstico con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de diagnóstico</goto>
  </check>
</step>

<step n="5" goal="Análisis Arquitectónico (Solo P2-P4)" if="flujo_critico == false and skip_analisis == 'preguntar'">
  <ask>¿El fix requiere análisis arquitectónico profundo? 
(Solo si hay impacto en múltiples componentes o decisiones de diseño complejas)
  [s] - Sí, ejecutar análisis arquitectónico
  [n] - No, continuar con refinamiento
  </ask>
  
  <check if="respuesta == 'n'">
    <action>Establecer skip_analisis = true</action>
    <goto step="6">Continuar con refinamiento</goto>
  </check>
  
  <action>═══════════════════════════════════════════════════════════</action>
  <action>PASO 3B: ANÁLISIS ARQUITECTÓNICO (OPCIONAL)</action>
  <action>═══════════════════════════════════════════════════════════</action>
  <action>Iniciando análisis arquitectónico del incidente...</action>
  
  <invoke-workflow path="{{analisis_workflow}}" critical="true">
    <input name="story_number">{{incident_number}}</input>
  </invoke-workflow>
  
  <action>✓ Análisis arquitectónico completado</action>
  <action>El incidente incluye decisiones arquitectónicas y diseño</action>
  
  <ask>Análisis completado. ¿Continuar con refinamiento? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar del análisis arquitectónico:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones al análisis en {{target_incident_file}}</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="5">Volver a mostrar resultado de análisis con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de análisis</goto>
  </check>
</step>

<step n="6" goal="Refinamiento Técnico">
  <action>═══════════════════════════════════════════════════════════</action>
  <action if="flujo_critico == true">PASO 3A: REFINAMIENTO TÉCNICO URGENTE</action>
  <action if="flujo_critico == false">PASO 4B: REFINAMIENTO TÉCNICO</action>
  <action>═══════════════════════════════════════════════════════════</action>
  <action if="flujo_critico == true">Refinamiento rápido enfocado en solución urgente...</action>
  <action if="flujo_critico == false">Refinamiento detallado con descomposición en tareas...</action>
  
  <invoke-workflow path="{{refinamiento_workflow}}" critical="true">
    <input name="story_number">{{incident_number}}</input>
  </invoke-workflow>
  
  <action>✓ Refinamiento técnico completado</action>
  <action>El incidente incluye detalles técnicos de implementación</action>
  
  <ask>Refinamiento completado. ¿Continuar con el siguiente paso? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar del refinamiento técnico:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones al refinamiento en {{target_incident_file}}</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="6">Volver a mostrar resultado de refinamiento con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de refinamiento</goto>
  </check>
</step>

<step n="6b" goal="Estimación (Solo P2-P4)" if="flujo_critico == false and skip_estimacion == 'preguntar'">
  <ask>¿Desea ejecutar estimación de esfuerzo? (Opcional según políticas del equipo)
  [s] - Sí, estimar esfuerzo
  [n] - No, continuar con desarrollo
  </ask>
  
  <check if="respuesta == 'n'">
    <action>Establecer skip_estimacion = true</action>
    <goto step="7">Continuar con desarrollo</goto>
  </check>
  
  <action>═══════════════════════════════════════════════════════════</action>
  <action>PASO 5B: ESTIMACIÓN DE ESFUERZO (OPCIONAL)</action>
  <action>═══════════════════════════════════════════════════════════</action>
  <action>Iniciando estimación del incidente...</action>
  
  <invoke-workflow path="{{estimacion_workflow}}" critical="true">
    <input name="story_number">{{incident_number}}</input>
  </invoke-workflow>
  
  <action>✓ Estimación completada</action>
  <action>El incidente incluye estimación de esfuerzo</action>
  
  <ask>Estimación completada. ¿Continuar con desarrollo? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar de la estimación:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones a la estimación en {{target_incident_file}}</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="6b">Volver a mostrar resultado de estimación con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de estimación</goto>
  </check>
</step>

<step n="7" goal="Desarrollo e Implementación">
  <action>═══════════════════════════════════════════════════════════</action>
  <action if="flujo_critico == true">PASO 4A: DESARROLLO URGENTE</action>
  <action if="flujo_critico == false">PASO 6B: DESARROLLO</action>
  <action>═══════════════════════════════════════════════════════════</action>
  <action if="flujo_critico == true">Implementando fix urgente con tests...</action>
  <action if="flujo_critico == false">Implementando solución completa...</action>
  
  <invoke-workflow path="{{desarrollo_workflow}}" critical="true">
    <input name="story_number">{{incident_number}}</input>
  </invoke-workflow>
  
  <action>✓ Desarrollo completado</action>
  <action>El incidente ha sido resuelto con código y tests</action>
  
  <ask>Desarrollo completado. ¿Continuar con revisión? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar del desarrollo:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones al código implementado</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="7">Volver a mostrar resultado de desarrollo con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de desarrollo</goto>
  </check>
</step>

<step n="8" goal="Revisión de Calidad">
  <action>═══════════════════════════════════════════════════════════</action>
  <action if="flujo_critico == true">PASO 5A: REVISIÓN EXPEDITA</action>
  <action if="flujo_critico == false">PASO 7B: REVISIÓN DE CALIDAD</action>
  <action>═══════════════════════════════════════════════════════════</action>
  <action if="flujo_critico == true">Revisión rápida enfocada en no-regresión...</action>
  <action if="flujo_critico == false">Revisión completa de calidad y seguridad...</action>
  
  <invoke-workflow path="{{revision_workflow}}" critical="true">
    <input name="story_number">{{incident_number}}</input>
  </invoke-workflow>
  
  <action>✓ Revisión completada</action>
  <action>Se ha generado el reporte de revisión</action>
  
  <action>Leer la sección de QA Results en {{target_incident_file}}</action>
  <action>Extraer el resultado: PASS, FAIL, CONCERNS o WAIVED</action>
  
  <check if="resultado == 'FAIL'">
    <action>⚠️  La revisión encontró problemas que requieren correcciones</action>
    <ask>¿Desea volver al desarrollo para corregir?
    [s] - Sí, volver a desarrollo
    [n] - No, revisar manualmente
    </ask>
    
    <check if="respuesta == 's'">
      <goto step="7">Volver a desarrollo con correcciones</goto>
    </check>
    <check if="else">
      <goto step="fin">Finalizar para revisión manual</goto>
    </check>
  </check>
  
  <check if="resultado == 'PASS' or resultado == 'CONCERNS' or resultado == 'WAIVED'">
    <action>✅ Incidente resuelto y aprobado</action>
  </check>
  
  <ask>Revisión completada. ¿Continuar con post-mortem? 
  [s] - Sí, continuar
  [c] - Deseo corregir/complementar algo de la fase actual
  [n] - No, detener aquí el ciclo
  </ask>
  
  <check if="respuesta == 'c'">
    <ask>Por favor, indique qué desea corregir o complementar de la revisión:</ask>
    <action>Recibir y procesar las correcciones/complementos indicados por el usuario</action>
    <action>Aplicar las correcciones a la revisión en {{target_incident_file}}</action>
    <action>Mostrar resumen de los cambios aplicados</action>
    <goto step="8">Volver a mostrar resultado de revisión con correcciones aplicadas</goto>
  </check>
  
  <check if="respuesta == 'n'">
    <goto step="fin">Finalizar después de revisión</goto>
  </check>
</step>

<step n="9" goal="Post-Mortem y Documentación en Knowledge Base">
  <action>═══════════════════════════════════════════════════════════</action>
  <action if="flujo_critico == true">PASO 6A: POST-MORTEM (OBLIGATORIO P0-P1)</action>
  <action if="flujo_critico == false">PASO 8B: POST-MORTEM</action>
  <action>═══════════════════════════════════════════════════════════</action>
  <action>Generando documentación post-mortem y evaluando para KB...</action>
  
  <invoke-workflow path="{{postmortem_workflow}}" critical="true">
    <input name="incident_number">{{incident_number}}</input>
  </invoke-workflow>
  
  <action>✓ Post-mortem completado</action>
  <action>Documentación generada y Knowledge Base actualizado</action>
</step>

<step n="10" goal="Resumen final" id="fin">
  <action>═══════════════════════════════════════════════════════════</action>
  <action>CICLO DE INCIDENTE COMPLETADO</action>
  <action>═══════════════════════════════════════════════════════════</action>
  
  <action>Incidente procesado: {{incident_number}}</action>
  <action>Prioridad: {{incident_priority}}</action>
  <action>Archivo: {{target_incident_file}}</action>
  
  <action if="flujo_critico == true">Flujo ejecutado: CRÍTICO (P0-P1) - Resolución urgente</action>
  <action if="flujo_critico == false">Flujo ejecutado: NORMAL (P2-P4) - Proceso completo</action>
  
  <action>El incidente está resuelto y documentado en el Knowledge Base.</action>
</step>
</workflow>
