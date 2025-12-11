# Decision Outcome - Instrucciones del Sub-Workflow

```xml
<critical>The workflow execution engine is governed by: {project-root}/.ceiba-metodo/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>Communicate all responses in {communication_language}</critical>
<critical>Este es un SUB-WORKFLOW invocado por revisar-historia - NO standalone</critical>
<critical>Output: Escribe decisión directamente al story file (NO JSON)</critical>
<critical>Este workflow es AUTOMÁTICO - determina la decisión basada en REGLAS, NO solicita input del usuario</critical>

<workflow>

  <step n="1" goal="Evaluar hallazgos y determinar outcome automáticamente">
    <mandate>La decisión se calcula automáticamente basada en las siguientes REGLAS:</mandate>
    
    <action>Extraer conteos de {{statistics}}:</action>
    <action>- alta_count = {{statistics.by_severity.ALTA}}</action>
    <action>- media_count = {{statistics.by_severity.MEDIA}}</action>
    <action>- baja_count = {{statistics.by_severity.BAJA}}</action>
    <action>- ac_covered = número de ACs con estado "cubierto"</action>
    <action>- ac_total = total de ACs en la historia</action>
    <action>- ac_partial = número de ACs con estado "parcial"</action>
    <action>- ac_missing = número de ACs sin cubrir</action>
    
    <mandate>REGLAS DE DECISIÓN (evaluar en orden):</mandate>
    
    <rule id="bloqueado-1" priority="1">
      SI alta_count > 3 ENTONCES outcome = "Bloqueado"
      Justificación: "Historia bloqueada por exceso de hallazgos críticos ({{alta_count}} > 3)"
    </rule>
    
    <rule id="bloqueado-2" priority="2">
      SI ac_missing > 0 ENTONCES outcome = "Bloqueado"
      Justificación: "Historia bloqueada por Criterios de Aceptación sin implementar ({{ac_missing}} faltantes)"
    </rule>
    
    <rule id="bloqueado-3" priority="3">
      SI existe hallazgo con categoria_owasp IN ["A01:2023 BOLA", "A03:2021 Injection", "A07 Auth"] Y severity = "ALTA"
      ENTONCES outcome = "Bloqueado"
      Justificación: "Historia bloqueada por vulnerabilidad de seguridad crítica ({{categoria_owasp}})"
    </rule>
    
    <rule id="cambios-1" priority="4">
      SI alta_count >= 1 AND alta_count <= 3 ENTONCES outcome = "Cambios Solicitados"
      Justificación: "Se requieren correcciones para {{alta_count}} hallazgos de alta severidad"
    </rule>
    
    <rule id="cambios-2" priority="5">
      SI ac_partial > 0 ENTONCES outcome = "Cambios Solicitados"
      Justificación: "Se requieren correcciones para completar {{ac_partial}} Criterios de Aceptación parciales"
    </rule>
    
    <rule id="cambios-3" priority="6">
      SI media_count > 5 ENTONCES outcome = "Cambios Solicitados"
      Justificación: "Se requieren correcciones por acumulación de hallazgos medios ({{media_count}} > 5)"
    </rule>
    
    <rule id="aprobado-condiciones" priority="7">
      SI alta_count = 0 AND ac_missing = 0 AND ac_partial = 0 AND media_count <= 5
      ENTONCES outcome = "Aprobado"
      Justificación: "Historia aprobada - todos los ACs cubiertos, sin hallazgos críticos"
    </rule>
    
    <rule id="aprobado-con-observaciones" priority="8">
      SI alta_count = 0 AND ac_missing = 0 AND (ac_partial > 0 OR media_count > 0)
      ENTONCES outcome = "Aprobado con Observaciones"
      Justificación: "Historia aprobada con observaciones menores a considerar en futuras iteraciones"
    </rule>
    
    <action>Aplicar reglas en orden de prioridad hasta encontrar match</action>
    <action>Almacenar outcome y justification calculados</action>
  </step>

  <step n="2" goal="Generar action items basados en la decisión">
    <action>Construir lista de action items basándose en hallazgos y decisión:</action>
    
    <check if="outcome == 'Aprobado' OR outcome == 'Aprobado con Observaciones'">
      <action>Incluir hallazgos MEDIA y BAJA como action items opcionales</action>
      <action>Marcar como prioridad: "Baja - Mejora continua"</action>
    </check>
    
    <check if="outcome == 'Cambios Solicitados'">
      <action>Incluir TODOS los hallazgos ALTA como action items OBLIGATORIOS</action>
      <action>Incluir hallazgos MEDIA relacionados con ALTA</action>
      <action>Marcar ALTA como: "Crítica - Bloquea merge"</action>
      <action>Marcar MEDIA como: "Alta - Recomendado corregir"</action>
    </check>
    
    <check if="outcome == 'Bloqueado'">
      <action>Incluir TODOS los hallazgos ALTA y MEDIA</action>
      <action>Priorizar: seguridad > arquitectura > ACs faltantes > otros</action>
      <action>Marcar todos como: "Crítica - Historia bloqueada"</action>
    </check>
    
    <action>Para cada action item:</action>
    <action>- Generar descripción clara y accionable</action>
    <action>- Incluir referencia específica (archivo:línea)</action>
    <action>- Incluir severity del finding original</action>
    <action>- Incluir estimación de esfuerzo (S/M/L)</action>
    
    <action>Almacenar en {{action_items}} array</action>
  </step>

  <step n="3" goal="Generar next_steps según outcome">
    <check if="outcome == 'Aprobado' OR outcome == 'Aprobado con Observaciones'">
      <action>{{next_steps}} = "1. ✅ Historia lista para merge a rama principal\n2. Si hay action items opcionales, considerar implementarlos en futuras mejoras\n3. Actualizar tablero de proyecto"</action>
    </check>
    
    <check if="outcome == 'Cambios Solicitados'">
      <action>{{next_steps}} = "1. 🔧 Ejecutar `*desarrollar-historia-usuario` para implementar los {{action_items.length}} action items\n2. Los hallazgos ALTA son OBLIGATORIOS antes de merge\n3. Una vez completados, re-ejecutar `*revisar-historia`\n4. Priorizar por severidad: ALTA > MEDIA"</action>
    </check>
    
    <check if="outcome == 'Bloqueado'">
      <action>{{next_steps}} = "1. ⚠️ ATENCIÓN INMEDIATA: {{statistics.by_severity.ALTA}} issues críticos\n2. Ejecutar `*desarrollar-historia-usuario` para resolver bloqueos\n3. Consultar con arquitecto si hay violaciones arquitectónicas\n4. Resolver TODOS los issues ALTA antes de continuar\n5. Una vez resueltos, re-ejecutar `*revisar-historia`"</action>
    </check>
  </step>

  <step n="4" goal="Retornar resultado al workflow padre">
    <critical>NO escribir archivos - solo retornar datos al padre para persistencia</critical>
    
    <action>Preparar objeto de resultado para el padre:</action>
    <result-object>
      outcome: "{{outcome}}"
      justification: "{{justification}}"
      reviewer_name: "{{user_name}}"
      review_date: "{{current_date}}"
      action_items: [{{action_items}}]
      statistics: {
        total: {{total_findings}},
        alta: {{alta_count}},
        media: {{media_count}},
        baja: {{baja_count}},
        ac_total: {{ac_total}},
        ac_covered: {{ac_covered}},
        ac_partial: {{ac_partial}},
        ac_missing: {{ac_missing}}
      }
      next_steps: "{{next_steps}}"
    </result-object>
    
    <output>
══════════════════════════════════════════════════════════════════════════════
🎯 DECISIÓN AUTOMÁTICA DE REVISIÓN
══════════════════════════════════════════════════════════════════════════════

📊 **Resultado:** {{outcome}}

📝 **Justificación:**
{{justification}}

📋 **Contexto de Decisión:**
- Hallazgos ALTA: {{alta_count}}
- Hallazgos MEDIA: {{media_count}}
- ACs Cubiertos: {{ac_covered}}/{{ac_total}}
- ACs Parciales: {{ac_partial}}
- ACs Faltantes: {{ac_missing}}

✅ **Action Items:** {{action_items.length}} generados

👉 **Próximos Pasos:**
{{next_steps}}

══════════════════════════════════════════════════════════════════════════════
    </output>
  </step>

</workflow>
```
