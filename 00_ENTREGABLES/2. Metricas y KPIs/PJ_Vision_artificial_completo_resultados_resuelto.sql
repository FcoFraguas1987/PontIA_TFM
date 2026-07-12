#KPIS PROYECTO JÚPITER - Visión artificial#

USE proyecto_jupiter_alchemy;

#=======================================================================================================#
#1. Calcular la media diaria de la cuantía de las distribuciones# 
# (Obtenemos media diaria y también la media por días, tras haber transformado la columna de fecha_venta por el día que según el valor)#
# Resultado: 2.137,85 media diaria de ventas # En segundo cálculo se desglosa la media por días #
# Resulto por Alejandro Torrecilla
#========================================================================================================#
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

#=======================================================================================================#
#2. Calcular la cuantía total de las distribuciones#
# (Se obtiene el número total de ventas(distribuciones) y el importe total en precio) #
# Resultado: 70.549 #
# Resuelto por Alejandro Torrecilla # Primero se calculan el total de distribuciones #
#========================================================================================================#
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

#=======================================================================================================#
#3. ¿Qué días del mes se han producido más distribuciones y cuántas?#
# (Se obtiene el día con más ventas(distribuciones) #
# Resultado: 13 de septiembre de 2025 #
# Resuelto por Alejandro Torrecilla #
#========================================================================================================#
SELECT 
    DATE(fecha_venta) AS dia,
    COUNT(*) AS ventas_en_el_dia
FROM ventas
GROUP BY DATE(fecha_venta)
ORDER BY ventas_en_el_dia DESC
LIMIT 1;


# ===================================================================================================================
# 4 ¿A qué horas del día se producen más recogidas de alimentos y cuántas? 
# Resultado: Hora 3 del día #
# Resuelto por SEBASTIÁN GONZÁLEZ
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
# 5 ¿Cuáles son los 5 clientes que más dinero han gastado comprando la fruta y cuánto? 
#Resultado: SuperEconómico, SuperMercado Ideal, Cosecha Fresca, MegaCompra y Distribuciones del SOL #
# Resuelto por SEBASTIÁN GONZÁLEZ #
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
# 6 ¿Cuáles son los 5 clientes que menos dinero han gastado comprando la fruta y cuánto? 
# Resultado: Distribuidora Gourmet, Almacén Estrella, CompraMaestra, Distribuidora Nacional, SuperAhorra Express
# Resuelto por SEBASTIÁN GONZÁLEZ
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

#=======================================================================================================#
SELECT *
FROM clientes;
# 7. ¿Cuáles son los 10 proveedores que han recibido más dinero y cuánto?
# Resultado: CompraMaestra, Alimentación Total, Central de Abastos Central, Almacen Estrella, Distribuciones del Sol, Mercado del Barrio, Tienda Selecta, Distribuidora Alfa, SuperValle Verde, EcoTienda#
# Resuelto por JAVIER FRAGUAS
#========================================================================================================#
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

#=======================================================================================================#
# 8. Pregunta: ¿Cuáles son los 3 productos con mayor beneficio a lo largo del mes (aquellos que al restarle
#al coste de venta el precio de compra se quedan con un mejor resultado) y cuál ha sido su
#balance?
#Aqui el link de todo es id_lote. de ventas: id_lote y precio ventas. de compras id_lote y precio_compra. De lote: id_lote id_tipo y de frutas: 
# id_tipo y tipo
# Resultado: Guava, Apple, Kiwi
# Resuelto por JAVIER FRAGUAS
#=======================================================================================================#

SELECT 
    f.tipo, #Quiero pintar el tipo
    ROUND(SUM(b.beneficio),2) AS beneficio_total #calculo el beneficio trayendo los datos de las tablas de ventas y compras
FROM (
	SELECT
    v.id_lote,
    (CAST(v.precio_venta AS SIGNED) - CAST(c.coste_inicial AS SIGNED)) AS beneficio
	FROM ventas v
	JOIN compras c ON v.id_lote = c.id_lote
) b #uno los cálculos en un estado intermedio llamado beneficios o b
JOIN lotes l ON b.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
GROUP BY f.id_tipo #los beneficios se relacionan con el tipo de fruta a través del lote
ORDER BY beneficio_total DESC
LIMIT 3; #Lo ordenamos de forma descendente y acotamos el resultado a los tres primeros

