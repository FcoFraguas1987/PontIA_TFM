import pandas as pd

from src.datos.validar_incidencias import validar_incidencias


def _df_bueno():
    return pd.DataFrame(
        [
            {"proveedor": "A", "lote": "L-0001", "tiempo_compra": "2026-06-01", "precio_compra": 1.5, "tipo": "manzana", "incidencia": "cadena_frio"},
            {"proveedor": "A", "lote": "L-0002", "tiempo_compra": "2026-06-15", "precio_compra": 1.2, "tipo": "pera", "incidencia": "cadena_frio"},
            {"proveedor": "B", "lote": "L-0003", "tiempo_compra": "2025-01-10", "precio_compra": 0.9, "tipo": "naranja", "incidencia": "documentacion_incorrecta"},
            {"proveedor": "C", "lote": "L-0004", "tiempo_compra": "2025-05-20", "precio_compra": 2.0, "tipo": "kiwi", "incidencia": "retraso_entrega"},
            {"proveedor": "C", "lote": "L-0005", "tiempo_compra": "2025-06-20", "precio_compra": 2.1, "tipo": "kiwi", "incidencia": "cantidad_incorrecta"},
        ]
    )


def test_dataframe_bueno_no_reporta_problemas():
    assert validar_incidencias(_df_bueno()) == []


def test_detecta_fruta_no_reconocida():
    df = _df_bueno()
    df.loc[0, "tipo"] = "durian"
    problemas = validar_incidencias(df)
    assert any("tipo" in p for p in problemas)


def test_detecta_categoria_incidencia_no_reconocida():
    df = _df_bueno()
    df.loc[0, "incidencia"] = "envio_perdido"
    problemas = validar_incidencias(df)
    assert any("incidencia" in p for p in problemas)


def test_detecta_falta_caso_sembrado_proveedor_a():
    df = _df_bueno()
    df.loc[df["proveedor"] == "A", "incidencia"] = "retraso_entrega"
    problemas = validar_incidencias(df)
    assert any("proveedor 'A'" in p for p in problemas)


def test_detecta_proveedor_b_con_mas_de_una_fila():
    df = pd.concat(
        [
            _df_bueno(),
            pd.DataFrame([{"proveedor": "B", "lote": "L-0006", "tiempo_compra": "2025-02-01", "precio_compra": 1.0, "tipo": "uva", "incidencia": "retraso_entrega"}]),
        ],
        ignore_index=True,
    )
    problemas = validar_incidencias(df)
    assert any("proveedor 'B'" in p for p in problemas)
