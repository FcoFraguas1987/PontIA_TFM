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


#RESULTADO: En csv Resultado_pregunta_9.csv