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


print(questionAnswer("How do memory mapped files improve I/O performance?", "Memory-mapped files improve I/O performance by allowing files to be accessed as if they were portions of memory, eliminating the need for explicit read and write operations. This approach reduces system calls and data copying overhead, leading to faster data access, especially for large files, and enabling efficient sharing of data between processes."))


# Answer from AI
# 1) That was a clear and concise explanation of the difference between private and shared memory mapped files. You highlighted the main differences and benefits of each type effectively. Great job!

# 2) Thank you for providing a detailed explanation of the `mmap()` function and its required arguments. Your answer was informative and well-organized. However, it would have been more helpful to also mention the purpose or benefits of using the `mmap()` function in a mockup interview scenario.

# 3) Great answer! You have properly explained the purpose and working of the `mmap()` function. You have also mentioned all the necessary arguments required when using it. Keep up the good work!

# 4) Great job explaining the concept of persisted and non-persisted memory mapped files! Your explanation is clear and concise, and you have provided a useful comparison between the two. It's important to consider performance needs and data durability when choosing between the two options, and you have effectively highlighted this. Keep up the good work!

# 5) Great response! You have clearly explained the difference between persisted and non-persisted memory-mapped files, as well as their importance in an application. Your answer is informative and easy to understand. Keep up the good work! 





