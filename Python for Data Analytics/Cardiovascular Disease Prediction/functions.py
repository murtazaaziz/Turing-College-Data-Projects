def load_csv(path, index_col=None):

    import pandas as pd

    df = pd.read_csv(path, index_col=False)

    print(f"Loaded {path} successfully.")
    return df

def sanity_check(df):

    df.info()
    print("\nDataframe shape:", df.shape)
    print("\nDuplicate rows:", df.duplicated().sum())
    if "address" in df.columns:
        print("Duplicate addresses:",
              df["address"].duplicated().sum())

    # Print sorted percentage of missing values per column
    missing_percent = df.isna().mean().round(4) * 100
    missing_percent = missing_percent[missing_percent > 0].sort_values(
        ascending=False)
    print("\n Percent of columns with missing values (sorted):")
    print(missing_percent)

    return df

def clean_data(df):
    import pandas as pd

    # Removing whitespaces, lower casing, replacing spaces with underscores
    df.columns = df.columns.str.strip().str.replace(' ', '_')

    # If column name has more than one word, remove underscores between words and snake case to camel case
    df.columns = [''.join([word.capitalize() if i != 0 else word for i, word in enumerate(col.split('_'))]) for col in df.columns]

    # Renaming specific columns for consistency
    df = df.rename(columns={"BPMeds": "bpMeds", "TenYearCHD": "tenYearCHD"})

    # Drop duplicates
    df = df.drop_duplicates()

    # Convert isSmoking to binary and int data type
    df['isSmoking'] = df['isSmoking'].apply(lambda x: 1 if x == 'YES' else 0)
    
    # Convert sex to binary (Male = 1, Female = 0)
    df["sexBinary"] = df["sex"].map({"M": 0, "F": 1})
    df = df.drop(columns=["sex"])

    # Move 'sexBinary' column to second column position
    df.insert(1, 'sexBinary', df.pop('sexBinary'))

    # Change data types
    df['isSmoking'] = df['isSmoking'].astype(int)

    # Final sanity check after cleaning
    print("\nAfter Cleaning:")
    df.info()
    missing_percent = df.isna().mean().round(4) * 100
    missing_percent = missing_percent[missing_percent > 0].sort_values(
        ascending=False)
    if not missing_percent.empty:
        print("\n Columns with missing values (sorted):")
        print(missing_percent)
    else:
        print("\n No missing values in the dataframe.")

    return df