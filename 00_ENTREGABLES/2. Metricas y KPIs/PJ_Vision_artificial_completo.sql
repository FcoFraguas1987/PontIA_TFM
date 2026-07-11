#KPIS PROYECTO JÚPITER - Visión artificial#

#1. Calcular la media diaria de la cuantía de las distribuciones# 
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

#-----------------------------------------------------------------------------------------------------------#
#2. Calcular la cuantía total de las distribuciones#
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

#--------------------------------------------------------------------------------------------------------#
#3. ¿Qué días del mes se han producido más distribuciones y cuántas?#
-- (Se obtiene el día con más ventas(distribuciones) --
SELECT 
    DATE(fecha_venta) AS dia,
    COUNT(*) AS ventas_en_el_dia
FROM ventas
GROUP BY DATE(fecha_venta)
ORDER BY ventas_en_el_dia DESC
LIMIT 1;

# =========================================================
# PROYECTO JÚPITER - KPI'S
# Caso: Pontia Logista
# =========================================================

# Utilizamos el dataset con el nombre que le tenemos asignado
USE proyecto_jupiter;

# ===================================================================================================================
# 4 ¿A qué horas del día se producen más recogidas de alimentos y cuántas? SEBASTIÁN GONZÁLEZ
# ===================================================================================================================

SELECT
    HOUR(DATE_ADD('2025-09-01 07:00:00', INTERVAL tiempo_recogida HOUR)) AS hora_del_dia, # Transformamos las horas acumuladas en fechas reales y extraemos las horas
    COUNT(*) AS total_recogidas  # Contamos la cantidad de recogidas por cada hora
FROM compras
GROUP BY HOUR(DATE_ADD('2025-09-01 07:00:00',  INTERVAL tiempo_recogida HOUR))  # Agrupamos por cada una de las horas de recogida
ORDER BY total_recogidas DESC, hora_del_dia ASC  # Ordenamos por el total de recogidas de mayor a menor y en caso de empate por la hora del dia de menor a mayor
LIMIT 10; 

# Resultado en archivo csv pregunta_4

# ===================================================================================================================
# 5 ¿Cuáles son los 5 clientes que más dinero han gastado comprando la fruta y cuánto? SEBASTIÁN GONZÁLEZ
# ===================================================================================================================

SELECT
    c.cliente,                                    # Seleccionamos el campo que queremos visualizar nombre cliente
    ROUND(SUM(v.precio_venta),2) AS total_gastado # Le sumamos el total gastado 
FROM ventas v
JOIN clientes c
    ON v.id_cliente = c.id_cliente                # Hacemos un JOIN uniendo por los campos  id_cliente que tenemos como enlace en las tablas clientes y ventas
GROUP BY c.cliente                                # Agrupamos por cliente 
ORDER BY total_gastado DESC                       # Ordenamos de mayor a menor 
LIMIT 5;

# Resultado archivo csv pregunta_5


# ===================================================================================================================
# 6 ¿Cuáles son los 5 clientes que menos dinero han gastado comprando la fruta y cuánto?  SEBASTIÁN GONZÁLEZ
# ===================================================================================================================

SELECT
    c.cliente,                                    # Seleccionamos el campo que queremos visualizar nombre cliente
    ROUND(SUM(v.precio_venta),2) AS total_gastado # Le sumamos el total gastado 
FROM ventas v
JOIN clientes c
    ON v.id_cliente = c.id_cliente                # Hacemos un JOIN uniendo por los campos  id_cliente que tenemos como enlace en las tablas clientes y ventas
GROUP BY c.cliente                                # Agrupamos por cliente 
ORDER BY total_gastado ASC                        # Ordenamos de menor a mayor
LIMIT 5;

# Resultado archivo csv pregunta_6

#----------------------------------------------------------------------------------------------#
SELECT *
FROM clientes;

#¿Cuáles son los 10 proveedores que han recibido más dinero y cuánto? JAVIER FRAGUAS

#Seleccionamos el coste inicial y los proveedores de compras
SELECT 
    cl.cliente, ROUND(SUM(coste_inicial),2) AS sum_coste_inicial
FROM
    compras co
JOIN clientes cl ON co.id_proveedor = cl.id_cliente
GROUP BY co.id_proveedor
ORDER BY sum_coste_inicial DESC
LIMIT 10;

#RESULTADO: En csv Resultado_pregunta_7.csv

#------------------------------------------------------------------------------------------------------------#
#Pregunta: ¿Cuáles son los 3 productos con mayor beneficio a lo largo del mes (aquellos que al restarle
#al coste de venta el precio de compra se quedan con un mejor resultado) y cuál ha sido su
#balance?
#Aqui el link de todo es id_lote. de ventas: id_lote y precio ventas. de compras id_lote y precio_compra. De lote: id_lote id_tipo y de frutas: 
# id_tipo y tipo


SELECT 
    f.tipo, #Quiero pintar el tipo
    ROUND(SUM(b.beneficio),2) AS beneficio_total #calculo el beneficio trayendo los datos de las tablas de ventas y compras
FROM (
    SELECT 
        v.id_lote,
        (v.precio_venta - c.coste_inicial) AS beneficio
    FROM ventas v
    JOIN compras c ON v.id_lote = c.id_lote
) b #uno los cálculos en un estado intermedio llamado beneficios o b
JOIN lotes l ON b.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
GROUP BY f.id_tipo #los beneficios se relacionan con el tipo de fruta a través del lote
ORDER BY beneficio_total DESC
LIMIT 3; #Lo ordenamos de forma descendente y acotamos el resultado a los tres primeros

#RESULTADO: En csv Resultado_pregunta_8.csv

#----------------------------------------------------------------------------------------------------------------#
# Pregunta: ¿Cuáles son los 3 productos con peor beneficio a lo largo de todo el mes y cuál ha sido?
SELECT 
    f.tipo, #Quiero pintar el tipo
    ROUND(SUM(b.beneficio),2) AS beneficio_total #calculo el beneficio trayendo los datos de las tablas de ventas y compras
FROM (
    SELECT 
        v.id_lote,
        CAST(v.precio_venta AS DECIMAL(10,2)) - CAST(c.coste_inicial AS DECIMAL(10,2)) AS beneficio
    FROM ventas v
    JOIN compras c ON v.id_lote = c.id_lote
) b #uno los cálculos en un estado intermedio llamado beneficios o b
JOIN lotes l ON b.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
GROUP BY f.id_tipo #los beneficios se relacionan con el tipo de fruta a través del lote
ORDER BY beneficio_total ASC
LIMIT 3; #Lo ordenamos de forma descendente y acotamos el resultado a los tres primeros

#RESULTADO: En csv Resultado_pregunta_9.csv

#----------------------------------------------------------------------------------------------------------#
#10.¿Cuál es el precio de venta medio de cada fruta?#
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

#--------------------------------------------------------------------------------------------------------------------------------------#
#11.Suponiendo que si no se dispone de información de venta se trata de una fruta que no ha podido venderse por haber sido dañada durante la distribución, ¿cuánta fruta de cada tipo ha sido dañada?#
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

#---------------------------------------------------------------------------------------------------------------------------------#
#12.¿Cuál ha sido la pérdida total de la fruta dañada?#
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


# ===================================================================================================================
# 13 ¿Cuál es la cuantía total de cada tipo de fruta que han comprado los 5 clientes que más dinero han gastado?  SEBASTIÁN GONZÁLEZ
# ===================================================================================================================


WITH top_5_clientes AS (                                  # Realizamos una CTE para determinar el top 5 de clientes que más han gastado
    SELECT
        v.id_cliente,
        SUM(v.precio_venta) AS total_gastado
    FROM ventas v
    GROUP BY v.id_cliente
    ORDER BY total_gastado DESC
    LIMIT 5
)

SELECT                                                   # Realizamos la consulta con los campos que necesitamos visualizar
    c.cliente,
    f.tipo,
    ROUND(SUM(v.precio_venta),2) AS cuantia_total
FROM ventas v
JOIN top_5_clientes t                                   # 1er JOIN enlace de la CTE ( top_5_clientes) y tabla ventas
    ON v.id_cliente = t.id_cliente
JOIN clientes c                                         # 2do JOIN enlace de tabla clientes con tabla ventas
    ON v.id_cliente = c.id_cliente
JOIN lotes l                                            # 3er JOIN enlace de tabla lotes con tabla ventas
    ON v.id_lote = l.id_lote
JOIN frutas f                                           # 4to JOIN enlace de tabla frutas con tabla lotes
    ON l.id_tipo = f.id_tipo
GROUP BY c.cliente, f.tipo                              # Agrupamos por cliente y tipo de fruta
ORDER BY c.cliente ASC, 
 cuantia_total DESC;                                    # Ordenamos con una lógica sugerida
 
 # Resultado archivo csv pregunta_13
 
 #----------------------------------------------------------------------------------------------------------------------------#
 #Para cada producto, calcular el porcentaje de beneficio.
SELECT 
    f.tipo, #Quiero pintar el tipo
    ROUND(SUM(b.beneficio),2) AS beneficio_porcentual #calculo el beneficio trayendo los datos de las tablas de ventas y compras
FROM (
    SELECT 
        v.id_lote,
        (((v.precio_venta - c.coste_inicial)/v.precio_venta)*100) AS beneficio
    FROM ventas v
    JOIN compras c ON v.id_lote = c.id_lote
) b #uno los cálculos en un estado intermedio llamado beneficios o b
JOIN lotes l ON b.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
GROUP BY f.id_tipo #los beneficios se relacionan con el tipo de fruta a través del lote
ORDER BY beneficio_porcentual DESC;

#RESULTADO: En csv Resultado_pregunta_14.csv
 






















