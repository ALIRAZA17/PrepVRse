from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate
from key import OpenApikey


def questionGeneration(extractedText):
    templateQA = """I am making an app where user can upload presentation slides and perform presentation by recording audio. I have extracted text from powerpoint slides given by user and providing it as content below. Now you need to generate 5 questions, which can be asked from the user at the end of his presentation in QA session and these questions should be in such a way to test user's understanding of different things present in the content which he may not have said during his presentation. Cause you know this is important that questions shouldnt be asking the same thing which the user might have already said during presentation. (ignore any irrelevant data as I have extracted data from the pptx file so there can be some data which doesnt make any sense. So just focus on the data. Also ignore data such as person names etc)".
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
        model_name="gpt-3.5-turbo-instruct",
        openai_api_key= OpenApikey,
        temperature=1
    )

    return openai(formattedTemplateQA)



