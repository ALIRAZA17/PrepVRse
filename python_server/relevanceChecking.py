from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate
from key import OpenApikey

def relevanceChecking(extractedText, spokenText):

    templateRelevance = """I am making an app in which user will upload presentation slides and then record his speech. Now we need to measure relevance between the contexts of slides content and his speech content, basically to determine is he doing presentation in accordance with context of the content. I have extracted text from powerpoint slides given by user and providing it as content below. I have converted speech to text and providing it as well. Now you need to show relevance or irrelevance between the two texts in form of a paragraph highlighting ups and downs if there are any. (ignore any irrelevant data including profile data as I have extracted data from the pptx file and speech so there can be some data which doesnt make any sense. So just focus on the data.)".

    Content: {slide}

    Spoken Speech Text: {spoken}

    Answer: """


    # create a prompt template for QA
    promptTemplateRelevance = PromptTemplate(
        input_variables=["slide", "spoken"],
        template=templateRelevance
    )

    slideContent = extractedText
    spokenContent = spokenText

    formattedTemplateRelevance = promptTemplateRelevance.format(
            slide = slideContent, spoken = spokenContent
        )


    # initialize the models
    openai = OpenAI(
        model_name="text-davinci-003",
        openai_api_key=OpenApikey,
        temperature=1
    )

    return openai(formattedTemplateRelevance)

