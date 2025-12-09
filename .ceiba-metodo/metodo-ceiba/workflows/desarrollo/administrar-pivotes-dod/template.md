# Pivotes de Estimación y Definition of Done

> **Propósito:** Define tareas del DoD y pivotes técnicos para estimación precisa.
>
> **DoD:** Se usa en **refinamiento** para agregar tareas manuales obligatorias.
>
> **Pivotes:** Se usa en **estimación** para tiempos base de tareas técnicas.
>
> **Opcional:** Ambas tablas son opcionales. Si no existen, workflows usan comportamiento default.

---

## 📋 Definition of Done (Tareas Manuales Obligatorias)

**Uso en Refinamiento:** Si esta tabla existe, el workflow agrega SOLO estas tareas manuales (no inventa otras).

| Tarea | Complejidad BAJA | Complejidad MEDIA | Complejidad ALTA | Notas |
|-------|------------------|-------------------|------------------|-------|
{{#each tareas_dod}}
| {{nombre}} | {{tiempo_baja}}h ({{minutos_baja}}min) | {{tiempo_media}}h ({{minutos_media}}min) | {{tiempo_alta}}h ({{minutos_alta}}min) | {{notas}} |
{{/each}}

---

## 🔧 Pivotes Técnicos (Tareas de Desarrollo Recurrentes)

**Uso en Estimación:** Si una tarea refinada coincide con un pivote, usa este tiempo directamente como tiempo final.

**Tiempos:** Son tiempos **Senior con Método Ceiba YA APLICADO** - el workflow solo aplicará multiplicadores por seniority (Jr, Semi Sr).

**Importante:** Estos tiempos representan el valor REAL de desarrollo con IA. NO se aplica descuento adicional.

| Tarea | Senior BAJA | Senior MEDIA | Senior ALTA | Notas |
|-------|-------------|--------------|-------------|-------|
{{#each pivotes_tecnicos}}
| {{nombre}} | {{tiempo_baja}}h | {{tiempo_media}}h | {{tiempo_alta}}h | {{notas}} |
{{/each}}

---

## 🎯 Cómo Funciona

### Clasificación de Complejidad

- **BAJA:** Cambio menor, alcance limitado, pocos componentes afectados
- **MEDIA:** Cambio normal del día a día, complejidad estándar
- **ALTA:** Cambio crítico, arquitectónico, o que afecta múltiples componentes

### Flujo de Uso

**En Refinamiento:**
1. Workflow busca tabla DoD
2. Si existe → Agrega tareas manuales de la tabla
3. Si NO existe → Agrega tareas default (pipeline, PR, deploy, etc.)

**En Estimación:**
1. Para tareas manuales → Busca en DoD para tiempo
2. Para tareas técnicas → Busca en Pivotes para tiempo final (con MC)
3. Si no encuentra → Usa PERT normalmente

---

## ✏️ Personalización

**Para modificar tablas:**

1. Ejecuta el workflow `*administrar-pivotes-dod`
2. Selecciona qué tabla quieres editar (DoD o Pivotes)
3. O edita este archivo directamente

---

*Última actualización: {date}*
