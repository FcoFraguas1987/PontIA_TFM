from src.datos.validar_corpus import validar_corpus

EMAIL_BUENO = {
    "tono": "formal",
    "categoria": "retraso_entrega",
    "asunto": "Retraso en la entrega del lote L-1234",
    "cuerpo": " ".join(["palabra"] * 120),
}


def test_corpus_bueno_no_reporta_problemas():
    assert validar_corpus([EMAIL_BUENO, EMAIL_BUENO]) == []


def test_detecta_email_vacio():
    email = dict(EMAIL_BUENO, cuerpo="   ")
    problemas = validar_corpus([email])
    assert any("cuerpo vacio" in p for p in problemas)


def test_detecta_categoria_invalida():
    email = dict(EMAIL_BUENO, categoria="envio_perdido")
    problemas = validar_corpus([email])
    assert any("categoria no reconocida" in p for p in problemas)


def test_detecta_tono_invalido():
    email = dict(EMAIL_BUENO, tono="agresivo")
    problemas = validar_corpus([email])
    assert any("tono no reconocido" in p for p in problemas)


def test_detecta_longitud_fuera_de_rango():
    email = dict(EMAIL_BUENO, cuerpo="muy corto")
    problemas = validar_corpus([email])
    assert any("fuera de rango" in p for p in problemas)


def test_detecta_campos_faltantes():
    email = {"tono": "formal", "categoria": "retraso_entrega", "asunto": "x"}
    problemas = validar_corpus([email])
    assert any("campos inesperados" in p for p in problemas)
