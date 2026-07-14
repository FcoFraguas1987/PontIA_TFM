import pandas as pd

from src.config import INCIDENCIAS_CSV_PATH
from src.generador import generar_borrador
from src.historial import calcular_historial_proveedor

FECHA_REFERENCIA = "2026-07-06"

PATRONES_REINCIDENCIA = ["reincidencia", "reincidente", "de nuevo", "reiterada", "reiterado", "nuevamente"]

TERMINOS_AMENAZA = [
    "penalizacion",
    "penalización",
    "sancion",
    "sanción",
    "rescindir",
    "ultima advertencia",
    "última advertencia",
    "exigimos",
]


def _generar(proveedor, incidencia_actual, tono, objetivo, mensaje_libre=None):
    df = pd.read_csv(INCIDENCIAS_CSV_PATH)
    historial = calcular_historial_proveedor(df, proveedor, FECHA_REFERENCIA)
    return generar_borrador(
        proveedor=proveedor,
        incidencia_actual=incidencia_actual,
        historial=historial,
        tono=tono,
        objetivo=objetivo,
        mensaje_libre=mensaje_libre,
    )


def test_caso_a_reincidencia_grave():
    borrador = _generar("A", "cadena_frio", "firme-pero-cordial", "exigir compensacion")
    texto = borrador.lower()
    assert any(patron in texto for patron in PATRONES_REINCIDENCIA)


def test_caso_b_leve_primera_vez():
    borrador = _generar("B", "documentacion_incorrecta", "conciliador", "avisar")
    texto = borrador.lower()
    assert not any(termino in texto for termino in TERMINOS_AMENAZA)


def test_caso_c_mensaje_libre():
    borrador = _generar(
        "C",
        "retraso_entrega",
        "formal",
        "pedir explicacion",
        mensaje_libre="recordarles el plazo de 48h para responder",
    )
    texto = borrador.lower()
    assert "48h" in texto or "48 horas" in texto
    assert "respond" in texto or "plazo" in texto
