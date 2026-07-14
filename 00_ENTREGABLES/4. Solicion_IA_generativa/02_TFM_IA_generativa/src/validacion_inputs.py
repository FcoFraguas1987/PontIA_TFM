import pandas as pd

from src.config import CATEGORIAS_INCIDENCIA, OBJETIVOS, TONOS


def validar_inputs_cli(df: pd.DataFrame, proveedor: str, incidencia_actual: str, tono: str, objetivo: str) -> list[str]:
    errores = []

    if proveedor not in set(df["proveedor"]):
        errores.append(f"Proveedor '{proveedor}' no existe en incidencias.csv")

    if incidencia_actual not in CATEGORIAS_INCIDENCIA:
        errores.append(f"Incidencia '{incidencia_actual}' no reconocida. Valores validos: {CATEGORIAS_INCIDENCIA}")

    if tono not in TONOS:
        errores.append(f"Tono '{tono}' no reconocido. Valores validos: {TONOS}")

    if objetivo not in OBJETIVOS:
        errores.append(f"Objetivo '{objetivo}' no reconocido. Valores validos: {OBJETIVOS}")

    return errores
