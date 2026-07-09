# =========================================================
# PROYECTO JÚPITER - KPI'S
# Caso: Pontia Logista
# =========================================================

# Utilizamos el dataset con el nombre que le tenemos asignado
USE proyecto_jupiter_va;
USE proyecto_jupiter;
USE proyecto_jupiter_alchemy;

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
 