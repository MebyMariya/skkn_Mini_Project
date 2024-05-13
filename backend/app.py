import csv

# Load the CSV file and store its data in a list of dictionaries
def load_data(file_path):
    data = []
    with open(file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            data.append(row)
    return data

# Check if selected options match any row in the data
def check_match(data, selected_options):
    for row in data:
        match_count = 0
        for key, value in selected_options.items():
            if row[key] == value:
                match_count += 1
        if match_count >= 3:  # Adjust the threshold as needed
            return row['Skin Type']
    return None

# Store the skin type to a .txt file
def store_skin_type(skin_type, output_file):
    with open(output_file, 'w') as txtfile:
        txtfile.write(skin_type)

# Example usage
if __name__ == "__main__":
    # Sample selected options from the front end
    selected_options = {
        'Oily T-Zone': 'A',
        'Tight After Cleansing': 'B',
        'Dry Patches': 'C',
        'Reacts to Products': 'D',
        'Redness/Stinging': 'D',
        'Sun Sensitivity': 'A'
        # Add more selected options as needed
    }

    # Load data from the CSV file
    data = load_data('C:\\flutterapps\\skkn\\backend\\qna.csv')

    # Check for a match and get the skin type
    matched_skin_type = check_match(data, selected_options)

    if matched_skin_type:
        # Store the matched skin type to a .txt file
        store_skin_type(matched_skin_type, 'matched_skin_type.txt')
        print(f"Match found! Skin type: {matched_skin_type}")
    else:
        print("No match found.")
