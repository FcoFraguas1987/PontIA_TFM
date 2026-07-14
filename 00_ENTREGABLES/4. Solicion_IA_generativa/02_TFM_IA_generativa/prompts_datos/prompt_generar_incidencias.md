Vas a generar un dataset sintético en formato CSV para una prueba de
concepto (no son datos reales). Representa incidencias detectadas en compras
de fruta a proveedores. Genera el CSV completo siguiendo EXACTAMENTE estas
reglas.

## Columnas (en este orden, cabecera incluida)

```
proveedor,lote,tiempo_compra,precio_compra,tipo,incidencia
```

- `proveedor`: identificador corto del proveedor. Usa letras mayúsculas de
  la A a la S (19 proveedores en total: A, B, C, D, ..., S).
- `lote`: identificador de lote, formato `L-XXXX` con 4 dígitos, único por
  fila.
- `tiempo_compra`: fecha de la compra, formato ISO `AAAA-MM-DD`, repartidas
  entre `2024-07-01` y `2026-07-06` (fecha de referencia = `2026-07-06`,
  "hoy" a efectos de este dataset).
- `precio_compra`: número decimal (punto como separador decimal) entre 0.40
  y 4.50, con 2 decimales. Precio coherente por tipo de fruta (frutas como
  aguacate o mango algo más caras que manzana o naranja, pero no hace falta
  precisión real, solo variedad razonable).
- `tipo`: una de estas 15 frutas EXACTAMENTE (en minúsculas, sin tildes):
  `manzana, pera, platano, naranja, limon, fresa, uva, melocoton, ciruela,
  sandia, melon, pina, kiwi, mango, aguacate`
- `incidencia`: una de estas 8 categorías EXACTAMENTE (en minúsculas, con
  guion bajo):
  `retraso_entrega, calidad_producto, cantidad_incorrecta, producto_danado,
  variedad_incorrecta, documentacion_incorrecta, precio_incorrecto,
  cadena_frio`

## Volumen

- Genera entre 180 y 220 filas en total.
- Reparte las incidencias de forma desigual entre proveedores y categorías
  (algunos proveedores con muchas incidencias, otros con pocas; algunas
  categorías más frecuentes que otras) para que el dataset parezca real, con
  la EXCEPCIÓN de los casos obligatorios de la siguiente sección, que deben
  cumplirse exactamente.

## Casos obligatorios (no negociables, deben aparecer tal cual)

1. **Proveedor `A`**: al menos 4 filas con `incidencia = cadena_frio` y
   `tiempo_compra` dentro de los últimos 6 meses antes de la fecha de
   referencia (es decir, entre `2026-01-06` y `2026-07-06`). Puede tener
   además otras filas de otras categorías o fechas más antiguas, pero el
   patrón de reincidencia reciente en `cadena_frio` debe ser inequívoco.
2. **Proveedor `B`**: EXACTAMENTE 1 fila en todo el dataset, con
   `incidencia = documentacion_incorrecta`. No debe tener ninguna otra fila
   (ni otras incidencias, ni fechas adicionales).
3. **Proveedor `C`**: al menos 3 filas con incidencias variadas (cualquier
   categoría, cualquier fecha dentro del rango), sin ningún patrón especial
   más allá de tener historial suficiente para calcular sus métricas.

## Formato de salida

- Devuelve ÚNICAMENTE el contenido del CSV (cabecera + filas).
- No incluyas explicaciones, comentarios, numeración ni bloques de código
  markdown (nada de ```): solo texto plano CSV, listo para guardar
  directamente como `incidencias.csv`.
- Separador: coma. Sin comillas salvo que un valor las requiera (no debería
  ser necesario con estos campos).
