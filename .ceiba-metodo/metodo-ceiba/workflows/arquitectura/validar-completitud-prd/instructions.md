# Validación de completitud PRD - Instrucciones de Workflow


````xml
<critical>🚨 El motor de ejecución de workflows está gobernado por el archivo: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>🚨 Debes haber cargado y procesado el archivo: {project-root}/.ceiba-metodo/metodo-ceiba/workflows/arquitectura/validar-completitud-prd/workflow.yaml</critical>
<critical>🚨 Comunica SIEMPRE ESTRICTAMENTE en {communication_language} sin importar el idioma usado por el usuario</critical>
<critical>🚨 Genera todos los documentos en {document_output_language}</critical>

<critical>🚨 REGLAS DE SALIDA DEL TEMPLATE: (1) Remover comentarios HTML de secciones completadas, mantener para secciones vacías/opcionales. (2) Asegurar que TODOS los elementos del template (títulos, encabezados, etiquetas) coincidan con {document_output_language}, no solo el contenido.</critical>

<critical>🚨 NUNCA modificar archivos de plantilla (template) - deben permanecer inmutables para reutilización</critical>

<critical>🚨 **Propósito**
   Validar completitud del PRD entregado por el proceso comercial o validar completitud de los requisitos de producto que se proporcionen con el objetivo de determinar la viabilidad de generar un definición de arquitectura tomando como base esta información. 
</critical>

<critical>🚨 **Usa esta tarea cuando:**
   Necesita crear una arquitectura de solución para un proyecto en etapa comercial
   Realizar propuestas de arquitectura de alto nivel  
</critical>

<critical>🚨 **Prerequisites:**
   Acceso a la documentación necesaria que define la necesidad
   Conocimiento del arquitecto responsable del sistema
   Documentación existente (si está disponible)
</critical>

