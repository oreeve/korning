-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS frequency;

CREATE TABLE customer(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  account VARCHAR(100)
);

CREATE TABLE employee(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE frequency(
  id SERIAL PRIMARY KEY,
  frequency VARCHAR(100)
);

CREATE TABLE sales(
  id SERIAL PRIMARY KEY,
  date DATE,
  emp_id INTEGER REFERENCES employee(id),
  cust_id INTEGER REFERENCES customer(id),
  product VARCHAR(100),
  amount MONEY,
  units INTEGER,
  inv_num INTEGER,
  frequency INTEGER REFERENCES frequency(id)
);
