#KPIS PROYECTO JÚPITER - Visión artificial#

#Calcular la media diaria de la cuantía de las distribuciones# 
-- (Obtenemos media diaria y también la media por días, tras haber transformado la columna de fecha_venta por el día que según el valor --
UPDATE ventas
SET fecha_venta = DATE_ADD('2025-09-01 07:00:00', INTERVAL tiempo_venta HOUR)
WHERE id_venta > 0;
SELECT 
    AVG(ventas_diarias) AS media_diaria_ventas
FROM (
    SELECT 
        DATE(fecha_venta) AS dia,
        COUNT(*) AS ventas_diarias
    FROM ventas
    GROUP BY DATE(fecha_venta)
) AS t;

#Calcular la cuantía total de las distribuciones#
-- (Se obtiene el número total de ventas(distribuciones) y el importe total en precio) -- 
SELECT 
    DATE(fecha_venta) AS dia,
    COUNT(*) AS ventas_diarias
FROM ventas
GROUP BY DATE(fecha_venta)
ORDER BY dia;
SELECT COUNT(*) AS total_distribuciones
FROM ventas;
SELECT SUM(precio_venta) AS cuantia_total_distribuciones
FROM ventas;

#¿Qué días del mes se han producido más distribuciones y cuántas?#
-- (Se obtiene el día con más ventas(distribuciones) --
SELECT 
    DATE(fecha_venta) AS dia,
    COUNT(*) AS ventas_en_el_dia
FROM ventas
GROUP BY DATE(fecha_venta)
ORDER BY ventas_en_el_dia DESC
LIMIT 1;

#¿Cuál es el precio de venta medio de cada fruta?#
-- (Se obtiene el precio medio de venta de cada fruta) --
-- (Como salen números muy parejos en todas, se obtiene el precio min y max y la media global así como la dispersión de cada fruta --
SELECT 
    f.tipo AS fruta,
    AVG(v.precio_venta) AS precio_medio
FROM ventas v
JOIN lotes l ON v.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
GROUP BY f.tipo
ORDER BY precio_medio DESC;
SELECT 
    MIN(precio_venta) AS min_precio,
    MAX(precio_venta) AS max_precio,
    AVG(precio_venta) AS media_global
FROM ventas;
SELECT 
    f.tipo AS fruta,
    AVG(v.precio_venta) AS precio_medio,
    STDDEV(v.precio_venta) AS dispersion
FROM ventas v
JOIN lotes l ON v.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
GROUP BY f.tipo

#Suponiendo que si no se dispone de información de venta se trata de una fruta que no ha podido venderse por haber sido dañada durante la distribución, ¿cuánta fruta de cada tipo ha sido dañada?#
-- (Se obtiene fruta dañada por tipo de fruta, ya que no tiene precio de venta su lote --
ORDER BY dispersion DESC;SELECT 
    f.tipo AS fruta,
    COUNT(*) AS cantidad_daniada
FROM lotes l
JOIN frutas f ON l.id_tipo = f.id_tipo
LEFT JOIN ventas v ON l.id_lote = v.id_lote
WHERE v.id_lote IS NULL
GROUP BY f.tipo
ORDER BY cantidad_daniada DESC;

#¿Cuál ha sido la pérdida total de la fruta dañada?#
-- (Se obtiene pérdida total de fruta y por cada fruta. No se tiene precio de venta pero si coste inicial de ese lote --
SELECT 
    SUM(c.coste_inicial) AS perdida_total
FROM compras c
LEFT JOIN ventas v ON c.id_lote = v.id_lote
WHERE v.id_lote IS NULL;
SELECT 
    f.tipo AS fruta,
    SUM(c.coste_inicial) AS perdida_total
FROM compras c
JOIN lotes l ON c.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
LEFT JOIN ventas v ON c.id_lote = v.id_lote
WHERE v.id_lote IS NULL
GROUP BY f.tipo
ORDER BY perdida_total DESC;






