#RESULTADO: En csv Resultado_pregunta_8.csv

#========================================================================================================#
# 9. Pregunta: ¿Cuáles son los 3 productos con peor beneficio a lo largo de todo el mes y cuál ha sido?
# Resultado: muskmelón, Carambola, Persimmon
# Resuelto por JAVIER FRAGUAS
#========================================================================================================#


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

#=========================================================================================================#
#10.¿Cuál es el precio de venta medio de cada fruta?#
-- (Se obtiene el precio medio de venta de cada fruta) --
-- (Como salen números muy parejos en todas, se obtiene el precio min y max y la media global así como la dispersión de cada fruta --
#Peach	3.5215. Kiwi	3.5150, Orange	3.5147, Pitaya	3.5137, Pear	3.5124, Persimmon	3.5119, Guava	3.5044, Banana	3.5030, Pomegranate	3.5005, Plum	3.4914, Carambola	3.4913, Apple	3.4881, Mango	3.4866, muskmelon	3.4834, Tomatoes	3.4402
# Resuelto por Alejandro Torrecilla
#=========================================================================================================#

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
GROUP BY f.tipo;

#===================================================================================================================================#
# 11. Suponiendo que si no se dispone de información de venta se trata de una fruta que no ha podido venderse por haber sido dañada durante la distribución, ¿cuánta fruta de cada tipo ha sido dañada?
# Resultado: Guava	66, Apple	47, Kiwi	25, Mango	14, Banana	12, Pear	10, Pomegranate	10, Tomatoes	9, Pitaya	8, Carambola	6, Orange	6, Peach	5, Plum	5, Persimmon	4, muskmelon	2
# Resuelto por Alejandro Torrecilla #
#===================================================================================================================================#

SELECT 
    f.tipo AS fruta,
    COUNT(*) AS cantidad_daniada
FROM compras c
JOIN lotes l ON c.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
LEFT JOIN ventas v ON c.id_lote = v.id_lote
WHERE v.fecha_venta IS NULL
GROUP BY f.tipo
ORDER BY cantidad_daniada DESC;

#======================================================================================================================================= #
#12.¿Cuál ha sido la pérdida total de la fruta dañada?#
-- (Se obtiene pérdida total de fruta y por cada fruta. No se tiene precio de venta pero si coste inicial de ese lote --
# Resultado: Pear	19, Pitaya	18, Tomatoes	18, Pomegranate	17, Orange	13, Plum	13, Carambola	12, Persimmon	9, Peach	8, muskmelon	3
# Resuelto por Alejandro Torrecilla #
#========================================================================================================================================#

SELECT 
    f.tipo AS fruta,
    SUM(c.coste_inicial) AS perdida_total
FROM compras c
JOIN lotes l ON c.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
LEFT JOIN ventas v ON c.id_lote = v.id_lote
WHERE v.fecha_venta IS NULL
GROUP BY f.tipo
ORDER BY perdida_total DESC;


# ===================================================================================================================
# 13 ¿Cuál es la cuantía total de cada tipo de fruta que han comprado los 5 clientes que más dinero han gastado?  
# Resultado Cosecha Fresca	Guava	2144
# Cosecha Fresca	Apple	1218 Cosecha Fresca	Kiwi	851 Cosecha Fresca	Mango	465 Cosecha Fresca	Pear	288 Cosecha Fresca	Orange	274 Cosecha Fresca	Plum	257 Cosecha Fresca	Banana	255 Cosecha Fresca	Carambola	248 Cosecha Fresca	Persimmon	246 Cosecha Fresca	Peach	241 Cosecha Fresca	Pitaya	240 Cosecha Fresca	Pomegranate	223 Cosecha Fresca	muskmelon	219 Cosecha Fresca	Tomatoes	204
# Distribuciones del Sol	Guava	2141 Distribuciones del Sol	Apple	1169 Distribuciones del Sol	Kiwi	883 Distribuciones del Sol	Mango	408 Distribuciones del Sol	Orange	317 Distribuciones del Sol	Peach	316 Distribuciones del Sol	Pear	308 Distribuciones del Sol	Pitaya	294 Distribuciones del Sol	Banana	278 Distribuciones del Sol	Plum	258 Distribuciones del Sol	Pomegranate	250 Distribuciones del Sol	Tomatoes	214 Distribuciones del Sol	muskmelon	170 Distribuciones del Sol	Carambola	170 Distribuciones del Sol	Persimmon	140
# MegaCompra	Guava	2007 MegaCompra	Apple	1394 MegaCompra	Kiwi	804 MegaCompra	Mango	436 MegaCompra	Banana	325 MegaCompra	Peach	294 MegaCompra	Orange	285 MegaCompra	Plum	273 MegaCompra	Pear	268 MegaCompra	Pitaya	260 MegaCompra	Carambola	244 MegaCompra	Pomegranate	225 MegaCompra	Tomatoes	194 MegaCompra	muskmelon	183 MegaCompra	Persimmon	162 
# SuperEconómico	Guava	2055 SuperEconómico	Apple	1216 SuperEconómico	Kiwi	876 SuperEconómico	Mango	434 SuperEconómico	Orange	330 SuperEconómico	Banana	327 SuperEconómico	Pear	287 SuperEconómico	Persimmon	276 SuperEconómico	Pitaya	269 SuperEconómico	Peach	246 SuperEconómico	Pomegranate	235 SuperEconómico	Carambola	234 SuperEconómico	Plum	223 SuperEconómico	muskmelon	221 SuperEconómico	Tomatoes	220 
# SuperMercado Ideal	Guava	2016 SuperMercado Ideal	Apple	1190 SuperMercado Ideal	Kiwi	951 SuperMercado Ideal	Mango	381 SuperMercado Ideal	Peach	345 SuperMercado Ideal	Banana	327 SuperMercado Ideal	Orange	320 SuperMercado Ideal	Plum	277 SuperMercado Ideal	Pear	270 SuperMercado Ideal	Tomatoes	254 SuperMercado Ideal	Carambola	246 SuperMercado Ideal	Pitaya	239 SuperMercado Ideal	Pomegranate	217 uperMercado Ideal	Persimmon	204 uperMercado Ideal	muskmelon	197 #
# Resuelto por SEBASTIÁN GONZÁLEZ
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
 
 #==========================================================================================================================================#
 # 14.  #Para cada producto, calcular el porcentaje de beneficio.#
 # Resultado: Guava	776173.33 pple	560436.67Kiwi	344041.67 ango	165841.67 Orange 123095.00 Banana122870.00Pear 12161.19Peach	107181.67Pitaya	100628.33Plum	91580.00Pomegranate	88220.00Tomatoes	86913.33Carambola	83985.00Persimmon	83883.33muskmelon	83063.33
 #Resuelto por JAVIER FRAGUAS
 #===========================================================================================================================================#
SELECT 
    f.tipo, #Quiero pintar el tipo
    ROUND(SUM(b.beneficio),2) AS beneficio_porcentual #calculo el beneficio trayendo los datos de las tablas de ventas y compras
FROM (
    SELECT 
        v.id_lote,
       (((CAST(v.precio_venta AS SIGNED) - CAST(c.coste_inicial AS SIGNED))/v.precio_venta)*100) AS beneficio
    FROM ventas v
    JOIN compras c ON v.id_lote = c.id_lote
) b #uno los cálculos en un estado intermedio llamado beneficios o b
JOIN lotes l ON b.id_lote = l.id_lote
JOIN frutas f ON l.id_tipo = f.id_tipo
GROUP BY f.id_tipo #los beneficios se relacionan con el tipo de fruta a través del lote
ORDER BY beneficio_porcentual DESC;

#RESULTADO: En csv Resultado_pregunta_14.csv
 






















