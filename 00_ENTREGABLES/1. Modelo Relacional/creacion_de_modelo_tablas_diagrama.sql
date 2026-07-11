# =========================================================
# PROYECTO JÚPITER - MODELO RELACIONAL BASE
# Caso: Pontia Logista
# =========================================================

# =========================================================
# 1. CREACIÓN Y SELECCIÓN DE BASE DE DATOS
# =========================================================
CREATE DATABASE IF NOT EXISTS proyecto_jupiter
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE proyecto_jupiter;


# =========================================================
# 2. TABLAS MAESTRAS / DIMENSIONES
# Solo se restringe NOT NULL en las PK
# =========================================================

# Tabla de proveedores
CREATE TABLE proveedores (
    id_proveedor MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
    proveedor VARCHAR(36)
) ENGINE=InnoDB;

# Tabla de clientes
CREATE TABLE clientes (
    id_cliente MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
    cliente VARCHAR(26)
) ENGINE=InnoDB;

# Tabla de etiquetas
CREATE TABLE etiquetas (
    id_t_id MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
    t_id VARCHAR(33)
) ENGINE=InnoDB;

# Tabla de frutas
CREATE TABLE frutas (
    id_tipo MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
    tipo VARCHAR(11)
) ENGINE=InnoDB;

# Tabla de marcas
CREATE TABLE marca (
    id_marca MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
    marca VARCHAR(19)
) ENGINE=InnoDB;


# =========================================================
# 3. TABLA CENTRAL DE LOTES
# Se permiten nulos en variables no PK para mantener el dato
# bruto y analizar su calidad posteriormente
# =========================================================

CREATE TABLE lotes (
    id_lote MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
    lote VARCHAR(47),
    id_t_id MEDIUMINT UNSIGNED NOT NULL,
    id_marca MEDIUMINT UNSIGNED NOT NULL,
    id_tipo MEDIUMINT UNSIGNED NOT NULL,

    CONSTRAINT fk_lotes_etiquetas
        FOREIGN KEY (id_t_id) REFERENCES etiquetas(id_t_id),

    CONSTRAINT fk_lotes_marca
        FOREIGN KEY (id_marca) REFERENCES marca(id_marca),

    CONSTRAINT fk_lotes_frutas
        FOREIGN KEY (id_tipo) REFERENCES frutas(id_tipo)
) ENGINE=InnoDB;


# =========================================================
# 4. TABLAS OPERATIVAS / HECHOS
# Solo las PK se fuerzan como NOT NULL
# El resto de variables puede contener nulos
# =========================================================

# Tabla de compras
CREATE TABLE compras (
    id_compra MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
    tiempo_recogida SMALLINT UNSIGNED,
    coste_inicial TINYINT UNSIGNED,
    id_proveedor MEDIUMINT UNSIGNED NOT NULL,
    id_lote MEDIUMINT UNSIGNED NOT NULL,

    CONSTRAINT fk_compras_proveedores
        FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),

    CONSTRAINT fk_compras_lotes
        FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
) ENGINE=InnoDB;

# Tabla de ventas
CREATE TABLE ventas (
    id_venta MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
    tiempo_venta SMALLINT,
    precio_venta TINYINT UNSIGNED,
    peso SMALLINT,
    id_cliente MEDIUMINT UNSIGNED NOT NULL,
    id_lote MEDIUMINT UNSIGNED NOT NULL,

    CONSTRAINT fk_ventas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),

    CONSTRAINT fk_ventas_lotes
        FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
) ENGINE=InnoDB;

ALTER TABLE ventas
MODIFY COLUMN precio_venta DECIMAL(4,2) UNSIGNED,
MODIFY COLUMN peso DECIMAL(6,2);

# =========================================================
# 5. COMPROBACIÓN RÁPIDA
# =========================================================
SHOW TABLES;