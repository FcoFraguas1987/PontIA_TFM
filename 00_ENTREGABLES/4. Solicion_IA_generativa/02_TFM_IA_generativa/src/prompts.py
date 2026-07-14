PLANTILLA_BORRADOR = """Eres un asistente del departamento de compras 
de una empresa de fruta. Tu tarea es redactar un borrador de email 
de respuesta a un proveedor ante una incidencia, en espanol, 
listo para revision humana.

## Datos de la incidencia actual
- Proveedor: {proveedor}
- Categoria de incidencia: {incidencia_actual}

## Evaluacion del historial del proveedor
{evaluacion_historico}

## Ejemplos de emails similares ya redactados (para inspirar el estilo, no copiar literalmente)
{ejemplos_rag}

## Instrucciones del usuario
- Tono deseado: {tono}
- Objetivo del email: {objetivo}
- Mensaje libre a incluir (si aplica): {mensaje_libre}

## Requisitos del borrador
- Estructura: asunto + cuerpo (saludo, referencia al lote/fecha, 
descripcion de la incidencia, mencion al historial si es relevante, 
peticion/objetivo si lo hay, cierre).
- Longitud orientativa: 100-180 palabras en el cuerpo.
- Refleja el tono solicitado.
- Menciona SOLO datos que existan en la incidencia o en la evaluacion 
del historial proporcionados arriba: no inventes cifras, 
fechas ni nombres que no aparezcan en esta informacion.
- Devuelve el asunto y el cuerpo, sin explicaciones adicionales.
"""


def construir_prompt_borrador(
    proveedor: str,
    incidencia_actual: str,
    evaluacion_historico: str,
    ejemplos_rag: list[str],
    tono: str,
    objetivo: str,
    mensaje_libre: str | None = None,
    plantilla: str = PLANTILLA_BORRADOR,
) -> str:
    ejemplos_texto = "\n\n".join(ejemplos_rag) if ejemplos_rag else "(sin ejemplos disponibles)"
    return plantilla.format(
        proveedor=proveedor,
        incidencia_actual=incidencia_actual,
        evaluacion_historico=evaluacion_historico,
        ejemplos_rag=ejemplos_texto,
        tono=tono,
        objetivo=objetivo,
        mensaje_libre=mensaje_libre or "(ninguno)",
    )
