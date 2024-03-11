from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate
from key import OpenApikey


def lineSeparator(extractedText):

    templateQA = """I am making an app where user can record audio and get back the extracted text from the audio. I have extracted text from the audio and providing it as content below. There is one problem with the extracted text that its not catering sentence structure. Now you need to add punctuations according to the context of the content and return only the puntuated text as answer. (ignore any abnormal data as I have extracted data from the audio file so there can be some data which doesnt make any sense. So just focus on the completing sentences with periods."

    Content: {query}

    Answer: """

    # create a prompt template for QA
    promptTemplateLineSep = PromptTemplate(
        input_variables=["query"],
        template=templateQA
    )

    contentLineSep = extractedText

    formattedTemplateLineSep = promptTemplateLineSep.format(
            query=contentLineSep
        )

    # initialize the models
    openai = OpenAI(
        model_name="gpt-3.5-turbo-instruct",
        openai_api_key= OpenApikey,
        temperature=0.5
    )

    
    return openai(formattedTemplateLineSep)
