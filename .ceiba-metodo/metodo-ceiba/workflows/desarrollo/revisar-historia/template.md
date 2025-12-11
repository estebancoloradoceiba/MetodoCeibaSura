# Template: Revisión de Código (Peer Review)

<critical>Este template se APPENDA al archivo de historia existente, NO crea un archivo nuevo</critical>
<critical>Las variables se resuelven desde los resultados de los 5 sub-workflows</critical>

---

## Revisión de Código (Peer Review)

**Revisor:** {{user_name}}
**Fecha:** {{date}}
**Decisión:** {{outcome}}

### Resumen Ejecutivo

| Métrica | Valor |
|---------|-------|
| Hallazgos ALTA | {{stats_alta}} |
| Hallazgos MEDIA | {{stats_media}} |
| Hallazgos BAJA | {{stats_baja}} |
| ACs Cubiertos | {{ac_covered}}/{{ac_total}} |

### Hallazgos por Categoría

#### Seguridad
{{tabla_seguridad}}

#### Backend  
{{tabla_backend}}

#### Frontend
{{tabla_frontend}}

#### Testing
{{tabla_testing}}

### Acciones Requeridas

{{lista_action_items}}

### Próximos Pasos

{{next_steps}}
