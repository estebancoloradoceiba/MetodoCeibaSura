# Template: Revisión de Código (Peer Review)

<critical>Este template se APPENDA al archivo de historia existente, NO crea un archivo nuevo</critical>
<critical>Solo incluir secciones de tipos de revisión que tengan hallazgos</critical>

---

## Revisión de Código (Peer Review)

**Revisor:** {{user_name}}  
**Fecha:** {{date}}  
**Decisión:** {{outcome}}

### Resumen

| Severidad | Cantidad |
|-----------|----------|
| 🔴 ALTA   | {{alta_count}} |
| 🟡 MEDIA  | {{media_count}} |
| 🟢 BAJA   | {{baja_count}} |

### Hallazgos por Tipo de Revisión

<!-- 
INSTRUCCIONES: Crear sección por cada tipo con hallazgos. Estado inicial: PENDIENTE.
Estados válidos: PENDIENTE | CORREGIDO | NO_APLICA

| Archivo | Línea | Severidad | Estado | Problema | Sugerencia |
|---------|-------|-----------|--------|----------|------------|
-->

#### BACKEND
| Archivo | Línea | Severidad | Estado | Problema | Sugerencia |
|---------|-------|-----------|--------|----------|------------|
| src/service/UserService.java | 85 | MEDIA | PENDIENTE | Falta manejo de excepción en llamada externa | Agregar try-catch con logging |

#### SEGURIDAD
| Archivo | Línea | Severidad | Estado | Problema | Sugerencia |
|---------|-------|-----------|--------|----------|------------|
| src/controller/OrderController.java | 23 | ALTA | PENDIENTE | BOLA: No valida ownership del recurso | Verificar que order.userId == currentUser.id |

<!-- 
Tipos disponibles: BACKEND, SEGURIDAD, PENTESTING, FRONTEND, 
TESTS_INTEGRACION, TESTS_UNITARIOS, CICD, FINOPS_GREENOPS, PROBLEMAS_CRITICOS
-->
