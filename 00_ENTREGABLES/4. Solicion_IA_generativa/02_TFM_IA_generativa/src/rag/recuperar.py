from langchain_chroma import Chroma
from langchain_core.documents import Document
from langchain_ollama import OllamaEmbeddings

from src.config import CHROMA_DIR, EMBEDDING_MODEL


def buscar_emails_similares(query: str, k: int = 3) -> list[Document]:
    embeddings = OllamaEmbeddings(model=EMBEDDING_MODEL)
    vectorstore = Chroma(persist_directory=str(CHROMA_DIR), embedding_function=embeddings)
    return vectorstore.similarity_search(query, k=k)


if __name__ == "__main__":
    resultados = buscar_emails_similares("incidencia de cadena de frio reincidente", k=3)
    for doc in resultados:
        print(doc.metadata, "->", doc.page_content[:80])
