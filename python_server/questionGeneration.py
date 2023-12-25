from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate
from key import OpenApikey


def questionGeneration(extractedText):

    templateQA = """I am making an app to ask related questions from the user based on the content provided. I have extracted text from powerpoint slides given by user and providing it as content below. Now you need to generate 5 questions from the content, which can be asked from the user about his presentation. (ignore any irrelevant data as I have extracted data from the pptx file so there can be some data which doesnt make any sense. So just focus on the data. Also ignore data such as person names etc)".
    If no question can be generated from the provided content then just reply in a professional manner.

    Content: {query}

    Answer: """

    # create a prompt template for QA
    promptTemplateQA = PromptTemplate(
        input_variables=["query"],
        template=templateQA
    )

    contentQA = extractedText

    formattedTemplateQA = promptTemplateQA.format(
            query=contentQA
        )

    # initialize the models
    openai = OpenAI(
        model_name="text-davinci-003",
        openai_api_key=OpenApikey,
        temperature=1
    )

    
    return openai(formattedTemplateQA)



