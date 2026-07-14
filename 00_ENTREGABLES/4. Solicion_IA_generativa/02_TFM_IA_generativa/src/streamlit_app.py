import sys
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

import pandas as pd
import streamlit as st

from src.config import CATEGORIAS_INCIDENCIA, INCIDENCIAS_CSV_PATH, OBJETIVOS, TONOS
from src.generador import generar_borrador
from src.historial import calcular_historial_proveedor
from src.validacion_inputs import validar_inputs_cli

st.title("Borrador de email ante incidencia de compras")

df = pd.read_csv(INCIDENCIAS_CSV_PATH)

with st.form("form_borrador"):
    proveedor = st.text_input("Proveedor")
    incidencia_actual = st.selectbox("Categoria de incidencia", CATEGORIAS_INCIDENCIA)
    tono = st.selectbox("Tono deseado", TONOS)
    objetivo = st.selectbox("Objetivo", OBJETIVOS)
    mensaje_libre = st.text_input("Mensaje libre (opcional)")
    enviado = st.form_submit_button("Generar borrador")

if enviado:
    errores = validar_inputs_cli(df, proveedor, incidencia_actual, tono, objetivo)
    if errores:
        for error in errores:
            st.error(error)
    else:
        with st.spinner("Generando borrador..."):
            historial = calcular_historial_proveedor(df, proveedor, date.today().isoformat())
            borrador = generar_borrador(
                proveedor=proveedor,
                incidencia_actual=incidencia_actual,
                historial=historial,
                tono=tono,
                objetivo=objetivo,
                mensaje_libre=mensaje_libre or None,
            )
        st.text_area("Borrador generado", borrador, height=400)
