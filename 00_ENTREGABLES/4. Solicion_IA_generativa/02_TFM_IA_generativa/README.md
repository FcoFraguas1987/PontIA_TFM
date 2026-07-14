# Asistente de borradores de email para incidencias de compras

Prueba de concepto (PoC) del proyecto Jupiter del Máster DADS. Se crea un asistente de IA genertativa que pretende ayudar a un departamento de **COMPRAS** a redactar borradores de email de respuesta ante incidencias con proveedores de fruta (retrasos, calidad, cantidad, cadena de frío, etc.), apoyándose en el historial del proveedor y en un corpus de emails previos recuperado por RAG.

El borrador generado es siempre para **revisión humana**; no hay envío
automático de correos.

## Alcance

Esta es una PoC funcional en local, demostrable con datos sintéticos. No
incluye: módulo de ventas, fine-tuning, interfaz de producción multiusuario,
autenticación ni integración con Outlook/Gmail real. El detalle completo del alcance y los casos de prueba está en [`specs/01-borraodr-emails-compras.md`](specs/01-borraodr-emails-compras.md).

## Arquitectura

El diseño de la arquitectura, el pipeline RAG y la implementación del código (módulos de `src/`, tests, CLI, notebook, integración con Chroma/LangChain) se han desarrollado con asistencia de IA (Claude Code), siguiendo una metodología de desarrollo dirigida por especificaciones: cada pieza parte de un spec (`specs/01-borraodr-emails-compras.md`), un plan de tareas numeradas y testeables (`specs/01-plan.md`) y una validación explícita contra los casos de prueba del spec.

**La elección del modelo LLM y de embeddings, y el diseño/ajuste de los
prompts, son decisiones y trabajo del autor**, evaluados de forma manual
sobre los borradores generados (no una elección por defecto de la
herramienta de IA):

- El modelo de chat (`qwen3:8b`) y el de embeddings (`bge-m3`) se eligieron
  tras evaluar qué había disponible localmente vía Ollama y qué balance de calidad/tamaño convenía para esta PoC. Además se planetaron modelos locales que garanticen la privacidad del dato del cliente.
- La plantilla de prompt de generación (`src/prompts.py`) y los prompts de generación de datos sintéticos (`prompts_datos/`) han sido escritos y retocados a mano, revisando los borradores resultantes e iterando sobre el texto del prompt hasta obtener el tono y la fidelidad a los datos deseados.

## Stack

- Python 3.11+ (probado con 3.12)
- LLM local vía **Ollama**: `qwen3:8b`
- Embeddings locales vía Ollama: `bge-m3`
- RAG: **LangChain** + **Chroma** (vector store local)
- Datos estructurados: `pandas` sobre CSV
- Interfaces de demo: CLI, notebook Jupyter y Streamlit

## Estructura del proyecto

```
src/
  config.py              constantes de dominio (categorias, frutas, modelos...)
  historial.py            metricas de historial por proveedor
  prompts.py               plantilla de prompt del borrador (editable)
  generador.py             ensambla el prompt y llama al LLM
  validador_borrador.py    verificacion anti-alucinacion de cifras
  validacion_inputs.py     validacion de inputs de la CLI/Streamlit
  cli.py                   interfaz de linea de comandos
  streamlit_app.py         interfaz web (Streamlit)
  datos/
    validar_incidencias.py validador del CSV de incidencias
    validar_corpus.py       validador del corpus de emails
  rag/
    indexar.py              construye el indice Chroma sobre el corpus
    recuperar.py             busqueda por similitud sobre el indice

prompts_datos/             prompts para generar los datos sinteticos con un LLM online
notebooks/                 demo interactiva en Jupyter
data/                      incidencias.csv, corpus_emails.jsonl, indice Chroma
specs/                     spec, plan de tareas y checklist de validacion
tests/                     tests unitarios (pytest)
```

## Instalación

Requisitos: Python 3.11+ y [Ollama](https://ollama.com) instalado.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

ollama pull qwen3:8b
ollama pull bge-m3
```

## Datos

Los datos de esta PoC son sintéticos. `data/incidencias.csv` y
`data/corpus_emails.jsonl` se generaron pegando los prompts de
`prompts_datos/` en un LLM online (Claude/Gemini/GPT) y guardando la
salida tal cual — no hay script de generación en el repo, solo el prompt y un validador (`src/datos/validar_incidencias.py`, `src/datos/validar_corpus.py`) que comprueba que el resultado cumple el esquema esperado.

Para reconstruir el índice RAG sobre el corpus:

```bash
python -m src.rag.indexar
```

## Uso (Ejemplo)

### CLI

```bash
python -m src.cli \
  --proveedor "A" \
  --incidencia cadena_frio \
  --tono firme-pero-cordial \
  --objetivo "exigir compensacion" \
  --mensaje-libre "recordarles el plazo de 48h para responder"
```

### Streamlit

```bash
streamlit run src/streamlit_app.py
```

### Notebook

```bash
jupyter lab notebooks/demo_borrador copia.ipynb
```

El notebook permite ver la tabla de incidencias, elegir un lote y escribir un comentario libre, revisar la evaluación del historial, inspeccionar (y editar) el prompt, y ver el borrador generado — pensado para iterar a mano sobre el prompt sin tocar `src/`.

## Tests

```bash
pytest
```

Los tests de `tests/test_casos_validacion.py` llaman al LLM real y tardan
varios minutos; el resto son rápidos y no requieren Ollama.

## Especificaciones

- [`specs/01-borraodr-emails-compras.md`](specs/01-borraodr-emails-compras.md) — spec funcional
- [`specs/01-plan.md`](specs/01-plan.md) — plan de tareas de implementación
- [`specs/checklist_revision_manual.md`](specs/checklist_revision_manual.md) — revisión manual de los casos de prueba
