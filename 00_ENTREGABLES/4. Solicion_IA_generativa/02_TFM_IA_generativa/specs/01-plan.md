# Plan 01 — Implementación del spec "Borrador de email ante incidencia de compras"

Deriva de `specs/01-borraodr-emails-compras.md`. Decisiones tomadas para
resolver los puntos que el spec dejaba abiertos:

- **RAG**: LangChain.
- **LLM de chat (runtime del asistente)**: `qwen3:8b` vía Ollama (ya instalado
  localmente).
- **Embeddings**: `bge-m3` vía Ollama (requiere `ollama pull bge-m3`).
- **Vector store**: Chroma (local).
- **Interfaz**: CLI primero; Streamlit como tarea opcional/stretch al final.
- **Generación de datos sintéticos** (`incidencias.csv` y corpus de emails):
  se hace con un LLM online (Claude / Gemini / OpenAI) usado manualmente vía
  chat, no con Ollama ni con una integración de API en el código. En este
  plan solo se diseña el prompt exacto a pegar en ese LLM; ejecutarlo y
  pegar el resultado en `data/` es un paso manual, y luego un validador en
  Python comprueba que el resultado cumple el esquema/dominio esperado. Esto
  no afecta al stack de runtime del asistente (que sigue siendo 100% local
  vía Ollama, sin coste de API) — es solo una herramienta de preparación de
  datos, un paso único y offline.

Estructura de archivos que este plan asume:

```
src/
  config.py
  historial.py
  generador.py
  prompts.py
  validador_borrador.py
  validacion_inputs.py
  cli.py
  streamlit_app.py          (stretch)
  datos/
    validar_incidencias.py
    validar_corpus.py
  rag/
    indexar.py
    recuperar.py
prompts_datos/
  prompt_generar_incidencias.md
  prompt_generar_corpus_emails.md
data/
  incidencias.csv            (generado manualmente vía LLM online + prompt de prompts_datos/)
  corpus_emails.jsonl         (idem)
  chroma/                     (persistido, en .gitignore)
tests/
  test_historial.py
  test_validar_incidencias.py
  test_validar_corpus.py
  test_prompts.py
  test_validador_borrador.py
  test_casos_validacion.py
requirements.txt
.gitignore
```

Metodología: una tarea a la vez, con revisión de código entre tareas, commits
pequeños (uno por tarea), tal como indica `CLAUDE.md`.

---

## Bloque 1 — Setup del proyecto

**1. Estructura de carpetas y `.gitignore`**
- Archivos: crea `src/`, `data/`, `tests/`, `prompts_datos/`, `.gitignore`
  (excluye `.venv/`, `data/chroma/`, `__pycache__/`).
- Verificación: `python3 --version` ≥ 3.11; `ls src data tests prompts_datos`
  muestra las carpetas; `git status` no lista `.venv` ni `data/chroma`.

**2. `requirements.txt`**
- Archivos: `requirements.txt` (langchain, langchain-community,
  langchain-ollama, chromadb, pandas, python-dateutil, pytest; streamlit
  como extra opcional al final).
- Verificación: `pip install -r requirements.txt` en un venv limpio termina
  sin errores; `pip freeze | grep -i langchain` muestra las versiones
  instaladas.

**3. Pull de `bge-m3` y smoke test de ambos modelos de runtime**
- Archivos: ninguno de producción (opcionalmente un script desechable
  `scripts/smoke_test_ollama.py`).
- Verificación: `ollama pull bge-m3`; `ollama list` incluye `bge-m3` y
  `qwen3:8b`; `OllamaEmbeddings(model="bge-m3")` devuelve un vector de
  dimensión fija (>0); `ChatOllama(model="qwen3:8b")` responde a "hola" con
  texto no vacío.
- Justificación: aísla problemas de infraestructura (modelo no descargado,
  Ollama no corriendo) de bugs de código en tareas posteriores.

