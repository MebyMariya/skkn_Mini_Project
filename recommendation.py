import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer
# Read data from CSV file
df = pd.read_csv('dataset.csv')  # Replace 'your_dataset.csv' with the actual CSV file name or path
with open('predicted_skin_type.txt', 'r') as file:
    skin_type = file.read().strip()
# Function to recommend skincare products based on skin type and preferences
def recommend_skincare_products(skin_type, preferences=None):
              # Filter products based on skin type
        filtered_df = df[df['Skintype'] == skin_type]
    except KeyError:
        print("Error: 'Skin type' column not found in the dataset.")
        return []
    #TF-IDF Vectorization for product descriptions
    tfidf_vectorizer = TfidfVectorizer()
    tfidf_matrix = tfidf_vectorizer.fit_transform(filtered_df['Concern'])
    # Calculate cosine similarity
    similarity_matrix = cosine_similarity(tfidf_matrix)
    # Get indices of top recommendations
    product_indices = similarity_matrix.argsort()[:, ::-1][0]
    # Exclude products already used by the user (if preferences are provided)
    if preferences:
        product_indices = [idx for idx in product_indices if df.iloc[idx]['Product'] not in preferences]

    # Generate product recommendations
    recommendations = df.iloc[product_indices[:3]]['Product'].values
    recommendations = df.iloc[product_indices[:9]]['Product'].values

    return recommendations

# Example usage
preferences = ['Product A']
recommended_products = recommend_skincare_products(skin_type, preferences)
print("Recommended Skincare Products:")
for product in recommended_products:
    print(product)