CREATE TABLE menu(
product_id int PRIMARY KEY,
product_name varchar(20),
price int);

INSERT INTO menu 
VALUES(1,'sushi',10),(2,'curry',15),(3,'ramen',12);

CREATE TABLE members(
customer_id varchar(2) PRIMARY KEY,
join_date date);

INSERT INTO members
VALUES('A','2021-01-07'), ('B','2021-01-09');

CREATE TABLE sales(
customer_id varchar(2) ,
order_date date,
product_id int,
FOREIGN KEY (customer_id) references members(customer_id),
FOREIGN KEY (product_id) REFERENCES menu(product_id)
);
INSERT INTO sales 
VALUES('A', '2021-01-01',1),
	('A', '2021-01-01',2),
    ('A', '2021-01-07',2),
    ('A', '2021-01-10',3),
    ('A', '2021-01-11',3),
    ('A', '2021-01-11',3),
    
    ('B', '2021-01-01',2),
    ('B', '2021-01-02',2),
    ('B', '2021-01-04',1),
    ('B', '2021-01-11',1),
    ('B', '2021-01-16',3),
    ('B', '2021-02-01',3),
    
    ('A', '2021-01-01',3),
    ('A', '2021-01-01',3),
    ('A', '2021-01-07',3)
