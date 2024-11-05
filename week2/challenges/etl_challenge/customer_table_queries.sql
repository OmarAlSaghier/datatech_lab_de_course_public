CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    join_date DATE,
    location VARCHAR(100)
);

INSERT INTO customers (customer_id, name, email, join_date, location) 
VALUES
    (1, 'Alice Johnson', 'alice.johnson@example.com', '2023-01-15', 'New York, NY'),
    (2, 'Bob Smith', 'bob.smith@example.com', '2023-02-20', 'Los Angeles, CA'),
    (3, 'Charlie Brown', 'charlie.brown@example.com', '2023-03-05', 'Chicago, IL'),
    (4, 'Daisy Miller', 'daisy.miller@example.com', '2023-04-12', 'Houston, TX'),
    (5, 'Ethan Davis', 'ethan.davis@example.com', '2023-05-08', 'Phoenix, AZ'),
    (6, 'Fiona Clark', 'fiona.clark@example.com', '2023-06-17', 'Philadelphia, PA'),
    (7, 'George Lewis', 'george.lewis@example.com', '2023-07-03', 'San Antonio, TX'),
    (8, 'Hannah Turner', 'hannah.turner@example.com', '2023-08-25', 'San Diego, CA'),
    (9, 'Ian White', 'ian.white@example.com', '2023-09-13', 'Dallas, TX'),
    (10, 'Jack Wilson', 'jack.wilson@example.com', '2023-10-01', 'San Jose, CA')
;

