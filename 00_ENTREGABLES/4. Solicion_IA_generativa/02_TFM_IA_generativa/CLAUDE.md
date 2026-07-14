# Proyecto: Asistente de borradores de email para incidencias de compras (TFM)

## Objetivo
Asistente de IA generativa que ayuda al departamento de COMPRAS a redactar
borradores de email de respuesta ante incidencias con proveedores de fruta.
Es una prueba de concepto (PoC) para un TFM de un máster de ciencia y análisis
de datos. Fase futura (fuera de alcance ahora): extender a ventas.

## Alcance de esta fase (NO construir todavía)
- ❌ Módulo de ventas
- ❌ Fine-tuning de modelos
- ❌ Interfaz de producción / despliegue multiusuario
- ❌ Autenticación, roles, integración con correo real (Outlook/Gmail API)
- ✅ Sí: PoC funcional en local, demostrable, con datos sintéticos/csv de ejemplo

## Stack
- Python 3.11+
- Modelo LLM local vía **Ollama** (ej. `llama3.1:8b`, `qwen2.5:7b-instruct`) — sin coste de API
- Embeddings locales: `bge-m3` o `nomic-embed-text` (multilingüe, vía Ollama)
- RAG: `langchain` o `llama-index` (a decidir en spec de implementación)
- Vector store: `Chroma` (local, sin infraestructura)
- Datos estructurados: `pandas` sobre CSV (SQLite si el volumen lo justifica)
- Interfaz de demo: CLI simple primero; `Streamlit` si da tiempo

## Convenciones
- Todo el código en `src/`, specs en `specs/`, datos en `data/` (nunca subir datos reales/sensibles)
- Cada módulo funcional = una función pura testeable, sin efectos secundarios ocultos
- Nombrar los specs `NN-nombre-descriptivo.md` en orden de implementación
- Español para nombres de negocio (proveedor, incidencia, gravedad); inglés para nombres técnicos genéricos (config, utils)
- Commits pequeños, uno por tarea del plan

## Metodología de trabajo (Spec-Driven Development)
1. Specify → `specs/NN-*.md` (qué, no cómo)
2. Plan → lista de tareas numeradas derivada del spec, revisada por el usuario
3. Implement → una tarea a la vez, con revisión de código entre tareas
4. Validate → contra los casos de prueba definidos en el spec, no "a ojo"

No generar código sin un spec aprobado por el usuario primero.
