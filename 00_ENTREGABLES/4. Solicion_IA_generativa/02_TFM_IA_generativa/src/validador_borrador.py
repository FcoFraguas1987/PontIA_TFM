import re


def extraer_numeros(texto: str) -> set[str]:
    return set(re.findall(r"\d+(?:[.,]\d+)?", texto))


def comprobar_numeros_permitidos(texto: str, numeros_permitidos: set[str]) -> list[str]:
    numeros_en_texto = extraer_numeros(texto)
    valores_permitidos = {float(n.replace(",", ".")) for n in numeros_permitidos}

    discrepancias = []
    for numero in numeros_en_texto:
        if float(numero.replace(",", ".")) not in valores_permitidos:
            discrepancias.append(numero)
    return discrepancias