**4. `src/config.py` con constantes del dominio**
- Archivo: `src/config.py` — `CATEGORIAS_INCIDENCIA` (8), `FRUTAS` (15:
  manzana, pera, plátano, naranja, limón, fresa, uva, melocotón, ciruela,
  sandía, melón, piña, kiwi, mango, aguacate), `GRAVEDAD_PESOS` (dict
  categoría→peso), `TONOS`, `OBJETIVOS`, rutas de `data/`, nombres de modelos.
- Verificación: `python -c "from src.config import CATEGORIAS_INCIDENCIA, FRUTAS, GRAVEDAD_PESOS; assert len(CATEGORIAS_INCIDENCIA)==8; assert len(FRUTAS)==15; assert set(GRAVEDAD_PESOS)==set(CATEGORIAS_INCIDENCIA)"`
  no lanza error.

---

## Bloque 2 — Datos sintéticos (generados con LLM online vía prompt)

**5. Diseñar el prompt para generar `incidencias.csv`**
- Archivo: `prompts_datos/prompt_generar_incidencias.md` — prompt completo,
  listo para pegar en un LLM online (Claude/Gemini/GPT), que especifica:
  columnas exactas (proveedor, lote, tiempo_compra, precio_compra, tipo,
  incidencia), las 15 frutas y las 8 categorías de incidencia de
  `src/config.py`, número de proveedores/filas deseado, formato de salida
  (CSV puro, sin explicaciones ni markdown), y las filas **sembradas
  obligatorias** para los casos de validación del spec (sección 4):
  proveedor "A" con ≥3 incidencias `cadena_frio` en los últimos 6 meses,
  proveedor "B" con exactamente 1 incidencia `documentacion_incorrecta` y
  ninguna otra, proveedor "C" libre (para el caso de mensaje libre).
- Verificación: revisión manual del prompt confirma que cubre las 6
  columnas, las 8 categorías, los 3 casos sembrados, y pide explícitamente
  un CSV parseable sin texto adicional.

**6. Generar `data/incidencias.csv` ejecutando el prompt**
- Archivo: `data/incidencias.csv` (salida pegada del LLM online).
- Verificación: procedimiento manual — pegar el prompt de la tarea 5 en
  Claude/Gemini/GPT, guardar la salida como CSV, y ejecutar el validador de
  la tarea 7 sobre el resultado hasta que pase sin problemas.

**7. Validador de `incidencias.csv`**
- Archivo: `src/datos/validar_incidencias.py` con función pura
  `validar_incidencias(df: pd.DataFrame) -> list[str]` (detecta columnas
  faltantes/extra, `tipo` fuera de `FRUTAS`, `incidencia` fuera de
  `CATEGORIAS_INCIDENCIA`, fechas o precios inválidos, y ausencia de las
  filas sembradas para los proveedores "A"/"B").
- Verificación: `pytest tests/test_validar_incidencias.py` con un DataFrame
  fabricado "malo" (fruta inventada, categoría inválida, falta el caso "A")
  detecta cada problema; ejecutar sobre `data/incidencias.csv` real imprime
  "0 problemas".

**8. Diseñar el prompt para generar el corpus de emails**
- Archivo: `prompts_datos/prompt_generar_corpus_emails.md` — prompt para el
  LLM online que pide 40-60 emails cubriendo las 8 categorías × 3 tonos
  (formal / firme-pero-cordial / conciliador), en español, con salida en
  JSONL (campos: tono, categoria, asunto, cuerpo), variedad de redacción
  entre emails de la misma combinación tono/categoría.
- Verificación: revisión manual del prompt confirma rango de cantidad,
  cobertura de las 8×3 combinaciones, formato JSONL y los 4 campos
  requeridos.

**9. Generar `data/corpus_emails.jsonl` ejecutando el prompt**
- Archivo: `data/corpus_emails.jsonl` (salida pegada del LLM online).
- Verificación: procedimiento manual — pegar el prompt de la tarea 8,
  guardar la salida como JSONL, y ejecutar el validador de la tarea 10 hasta
  que pase sin problemas.

