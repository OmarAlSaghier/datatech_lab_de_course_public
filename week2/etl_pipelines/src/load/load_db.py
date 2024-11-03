from sqlalchemy import create_engine


def load_db_data(data_to_load, db_conn):
    try:
        engine = create_engine('postgresql://postgres:postgres@localhost:5433/postgres')
        data_to_load.to_sql('dest_table', engine, if_exists='append', index=False)

    except Exception as exp:
        print(f"Error occurred in load batches: {exp}")
        return False

    finally:
        db_conn.commit()
        db_conn.close()
