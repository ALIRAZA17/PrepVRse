from langchain_community.document_loaders import PyPDFLoader


def textExtractionPDF(path):
    loader = PyPDFLoader(path)
    pages = loader.load_and_split()
    extractedText = pages[0].page_content

    return extractedText