**10. Validador de calidad básica del corpus**
- Archivo: `src/datos/validar_corpus.py` con función pura
  `validar_corpus(lista_emails) -> list[str]` (problemas encontrados:
  vacíos, longitud fuera de rango, categoría o tono no reconocidos, JSONL
  mal formado).
- Verificación: `pytest tests/test_validar_corpus.py` con un corpus
  fabricado "malo" (email vacío, categoría inventada) detecta los
  problemas; ejecutar sobre `data/corpus_emails.jsonl` real imprime
  "0 problemas".

---

## Bloque 3 — Análisis de historial por proveedor

**11. Función pura `calcular_historial_proveedor`**
- Archivo: `src/historial.py` —
  `calcular_historial_proveedor(df, proveedor, fecha_referencia) -> dict` con
  las 5 métricas (num_incidencias_total, num_incidencias_ultimos_6_meses,
  incidencia_mas_frecuente, tasa_reincidencia, gravedad_media).
- Verificación: `pytest tests/test_historial.py` con un DataFrame hecho a
  mano (no el sintético completo, para poder calcular el resultado esperado
  manualmente) y `fecha_referencia` fija; asserts numéricos exactos para
  cada una de las 5 métricas.

**12. Función `formatear_evaluacion_historico`**
- Archivo: `src/historial.py` — `formatear_evaluacion_historico(historial: dict) -> str`.
- Verificación: test unitario que, dado un dict de historial conocido,
  comprueba que el string contiene las cifras exactas del dict y **no
  contiene ningún número que no esté en el dict de entrada** (extracción de
  números por regex + comparación de conjuntos) — cubre directamente el
  requisito "no inventar cifras" del spec.

---

## Bloque 4 — Índice RAG (embeddings `bge-m3` + Chroma)

**13. Indexación del corpus en Chroma**
- Archivo: `src/rag/indexar.py` —
  `construir_indice(corpus_path, persist_dir) -> None`.
- Verificación: ejecutar el script; `data/chroma/` se crea con archivos;
  cargar el vectorstore y comprobar que el número de documentos indexados
  coincide con las líneas de `corpus_emails.jsonl`.

**14. Función de recuperación**
- Archivo: `src/rag/recuperar.py` —
  `buscar_emails_similares(query: str, k: int) -> list[Document]`.
- Verificación: query manual "incidencia de cadena de frío reincidente",
  `k=3`; comprobar que la mayoría de resultados tienen metadata
  `categoria == "cadena_frio"`.

---

## Bloque 5 — Generación del borrador

**15. Plantilla de prompt**
- Archivo: `src/prompts.py` — plantilla que combina incidencia actual,
  evaluación de historial, ejemplos RAG recuperados, tono, objetivo,
  mensaje_libre.
- Verificación: test unitario que rellena la plantilla con datos ficticios
  (sin llamar al LLM) y comprueba que todos los placeholders quedan
  sustituidos, sin `KeyError` ni `{}` sin rellenar.

**16. Función `generar_borrador` (llamada real a `qwen3:8b`)**
- Archivo: `src/generador.py` —
  `generar_borrador(proveedor, incidencia_actual, historial, tono, objetivo, mensaje_libre) -> str`.
- Verificación: llamada manual con los datos del Caso A del spec; output no
  vacío, con una línea de asunto reconocible, cuerpo con saludo/cierre, y
  longitud aproximada 100-180 palabras (con tolerancia, dado que el LLM no
  es determinista).

**17. Validador anti-alucinación de cifras**
- Archivo: `src/validador_borrador.py` — `extraer_numeros(texto)` +
  `comprobar_numeros_permitidos(texto, numeros_permitidos) -> list[discrepancias]`.
