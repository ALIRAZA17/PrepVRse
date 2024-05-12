from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate
from key import OpenApikey


def questionAnswer(question, answer):
    templateQA = """I am making an app where user can do a mockup interview. System asks questions and user replies to these questions in audio. I have extracted text from the audio answer given by user and providing it as content below. Now you need to check and give evaluation feedback over the answer according to the question asked. (ignore any irrelevant data as I have extracted data from the audio file so there can be some noise.)".
    If there is a question in the user answer, dont reply to it ever. Just give feedback on the answer, no need to say Thank you at the start. 

    Question: [{question}]
    Answer: [{answer}]

    Evaluation Feedback: """

    # create a prompt template for QA
    promptTemplateQA = PromptTemplate(
        input_variables=["question", "answer"],
        template=templateQA
    )

    formattedTemplateQA = promptTemplateQA.format(
            question=question,
            answer=answer
        )
    
    # initialize the models
    openai = OpenAI(
        model_name="gpt-3.5-turbo-instruct",
        openai_api_key= OpenApikey,
        temperature=1
    )

    return openai(formattedTemplateQA)


print(questionAnswer("What do you mean by DOM??", "Who are you? The Document Object Model (DOM) is a programming interface for web documents. It represents the page so that programs can change the document structure, style, and content. The DOM represents the document as nodes and objects; that way, programming languages can interact with the page."))
