import pandas as pd

from src.validacion_inputs import validar_inputs_cli


def _df_prueba():
    return pd.DataFrame(
        [{"proveedor": "A", "lote": "L-1", "tiempo_compra": "2026-01-01", "precio_compra": 1.0, "tipo": "manzana", "incidencia": "cadena_frio"}]
    )


def test_inputs_validos_no_reportan_errores():
    errores = validar_inputs_cli(_df_prueba(), "A", "cadena_frio", "formal", "avisar")
    assert errores == []


def test_proveedor_inexistente():
    errores = validar_inputs_cli(_df_prueba(), "Z", "cadena_frio", "formal", "avisar")
    assert any("Proveedor" in e for e in errores)


def test_incidencia_no_reconocida():
    errores = validar_inputs_cli(_df_prueba(), "A", "envio_perdido", "formal", "avisar")
    assert any("Incidencia" in e for e in errores)


def test_tono_no_valido():
    errores = validar_inputs_cli(_df_prueba(), "A", "cadena_frio", "agresivo", "avisar")
    assert any("Tono" in e for e in errores)


def test_objetivo_no_valido():
    errores = validar_inputs_cli(_df_prueba(), "A", "cadena_frio", "formal", "amenazar")
    assert any("Objetivo" in e for e in errores)
