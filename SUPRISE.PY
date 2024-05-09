import pandas as pd
from surprise import Reader, Dataset, SVD

# ... data preparation code (loading, encoding, etc.)

# Create a Surprise reader object
reader = Reader(rating_scale=(1, 5))  # Assuming ratings are between 1 and 5 (if using explicit ratings)

# Create a Surprise dataset object
data = Dataset.load_from_df(df[['user_id', 'product_id']], reader)

# Define the recommender algorithm (SVD in this example)
algo = SVD()

# Train the model
trainset = data.build_full_trainset()
algo.fit(trainset)
# Get user ID for whom you want recommendations
user_id = 123  # Replace with actual user ID

# Get top-N recommendations for the user
predictions = algo.predict(user_id, k=10)  # Recommend top 10 products

# Extract recommended product IDs and potentially additional info from your data
recommended_product_ids = [pred.iid for pred in predictions]
recommended_products = df[df['product_id'].isin(recommended_product_ids)]

# Display recommendations
print(recommended_products)
