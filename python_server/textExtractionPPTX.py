from langchain_community.document_loaders import UnstructuredPowerPointLoader

def textExtractionPPTX(path):
        
    loader = UnstructuredPowerPointLoader(path)
    data = loader.load_and_split()
    extractedText = data[0].page_content

    return extractedText