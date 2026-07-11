# =========================================================
# # PROYECTO JÚPITER - CARGA DE DATOS
# Caso: Pontia Logista
# =========================================================

# Ver tablas disponibles
SHOW TABLES;

# =========================================================
# Nota:
# La importación de los CSV se realiza mediante
# Table Data Import Wizard de MySQL Workbench.
# Este script sirve como trazabilidad del proceso y para
# ejecutar comprobaciones posteriores a la carga.
# =========================================================


# =========================================================
# 1. SELECCIÓN DE BASE DE DATOS
# =========================================================
USE proyecto_jupiter;
USE proyecto_jupiter_va;
USE proyecto_jupiter_alchemy;


# =========================================================
# 2. ORDEN DE CARGA RECOMENDADO
# Primero se cargan las tablas maestras / dimensiones y después las
# tablas dependientes / hechos, respetando las claves foráneas
# =========================================================

# 1. proveedores
# 2. clientes
# 3. etiquetas
# 4. frutas
# 5. marca
# 6. lotes
# 7. compras
# 8. ventas


# =========================================================
# 3. FASE ACTUAL DE TRABAJO
# En esta primera fase:
# - Las tablas maestras se cargan con sus CSV completos
# - Las tablas lotes, compras y ventas pueden cargarse con
#   sample o con carga completa, según la estrategia elegida
# =========================================================

# Tablas maestras / dimensiones
# - proveedores
# - clientes
# - etiquetas
# - frutas
# - marca

# Tablas operativas
# - lotes
# - compras
# - ventas


# =========================================================
# 4. VALIDACIONES DESPUÉS DE LA CARGA
# =========================================================

# Verificación de tablas disponibles
SHOW TABLES;

# Conteo de registros por tabla
SELECT COUNT(*) AS total_proveedores FROM proveedores;
SELECT COUNT(*) AS total_clientes FROM clientes;
SELECT COUNT(*) AS total_etiquetas FROM etiquetas;
SELECT COUNT(*) AS total_frutas FROM frutas;
SELECT COUNT(*) AS total_marca FROM marca;
SELECT COUNT(*) AS total_lotes FROM lotes;
SELECT COUNT(*) AS total_compras FROM compras;
SELECT COUNT(*) AS total_ventas FROM ventas;


# =========================================================
# 5. INSPECCIÓN RÁPIDA DE CONTENIDO
# =========================================================

SELECT * FROM proveedores LIMIT 5;
SELECT * FROM clientes LIMIT 5;
SELECT * FROM etiquetas LIMIT 5;
SELECT * FROM frutas LIMIT 5;
SELECT * FROM marca LIMIT 5;
SELECT * FROM lotes LIMIT 5;
SELECT * FROM compras LIMIT 5;
SELECT * FROM ventas LIMIT 5;


# =========================================================
# 6. COMENTARIOS DE SEGUIMIENTO
# Archivo usado para proveedores: proveedores.csv
# Archivo usado para clientes: clientes.csv
# Archivo usado para etiquetas: etiquetas.csv
# Archivo usado para frutas: frutas.csv
# Archivo usado para marca: marca.csv
# Archivo usado para lotes: lotes.csv
# Archivo usado para compras: compras.csv
# Archivo usado para ventas: ventas.csv

 # Observaciones la cantidad de filas cargadas  NO coinciden con las cantidades que tienen los CSV's y los Dataframes en Pandas
 
# Comparativa de volúmenes entre Pandas, MySQL (Sebastián) y MySQL (Alejandro)
# ---------------------------------------------------------------------------------------------------------
# Tabla      | Pandas | MySQL (Sebastián) | Diferencia vs Pandas | MySQL (Alejandro) | Diferencia vs Pandas
# ---------------------------------------------------------------------------------------------------------
# etiquetas  | 69687  | 66648             | -3039                | 69687             | 0
# lotes      | 69687  | 66648             | -3039                | 69687             | 0
# compras    | 70549  | 65594             | -4955                | 68538             | -2011
# ventas     | 70549  | 66631             | -3918                | 69634             | -915
# ---------------------------------------------------------------------------------------------------------

# La diferencia entre el MySQL de Sebastián y el de Alejandro, es que el mío ( Sebastián) tiene los tipos de datos concretos para cada caso.
# Por el contrario, el otro tienes los tipo de datos más genéricos. No sé si esto pueda influir.
# En la diferencia con el MySQL de Alejandro parece que son los nulos.

# Finalmente hice la carga de los datos con SQLalchemy y todos los datos en este caso si han coincidido con los CSV's y los Dataframes de Pandas
# =========================================================


