from datetime import datetime
import pandas as pd


def transform_data(data):
    try:
        print(f"data shape before is: {data.shape}")

        # Rounding decimal digits
        data['price'] = round(data.price, 2)

        # Parsing Dates in year_of_selling column
        print(f"year_of_selling data type before: {type(data['year_of_selling'][0])}")

        # Converting year_of_selling to datetime type
        data['year_of_selling'] = pd.to_datetime(data['year_of_selling'])

        # Parse year_of_selling into format
        data['year_of_selling'].apply(lambda x: None if pd.NaT else x.strftime('%Y%m%d'))

        print(f"year_of_selling data type after: {type(data['year_of_selling'][0])}")

        # Removing rows with year_of_manufacture more than recent year
        current_year = datetime.today().year
        data = data[data["year_of_manufacture"] <= current_year]

        print(f"data shape after is: {data.shape}")

        return data

    except Exception as exp:
        return(f"Error occured in transform_data: {exp}")


if __name__ == "__main__":
    df = pd.read_csv("data_files/dealership_data/used_car_prices1.csv")
    print(df.head(10))
    df_t = transform_data(df)
    print(df_t.head(10))
