# Arquitectura Solución - Instrucciones de Workflow


````xml
<critical>🚨 El motor de ejecución de workflows está gobernado por: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>🚨 Debes haber cargado y procesado: {project-root}/.ceiba-metodo/metodo-ceiba/workflows/arquitectura/crear-arquitectura-solucion/workflow.yaml</critical>
<critical>🚨 Comunica SIEMPRE ESTRICTAMENTE en {communication_language} sin importar el idioma usado por el usuario</critical>
<critical>🚨 Genera todos los documentos en {document_output_language}</critical>

<critical>🚨 REGLAS DE SALIDA DEL TEMPLATE: (1) Remover comentarios HTML de secciones completadas, mantener para secciones vacías/opcionales. (2) Asegurar que TODOS los elementos del template (títulos, encabezados, etiquetas) coincidan con {document_output_language}, no solo el contenido.</critical>

<critical>🚨 NUNCA modificar archivos template - deben permanecer inmutables para reutilización</critical>

<critical>🚨 -SIEMPRE ejecuta los pasos de este workflow en el orden indicado, NO omitas ningún paso de este workflow.
-Para continuar con otro paso de este workflow se debe completar el paso previo.
-Si alguno de los pasos invoca a otro workflow, se debe completar todo la ejecución antes de continuar con el siguiente pasos.
</critical>

<critical>🚨 -Este workflow tiene un paso inicial que ejecuta una validación importante de completitud del PRD, este es el primer paso que se debe ejeuctar SIEMPRE.
-Luego continua con los pasos en el orden especificado por el workflow.
</critical>

<critical>🚨 **Propósito**
   Crear una propuesta de "arquitectura de solución de alto nivel" para proyectos que estan en etapa de propuesta comercial o poyectos que van iniciar etapa de construcción 
</critical>

<critical>🚨 **Usa esta tarea cuando:**
   Necesita crear una arquitectura de solución para un proyecto en etapa comercial
   Realizar propuestas de arquitectura de alto nivel
   Revisión de alternativas y toma de decisiones técnicas
   Documentación de la toma de decisiones
</critical>

<critical>🚨 **Prerequisites:**
   Acceso a la documentación necesaria que define la necesidad
   Conocimiento del arquitecto responsable del sistema
   Documentación existente (si está disponible)
</critical>

