import pandas as pd


def extract_db_data(src_cursor):
    try:

        # Execute query to select data
        src_cursor.execute(f"SELECT * FROM src_table")
        
        # Fetch all data from executed query
        src_data = src_cursor.fetchall()

        # Parse fetched data in pandas df
        src_data = pd.DataFrame(src_data, \
            columns=['car_id','car_model','year_of_manufacture','price', 'fuel', 'year_of_selling'])

        return src_data

    except Exception as exp:
        return(f"Error occured in extract_db: {exp}")


if __name__ == '__main__':
    df = extract_db_data()
    print("Extracted data Frame: ", df)