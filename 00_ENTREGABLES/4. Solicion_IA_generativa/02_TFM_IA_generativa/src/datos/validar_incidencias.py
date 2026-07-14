import pandas as pd

from src.config import CATEGORIAS_INCIDENCIA, FRUTAS, INCIDENCIAS_CSV_PATH

COLUMNAS_ESPERADAS = ["proveedor", "lote", "tiempo_compra", "precio_compra", "tipo", "incidencia"]


def validar_incidencias(df: pd.DataFrame) -> list[str]:
    problemas = []

    if list(df.columns) != COLUMNAS_ESPERADAS:
        problemas.append(f"Columnas inesperadas: {list(df.columns)} (se esperaba {COLUMNAS_ESPERADAS})")
        return problemas

    tipos_invalidos = set(df["tipo"]) - set(FRUTAS)
    if tipos_invalidos:
        problemas.append(f"Valores de 'tipo' no reconocidos: {sorted(tipos_invalidos)}")

    incidencias_invalidas = set(df["incidencia"]) - set(CATEGORIAS_INCIDENCIA)
    if incidencias_invalidas:
        problemas.append(f"Valores de 'incidencia' no reconocidos: {sorted(incidencias_invalidas)}")

    fechas = pd.to_datetime(df["tiempo_compra"], errors="coerce")
    if fechas.isna().any():
        problemas.append(f"{int(fechas.isna().sum())} fecha(s) invalida(s) en 'tiempo_compra'")

    precios = pd.to_numeric(df["precio_compra"], errors="coerce")
    if precios.isna().any() or (precios <= 0).any():
        problemas.append("Valores de 'precio_compra' invalidos o no positivos")

    if df["lote"].duplicated().any():
        problemas.append("Valores duplicados en 'lote'")

    if fechas.notna().any():
        fecha_referencia = fechas.max()
        hace_6_meses = fecha_referencia - pd.DateOffset(months=6)

        filas_a = df[(df["proveedor"] == "A") & (df["incidencia"] == "cadena_frio") & (fechas >= hace_6_meses)]
        if len(filas_a) < 1:
            problemas.append("Falta el caso sembrado del proveedor 'A' (cadena_frio en los ultimos 6 meses)")

        filas_b = df[df["proveedor"] == "B"]
        if len(filas_b) != 1:
            problemas.append(f"El proveedor 'B' debe tener exactamente 1 fila, tiene {len(filas_b)}")
        elif filas_b.iloc[0]["incidencia"] != "documentacion_incorrecta":
            problemas.append("La unica fila del proveedor 'B' debe ser 'documentacion_incorrecta'")

        filas_c = df[df["proveedor"] == "C"]
        if len(filas_c) < 1:
            problemas.append("Falta historial minimo para el proveedor 'C'")

    return problemas


if __name__ == "__main__":
    df = pd.read_csv(INCIDENCIAS_CSV_PATH)
    problemas = validar_incidencias(df)
    if problemas:
        for p in problemas:
            print(f"- {p}")
        print(f"{len(problemas)} problemas")
    else:
        print("0 problemas")