<workflow>

    <step n="0.1" goal="Verificar disponibilidad documentación comercial">

        <critical>🚨 Identificar la documentación generada por el proceso comercial de Ceiba, es necesaria para empezar a construir la propuesta de arquitectura de solución alineada con las necesidades de negocio</critical>

        <action>Verificar disponibilidad de documentos generados por el área comercial de Ceiba, buscar en la ruta {output_folder}/propuesta</action>
        <action>Identifica principalmente la existencia de los documentos {output_folder}/propuesta/03-prd/PRD.md y {output_folder}/propuesta/03-prd/epicas.md </action>
        <action>Identifica la existencia de otros documentos en esta ruta, como el {output_folder}/propuesta/02-brief-alcance/brief-alcance.md y otros documentos con información importante</action>
        <check if="prd.md no disponible">
            <ask>¿Qué documentos servirán de base para crear la propuesta de arquitectura? Proporciona las rutas:</ask>      
        </check>
        <action>Cargar y revisar TODOS los documentos relevantes que encuentres en las rutas indicadas o proporcionadas</action>
        <action>Realiza una busqueda recursiva de TODOS los documentos que hay en la ruta especificada por el usuario y lee completamente la información que hay en dichos archivos</action>
        <action>Identifica el nombre del proyecto</action>
        <ask>Confirma el nombre del proyecto para {{project_name}}:</ask>

        <template-output>project_name</template-output>
        <template-output>disponibilidad_documentacion_comercial</template-output>

    </step>

    <step n="0.2" goal="Análisis de completitud documentación comercial">

        <critical>🚨</critical>

        <action>Analizar exhaustivamente el contenido del PRD para identificar la información disponible</action>
        <action>Analizar exhaustivamente el contenido de otros documentos encontrados para identificar la información disponible</action>

        <action>Evaluar presencia de elementos críticos para la creación de la propuesta de arquitectura:</action>

        <action>Revisa introducción y objetivos:</action>
        <action>Verifica que exista resumen claro de requisitos funcionales</action>
        <action>Verifica que existan objetivos de calidad/NFRs</action>
        <action>Verifica definición de stakeholders y sus expectativas</action>

        <action>Revisa las restricciones:</action>
        <action>Verifica que las restricciones técnicas estén documentadas</action>
        <action>Revisa que mencionan limitaciones organizacionales</action>
        <action>Verifica la existencia de de políticas o compliance definidos</action>

        <action>Revisa el Contexto y Alcance:</action>
        <action>Identifica las definiciones de usuarios y sistemas externos</action>
        <action>Identifica las definiciones de integraciones requeridas</action>
        <action>Verifica la especifiación de entradas y salidas del sistema</action>

        <action>Revisa las especificaciones al diseño técnico:</action>
        <action>Identifica información sobre volúmenes de datos/usuarios</action>
        <action>Identifica los casos de uso principales</action>
        <action>Verifica los requerimientos de despliegue</action>

        <action>Revisa los escenarios de Calidad y Riesgos:</action>
        <action>Identifica escenarios de Calidad especificados</action>
        <action>Verifica la documentación de riesgos conocidos</action>
        <action>Identifica los criterios de éxito medibles</action>   

        <template-output>analisis_completitud_documentacion_comercial</template-output>
        
    </step>

    <step n="0.3" goal="Resumen completitud documentación comercial">

        <action>Teniendo en cuenta toda la información previamente verificada, realiza un resumen de completitud de la información</action>
        <action>Muestra al usuario los puntos que cumplen con información completa, genera una matriz que mapee estos puntos</action>
        <action>Para cada uno de los puntos identifica:
            1. ✅ **Información COMPLETA** - PRD tiene suficiente detalle
            2. ⚠️ **Información PARCIAL** - PRD tiene algo pero falta profundidad
            3. ❌ **Información FALTANTE** - PRD no contiene esta información
            4. 🔍 **Información INFERIBLE** - Puede deducirse de otros elementos
        </action>
        <action>Genera la tabla de mapeo:
            | Sección Arquitectura | Estado | Información Disponible | Información Faltante | Impacto         |
            | -------------------- | ------ | ---------------------- | -------------------- | --------------- |
            | Resumen Requisitos   | ✅/⚠️/❌  | [descripción]          | [gaps específicos]   | Alto/Medio/Bajo |
            | Objetivos Calidad    | ✅/⚠️/❌  | [descripción]          | [gaps específicos]   | Alto/Medio/Bajo |
            | ...                  | ...    | ...                    | ...                  | ...             |
        </action>

        <template-output>resumen_completitud_documentacion_comercial</template-output>

    </step>

    <step n="0.4" goal="Análisis de gaps identificados">

        <action>Identificar y categorizar los gaps encontrados por nivel de criticidad</action>

        <critical>🚨 Ten en cuenta los siguientes criterios para analizar categorizar los GAPS identificados, los elementos listados como criterios pueden ser frases o preguntas; se debe analizar la información teniendo en cuneta dichas frases y preguntas. No realizar estas preguntas al usuario</critical>
        
        <action>
            🚨 Información faltante que **BLOQUEA** la definición de arquitectura
            🔴 **CRITERIOS CRÍTICOS - Evaluación Objetiva:**
            
            **Para cada criterio evaluar: ✅ CUMPLE | ⚠️ PARCIAL | ❌ NO CUMPLE | 🔍 INFERIBLE**

            **C1: Contexto de Negocio Fundamental Documentado**
            
            **C1.1: Usuarios objetivo están claramente identificados y caracterizados**
            - Los tipos de usuarios están específicamente definidos con perfiles detallados
            - Las características técnicas de usuarios están documentadas (dispositivos, conectividad, nivel técnico)
            - El volumen esperado de usuarios está cuantificado con rangos específicos
            - Los patrones de uso y comportamiento están descritos
            
            **C1.2: Objetivos de negocio están claramente definidos y cuantificados**
            - El problema específico que resuelve el sistema está articulado claramente
            - Los resultados esperados están definidos de manera medible
            - Los criterios de éxito del proyecto están establecidos con métricas específicas
            - El valor de negocio esperado está cuantificado
            
            **C1.3: Flujos de negocio críticos están completamente documentados**
            - Los procesos core del negocio están descritos paso a paso
            - Los flujos principales que debe soportar el sistema están mapeados
            - Todos los actores participantes están identificados con sus roles y responsabilidades
            - Las interacciones entre actores están claramente definidas
            
            **C1.4: Volúmenes de transacciones y usuarios están cuantificados**
            - Las transacciones esperadas están especificadas por unidad de tiempo (segundo/día/mes)
            - Los picos de uso están identificados con valores específicos
            - Las variaciones estacionales o periódicas están documentadas
            - Los factores de crecimiento están proyectados

            **C2: Requerimientos No Funcionales Críticos Documentados**
            
            **C2.1: Requerimientos de performance están específicamente definidos**
            - TPS (transacciones por segundo) objetivo está especificado
            - Número máximo de usuarios concurrentes está definido
            - Tiempos de respuesta aceptables están establecidos por tipo de operación
            - Throughput requerido está cuantificado para diferentes escenarios
            
            **C2.2: Requerimientos de disponibilidad están claramente establecidos**
            - Los horarios de operación están específicamente definidos (24/7 o ventanas específicas)
            - El tiempo de inactividad aceptable está cuantificado
            - El nivel de disponibilidad requerido está especificado (99%, 99.9%, etc.)
            - Los procedimientos de recuperación ante fallos están considerados
            
            **C2.3: Requerimientos de escalabilidad están proyectados**
            - El crecimiento esperado en 1-3 años está cuantificado
            - Los planes de expansión geográfica están documentados si aplican
            - Nuevos productos o servicios planificados están considerados
            - Los límites de escalabilidad están definidos
            
            **C2.4: Requerimientos de seguridad están específicamente definidos**
            - Se ha identificado si es un sector regulado y qué regulaciones aplican
            - Los tipos de datos sensibles que maneja están categorizados
            - Los estándares de compliance requeridos están especificados (GDPR, PCI DSS, SOX, etc.)
            - Los niveles de seguridad por tipo de función están definidos

            **C3: Integraciones y Dependencias Externas Documentadas**
            
            **C3.1: Sistemas externos críticos están completamente identificados**
            - Todos los sistemas existentes con los que debe integrarse están listados
            - Los sistemas legacy involucrados están documentados con sus limitaciones
            - Los sistemas de terceros críticos están identificados con sus capacidades
            - Las dependencias entre sistemas están mapeadas
            
            **C3.2: Fuentes de datos principales están claramente definidas**
            - El origen de la información crítica del sistema está identificado
            - Los sistemas que son fuente de verdad están especificados
            - Los requerimientos de sincronización de datos están documentados
            - Los flujos de datos entre sistemas están mapeados
            
            **C3.3: Servicios de terceros requeridos están especificados**
            - Las necesidades de servicios externos están identificadas (pagos, notificaciones, autenticación)
            - Las dependencias de APIs de terceros están documentadas
            - Los servicios cloud requeridos están especificados
            - Los niveles de servicio esperados de terceros están definidos

            **C4: Restricciones Técnicas y Operacionales Documentadas**
            
            **C4.1: Plataformas de despliegue están claramente especificadas**
            - La estrategia de despliegue está definida (cloud, on-premise, híbrido)
            - Los proveedores cloud aprobados están especificados si aplica
            - Las restricciones de ubicación geográfica de datos están documentadas
            - Los ambientes requeridos están definidos (desarrollo, testing, producción)
            
            **C4.2: Dispositivos y navegadores objetivo están definidos**
            - Las plataformas objetivo están especificadas (móvil, web, desktop)
            - Las versiones mínimas de SO y navegadores están documentadas
            - Las restricciones de compatibilidad están establecidas
            - Los requisitos de accesibilidad están considerados
            
            **C4.3: Restricciones regulatorias y de compliance están identificadas**
            - Todas las regulaciones aplicables están documentadas
            - Los requerimientos de auditoría están especificados
            - Las certificaciones específicas necesarias están identificadas
            - Los procesos de compliance requeridos están definidos
            
            **C4.4: Limitaciones de infraestructura existente están documentadas**
            - La infraestructura actual que debe reutilizarse está inventariada
            - Las limitaciones de red, seguridad o capacidad están identificadas
            - Las restricciones presupuestarias están consideradas
            - Los recursos técnicos disponibles están documentados

            **C5: Alcance y Límites del Sistema Claramente Definidos**
            
            **C5.1: Fronteras del sistema están claramente establecidas**
            - Las funcionalidades incluidas en el alcance están específicamente listadas
            - Lo que se considera fuera del alcance está explícitamente documentado
            - Los límites entre este sistema y otros sistemas están claramente demarcados
            - Las interfaces de entrada y salida del sistema están definidas
            
            **C5.2: Responsabilidades del sistema están claramente diferenciadas**
            - Las funciones de este sistema vs sistemas existentes están diferenciadas
            - Las posibles duplicaciones de funcionalidades están identificadas y resueltas
            - La división de responsabilidades está claramente establecida
            - Los puntos de integración están específicamente definidos
            
            **C5.3: Fases de implementación están priorizadas y secuenciadas**
            - El MVP está claramente definido con sus funcionalidades específicas
            - Las versiones futuras están planificadas con sus incrementos funcionales
            - Las dependencias entre fases están identificadas y mapeadas
            - Las funcionalidades críticas para lanzamiento están priorizadas

            **C6: Arquitectura de Datos Fundamental Documentada** *(NUEVO)*
            
            **C6.1: Entidades de datos principales están identificadas**
            - Los objetos de negocio fundamentales están definidos
            - Las relaciones críticas entre entidades están establecidas
            - Los modelos de datos principales están conceptualizados
            - Los requerimientos de consistencia de datos están especificados
            
            **C6.2: Volúmenes de datos están cuantificados**
            - Los tamaños de datos esperados están estimados
            - Las tasas de crecimiento de datos están proyectadas
            - Los requerimientos de almacenamiento están cuantificados
            - Las políticas de retención de datos están definidas
        </action>

        <action>
            🚨 Información faltante que **COMPLICA** la definición de arquitectura
            🟡 **CRITERIOS IMPORTANTES - Evaluación Objetiva:**
            
            **Para cada criterio evaluar: ✅ CUMPLE | ⚠️ PARCIAL | ❌ NO CUMPLE | 🔍 INFERIBLE**

            **I1: Requerimientos Funcionales Completamente Especificados**
            
            **I1.1: Casos de uso principales están detallados suficientemente**
            - Los flujos principales de cada caso de uso están descritos paso a paso
            - Los flujos alternativos y de excepción están documentados
            - Las precondiciones y postcondiciones están claramente establecidas
            - Los criterios de aceptación están definidos para cada caso de uso
            
            **I1.2: Comportamientos de error y excepciones están especificados**
            - Los escenarios de error más comunes están identificados y documentados
            - Las estrategias de manejo de errores están definidas por tipo de error
            - Los mensajes de error y su presentación al usuario están especificados
            - Los procedimientos de recuperación ante errores están documentados
            
            **I1.3: Validaciones de negocio están claramente definidas**
            - Las reglas de negocio críticas están documentadas con sus condiciones
            - Los rangos, formatos y restricciones de datos están especificados
            - Las validaciones complejas que involucran múltiples campos están definidas
            - Los criterios de validación están priorizados por criticidad
            
            **I1.4: Estados y transiciones de datos están documentados**
            - Los estados posibles de las entidades principales están identificados
            - Las transiciones válidas entre estados están mapeadas
            - Las condiciones que disparan cambios de estado están especificadas
            - Los permisos requeridos para cada transición están definidos

            **I2: Requerimientos No Funcionales Cualitativos Definidos**
            
            **I2.1: Requerimientos de usabilidad están especificados**
            - El perfil de experiencia técnica de los usuarios está caracterizado
            - Los estándares de usabilidad a seguir están identificados (WCAG, etc.)
            - Los tiempos máximos de aprendizaje del sistema están establecidos
            - Los criterios de satisfacción del usuario están definidos
            
            **I2.2: Requerimientos de mantenibilidad están establecidos**
            - El perfil técnico del equipo de mantenimiento está documentado
            - Las herramientas de desarrollo y tecnologías preferidas están especificadas
            - Los estándares de código y documentación requeridos están definidos
            - Los tiempos objetivo para implementar cambios típicos están establecidos
            
            **I2.3: Requerimientos de observabilidad están definidos**
            - Las métricas de negocio críticas que deben monitorearse están identificadas
            - Los niveles de logging requeridos están especificados por componente
            - Las alertas y umbrales de monitoreo están definidos
            - Los requerimientos de auditoría y trazabilidad están establecidos
            
            **I2.4: Requerimientos de testabilidad están considerados**
            - Las estrategias de testing requeridas están identificadas (unit, integration, etc.)
            - Los entornos de testing necesarios están especificados
            - Los datos de prueba y su gestión están considerados
            - Los criterios de cobertura de testing están establecidos

            **I3: Contexto Técnico Organizacional Documentado**
            
            **I3.1: Tecnologías y estándares organizacionales están documentados**
            - Las tecnologías ya adoptadas en la organización están inventariadas
            - Los estándares técnicos corporativos están identificados
            - Las políticas de arquitectura existentes están documentadas
            - Las restricciones tecnológicas organizacionales están especificadas
            
            **I3.2: Capacidades del equipo de desarrollo están caracterizadas**
            - El tamaño y composición del equipo de desarrollo está definido
            - Las competencias técnicas disponibles están documentadas
            - Las limitaciones de capacidad del equipo están identificadas
            - Los planes de capacitación necesarios están considerados
            
            **I3.3: Restricciones presupuestarias están consideradas**
            - Los rangos presupuestarios aproximados están establecidos
            - Las restricciones de licenciamiento están identificadas
            - Los costos operacionales esperados están considerados
            - Las limitaciones de inversión en infraestructura están documentadas
            
            **I3.4: Políticas corporativas aplicables están identificadas**
            - Las políticas de seguridad corporativas están documentadas
            - Los estándares de desarrollo organizacionales están especificados
            - Los procedimientos de aprovisionamiento y deployment están considerados
            - Las políticas de gestión de datos están identificadas

            **I4: Características de Datos Detalladas**
            
            **I4.1: Tipos y estructuras de datos están identificados**
            - Los principales tipos de datos a manejar están categorizados
            - Las estructuras de datos complejas están identificadas
            - Los formatos de intercambio de datos están especificados
            - Las dependencias entre tipos de datos están mapeadas
            
            **I4.2: Volúmenes de almacenamiento están estimados**
            - Los volúmenes iniciales de datos están cuantificados
            - Las tasas de crecimiento esperadas están proyectadas a mediano plazo
            - Los picos de almacenamiento estacionales están considerados
            - Los requerimientos de archivado están identificados
            
            **I4.3: Políticas de gestión de datos están especificadas**
            - Las políticas de retención están definidas por tipo de dato
            - Los procedimientos de backup y recuperación están considerados
            - Las políticas de archivado y eliminación están establecidas
            - Los requerimientos de migración de datos están identificados
            
            **I4.4: Clasificación de sensibilidad de datos está establecida**
            - Los datos están clasificados por nivel de sensibilidad
            - Los requerimientos de cifrado están definidos por clasificación
            - Las políticas de acceso están establecidas por tipo de dato
            - Los procedimientos de anonimización están considerados si aplica

            **I5: Integración y Conectividad Detallada** *(NUEVO)*
            
            **I5.1: Patrones de integración están definidos**
            - Los patrones de comunicación preferidos están especificados (sync/async, REST/messaging, etc.)
            - Los protocolos de integración están identificados
            - Las estrategias de manejo de errores en integraciones están definidas
            - Los requerimientos de transformación de datos están considerados
            
            **I5.2: Requerimientos de conectividad están especificados**
            - Los requerimientos de ancho de banda están estimados
            - Las restricciones de conectividad de usuarios están consideradas
            - Los requerimientos de redundancia de conectividad están definidos
            - Los procedimientos para conectividad degradada están establecidos

            **I6: Consideraciones de Evolución y Crecimiento** *(NUEVO)*
            
            **I6.1: Capacidad de evolución está considerada**
            - Los puntos de extensibilidad requeridos están identificados
            - La estrategia de versionado de APIs está considerada
            - Los mecanismos de configuración dinámica están evaluados
            - La capacidad de modificación sin downtime está considerada
            
            **I6.2: Estrategia de migración está definida**
            - Los procedimientos de migración desde sistemas existentes están considerados
            - Las estrategias de coexistencia temporal están evaluadas
            - Los planes de rollback están considerados
            - Los criterios de éxito de migración están establecidos
        </action>

        <action>
            🚨 Detalles que pueden definirse durante el diseño **SIN AFECTAR** decisiones arquitectónicas
            🟢 **CRITERIOS MENORES - Evaluación Objetiva:**
            
            **Para cada criterio evaluar: ✅ CUMPLE | ⚠️ PARCIAL | ❌ NO CUMPLE | 🔍 INFERIBLE**
            
            **Estos criterios corresponden a información que naturalmente se define durante la implementación**

            **M1: Detalles de Implementación Específicos**
            
            **M1.1: Validaciones de campos específicas están definidas**
            - Las reglas de validación de formularios específicos están documentadas en detalle
            - Los formatos exactos de campos (máscaras, patrones) están especificados
            - Las validaciones de interdependencia entre campos específicos están definidas
            - Los mensajes de validación específicos están documentados
            
            **M1.2: Formatos exactos de intercambio están especificados**
            - Los esquemas detallados de mensajes de API están definidos
            - Los formatos específicos de archivos de importación/exportación están documentados
            - Las estructuras exactas de datos para integraciones están especificadas
            - Los códigos de error específicos y sus descripciones están catalogados
            
            **M1.3: Textos específicos de interfaz están documentados**
            - Los textos exactos de etiquetas, botones y mensajes están especificados
            - Las traducciones o internacionalización están consideradas en detalle
            - Los mensajes de ayuda y tooltips específicos están documentados
            - El copywriting exacto de la interfaz está definido
            
            **M1.4: Configuraciones menores de parámetros están especificadas**
            - Los valores por defecto de configuraciones menores están establecidos
            - Los rangos específicos de parámetros de configuración están definidos
            - Las opciones de personalización menores están documentadas
            - Los parámetros de fine-tuning del sistema están especificados

            **M2: Funcionalidades de Conveniencia Opcionales**
            
            **M2.1: Features "nice-to-have" están identificadas como opcionales**
            - Las funcionalidades claramente marcadas como no críticas están listadas
            - Las mejoras de experiencia de usuario opcionales están documentadas
            - Los atajos o accesos rápidos adicionales están considerados
            - Las funcionalidades de personalización avanzada están identificadas
            
            **M2.2: Reportes y consultas específicas están catalogadas**
            - Los reportes estándar sin complejidad arquitectónica están listados
            - Las consultas específicas de información están documentadas
            - Los dashboards básicos sin integración compleja están considerados
            - Las exportaciones de datos simples están especificadas
            
            **M2.3: Notificaciones simples están especificadas**
            - Las notificaciones básicas por email están definidas
            - Los mensajes de confirmación simples están documentados
            - Las alertas de usuario básicas están especificadas
            - Los recordatorios automáticos simples están considerados
            
            **M2.4: Mejoras incrementales de UX están identificadas**
            - Las mejoras de interfaz que no afectan lógica de negocio están listadas
            - Los refinamientos visuales opcionales están documentados
            - Las funcionalidades de accesibilidad básicas están consideradas
            - Las optimizaciones menores de flujo de usuario están identificadas

            **M3: Aspectos Operacionales Menores**
            
            **M3.1: Procedimientos operacionales específicos están documentados**
            - Los procedimientos de mantenimiento rutinario están especificados
            - Las rutinas de backup menores están documentadas
            - Los procedimientos de limpieza de datos están definidos
            - Las tareas de administración básicas están catalogadas
            
            **M3.2: Manuales de usuario detallados están considerados**
            - La estructura de documentación de usuario está planificada
            - Los tutoriales específicos de funcionalidades están considerados
            - Los materiales de capacitación están identificados
            - Las guías de resolución de problemas básicos están contempladas
            
            **M3.3: Procesos de soporte específicos están definidos**
            - Los procedimientos de primer nivel de soporte están documentados
            - Las escalaciones específicas de problemas están definidas
            - Los scripts de soporte para problemas comunes están considerados
            - Las métricas de soporte básicas están identificadas
            
            **M3.4: Configuraciones administrativas menores están especificadas**
            - Las configuraciones de ambiente no críticas están documentadas
            - Los parámetros de administración básicos están definidos
            - Las opciones de configuración de logs menores están especificadas
            - Los ajustes de rendimiento menores están considerados

            **M4: Refinamientos Estéticos y de Presentación** *(NUEVO)*
            
            **M4.1: Elementos estéticos específicos están definidos**
            - Los esquemas de colores específicos están documentados
            - Las tipografías exactas están especificadas
            - Los iconos y elementos gráficos menores están catalogados
            - Las animaciones y transiciones menores están consideradas
            
            **M4.2: Diseño responsivo detallado está especificado**
            - Los breakpoints específicos para diferentes dispositivos están definidos
            - Las adaptaciones menores para móvil están documentadas
            - Los ajustes específicos de layouts están especificados
            - Las optimizaciones menores de presentación están consideradas

            **M5: Optimizaciones Menores de Performance** *(NUEVO)*
            
            **M5.1: Optimizaciones específicas están identificadas**
            - Las mejoras menores de caching están consideradas
            - Las optimizaciones de queries específicas están documentadas
            - Los ajustes menores de algoritmos están identificados
            - Las mejoras incrementales de código están catalogadas
            
            **M5.2: Configuraciones de performance menores están especificadas**
            - Los parámetros de timeout específicos están definidos
            - Las configuraciones de pool de conexiones están especificadas
            - Los ajustes menores de memoria están considerados
            - Las optimizaciones de red menores están documentadas
        </action>      

        <action>Determina a que categoría pertenece cada GAP identificado utilizando la siguiente matriz de evaluación objetiva:</action>

        <action>
            🔴 **Para determinar si es CRÍTICO - Matriz de Evaluación:**
            
            **Por cada criterio C1-C6, evaluar usando puntuación:**
            - **Presencia (0-2)**: ¿Está documentado? | 0=No existe | 1=Mencionado vagamente | 2=Documentado específicamente
            - **Completitud (0-2)**: ¿Nivel de detalle suficiente? | 0=Insuficiente | 1=Básico | 2=Detallado y completo  
            - **Claridad (0-2)**: ¿Es inequívoco? | 0=Ambiguo | 1=Parcialmente claro | 2=Completamente claro
            - **Impacto Arquitectónico (1-3)**: ¿Criticidad para arquitectura? | 1=Bajo | 2=Medio | 3=Alto
            
            **Fórmula de Categorización:**
            - **Puntuación Total = (Presencia + Completitud + Claridad) × Impacto Arquitectónico**
            - **CRÍTICO**: Puntuación ≤ 12 Y Impacto = 3
            - **CRÍTICO**: Cualquier criterio C1-C6 con Presencia = 0 Y Impacto ≥ 2
            
            **Preguntas de Validación Específicas:**
            1. Sin esta información específica, ¿sería imposible tomar decisiones arquitectónicas fundamentales?
            2. ¿Este GAP bloquearía completamente la descomposición del sistema en componentes principales?
            3. ¿Afectaría directamente la selección del stack tecnológico o la estrategia de despliegue?
            4. ¿Sin esta información, existe alta probabilidad de que la arquitectura sea fundamentalmente incorrecta?
            5. ¿La ausencia de esta información genera riesgos técnicos o de negocio considerados inaceptables?
        </action>

        <action>
            🟡 **Para determinar si es IMPORTANTE - Matriz de Evaluación:**
            
            **Por cada criterio I1-I6, evaluar usando puntuación:**
            - **Presencia (0-2)**: ¿Está documentado? | 0=No existe | 1=Mencionado vagamente | 2=Documentado específicamente
            - **Completitud (0-2)**: ¿Nivel de detalle suficiente? | 0=Insuficiente | 1=Básico | 2=Detallado y completo  
            - **Claridad (0-2)**: ¿Es inequívoco? | 0=Ambiguo | 1=Parcialmente claro | 2=Completamente claro
            - **Impacto Arquitectónico (1-3)**: ¿Criticidad para arquitectura? | 1=Bajo | 2=Medio | 3=Alto
            
            **Fórmula de Categorización:**
            - **Puntuación Total = (Presencia + Completitud + Claridad) × Impacto Arquitectónico**
            - **IMPORTANTE**: Puntuación 13-15 Y Impacto ≥ 2
            - **IMPORTANTE**: Criterios I1-I6 con Presencia ≤ 1 Y Impacto = 2
            - **IMPORTANTE**: Cualquier criterio que afecte estimaciones o complejidad significativamente
            
            **Preguntas de Validación Específicas:**
            1. ¿Este GAP complicaría significativamente el diseño detallado pero no impediría las decisiones arquitectónicas principales?
            2. ¿Podría generar retrabajos significativos en fases de implementación si se define mal desde el inicio?
            3. ¿Afectaría directamente la estimación de esfuerzo, tiempo o complejidad del proyecto?
            4. ¿Su ausencia incrementaría los riesgos del proyecto a un nivel que requiere mitigación activa?
            5. ¿La información faltante impactaría la selección de patrones de diseño o estrategias de implementación?
        </action>

        <action>
            🟢 **Para determinar si es MENOR - Matriz de Evaluación:**
            
            **Por cada criterio M1-M5, evaluar usando puntuación:**
            - **Presencia (0-2)**: ¿Está documentado? | 0=No existe | 1=Mencionado vagamente | 2=Documentado específicamente
            - **Completitud (0-2)**: ¿Nivel de detalle suficiente? | 0=Insuficiente | 1=Básico | 2=Detallado y completo  
            - **Claridad (0-2)**: ¿Es inequívoco? | 0=Ambiguo | 1=Parcialmente claro | 2=Completamente claro
            - **Impacto Arquitectónico (1-3)**: ¿Criticidad para arquitectura? | 1=Bajo | 2=Medio | 3=Alto
            
            **Fórmula de Categorización:**
            - **Puntuación Total = (Presencia + Completitud + Claridad) × Impacto Arquitectónico**
            - **MENOR**: Puntuación ≥ 16 O Impacto = 1
            - **MENOR**: Criterios M1-M5 que no afectan decisiones estructurales
            - **MENOR**: Cualquier detalle que se puede resolver durante implementación sin retrabajos
            
            **Preguntas de Validación Específicas:**
            1. ¿Es algo que naturalmente se define durante la implementación sin afectar el diseño arquitectónico?
            2. ¿Su ausencia no impacta ninguna decisión estructural o tecnológica del sistema?
            3. ¿Puede resolverse con configuraciones, cambios menores o ajustes de implementación?
            4. ¿Es más un detalle de UX/UI, contenido o configuración que de arquitectura?
            5. ¿La información faltante puede posponerse sin generar riesgos o retrabajos significativos?
            6. ¿Se trata de refinamientos o optimizaciones que no afectan la funcionalidad core?
        </action>

        <action>Genera recomendaciones para cada uno de los GAPS identificados de acuerdo a su categorización</action> 

        <template-output>analisis_gaps_identificados</template-output>

    </step>

    <step n="0.5" goal="Generar recomendaciones específicas">

        <action>Crear recomendaciones específicas y accionables para completar información del documento PRD</action>
        <action>Para cada gap identificado, generar:
            1. **Pregunta específica** que debe responderse
            2. **Tipo de información** requerida
            3. **Fuente sugerida** (stakeholder, análisis, investigación)
            4. **Prioridad** (Crítico/Importante/Menor)
            5. **Impacto arquitectónico** si no se resuelve
        </action>

        <action>Agrupar recomendaciones por:
            - **Stakeholder responsable** (Product Owner, Negocio, Técnico)
            - **Fase de resolución** (Antes de arquitectura, Durante diseño, Posterior)
            - **Esfuerzo requerido** (Bajo, Medio, Alto)
        </action>

        <action>Identificar las 3 acciones prioritarias más críticas para próximos pasos</action>

        <template-output>recomendaciones_específicas_accionables</template-output>
        <template-output>priority_action_1</template-output>
        <template-output>priority_action_2</template-output>
        <template-output>priority_action_3</template-output>

    </step>

    <step n="0.6" goal="Cálculo objetivo del nivel de completitud">

        <action>Calcular el porcentaje de completitud de forma objetiva basándose en las evaluaciones realizadas en el paso 0.4</action>
        
        <critical>🚨 **METODOLOGÍA DE CÁLCULO OBJETIVA:**</critical>
        
        <action>**1. Recopilar puntuaciones de evaluación por categoría:**</action>
        <action>
            Para cada criterio evaluado en el paso 0.4, usar la puntuación obtenida:
            - **Puntuación por criterio = (Presencia + Completitud + Claridad) × Impacto Arquitectónico**
            - **Rango posible por criterio: 3-18 puntos**
            
            **Criterios Críticos (C1-C6):**
            - C1: Contexto de Negocio (4 subcriterios: C1.1-C1.4)
            - C2: Requerimientos No Funcionales (4 subcriterios: C2.1-C2.4)
            - C3: Integraciones y Dependencias (3 subcriterios: C3.1-C3.3)
            - C4: Restricciones Técnicas (4 subcriterios: C4.1-C4.4)
            - C5: Alcance y Límites (3 subcriterios: C5.1-C5.3)
            - C6: Arquitectura de Datos (2 subcriterios: C6.1-C6.2)
            - **Total subcriterios críticos: 20**
            
            **Criterios Importantes (I1-I6):**
            - I1: Requerimientos Funcionales (4 subcriterios: I1.1-I1.4)
            - I2: Requerimientos No Funcionales Cualitativos (4 subcriterios: I2.1-I2.4)
            - I3: Contexto Técnico Organizacional (4 subcriterios: I3.1-I3.4)
            - I4: Características de Datos (4 subcriterios: I4.1-I4.4)
            - I5: Integración y Conectividad (2 subcriterios: I5.1-I5.2)
            - I6: Consideraciones de Evolución (2 subcriterios: I6.1-I6.2)
            - **Total subcriterios importantes: 20**
            
            **Criterios Menores (M1-M5):**
            - M1: Detalles de Implementación (4 subcriterios: M1.1-M1.4)
            - M2: Funcionalidades de Conveniencia (4 subcriterios: M2.1-M2.4)
            - M3: Aspectos Operacionales (4 subcriterios: M3.1-M3.4)
            - M4: Refinamientos Estéticos (2 subcriterios: M4.1-M4.2)
            - M5: Optimizaciones Menores (2 subcriterios: M5.1-M5.2)
            - **Total subcriterios menores: 16**
        </action>

        <action>**2. Aplicar ponderación por importancia:**</action>
        <action>
            **Pesos por categoría:**
            - **Criterios Críticos**: Peso = 3.0 (máxima importancia)
            - **Criterios Importantes**: Peso = 2.0 (importancia media)
            - **Criterios Menores**: Peso = 1.0 (menor importancia)
        </action>

        <action>**3. Fórmula de cálculo:**</action>
        <action>
            **Paso 1: Calcular puntuación por categoría**
            ```
            Puntuación_Críticos = Σ(Puntuación_Subcriterio_Ci) / (20 × 18) × 100
            Puntuación_Importantes = Σ(Puntuación_Subcriterio_Ii) / (20 × 18) × 100  
            Puntuación_Menores = Σ(Puntuación_Subcriterio_Mi) / (16 × 18) × 100
            ```
            
            **Paso 2: Aplicar ponderación**
            ```
            Puntuación_Ponderada_Total = 
                (Puntuación_Críticos × 3.0) + 
                (Puntuación_Importantes × 2.0) + 
                (Puntuación_Menores × 1.0)
            ```
            
            **Paso 3: Normalizar al porcentaje final**
            ```
            Nivel_Completitud = Puntuación_Ponderada_Total / (3.0 + 2.0 + 1.0) × 100
            
            readiness_score = round(Nivel_Completitud, 1)
            ```
        </action>

        <action>**4. Calcular métricas adicionales:**</action>
        <action>
            **Conteo de gaps por categoría:**
            ```
            critical_gaps_count = Número de subcriterios C1-C6 con puntuación < 12
            important_gaps_count = Número de subcriterios I1-I6 con puntuación < 13
            minor_gaps_count = Número de subcriterios M1-M5 con puntuación < 16
            ```
            
            **Determinación de estado general:**
            ```
            if readiness_score >= 85 AND critical_gaps_count == 0:
                overall_status = "✅ APTO PARA ARQUITECTURA"
            elif readiness_score >= 70 AND critical_gaps_count <= 2:
                overall_status = "⚠️ APTO CON RESERVAS - Completar gaps críticos"
            elif readiness_score >= 50:
                overall_status = "⚠️ PARCIALMENTE APTO - Requiere mejoras importantes"
            else:
                overall_status = "❌ NO APTO - Información insuficiente para arquitectura"
            ```
        </action>

        <template-output>readiness_score</template-output>
        <template-output>overall_status</template-output>
        <template-output>critical_gaps_count</template-output>
        <template-output>important_gaps_count</template-output>
        <template-output>minor_gaps_count</template-output>

        <action>**5. Documentar cálculo detallado:**</action>
        <action>
            Generar tabla de puntuaciones detallada para transparencia:
            
            | Categoría   | Subcriterios Evaluados | Puntuación Obtenida | Puntuación Máxima | % Categoría | Peso    | Contribución |
            | ----------- | ---------------------- | ------------------- | ----------------- | ----------- | ------- | ------------ |
            | Críticos    | 20 subcriterios        | XXX/360             | 360               | XX.X%       | 3.0     | XX.X         |
            | Importantes | 20 subcriterios        | XXX/360             | 360               | XX.X%       | 2.0     | XX.X         |
            | Menores     | 16 subcriterios        | XXX/288             | 288               | XX.X%       | 1.0     | XX.X         |
            | **TOTAL**   | **56 subcriterios**    | **XXX/1008**        | **1008**          | **XX.X%**   | **6.0** | **XX.X**     |
        </action>

        <template-output>calculo_objetivo_nivel_completitud</template-output>
        <template-output>porcentaje_criticos</template-output>
        <template-output>porcentaje_importantes</template-output>
        <template-output>porcentaje_menores</template-output>
        <template-output>puntuacion_criticos</template-output>
        <template-output>puntuacion_importantes</template-output>
        <template-output>puntuacion_menores</template-output>
        <template-output>puntuacion_total</template-output>
        <template-output>contribucion_criticos</template-output>
        <template-output>contribucion_importantes</template-output>
        <template-output>contribucion_menores</template-output>
        <template-output>porcentaje_gaps_criticos</template-output>
        <template-output>porcentaje_gaps_importantes</template-output>
        <template-output>porcentaje_gaps_menores</template-output>

    </step>

    <step n="0.7" goal="Generar reporte de validación">

        <action>Compilar toda la información analizada y generada y tomala para generar un reporte estructurado</action>
        <critical>🚨 La información debe ser detallada, NO realices resumenes ejecutivos</critical>
        <action>Generar el reporte final de validación</action>      
        <action>Incluir métricas de completitud y recomendaciones priorizadas</action>
        <action>Incluir la tabla de cálculo detallado de completitud generada en el paso 0.6</action>
        <critical>🚨 Garantiza que en el archivo generado no queden variables sin reemplazar con la información correspondiente, revisa de forma detallada este punto, NO deben quedar variables sin reemplazar en el docuemnto generado</critical>

    </step>

    <step n="0.8" goal="Recomendaciones finales y próximos pasos">
        <output>
            **🎯 Validación PRD Completada**

            **Archivo generado:** {output_folder}/propuesta/04-arquitectura/reporte-validacion-completitud-prd.md

            **Resumen Ejecutivo:**
            - **Nivel de completitud:** {{readiness_score}}% (calculado objetivamente)
            - **Gaps críticos:** {{critical_gaps_count}} de 20 criterios
            - **Gaps importantes:** {{important_gaps_count}} de 20 criterios
            - **Gaps menores:** {{minor_gaps_count}} de 16 criterios
            - **Estado general:** {{overall_status}}

            **Metodología de cálculo:**
            - Evaluación objetiva de 56 subcriterios distribuidos en 3 categorías
            - Ponderación: Críticos (3.0) + Importantes (2.0) + Menores (1.0)
            - Fórmula matemática transparente documentada en el reporte

            **Próximos pasos recomendados:**
            1. {{priority_action_1}}
            2. {{priority_action_2}}
            3. {{priority_action_3}}
        </output>
        
        <ask>
            ¿Te gustaría:
            1. Ver el reporte completo de validación        
            2. Proceder con la arquitectura (si aplicable)
            3. Salir
        </ask>

        <check if="user_choice == 1">
            <action>Mostrar reporte completo de validación incluyendo tabla de cálculo detallado</action>
        </check>
        <check if="user_choice == 2">
            <check if="readiness_score < 70 OR critical_gaps_count > 2">
            <critical>🚨 Esta validación es obligatoria</critical>
            <action>Detener el flujo de trabajo y mostrar mensaje indicando que no es posible continuar debido a que se considera que la información generada por parte del equipo comercial no es lo suficientemente completa para generar la definición de arquitectura (Nivel de completitud: {{readiness_score}}%, Gaps críticos: {{critical_gaps_count}})</action>
            </check>            
        </check>      

    </step>  

</workflow>
````