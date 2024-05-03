from textstat import flesch_kincaid_grade

def analyze_and_classify_vocabulary_difficulty(text):
    try:
        # Calculate Flesch-Kincaid Grade Level
        grade_level = flesch_kincaid_grade(text)

        
        # Classify vocabulary difficulty
        if grade_level <= 5:
            difficulty_class = "Very Easy"
        elif 6 <= grade_level <= 8:
            difficulty_class = "Easy"
        elif 9 <= grade_level <= 12:
            difficulty_class = "Moderate"
        elif 13 <= grade_level <= 16:
            difficulty_class = "Difficult"
        else:
            difficulty_class = "Very Difficult"

        return grade_level, difficulty_class

    except Exception as e:
        print(f"Error: {e}")
        return None, None

# Example usage
# text = "In the realm of erudition, the quintessence of epistemological profundity lies in the synthesis of perspicacious exegesis and the adroit amalgamation of esoteric paradigms. This nascent intellectual tapestry, characterized by its ineffable intricacy, elucidates the imbrications of multifarious axioms within the purview of contemporary scholarship. The conscientious discernment of abstruse postulations necessitates a pedagogical metanoia, fostering a cognizant epistemic heuristic that transcends the conventional confines of disciplinary dichotomies. In such a cognitive milieu, the sagacious elucidation of ontological substrata presupposes an indefatigable intellectual rigor, propelling the scholarly dialectic towards the zenith of erudite sophistication."

# grade_level, difficulty_class = analyze_and_classify_vocabulary_difficulty(text)

# if grade_level is not None and difficulty_class is not None:
#     print(f"Flesch-Kincaid Grade Level: {grade_level}")
#     print(f"Vocabulary Difficulty Class: {difficulty_class}")
# else:
#     print("Error calculating the score.")
