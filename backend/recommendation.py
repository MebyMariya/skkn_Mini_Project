import pandas as pd

# Read data from CSV file
df = pd.read_csv('dataset.csv')  # Replace 'dataset.csv' with the actual CSV file name or path
with open('predicted_skin_type.txt', 'r') as file:
    skin_type = file.read().strip()

# Function to recommend skincare products based on skin type and experience level
def recommend_skincare_products(skin_type, experience_level, preferences=None):
    # Filter products based on skin type
    filtered_df = df[df['Skintype'] == skin_type]

    # Define product categories for each experience level
    product_categories = {
        'Beginner': ['Cleanser', 'Moisturizer', 'Lip balm', 'Sunscreen'],
        'Intermediate': ['Cleanser', 'Toner', 'Serum', 'Moisturizer', 'Lip balm', 'Sunscreen'],
        'Advanced': ['Cleanser', 'Exfoliant', 'Toner', 'Serum/ Essence/ oil', 'Mask', 'Treatment/ peel',
                     'Eye Cream/ Eye serum', 'Moisturizer', 'Lip Care', 'Sunscreen']
    }

    # Filter products based on experience level categories
    recommended_categories = product_categories.get(experience_level)
    if not recommended_categories:
        print(f"Error: Invalid experience level '{experience_level}'")
        return []

    # Filter products by recommended categories and generate recommendations
    recommendations = []
    for category in recommended_categories:
        category_products = filtered_df[filtered_df['product_type'] == category]['Product'].values.tolist()
        if preferences:
            category_products = [product for product in category_products if product not in preferences]
        recommendations.extend(category_products)

    return recommendations[:20]  # Limit recommendations to 9 products

# Ask the user to enter the experience level
def get_experience_level():
    while True:
        level = input("Enter your experience level (Beginner, Intermediate, Advanced): ")
        if level in ['Beginner', 'Intermediate', 'Advanced']:
            return level
        else:
            print("Invalid input. Please enter a valid experience level.")

# Example usage
experience_level = get_experience_level()  # Ask the user for experience level
preferences = []  # You can add user preferences here if needed
recommended_products = recommend_skincare_products(skin_type, experience_level, preferences)
print(f"Recommended Skincare Products for {experience_level} Level:")
for product in recommended_products:
    print(product)
