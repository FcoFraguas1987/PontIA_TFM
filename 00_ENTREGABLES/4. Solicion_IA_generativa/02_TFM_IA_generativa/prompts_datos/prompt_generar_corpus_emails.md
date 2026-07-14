Vas a generar un corpus sintético de emails para una prueba de concepto (no
son datos reales). Son ejemplos de emails que el departamento de COMPRAS de
una empresa envía a proveedores de fruta para responder ante incidencias
(retrasos, calidad, cantidad, etc.). Este corpus se usará como base de
recuperación (RAG) para ayudar a redactar nuevos borradores, así que la
variedad de redacción entre ejemplos es más importante que la cantidad.

## Combinaciones a cubrir

3 tonos:
- `formal`
- `firme-pero-cordial`
- `conciliador`

8 categorías de incidencia (usa EXACTAMENTE estos valores, en minúsculas con
guion bajo):
- `retraso_entrega`
- `calidad_producto` (madurez/estado incorrecto)
- `cantidad_incorrecta` (falta/exceso)
- `producto_danado` (roto/aplastado en transporte)
- `variedad_incorrecta` (no corresponde al tipo pactado)
- `documentacion_incorrecta` (albarán/factura)
- `precio_incorrecto` (discrepancia con lo pactado)
- `cadena_frio` (temperatura incorrecta)

Genera al menos 2 emails distintos para cada una de las 24 combinaciones
(3 tonos × 8 categorías), con un total entre 45 y 60 emails. No repitas la
misma redacción ni la misma estructura de frase entre ejemplos de la misma
combinación: varía el saludo, el orden de las ideas, el proveedor/lote
inventado, y las frases usadas.

## Contenido de cada email

Cada email debe tener:
- **Asunto**: breve, menciona la incidencia y opcionalmente el lote.
- **Cuerpo**: saludo, referencia a un lote/fecha ficticios (invéntalos,
  varía el formato: `L-XXXX`, fechas variadas), descripción de la
  incidencia concreta, opcionalmente mención a un historial previo con el
  proveedor (reincidencia, o primera vez — varíalo), una petición u
  objetivo claro (pedir explicación / exigir compensación / avisar / cerrar
  incidencia — varíalo libremente), y cierre.
- Extensión orientativa: 100-180 palabras en el cuerpo.
- Tono coherente con el campo `tono` de esa entrada (formal = distante y
  protocolario; firme-pero-cordial = directo pero educado, sin agresividad;
  conciliador = amable, poco exigente, casi disculpando la incidencia).
- Nunca inventes cifras de compensación económica exactas salvo que decidas
  incluir un ejemplo con petición de descuento genérica (sin céntimos
  concretos).
- Nombres de proveedores y personas: usa nombres ficticios genéricos, nunca
  empresas reales.

## Formato de salida

Devuelve el resultado en formato **JSONL**: una línea por email, cada línea
un objeto JSON válido con EXACTAMENTE estos 4 campos, en este orden:

```
{"tono": "...", "categoria": "...", "asunto": "...", "cuerpo": "..."}
```

- `tono`: uno de los 3 valores exactos de arriba.
- `categoria`: uno de los 8 valores exactos de arriba.
- `asunto` y `cuerpo`: texto en español, sin saltos de línea literales
  dentro del JSON (usa `\n` si necesitas separar párrafos en `cuerpo`).

No incluyas explicaciones, numeración, ni bloques de código markdown (nada
de ```): solo las líneas JSONL, listas para guardar directamente como
`corpus_emails.jsonl`.
