from datetime import datetime
import pandas as pd


def transform_db_data(data, db_conn):
    try:
        # Creating up the cursor
        dest_cursor = db_conn.cursor()
        # Created destination table
        dest_cursor.execute(
            """CREATE TABLE IF NOT EXISTS dest_table(
                car_id serial PRIMARY KEY,
                car_model VARCHAR(50),
                year_of_manufacture INT,
                price FLOAT8,
                fuel VARCHAR(50),
                year_of_selling DATE)
            """
        )
        
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
        
        return data, db_conn

    except Exception as exp:
        return(f"Error occured in load batches: {exp}")
    
    finally:
        db_conn.commit()