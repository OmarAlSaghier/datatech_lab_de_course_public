import pandas as pd
import psycopg2


def extract_db_data():
    try:
        # Connecting to DB
        src_conn = psycopg2.connect(
            host="localhost",
            port=5432,
            database="postgres",
            user="postgres",
            password="postgres"
        )
        
        # Creating up the cursor
        src_cursor = src_conn.cursor()

        # Execute query to select data
        src_cursor.execute("SELECT * FROM src_table")
        
        # Fetch all data from executed query
        src_data = src_cursor.fetchall()

        # Parse fetched data in pandas df
        src_data = pd.DataFrame(src_data, \
            columns=['car_id','car_model','year_of_manufacture','price', 'fuel', 'year_of_selling'])

        return src_data, src_conn

    except Exception as exp:
        return(f"Error occured in extract_db: {exp}")

    finally:
        src_conn.close()


if __name__ == '__main__':
    df, _ = extract_db_data()
    print("Extracted data Frame: ", df)