# Checklist de Validación - Revisión de Código (Meta-Workflow v4.0)

<critical>Validar TODOS los items antes de marcar el workflow como completado</critical>

## 1. Pre-Validación

### 1.1 Preparación
- [ ] Historia localizada y leída
- [ ] Estado válido para revisión (Lista para Revisión / Desarrollo Completado / En Revisión)
- [ ] staged_files detectados (mínimo 1 archivo)
- [ ] Variables establecidas: story_path, story_number, staged_files

---

## 2. Ejecución de Sub-Workflows (5 consolidados)

### 2.1 Contexto Técnico
- [ ] **1-contexto-tecnico** ejecutado
  - [ ] Architecture docs cargados (si existen)
  - [ ] Tech stack detectado
  - [ ] Coding standards identificados

### 2.2 Validación de Implementación (consolida criterios + coherencia)
- [ ] **2-validacion-implementacion** ejecutado
  - [ ] ACs parseados y verificados
  - [ ] Coherencia general validada
  - [ ] Issues cross-file detectados

### 2.3 Análisis de Código (consolida seguridad + backend + frontend)
- [ ] **3-analisis-codigo** ejecutado
  - [ ] OWASP Top 10 + BOLA validados
  - [ ] Arquitectura backend validada
  - [ ] Arquitectura frontend validada

### 2.4 Validación de Testing (consolida unit + integration)
- [ ] **4-validacion-testing** ejecutado
  - [ ] Pruebas unitarias: AAA, mocks, assertions
  - [ ] Pruebas integración: NO mocks, path completo

### 2.5 Decisión Final
- [ ] **5-decision-outcome** ejecutado
  - [ ] Decisión recibida (Aprobado | Aprobado con Observaciones | Cambios Solicitados | Bloqueado)

---

## 3. Consolidación de Hallazgos

### 3.1 Agregación
- [ ] Todos los hallazgos recopilados en memoria
- [ ] Hallazgos normalizados (source, severity, file, line, issue, solution)

### 3.2 Deduplicación
- [ ] Fingerprint generado: hash(file + line + issue)
- [ ] Duplicados eliminados
- [ ] Severidad más alta preservada

### 3.3 Estadísticas
- [ ] Conteo por severidad (ALTA, MEDIA, BAJA)
- [ ] Conteo por source (diagnóstico)
- [ ] Top 5 archivos con más hallazgos

---

## 4. Persistencia del Reporte

- [ ] Template renderizado completamente
- [ ] Reporte agregado al final de la historia
- [ ] Status actualizado según decisión
- [ ] Change Log actualizado
- [ ] Persistencia verificada (sección "## Revisión de Código" existe)

---

## 5. Resultado Final

- [ ] Mensaje de completitud mostrado al usuario
- [ ] Estadísticas incluidas
- [ ] Próximos pasos claros según resultado

---

## Criterios de Calidad

### ✅ Revisión Exitosa
- 5 sub-workflows ejecutados
- Hallazgos agregados y deduplicados
- Todos los ACs verificados
- Template completo renderizado
- Reporte persistido en historia

### ⚠️ Revisión con Warnings
- Algunos diagnósticos "No aplican"
- Hallazgos sin ubicación específica (file/line)

### ❌ Revisión Fallida
- Sub-workflows faltantes
- Agregación fallida
- Reporte no persistido
