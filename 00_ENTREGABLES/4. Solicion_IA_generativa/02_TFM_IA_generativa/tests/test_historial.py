import re

import pandas as pd

from src.historial import calcular_historial_proveedor, formatear_evaluacion_historico


def _df_prueba():
    return pd.DataFrame(
        [
            {"proveedor": "X", "lote": "L-1", "tiempo_compra": "2026-01-10", "precio_compra": 1.0, "tipo": "manzana", "incidencia": "cadena_frio"},
            {"proveedor": "X", "lote": "L-2", "tiempo_compra": "2026-02-15", "precio_compra": 1.0, "tipo": "pera", "incidencia": "cadena_frio"},
            {"proveedor": "X", "lote": "L-3", "tiempo_compra": "2026-03-01", "precio_compra": 1.0, "tipo": "uva", "incidencia": "retraso_entrega"},
            {"proveedor": "X", "lote": "L-4", "tiempo_compra": "2024-01-01", "precio_compra": 1.0, "tipo": "kiwi", "incidencia": "documentacion_incorrecta"},
            {"proveedor": "Y", "lote": "L-5", "tiempo_compra": "2026-06-01", "precio_compra": 1.0, "tipo": "mango", "incidencia": "precio_incorrecto"},
        ]
    )


def test_metricas_exactas_proveedor_con_historial():
    historial = calcular_historial_proveedor(_df_prueba(), "X", fecha_referencia="2026-07-01")

    assert historial["num_incidencias_total"] == 4
    assert historial["num_incidencias_ultimos_6_meses"] == 3
    assert historial["incidencia_mas_frecuente"] == "cadena_frio"
    assert historial["tasa_reincidencia"] == 25.0
    assert historial["gravedad_media"] == 3.25


def test_proveedor_sin_incidencias():
    historial = calcular_historial_proveedor(_df_prueba(), "Z", fecha_referencia="2026-07-01")

    assert historial == {
        "num_incidencias_total": 0,
        "num_incidencias_ultimos_6_meses": 0,
        "incidencia_mas_frecuente": None,
        "tasa_reincidencia": 0.0,
        "gravedad_media": 0.0,
    }


def test_proveedor_con_una_sola_incidencia():
    historial = calcular_historial_proveedor(_df_prueba(), "Y", fecha_referencia="2026-07-01")

    assert historial["num_incidencias_total"] == 1
    assert historial["num_incidencias_ultimos_6_meses"] == 1
    assert historial["incidencia_mas_frecuente"] == "precio_incorrecto"
    assert historial["tasa_reincidencia"] == 0.0
    assert historial["gravedad_media"] == 2.0


def _numeros(texto: str) -> set[str]:
    return set(re.findall(r"\d+\.?\d*", texto))


def test_formatear_evaluacion_solo_menciona_cifras_del_historial():
    historial = calcular_historial_proveedor(_df_prueba(), "X", fecha_referencia="2026-07-01")
    texto = formatear_evaluacion_historico(historial)

    numeros_del_dict = {
        str(historial["num_incidencias_total"]),
        str(historial["num_incidencias_ultimos_6_meses"]),
        str(historial["tasa_reincidencia"]),
        str(historial["gravedad_media"]),
    }

    assert _numeros(texto) == numeros_del_dict
    assert historial["incidencia_mas_frecuente"] in texto


def test_formatear_evaluacion_proveedor_sin_historial():
    historial = calcular_historial_proveedor(_df_prueba(), "Z", fecha_referencia="2026-07-01")
    texto = formatear_evaluacion_historico(historial)

    assert _numeros(texto) == set()
