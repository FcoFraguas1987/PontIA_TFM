from langchain_chroma import Chroma
from langchain_core.documents import Document
from langchain_ollama import OllamaEmbeddings

from src.config import CHROMA_DIR, CORPUS_EMAILS_PATH, EMBEDDING_MODEL
from src.datos.validar_corpus import cargar_corpus_jsonl


def construir_indice(corpus_path=CORPUS_EMAILS_PATH, persist_dir=CHROMA_DIR) -> None:
    emails, _ = cargar_corpus_jsonl(corpus_path)
    documentos = [
        Document(
            page_content=email["cuerpo"],
            metadata={
                "tono": email["tono"],
                "categoria": email["categoria"],
                "asunto": email["asunto"],
            },
        )
        for email in emails
    ]
    embeddings = OllamaEmbeddings(model=EMBEDDING_MODEL)
    Chroma.from_documents(documentos, embeddings, persist_directory=str(persist_dir))


if __name__ == "__main__":
    construir_indice()
    print(f"Indice construido en {CHROMA_DIR}")