- Verificación: test con borrador ficticio que incluye un número no presente
  en `numeros_permitidos` → se detecta; test con borrador limpio → sin
  discrepancias.
- Justificación: cubre explícitamente el requisito del spec de "mencionar
  SOLO datos que existan... no inventar cifras", que de otro modo solo se
  comprobaría "a ojo".

---

## Bloque 6 — CLI de demo

**18. CLI que une todo el pipeline**
- Archivo: `src/cli.py`.
- Verificación:
  `python -m src.cli --proveedor "A" --incidencia cadena_frio --tono firme-pero-cordial --objetivo "exigir compensación"`
  imprime un borrador completo por stdout sin trazas de error.

**19. Manejo de errores de entrada**
- Archivos: `src/cli.py` (modifica) + `src/validacion_inputs.py`.
- Verificación: `pytest` sobre las funciones de validación con proveedor
  inexistente / incidencia no reconocida / tono no válido; prueba manual de
  CLI con esos inputs muestra un mensaje de error legible y exit code ≠ 0
  (no traceback crudo).

---

## Bloque 7 — Validación contra los 3 casos de prueba del spec

**20. Test automatizado Caso A (reincidencia grave)**
- Archivo: `tests/test_casos_validacion.py::test_caso_a`.
- Verificación: ejecuta el pipeline completo sobre el proveedor "A" sembrado
  en la tarea 5-6 (cadena_frio, firme-pero-cordial, exigir compensación);
  assert por lista de patrones aceptables ("N-ésima vez", "de nuevo",
  "reiterada", "reincidencia") presentes en el borrador (se valida por
  keywords/regex, no por igualdad exacta, dado que el LLM no es
  determinista).

**21. Test automatizado Caso B (leve, primera vez)**
- Mismo archivo, `test_caso_b`.
- Verificación: proveedor "B" sembrado, documentacion_incorrecta,
  conciliador, avisar; assert de **ausencia** de lista negra de términos
  ("penalización", "sanción", "rescindir", "última advertencia", "exigimos").

**22. Test automatizado Caso C (mensaje libre integrado)**
- Mismo archivo, `test_caso_c`.
- Verificación: `mensaje_libre="recordarles el plazo de 48h para responder"`;
  assert que el borrador contiene "48h" o "48 horas" y algún término
  relacionado con "responder"/"plazo".

**23. Checklist de revisión manual complementaria**
- No es código; es un procedimiento de validación humana rápida sobre los 3
  borradores generados (los asserts automáticos no cubren calidad de
  redacción/tono real).
- Verificación: el usuario revisa los 3 outputs y marca aprobado/no
  aprobado; no bloquea el resto del plan pero cierra formalmente la
  sección 4 del spec.

---

## Bloque 8 — Streamlit (opcional/stretch)

**24. App Streamlit mínima**
- Archivo: `src/streamlit_app.py` (reutiliza `src/generador.py`,
  `src/historial.py`, `src/rag/recuperar.py` — sin duplicar lógica).
- Verificación: `streamlit run src/streamlit_app.py`; abrir la URL local,
  rellenar el formulario con los mismos inputs que la CLI, confirmar que se
  muestra el borrador en pantalla sin errores en consola.

---

## Notas de secuenciación

- Tareas 1-4 son bloqueantes para todo lo demás.
- Tareas 5-7 (incidencias.csv) deben completarse antes de la 11 (historial)
  y antes de las 20-22 (necesitan los proveedores sembrados).
- Tareas 8-10 (corpus de emails) deben completarse antes de las 13-14 (RAG
  necesita el corpus).
- Tareas 11-12 y 13-14 son independientes entre sí y pueden hacerse en
  paralelo, pero ambas son prerequisito de las 15-16.
- Tareas 18-19 (CLI) requieren 11, 14 y 16 terminadas.
- Tareas 20-23 requieren la 18 funcionando end-to-end.
- Tarea 24 es la única opcional y va al final.
