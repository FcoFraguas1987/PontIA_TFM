import pandas as pd

from src.config import GRAVEDAD_PESOS


def calcular_historial_proveedor(df: pd.DataFrame, proveedor: str, fecha_referencia) -> dict:
    df_prov = df[df["proveedor"] == proveedor].copy()
    df_prov["tiempo_compra"] = pd.to_datetime(df_prov["tiempo_compra"])
    fecha_referencia = pd.Timestamp(fecha_referencia)

    num_incidencias_total = len(df_prov)

    if num_incidencias_total == 0:
        return {
            "num_incidencias_total": 0,
            "num_incidencias_ultimos_6_meses": 0,
            "incidencia_mas_frecuente": None,
            "tasa_reincidencia": 0.0,
            "gravedad_media": 0.0,
        }

    hace_6_meses = fecha_referencia - pd.DateOffset(months=6)
    en_ultimos_6_meses = df_prov["tiempo_compra"].between(hace_6_meses, fecha_referencia)
    num_incidencias_ultimos_6_meses = int(en_ultimos_6_meses.sum())

    conteo_categorias = df_prov["incidencia"].value_counts()
    incidencia_mas_frecuente = conteo_categorias.idxmax()

    categorias_unicas = df_prov["incidencia"].nunique()
    tasa_reincidencia = (num_incidencias_total - categorias_unicas) / num_incidencias_total * 100

    gravedad_media = df_prov["incidencia"].map(GRAVEDAD_PESOS).mean()

    return {
        "num_incidencias_total": num_incidencias_total,
        "num_incidencias_ultimos_6_meses": num_incidencias_ultimos_6_meses,
        "incidencia_mas_frecuente": incidencia_mas_frecuente,
        "tasa_reincidencia": round(tasa_reincidencia, 2),
        "gravedad_media": round(gravedad_media, 2),
    }


def formatear_evaluacion_historico(historial: dict) -> str:
    if historial["num_incidencias_total"] == 0:
        return "Este proveedor no tiene incidencias previas registradas."

    partes = [
        f"Este proveedor registra {historial['num_incidencias_total']} incidencia(s) en total, "
        f"de las cuales {historial['num_incidencias_ultimos_6_meses']} se han producido recientemente.",
        f"La incidencia mas frecuente es '{historial['incidencia_mas_frecuente']}'.",
        f"La tasa de reincidencia en la misma categoria es del {historial['tasa_reincidencia']}%.",
        f"La gravedad media de sus incidencias es {historial['gravedad_media']}.",
    ]
    return " ".join(partes)