<workflow>

  <step n="0" goal="Preparación y Contexto Inicial">
  
    <critical>🚨 Asegurate de ejecutar siempre este paso y sus subpasos, No lo omitas y solo continua con los siguientes pasos del workflow cuando estes seguro de que este está terminado</critical>
    <critical>🚨 Si dentro de estos pasos o subpasos hay llamados a otros workflows, asegurate de que estos se ejeucten completamente, NO los omitas y solo continua con los siguientes pasos al terminar la ejecución del flujo</critical>
    
    <step n="0.1" goal="Validar completitud información requisitos de producto">

      <action>Valida si existe un documento {output_folder}/propuesta/04-arquitectura/reporte-validacion-completitud-prd.md</action>

      <check if="existe un documento {output_folder}/propuesta/04-arquitectura/reporte-validacion-completitud-prd.md">
        <ask>
          Se ha encontrado un documento de reporte de validación de completitud de PRD en la ruta {output_folder}/propuesta/04-arquitectura/, ¿que desea hacer?
          1. Continuar con el proceso de creación arquitectura de solución.
          2. Volver a ejecutar el proceso de validación de completitud del PRD.
          3. Salir.
        </ask>
      </check>

      <check if="user_choice == 1">
        <goto step="1">Comenzar a crear arquitectura solución</goto>
      </check>

      <check if="user_choice == 2 OR no existe documento de validación">
        <invoke-workflow path="{project-root}/.ceiba-metodo/metodo-ceiba/workflows/arquitectura/validar-completitud-prd/workflow.yaml">
        </invoke-workflow>
      </check>

      <check if="validacion_prd_no_completada">
        <action>NO continues con el siguiente paso del workflow de definición de arquitectura de solución</action>
        <action>aún NO generes documentación de arquitectura de solución</action>
      </check>

    </step>    

  </step>

  <step n="1" goal="Definir Introducción y Objetivos">

    <ask>¿Cuál es el nombre del proyecto para el cual se generará la arquitectura de solución?</ask>
    <action>Almacenar el nombre del proyecto en la variable project_name</action>

    <action>Verificar disponibilidad de documentos generados por el área comercial de Ceiba, buscar en la ruta {output_folder}/propuesta</action>
    <action>Identifica principalmente la existencia de los documentos {output_folder}/propuesta/03-prd/PRD.md y {output_folder}/propuesta/03-prd/epicas.md </action>
    <action>Identifica la existencia de otros documentos en esta ruta, como el {output_folder}/propuesta/02-brief-alcance/brief-alcance.md y otros documentos con información importante</action>
    <critical>🚨Si como mínimo no puedes localizar el archivo docs/prd.md, antes de continuar pregúntale al usuario qué documentos servirán de base para la arquitectura.</critical>
    
    <step n="1.1" goal="Realizar Resumen de requisitos">

      <action>
        Proveer un extracto o resumen de los requisitos funcionales y las motivaciones o fuerzas impulsoras del sistema. 
        - Es importante que esta sección sea concisa. 
        - Si existen documentos de requisitos, esta visión general debe referenciar a estos documentos. 
        - Mantén estos extractos lo más breves posible. 
        - Equilibra la legibilidad de este documento con la potencial redundancia respecto a los documentos de requisitos.
      </action>

      <template-output>resumen_requisitos</template-output>

      <elicit-required></elicit-required>

    </step>

    <step n="1.2" goal="Definir Objetivos de Calidad">

      <action>
        Identifica y prioriza los 3 a 5 objetivos de calidad más críticos para la arquitectura
        - Basate en el contexto y las expectativas de los interesados proporcionados. 
        - La priorización debe reflejar el impacto directo en las decisiones de arquitectura.
        - Asegúrate de que los objetivos se centren en los atributos de calidad del sistema (qué tan bien hace algo) y no en los objetivos funcionales del proyecto (qué hace).
        -Toma como referencia la lista de atributos de calidad sugerida en el modelo de calidad de arc42 (https://quality.arc42.org/)
      </action>
      <action>
        Redacta cada objetivo de calidad:
        - Como un ASR principal
        - De forma clara y concreta
        - Evita términos de moda o ambiguos.
      </action>
      <action>
        Justifica la relevancia de cada objetivo:
        - Explica por qué es crucial para los interesados
        - Cómo influirá en las decisiones de diseño arquitectónico.
      </action>
      <action>
        El resultado final debe dejar claro que estos no son simples deseos, sino requisitos rigurosos que dictarán las decisiones de arquitectura más importantes del proyecto.
      </action>

      <template-output>objetivos_calidad</template-output>

      <elicit-required></elicit-required>

    </step>

    <step n="1.3" goal="Indetificar interesados">

      <action>
        Identifica las personas, roles u organizaciones que:
        - Deben conocer la arquitectura.
        - Deben aprobar o dar su visto bueno a la arquitectura.
        - Deben trabajar con la arquitectura o con el código.
        - Necesitan la documentación de la arquitectura para su trabajo.
        - Deben tomar decisiones sobre el sistema o su desarrollo.
      </action>

      <template-output>tabla_interesados</template-output>

      <elicit-required></elicit-required>

    </step>

  </step>

  <step n="2" goal="Indetificar restricciones">

      <action>
        Documentar cualquier requisito, que deba ser respetado, y que limite o condicione la libertad en la toma de decisiones de diseño o implementación, así como decisiones sobre el proceso de desarrollo. 
        Estas restricciones a menudo van más allá de los sistemas individuales y son válidas para organizaciones y empresas enteras. 
        Las restricciones NO son supestos
        Las restricciones se documentan en lista sencillas con explicaciones y agrupadas según la clasificación de las restricciones que se encuentran en un proyecto:
      </action>

      <action>
        **Restricciones Técnicas:**
        - Tecnologías específicas que deben utilizarse (por ejemplo, lenguajes de ogramación, frameworks, plataformas).
        - Limitaciones de infraestructura (por ejemplo, requisitos de hardware, sistemas operativos, bases de datos).
        - Normativas de seguridad y cumplimiento.
      </action>

      <action>
        **Restricciones Organizativas:**
        - Directrices corporativas (por ejemplo, políticas de TI, estándares de calidad).
        - Procesos de desarrollo establecidos (por ejemplo, metodologías ágiles, ciclos de lanzamiento).
      </action>

      <action>
        **Restricciones Políticas:**
        - Normativas legales y de regulación que deben cumplirse.
        - Acuerdos contractuales con terceros o proveedores.
      </action>

      <action>
        **Convenciones:**
        - Guías de programación (estilo de codificación, estándares de revisión de código).
        - Directrices de versionado y gestión de configuraciones.
        - Convenciones de documentación y nomenclatura.
      </action>

      <template-output>restricciones</template-output>

      <elicit-required></elicit-required>

  </step>

  <step n="3" goal="Contexto y alcance">

    <step n="3.1" goal="Contexto de Negocio">

      <action>Identifica todos los sistemas y/o personas con los que interactúa el sistema que se está construyendo.</action>
      <action>Se deben especificar las entradas y salidas propias del dominio para mostrar como encaja en la solución.</action>
      <action>Opcionalmente, se pueden agregar formatos específicos del dominio o protocolos de comunicación.</action>
      <action>Es importante dar a enteder qué datos se intercambian con el entorno del sistema.</action>
      <action>Los detalles no son importantes aquí, ya que esta es una vista ampliada que muestra un panorama general del panorama del sistema.</action>
      <action>El enfoque debe estar en las personas (actores, roles, personajes, etc.) y los sistemas de software.</action>
      <action>Este debe ser un diagrama que podría mostrar a personas sin conocimientos técnicos.
      </action>
      <action>Utiliza mermaid C4Context para construir el diagrama correspondiente.</action>
      <action>Detalla la información que no puede representarse en el diagrama de contexto. La tabla debe incluir tres columnas para el nombre del socio de comunicación como elemento, las entradas y las salidas.</action>

      <template-output>contexto_negocio</template-output>

      <elicit-required></elicit-required>

    </step>

    <step n="3.2" goal="Contexto Técnico">

      <action>Identifica y describe los canales técnicos que enlazan el sistema con su entorno</action>
      <action>Mapea entradas y salidas especificas del dominio a los canales técnicos, con el objetivo de identificar cuales entradas y salidas utilizan los canales</action>
      <action>Utilizar un diagrama de despliegue UML para describir claramente los canales hacia los sistemas vecinos, junto con una tabla de mapeo que muestre las relaciones entre los canales y las entradas/salidas</action>
      <action>No es necesario ser tan detallado, la idea dar un contexto técnico de alto nivel, en una sección mas adelante se debe dar mas detalle</action>
      <action>Utiliza mermaid C4Deployment para construir el diagrama correspondiente.</action>
      <action>Para las soluciones en nube se debe preferir la generacíon de diagramas usando los iconos y notación propuesta por el provedor de servicios en la nube seleccionado ([AWS](https://aws.amazon.com/architecture/icons/), [Azure](https://learn.microsoft.com/en-us/azure/architecture/icons/), [GCP](https://cloud.google.com/icons))</action>      
      <action>Lista con cada uno de los servicios/componentes del diagrama junto con la descripción de lo que aportan a la solución y la justificación de uso</action>

      <template-output>contexto_tecnico</template-output>

      <elicit-required></elicit-required>

    </step>

  </step>

  <step n="4" goal="Estrategia de solución">  

    <action>Ofrece un resumen y una explicación breve de las decisiones fundamentales y las estrategias de solución que configuran la arquitectura del sistema.</action>
    <action>
      Incluye:
      - **Decisiones tecnológicas:** Elecciones sobre las tecnologías que se utilizarán.
      - **Decisiones sobre la descomposición de alto nivel del sistema:** Uso de patrones arquitectónicos o de diseño.
      - **Decisiones sobre cómo alcanzar objetivos clave de calidad:** Estrategias para cumplir con los objetivos de calidad del sistema.
      - **Decisiones organizativas relevantes:** Selección de procesos de desarrollo o delegación de tareas a terceros.
    </action>
    <action>Mantén la explicación de estas decisiones breve, centrate en lo que has decidido y por qué decidiste de esa manera, basándote en la declaración del problema, los objetivos de calidad y las restricciones clave.</action>
    <action>Las secciones Vista estática y Aspectos transversales son ideales para, en caso de ser necesario, detallar las estrategias de solución.</action>
    <action>La lista de las decisiones NO debe estar agrupada.</action>

    <template-output>estrategia_solucion</template-output>

    <elicit-required></elicit-required>

  </step>

  <step n="5" goal="Vista estática">

    <action>La vista estática muestra la descomposición del sistema en bloques de construcción (módulos, componentes, subsistemas, etc.) así como sus dependencias (relaciones, asociaciones, etc.).</action>
    <action>Esta vista es obligatoria para toda documentación de arquitectura.</action>
    <action>Mantén una visión general de la solución haciendo su estructura comprensible a través de la abstracción. Esto permitirá la comunicación con los interesados a un nivel abstracto sin revelar detalles de implementación.</action>
    <action>Mostrar cómo el sistema se descompone en contenedores, que pueden ser aplicaciones, servicios, bases de datos, etc., y cómo interactúan entre sí.</action>
    <action>Utiliza mermaid C4Container para construir el diagrama correspondiente.</action>
    <action>Descripción de todos los elementos del diagrama describiendo su propósito, responsabilidad e interfaces.</action>

    <template-output>vista_estatica</template-output>

    <elicit-required></elicit-required>

  </step>

  <step n="6" goal="Vista dinámica" repeat="for-each-flujo">  
    <action>El criterio principal para la elección de posibles escenarios (secuencias, flujos de trabajo) es la relevancia arquitectónica.</action>
    <action>No es importante describir un gran número de escenarios, Debes documentar los escenarios que son críticos y/o representativos para la comprensión arquitectónica y que tengan un impacto significativo sobre la arquitectura del sistema.</action>
    <action>
      La vista dinámica describe el comportamiento concreto y las interacciones de los bloques del sistema en forma de escenarios desde los siguientes puntos de vista:
      1. **Casos de uso o caracteristicas importantes:** ¿Cómo ejecutan los bloques estos casos de uso?
      2. **Interacciones en interfaces externas críticas:** ¿Cómo cooperan los bloques de construcción con los usuarios y sistemas vecinos?
      3. **Operación y administración:** Inicio, arranque, detención, escenarios de error y caminos excepción.
    </action>
    <action>Es muy importante por dar a entender cómo los bloques del sistema realizan su trabajo y se comunican en tiempo de ejecución y satisfacen los requerimientos.</action>
    <action>Identifica el nombre del flujo</action>
    <action>Utiliza mermaid sequenceDiagram para construir los diagramas correspondientes.</action>
    <action>Construye el diagrama de secuencia del flujo que se está iterando</action>

    <template-output>vista_dinamica</template-output>

    <elicit-required></elicit-required>

  </step>

  <step n="7" goal="Vista de despliegue">

    <action>Teniendo en cuenta la información de los pasos anteriores, identifica los elementos importantes para construir una vista de despliegue:
    - ubicaciones geográficas
    - entornos
    - computadoras
    - procesadores
    - canales y redes
    </action>
    <action>Identifica la asignación de bloques de construcción a los elementos de infraestructura, teniendo en cuenta información levantada en los pasos anteriores</action>
    <action>Muestra al usuario la lista de elementos de infraestructura identificados</action>
    <ask>
      Estos son los elementos de infraestructura importantes identificados
      ¿Deseas realizar modificaciones a la lista?
    </ask>
    <action>Profundiza y refina con el usuario dicha definición haciendo una descripción de la infraestructura, su configuración y las consideraciones de despliegue.</action>
    <action>Teniendo en cuenta la información de los pasos anteriores, construye una diagrama de despliegue para representar la infraestructura técnica utilizada para ejecutar el sistema.</action>
    <action>Utiliza mermaid C4Deployment para construir el diagrama correspondiente.</action>
    <critical>🚨 Es posible que el diagrama de despliegue de nivel mas alto ya esté definido en el paso 3.2 (Contexto Técnico), en este nuevo diagrama debes bajar de nivel y mostrar detalles claros de la infraestructura que soportará el sistema.</critical>

    <template-output>vista_despliegue</template-output>

    <elicit-required></elicit-required>

  </step>

  <step n="8" goal="Aspectos transversales">
    <action>Describe las regulaciones generales y las ideas de solución que son relevantes en múltiples partes (transversales) del sistema.</action>
    <action>
      Enfócate en identificar y tratar los aspectos transversales como elementos que:
      - No pueden aislarse en componentes individuales.
      - Atraviesan múltiples módulos y capas del sistema.
      - Son esenciales para las cualidades internas del software.
      - Incluyen áreas como seguridad, logging, manejo de errores, transacciones, etc.
    </action>
    <action>Estos conceptos a menudo están relacionados con múltiples bloques de construcción. Incluyen una variedad de temas, tales como:
      - Modelos de dominio
      - Manejo de excepciones
      - Persitencia y Transacciones
      - Experiencia de Usuario (UX)
      - Seguridad
      - Observabilidad (Logs, metricas y trazas)
      - Patrones arquitectónicos o de diseño
      - Reglas para el uso de tecnologías específicas
      - Decisiones técnicas principales
      - Reglas y ejemplos de implementación
    </action>
    <action>
      Cuando estes realizando este análisis, pregúntate:
      - ¿Cómo se están gestionando los aspectos transversales? 
      - ¿Están contribuyendo a la consistencia y homogeneidad del sistema?
    </action>
    <action>Prioriza soluciones que mantengan la integridad conceptual en lugar de implementaciones fragmentadas o inconsistentes.</action>
    <critical>🚨 No existe una estructura obligatoria predeterminada para esta sección; su contenido dependerá de la naturaleza del proyecto, los lineamientos, las decisiones arquitectónicas existentes y tu criterio como arquitecto. Por lo tanto, no hay un formato de documento específico; la estructura debe ser aquella que mejor facilite la comunicación efectiva. Además, en esta sección se deben referenciar los documentos externos que contengan definiciones aplicables de manera transversal al proyecto.</critical>
    <action>Pregunta al usuario si está de acuerdo con la estrutura propuesta para presentar la información de Aspectos Transversales o si desea realizar modificaciones antes de continuar</action>

    <template-output>aspectos_transversales</template-output>

    <elicit-required></elicit-required>

  </step>

  <step n="9" goal="Decisiones de arquitectura">  

    <action>Documenta decisiones arquitectónicas importantes, costosas, a gran escala o arriesgadas, incluyendo sus justificaciones. Por "decisiones" nos referimos a la selección de una alternativa basada en criterios dados.</action>
    <action>Utiliza tu juicio para decidir si una decisión arquitectónica debe documentarse aquí en esta sección central o si es mejor documentarla localmente (por ejemplo, dentro de la plantilla de caja blanca de un bloque de construcción). Evita textos redundantes. Refiérete a la sección 4, donde ya capturaste las decisiones más importantes de la arquitectura.</action>
    <action>Debes tener en cuneta que los interesados en el sistema deben poder comprender y seguir las decisiones.</action>
    <action>Para documentar las decisiones de arquitectura, debes usar ADR "Architecture Decision Records", los siguientes enlaces incluyen información conceptual, plantillas y ejemplos relacionados con los ADRs, su propósito y como pueden ser utilizados en la gestión del conocimiento arquitectónico.</action>
    <action>También puedes revisar las siguinetes plantillas sugeridas para usar la mas adecuada según sea el caso:
    
    ** MADR: https://adr.github.io/madr/

      1. Plantilla Completa
        - https://github.com/adr/madr/blob/4.0.0/template/adr-template.md?plain=1
      2. Plantilla Simplificada
        - https://github.com/adr/madr/blob/4.0.0/template/adr-template-minimal.md?plain=1 (simplificada)

    ** Nygard ADR: https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions

      1. https://github.com/joelparkerhenderson/architecture-decision-record/tree/main/locales/en/templates/decision-record-template-by-michael-nygard    
    </action>

    <template-output>decisiones_arquitectura</template-output>

    <elicit-required></elicit-required>

  </step>

  <step n="10" goal="Requerimientos de calidad">

    <step n="10.1" goal="Otros objetivos de Calidad">
      <action>Identifica la sección de requerimientos de calidad en la documentación de arquitectura que se está analizando o creando.</action>
      <action>Verifica que los objetivos de calidad principales ya estén documentados en el paso 1.2. Si no existen, señálalo como un problema prioritario.</action>
      <action>
      Documenta los requerimientos de calidad secundarios:
      - Captura aquellos atributos de calidad que tienen menor prioridad
      - Enfócate en requerimientos cuyo incumplimiento no genere riesgos altos para el sistema
      - Distingue claramente entre requerimientos críticos y secundarios
      </action>
      <action>
      Utiliza como referencia el modelo de calidad de arc42 (https://quality.arc42.org/):
      - Consulta la lista de atributos de calidad sugerida
      - Selecciona los atributos relevantes para el contexto del sistema
      - Asegúrate de cubrir las categorías pertinentes (rendimiento, seguridad, mantenibilidad, usabilidad, etc.)
      </action>
      <action>Identifica a todas las partes interesadas (stakeholders) del proyecto o sistema.</action>
      <action>
      Para cada stakeholder, determina:
      - Cuáles son sus requerimientos de calidad prioritarios
      - Qué atributos de calidad son críticos desde su perspectiva
      - Qué impacto tienen estos requerimientos en su área de interés
      </action>
      <action>
      Evalúa el impacto arquitectónico:
      - Analiza cómo cada requerimiento de calidad influirá en las decisiones de arquitectura
      - Identifica posibles conflictos entre requerimientos de diferentes stakeholders
      - Prioriza los requerimientos según su impacto en decisiones arquitectónicas clave
      </action>
      <action>Documenta la correlación entre requerimientos de calidad de stakeholders y las decisiones arquitectónicas que estos impulsan.</action>
      <action>Ante decisiones arquitectónicas importantes, verifica que estén alineadas con los requerimientos de calidad prioritarios de las partes interesadas más relevantes.</action>
      <action>Realiza una lista con estos objetivos de calidad y una descripción</action>

      <template-output>otros_objetivos_calidad</template-output>

      <elicit-required></elicit-required>

    </step>

    <step n="10.2" goal="Escenarios de calidad">
      <action>Analiza los objetivos de calidad definidos en la sección 1.2, para cada requerimiento de calidad identificado, crea escenarios de calidad concretos que lo materialicen.</action>
      <action>
      Estructura cada escenario de calidad con los siguientes elementos:
      - Fuente del estímulo: Quién o qué genera el evento (usuario, sistema externo, componente interno)
      - Estímulo: Qué acción o evento ocurre
      - Entorno/Contexto: Bajo qué condiciones sucede (carga normal, pico de tráfico, fallo de componente, etc.)
      - Artefacto afectado: Qué parte del sistema recibe el estímulo
      - Respuesta esperada: Qué debe hacer el sistema cuando recibe el estímulo
      - Medida de respuesta: Cómo se mide que la respuesta es adecuada (métricas cuantificables)
      </action>
      <action>
      Transforma requerimientos abstractos en escenarios medibles. Por ejemplo:
      - En lugar de "el sistema debe ser rápido" → "Cuando un usuario solicita consultar su saldo (estímulo) en horas pico (contexto), el sistema debe responder en menos de 2 segundos (medida)"
      - Define al menos 2-3 escenarios por cada objetivo de calidad principal
      </action>
      <action>
      Asegúrate de que cada escenario sea:
      - Específico y medible (Incluye métricas cuantitativas o criterios objetivos de cumplimiento)
      - Verificable mediante pruebas
      - Relevante para decisiones arquitectónicas (Puede usarse para validar decisiones arquitectónicas)
      - Suficientemente detallado para su evaluación
      </action>
      <action>Documenta los escenarios de forma que puedan utilizarse como criterios de aceptación y guía para validación arquitectónica.</action>
      <action>Cuando evalúes la arquitectura:
        - Usa los escenarios como checklist de validación
        - Verifica que cada decisión arquitectónica soporte el cumplimiento de los escenarios críticos
        - Identifica gaps donde los escenarios no puedan cumplirse con la arquitectura actual
      </action>
      <action>Facilita discusiones técnicas usando estos escenarios como lenguaje común entre arquitectos, desarrolladores y stakeholders.</action>

      <template-output>escenarios_calidad</template-output>

      <elicit-required></elicit-required>

    </step>

  </step>

  <step n="11" goal="Riesgos y deuda técnica">

    <action>Identifica todos los riesgos técnicos y deudas técnicas presentes o potenciales en la arquitectura del sistema.</action>
    <action>Para cada riesgo o deuda técnica identificado, documenta:
    - Descripción: Qué es el riesgo o deuda técnica
    - Impacto: Qué consecuencias tendría si se materializa o no se resuelve
    - Probabilidad: Qué tan probable es que ocurra (para riesgos)
    - Área afectada: Qué componentes, módulos o aspectos del sistema impacta
    - Prioridad: Clasificación según severidad e impacto (alta, media, baja)
    </action>
    <action>Ordena la lista por prioridad:
    - Prioriza según combinación de impacto y probabilidad/urgencia
    - Coloca primero los riesgos críticos que amenacen objetivos de calidad clave
    - Considera deudas técnicas que puedan convertirse en riesgos mayores
    </action>
    <action>Para cada elemento de la lista, define medidas concretas:
    - Evitar: Acciones para prevenir que el riesgo ocurra
    - Mitigar: Estrategias para reducir el impacto si ocurre
    - Minimizar: Tácticas para disminuir la probabilidad de ocurrencia
    - Reducir deuda: Plan de acción para resolver deudas técnicas gradualmente
    </action>
    <action>Mantén la lista actualizada:
    - Revisa periódicamente el estado de riesgos y deudas
    - Actualiza prioridades según evolución del proyecto
    - Marca elementos resueltos y agrega nuevos según surjan
    </action>
    <action>Comunica los riesgos críticos a los stakeholders relevantes para asegurar visibilidad y apoyo en su gestión.</action>

    <template-output>riesgos_deuda_tecnica</template-output>

    <elicit-required></elicit-required>

  </step>
  
  <step n="12" goal="Glosario">  

    <action>Identifica todos los términos clave utilizados en la documentación arquitectónica y en las discusiones del sistema:
    - Términos del dominio de negocio
    - Términos técnicos específicos del sistema
    - Conceptos arquitectónicos particulares del proyecto
    - Acrónimos y abreviaturas
    </action>
    <action>Para cada término identificado, crea una entrada de glosario que incluya:
    - Término: El nombre exacto como se usa en el proyecto
    - Definición: Explicación clara y precisa del significado
    - Sinónimos: Otros nombres con los que podría conocerse (si existen)
    - Traducción: Equivalente en otros idiomas si aplica (entornos multilingües/offshore)
    - Contexto de uso: Dónde o cómo se utiliza en el sistema
    </action>
    <action>Elimina ambigüedades:
    - Si detectas que un mismo término se usa con significados diferentes, clarifica y estandariza
    - Identifica homónimos (misma palabra, diferente significado) y diferéncialos
    - Desalienta el uso de sinónimos para el mismo concepto
    </action>
    <action>Mantén el glosario ordenado alfabéticamente para facilitar la búsqueda.</action>
    <action>Valida con stakeholders:
    - Verifica que las definiciones sean comprensibles para todas las partes interesadas
    - Asegura consenso en la terminología entre equipos técnicos y de negocio
    - Actualiza el glosario cuando surjan nuevos términos o se modifiquen conceptos
    </action>
    <action>Usa el glosario activamente:
    - Referencia términos del glosario en toda la documentación arquitectónica
    - Señala cuando se usen términos no definidos en el glosario
    - Mantén consistencia terminológica en toda la documentación
    </action>

    <template-output>glosario</template-output>

    <elicit-required></elicit-required>

  </step>


</workflow>
````
