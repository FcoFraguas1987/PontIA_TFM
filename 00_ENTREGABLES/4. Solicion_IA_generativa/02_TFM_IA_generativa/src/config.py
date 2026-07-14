from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = PROJECT_ROOT / "data"
INCIDENCIAS_CSV_PATH = DATA_DIR / "incidencias.csv"
CORPUS_EMAILS_PATH = DATA_DIR / "corpus_emails.jsonl"
CHROMA_DIR = DATA_DIR / "chroma"

LLM_MODEL = "qwen3:8b"
EMBEDDING_MODEL = "bge-m3"

CATEGORIAS_INCIDENCIA = [
    "retraso_entrega",
    "calidad_producto",
    "cantidad_incorrecta",
    "producto_danado",
    "variedad_incorrecta",
    "documentacion_incorrecta",
    "precio_incorrecto",
    "cadena_frio",
]

FRUTAS = [
    "manzana",
    "pera",
    "platano",
    "naranja",
    "limon",
    "fresa",
    "uva",
    "melocoton",
    "ciruela",
    "sandia",
    "melon",
    "pina",
    "kiwi",
    "mango",
    "aguacate",
]

GRAVEDAD_PESOS = {
    "cadena_frio": 5,
    "producto_danado": 4,
    "calidad_producto": 4,
    "cantidad_incorrecta": 3,
    "variedad_incorrecta": 3,
    "retraso_entrega": 2,
    "precio_incorrecto": 2,
    "documentacion_incorrecta": 1,
}

TONOS = ["formal", "firme-pero-cordial", "conciliador"]

OBJETIVOS = [
    "pedir explicacion",
    "exigir compensacion",
    "avisar",
    "cerrar incidencia",
]
