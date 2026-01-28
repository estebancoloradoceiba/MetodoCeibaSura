# Checklist - Refinamiento Técnico

## 🔍 Uso de DoD

- [ ] **DoD verificado**: Si existe `{dod_pivots_location}`, las tareas manuales de Fase N provienen EXCLUSIVAMENTE de la tabla DoD
- [ ] **Tareas manuales correctas**: Todas las tareas de Fase N están marcadas como MANUAL (no aplica Método Ceiba)

---

## ✅ Validación de Tareas Técnicas

- [ ] **Archivos existen**: Cada subtarea referencia archivos que EXISTEN en el código base o indica "crear nuevo"
- [ ] **Patrones verificados**: Patrones de código propuestos coinciden con patrones encontrados en el análisis del Step 3
- [ ] **Dependencias válidas**: Librerías/dependencias propuestas existen en el proyecto o se documentó su adición
- [ ] **Código alcanzable**: Las modificaciones propuestas son posibles dado el código actual analizado

---

## 🧪 Estrategia de Testing

- [ ] **Frameworks reales**: Frameworks de testing listados fueron encontrados en el proyecto (no asumidos)
- [ ] **Convenciones respetadas**: Ubicación y nombres de tests siguen convenciones descubiertas en Step 3.5.2
- [ ] **Test Data Builders**: Si se referencian builders, existen en el código o se indica crearlos
- [ ] **E2E solo si aplica**: Tests E2E propuestos SOLO si existen en el proyecto o arquitectura lo especifica

---

## 🏗️ Coherencia Arquitectónica

- [ ] **Análisis arquitectónico usado**: Si historia tiene sección "Análisis Arquitectónico (Arquitecto)", se consumieron sus decisiones
- [ ] **Hitos respetados**: Cada Fase (1+) corresponde a un Hito del arquitecto (si existe análisis)
- [ ] **Estándares aplicados**: Si existe archivo `{architecture_sharded_location}/{coding_standards_file}`, se incorporaron sus reglas

---

## Seguridad y Eficiencia

- [ ] **Seguridad considerada**: Tareas con endpoints/datos sensibles incluyen validación de ownership (BOLA)
- [ ] **Eficiencia considerada**: Se evitan N+1, llamadas redundantes, recursos sin liberar en el diseño- [ ] **Tolerancia a fallos**: Integraciones externas especifican timeouts, reintentos o circuit breaker
- [ ] **Validación de entrada**: Endpoints con input de usuario incluyen sanitización

---

## 📋 Completitud del Refinamiento

- [ ] **ACs cubiertos**: Cada criterio de aceptación tiene al menos una tarea asociada
- [ ] **Todas las fases definidas**: Fase 0 (si aplica) + Fases de implementación + Fase N (QA/Deployment)
- [ ] **Subtareas con archivos**: TODA subtarea incluye archivo específico (formato: "Acción + Archivo")
- [ ] **Complejidad justificada**: Nivel de complejidad (BAJA/MEDIA/ALTA) tiene justificación clara
- [ ] **Riesgos documentados**: Riesgos técnicos identificados durante análisis están en `known_risks`

---

## 🚦 Criterios de Fallo

**DETENER y corregir si:**

- [ ] Se proponen archivos que NO existen y NO se indica "crear nuevo"
- [ ] Se usan frameworks de testing NO encontrados en el proyecto
- [ ] Tareas de Fase N difieren de tabla DoD cuando DoD existe
- [ ] Falta sección obligatoria del template (Consideraciones Generales, Estrategia Testing, Tareas)
