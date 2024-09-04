create table if not exists src_table(
	car_id serial PRIMARY KEY,
	car_model VARCHAR(50),
	year_of_manufacture INT,
	price FLOAT8,
	fuel VARCHAR(50),
	year_of_selling DATE
);

COPY src_table(car_model,year_of_manufacture,price,fuel,year_of_selling)
FROM '/data/src_data/src_data.csv'
DELIMITER ','
CSV HEADER;