# Checklist - Administrar Pivotes DoD

## 🚦 Pre-Ejecución

### Archivo de Pivotes

- [ ] Path a archivo de pivotes configurado en config.yaml
- [ ] Variable dod_pivots_location apunta a ubicación correcta

---

## ✅ Operaciones Completadas

### Si se CREÓ tabla nueva

- [ ] Archivo creado en path correcto
- [ ] Estructura markdown válida (encabezados, 2 tablas)
- [ ] Tabla DoD con 3 tareas ejemplo (Code Quality, Deployment, Testing Manual)
- [ ] Tabla Pivotes Técnicos inicialmente vacía
- [ ] Cada tarea tiene 3 tiempos (BAJA, MEDIA, ALTA)
- [ ] Formato DoD: Xh (Xmin)
- [ ] Formato Pivotes: Xh (tiempo con MC incluido)
- [ ] Sección de instrucciones incluida

### Si se AGREGÓ tarea

- [ ] Nombre descriptivo de la tarea
- [ ] Tiempos definidos para 3 complejidades
- [ ] Notas explicativas incluidas
- [ ] Fila insertada en tabla correctamente
- [ ] Archivo guardado sin corrupción

### Si se EDITÓ tarea

- [ ] Tarea correcta identificada
- [ ] Valores actualizados según input del usuario
- [ ] Formato consistente mantenido
- [ ] Archivo guardado sin corrupción

### Si se ELIMINÓ tarea

- [ ] Confirmación del usuario obtenida
- [ ] Fila removida de la tabla
- [ ] Estructura de tabla intacta
- [ ] Archivo guardado sin corrupción

### Si se CALIBRÓ con datos reales

- [ ] Datos reales capturados correctamente
- [ ] Delta calculado y mostrado al usuario
- [ ] Usuario confirmó actualización
- [ ] Pivote actualizado con nuevo valor
- [ ] Archivo guardado

---

## 📋 Validación de Integridad

### Estructura del Archivo

- [ ] Encabezado principal presente
- [ ] Sección de instrucciones/propósito presente
- [ ] Tabla markdown bien formada
- [ ] Separadores de columna (|) correctos
- [ ] Línea de alineación presente

### Contenido de Tabla

- [ ] Tabla DoD: 5 columnas (Tarea, BAJA, MEDIA, ALTA, Notas)
- [ ] Tabla Pivotes: 5 columnas (Tarea, Senior BAJA, Senior MEDIA, Senior ALTA, Notas)
- [ ] DoD - Formato: Xh (Xmin)
- [ ] Pivotes - Formato: Xh (tiempos YA con Método Ceiba)
- [ ] Separadores de columna (|) correctos
- [ ] Línea de alineación presente

### Validación de Tiempos

- [ ] Tiempos en formato numérico válido
- [ ] BAJA < MEDIA < ALTA (para cada tarea)
- [ ] Conversión minutos ↔ horas correcta
- [ ] No hay valores negativos o cero

---

## 🎯 Criterios de Bloqueo

**NO PERMITIR GUARDAR SI:**

🚫 Formato de tabla markdown está roto (tabla no parseable)
🚫 Alguna tarea tiene tiempos faltantes
🚫 Tiempos no cumplen BAJA < MEDIA < ALTA
🚫 Formato de tiempo inválido (no es Xh (Xmin))

---

## ✅ Post-Ejecución

### Verificación Final

- [ ] Archivo existe en path correcto
- [ ] Archivo es legible (no corrupto)
- [ ] Workflow refinamiento-tecnico puede leer tabla DoD
- [ ] Workflow estimar-historia-usuario puede leer ambas tablas
- [ ] Al menos 1 tarea en DoD O 1 pivote técnico

### Documentación

- [ ] Usuario informado de operación completada
- [ ] Usuario sabe cómo se usan DoD (en refinamiento) y Pivotes (en estimación)
- [ ] Usuario sabe que Pivotes Técnicos YA tienen Método Ceiba aplicado

---

*Última actualización: 2025-11-14*
