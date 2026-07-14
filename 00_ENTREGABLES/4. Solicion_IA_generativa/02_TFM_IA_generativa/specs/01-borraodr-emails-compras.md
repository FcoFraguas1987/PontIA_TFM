# Spec 01 — Borrador de email ante incidencia de compras

## 1. Problema
El equipo de compras recibe incidencias de proveedores de fruta (retrasos,
calidad, cantidad, etc.) y dedica tiempo a redactar cada email de respuesta
desde cero, con tono y rigor desiguales, sin apoyarse sistemáticamente en el
historial del proveedor.

## 2. Datos de entrada

### 2.1 Tabla de incidencias (`data/incidencias.csv`)
Columnas:
| campo | tipo | notas |
|---|---|---|
| proveedor | string | identificador del proveedor |
| lote | string | identificador de lote |
| tiempo_compra | fecha | fecha de la compra |
| precio_compra | float | precio pactado |
| tipo | categórico (15 valores) | tipo de fruta |
| incidencia | categórico | ver tabla 2.2 |

### 2.2 Categorías de `incidencia` (propuesta — AJUSTAR según tu CSV real)
1. `retraso_entrega`
2. `calidad_producto` (madurez/estado incorrecto)
3. `cantidad_incorrecta` (falta/exceso)
4. `producto_danado` (roto/aplastado en transporte)
5. `variedad_incorrecta` (no corresponde al tipo pactado)
6. `documentacion_incorrecta` (albarán/factura)
7. `precio_incorrecto` (discrepancia con lo pactado)
8. `cadena_frio` (temperatura incorrecta)


### 2.3 Historial de incidencias (derivado, no es una fuente nueva)
Se calcula agregando el propio CSV por `proveedor`:
- `num_incidencias_total`
- `num_incidencias_ultimos_6_meses`
- `incidencia_mas_frecuente` (moda de `tipo` de incidencia)
- `tasa_reincidencia` (% de incidencias repetidas en la misma categoría)
- `gravedad_media`: requiere un **mapeo categoría → peso (1-5)**, que no viene
  en el CSV. Propuesta inicial (ajustar en plan.md):
  - cadena_frio: 5, producto_danado: 4, calidad_producto: 4,
    cantidad_incorrecta: 3, variedad_incorrecta: 3, retraso_entrega: 2,
    documentacion_incorrecta: 1, precio_incorrecto: 2

### 2.4 Corpus de correos (sintético)
No existe corpus real → se generará uno de ejemplo antes de construir el RAG.
- ~40-60 emails sintéticos cubriendo combinaciones de:
  - tono (formal / firme-pero-cordial / conciliador)
  - categoría de incidencia (las 8 de arriba)
- Generados con LLM gratis. Se generará un promp adecuado para conseguir una variedad de correos que genere un buen corpus para el objetivo del proyecto.
- Se convierte en tarea propia del plan (no se asume ya disponible)

### 2.5 Inputs del modelo
| campo | tipo | ejemplo | procedencia
|---|---|---|---|
| proveedor | string | debe existir en el CSV | Tabla de incidencias
| incidencia_actual | categórico | una de las 8 categorías | Tabla de incidencias
| evaluación del histórico | string |  resultado de la revisión del histórico de incidencias del cliente | Análisis de datos
| tono deseado | enum | formal / firme-pero-cordial / conciliador | Usuario
| objetivo | enum | pedir explicación / exigir compensación / avisar / cerrar incidencia | Usuario
| mensaje_libre | string opcional | frase o idea que el usuario quiere incluir | Usuario

## 3. Output esperado
- Un borrador de email en español, listo para revisión humana (nunca envío automático)
- Estructura: asunto + cuerpo (saludo, referencia a lote/fecha, descripción
  de la incidencia, mención al historial si es relevante —p.ej. reincidencia—,
  petición/objetivo, cierre)
- Longitud orientativa: 100-180 palabras
- Debe reflejar el tono solicitado y mencionar SOLO datos que existan en la
  tabla/historial (no inventar cifras)

## 4. Casos de prueba (validación)

**Caso A — reincidencia grave**
- Proveedor con `tasa_reincidencia` alta en `cadena_frio`
- Input: tono=firme-pero-cordial, objetivo=exigir compensación
- Se espera: el email mencione explícitamente que es la N-ésima vez

**Caso B — incidencia leve, primera vez**
- Proveedor sin incidencias previas, `documentacion_incorrecta`
- Input: tono=conciliador, objetivo=avisar
- Se espera: tono ligero, sin lenguaje de amenaza/penalización

**Caso C — mensaje libre**
- Usuario incluye `mensaje_libre` = "recordarles el plazo de 48h para responder"
- Se espera: esa frase (o su intención) aparece integrada de forma natural


## 5. Fuera de alcance de este spec
- Envío real de correos
- Ventas
- Multi-idioma

