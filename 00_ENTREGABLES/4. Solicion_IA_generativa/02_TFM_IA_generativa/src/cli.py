import argparse
import sys
from datetime import date

import pandas as pd

from src.config import INCIDENCIAS_CSV_PATH
from src.generador import generar_borrador
from src.historial import calcular_historial_proveedor
from src.validacion_inputs import validar_inputs_cli


def main():
    parser = argparse.ArgumentParser(
        description="Genera un borrador de email de respuesta a una incidencia de compras."
    )
    parser.add_argument("--proveedor", required=True)
    parser.add_argument("--incidencia", required=True, dest="incidencia_actual")
    parser.add_argument("--tono", required=True)
    parser.add_argument("--objetivo", required=True)
    parser.add_argument("--mensaje-libre", default=None, dest="mensaje_libre")
    parser.add_argument(
        "--fecha-referencia",
        default=None,
        help="AAAA-MM-DD usada para calcular el historial; por defecto, hoy.",
    )
    args = parser.parse_args()

    fecha_referencia = args.fecha_referencia or date.today().isoformat()

    df = pd.read_csv(INCIDENCIAS_CSV_PATH)

    errores = validar_inputs_cli(df, args.proveedor, args.incidencia_actual, args.tono, args.objetivo)
    if errores:
        for error in errores:
            print(f"Error: {error}", file=sys.stderr)
        sys.exit(1)

    historial = calcular_historial_proveedor(df, args.proveedor, fecha_referencia)

    borrador = generar_borrador(
        proveedor=args.proveedor,
        incidencia_actual=args.incidencia_actual,
        historial=historial,
        tono=args.tono,
        objetivo=args.objetivo,
        mensaje_libre=args.mensaje_libre,
    )
    print(borrador)


if __name__ == "__main__":
    main()
