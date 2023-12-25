import nltk
from nltk.sentiment import SentimentIntensityAnalyzer

# Download the VADER lexicon for sentiment analysis
nltk.download('vader_lexicon')

def analyze_and_classify_sentiment(text, high_positive_threshold=0.6, low_negative_threshold=-0.6):
    # Initialize the VADER sentiment analyzer
    sid = SentimentIntensityAnalyzer()

    # Get the sentiment scores
    sentiment_scores = sid.polarity_scores(text)

    # Extract the compound sentiment score
    sentiment_score = sentiment_scores['compound']

    # Classify sentiment
    if sentiment_score > high_positive_threshold:
        sentiment_class = "Very Positive"
    elif high_positive_threshold >= sentiment_score > 0:
        sentiment_class = "Positive"
    elif -low_negative_threshold < sentiment_score < low_negative_threshold:
        sentiment_class = "Neutral"
    elif 0 > sentiment_score >= -low_negative_threshold:
        sentiment_class = "Negative"
    elif sentiment_score == 0:
        sentiment_class = "Neutral"
    else:
        sentiment_class = "Very Negative"

    return sentiment_score, sentiment_class

# Example usage
# text = "I am a boy"
# sentiment_score, sentiment_class = analyze_and_classify_sentiment(text)

# print(f"Sentiment Score: {sentiment_score:.4f}")
# print(f"Sentiment Class: {sentiment_class}")
