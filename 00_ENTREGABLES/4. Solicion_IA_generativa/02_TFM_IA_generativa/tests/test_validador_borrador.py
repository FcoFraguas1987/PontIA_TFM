from src.validador_borrador import comprobar_numeros_permitidos, extraer_numeros


def test_extraer_numeros_detecta_enteros_y_decimales_con_coma_y_punto():
    texto = "Registra 20 incidencias, tasa del 70,0% y gravedad media 3.55."
    assert extraer_numeros(texto) == {"20", "70,0", "3.55"}


def test_comprobar_numeros_permitidos_sin_discrepancias():
    texto = "Este proveedor registra 20 incidencias, con una tasa de reincidencia del 70,0%."
    numeros_permitidos = {"20", "70.0"}
    assert comprobar_numeros_permitidos(texto, numeros_permitidos) == []


def test_comprobar_numeros_permitidos_detecta_numero_inventado():
    texto = "Le ofrecemos una compensacion del 15% por las 3 incidencias detectadas."
    numeros_permitidos = {"3"}
    discrepancias = comprobar_numeros_permitidos(texto, numeros_permitidos)
    assert discrepancias == ["15"]


def test_comprobar_numeros_permitidos_equivalencia_entero_y_decimal():
    texto = "La tasa de reincidencia es del 70%."
    numeros_permitidos = {"70.0"}
    assert comprobar_numeros_permitidos(texto, numeros_permitidos) == []
