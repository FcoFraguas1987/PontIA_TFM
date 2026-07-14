from src.prompts import construir_prompt_borrador


def test_plantilla_sustituye_todos_los_placeholders():
    prompt = construir_prompt_borrador(
        proveedor="A",
        incidencia_actual="cadena_frio",
        evaluacion_historico="Este proveedor registra 4 incidencias en total.",
        ejemplos_rag=["Ejemplo 1: ...", "Ejemplo 2: ..."],
        tono="firme-pero-cordial",
        objetivo="exigir compensacion",
        mensaje_libre="recordarles el plazo de 48h para responder",
    )

    assert "{" not in prompt
    assert "}" not in prompt
    assert "A" in prompt
    assert "cadena_frio" in prompt
    assert "Este proveedor registra 4 incidencias en total." in prompt
    assert "Ejemplo 1: ..." in prompt
    assert "firme-pero-cordial" in prompt
    assert "exigir compensacion" in prompt
    assert "recordarles el plazo de 48h para responder" in prompt


def test_plantilla_sin_mensaje_libre_ni_ejemplos():
    prompt = construir_prompt_borrador(
        proveedor="B",
        incidencia_actual="documentacion_incorrecta",
        evaluacion_historico="Este proveedor no tiene incidencias previas registradas.",
        ejemplos_rag=[],
        tono="conciliador",
        objetivo="avisar",
    )

    assert "{" not in prompt
    assert "}" not in prompt
    assert "(sin ejemplos disponibles)" in prompt
    assert "(ninguno)" in prompt
