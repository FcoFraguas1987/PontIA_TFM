import json

from src.config import CATEGORIAS_INCIDENCIA, CORPUS_EMAILS_PATH, TONOS

CAMPOS_ESPERADOS = {"tono", "categoria", "asunto", "cuerpo"}
MIN_PALABRAS_CUERPO = 50
MAX_PALABRAS_CUERPO = 250


def validar_corpus(lista_emails: list[dict]) -> list[str]:
    problemas = []

    for i, email in enumerate(lista_emails):
        if set(email.keys()) != CAMPOS_ESPERADOS:
            problemas.append(f"Email {i}: campos inesperados {sorted(email.keys())}")
            continue

        if email["tono"] not in TONOS:
            problemas.append(f"Email {i}: tono no reconocido '{email['tono']}'")

        if email["categoria"] not in CATEGORIAS_INCIDENCIA:
            problemas.append(f"Email {i}: categoria no reconocida '{email['categoria']}'")

        if not email["asunto"].strip():
            problemas.append(f"Email {i}: asunto vacio")

        cuerpo = email["cuerpo"].strip()
        if not cuerpo:
            problemas.append(f"Email {i}: cuerpo vacio")
        else:
            n_palabras = len(cuerpo.split())
            if n_palabras < MIN_PALABRAS_CUERPO or n_palabras > MAX_PALABRAS_CUERPO:
                problemas.append(f"Email {i}: cuerpo con {n_palabras} palabras, fuera de rango razonable")

    return problemas


def cargar_corpus_jsonl(path) -> tuple[list[dict], list[str]]:
    emails = []
    problemas = []
    with open(path, encoding="utf-8") as f:
        for i, linea in enumerate(f):
            linea = linea.strip()
            if not linea:
                continue
            try:
                emails.append(json.loads(linea))
            except json.JSONDecodeError as e:
                problemas.append(f"Linea {i}: JSON invalido ({e})")
    return emails, problemas


if __name__ == "__main__":
    emails, problemas_formato = cargar_corpus_jsonl(CORPUS_EMAILS_PATH)
    problemas = problemas_formato + validar_corpus(emails)
    if problemas:
        for p in problemas:
            print(f"- {p}")
        print(f"{len(problemas)} problemas")
    else:
        print("0 problemas")
