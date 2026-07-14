from langchain_ollama import ChatOllama

from src.config import LLM_MODEL
from src.historial import formatear_evaluacion_historico
from src.prompts import PLANTILLA_BORRADOR, construir_prompt_borrador
from src.rag.recuperar import buscar_emails_similares


def _formatear_ejemplo_rag(doc) -> str:
    categoria = doc.metadata.get("categoria", "?")
    tono = doc.metadata.get("tono", "?")
    return f"({categoria}, {tono}): {doc.page_content}"


def construir_prompt_completo(
    proveedor: str,
    incidencia_actual: str,
    historial: dict,
    tono: str,
    objetivo: str,
    mensaje_libre: str | None = None,
    plantilla: str = PLANTILLA_BORRADOR,
) -> str:
    evaluacion_historico = formatear_evaluacion_historico(historial)

    ejemplos_docs = buscar_emails_similares(f"incidencia de {incidencia_actual}", k=3)
    ejemplos_rag = [_formatear_ejemplo_rag(doc) for doc in ejemplos_docs]

    return construir_prompt_borrador(
        proveedor=proveedor,
        incidencia_actual=incidencia_actual,
        evaluacion_historico=evaluacion_historico,
        ejemplos_rag=ejemplos_rag,
        tono=tono,
        objetivo=objetivo,
        mensaje_libre=mensaje_libre,
        plantilla=plantilla,
    )


def generar_borrador(
    proveedor: str,
    incidencia_actual: str,
    historial: dict,
    tono: str,
    objetivo: str,
    mensaje_libre: str | None = None,
) -> str:
    prompt = construir_prompt_completo(proveedor, incidencia_actual, historial, tono, objetivo, mensaje_libre)
    llm = ChatOllama(model=LLM_MODEL)
    respuesta = llm.invoke(prompt)
    return respuesta.content
