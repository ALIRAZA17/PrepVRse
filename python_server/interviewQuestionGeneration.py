from langchain_community.llms import OpenAI
from langchain.prompts import PromptTemplate
from key import OpenApikey

# formData = {
#     "jd": "",
#     "position": "",
#     "experience": ""
# }
def interviewQuestionGeneration(extractedText, formData):
    print('in interview function')
    templateQA = """I am making an app where user will upload resume for a mockup interview in my VR app. I have extracted text from the resume and providing it as content below. The following is a resume and profile information for a job applicant. Based on this information, generate 10 questions that a Technical HR representative might ask the applicant. Give importance to job description & position and ask questions which an interviewer asks. (ignore any irrelevant data as I have extracted data from the pdf file so there can be some data which does not make any sense. So just focus on the data.)".
    If no question can be generated from the provided content then just reply in a professional manner.

    Profile Questions:
    1. Job Description: [{jd}]
    2. Position Applying For: [{position}]
    3. Relevant Experience: [{experience}]

    Resume Content: [{query}]

    Answer: """
    
    
    # templateQA = """I am making an app where user will upload resume for a mockup interview in my VR app. I have extracted text from the resume and providing it as content below. The following is a resume and profile information for a job applicant. Based on this information, generate 10 questions that an HR representative might ask the applicant. Give importance to job description & position and ask questions which an interviewer asks. (ignore any irrelevant data as I have extracted data from the pdf file so there can be some data which does not make any sense. So just focus on the data.)".
    # If no question can be generated from the provided content then just reply in a professional manner.

    # Profile Questions:
    # 1. Job Description: [{jd}]
    # 2. Position Applying For: [{position}]
    # 3. Relevant Experience: [{experience}]

    # Resume Content will have this sequence:
    # Name
    # Description
    # Email Address
    # Phone Number
    # Address
    # Some URLs
    # Education Section
    # Work Experience Section
    # Skills Section
    # Projects Section
    # Languages Section
    
    # Resume Content: [{query}]

    # Answer: """
    

    # create a prompt template for QA
    promptTemplateQA = PromptTemplate(
        input_variables=["query", 'jd', 'position', 'experience'],
        template=templateQA
    )
    # print("prompt template: ", promptTemplateQA)

    formattedTemplateQA = promptTemplateQA.format(
            query=extractedText,
            jd=formData["jd"],
            position=formData["position"],
            experience=formData["experience"]
        )
    
    # print("Formatted template: ", formattedTemplateQA)
    
    # initialize the models
    openaiModel = OpenAI(
        model_name="gpt-3.5-turbo-instruct",
        openai_api_key= OpenApikey,
        temperature=1
    )
    
    return openaiModel(formattedTemplateQA)
    

