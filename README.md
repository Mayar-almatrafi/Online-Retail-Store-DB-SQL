# Online Retail Store — Database Systems Final Project

This repository contains a **Database Systems project** for an **Online Retail Store**.  
It includes the full database implementation (DDL + constraints), sample data inserts, and example SQL queries.

## Files in this repo
- **`Online-Retail Store SQL.sql`**  
  Main SQL script that includes:
  - Table creation (DDL) + primary/foreign keys + CHECK/UNIQUE constraints
  - Sample inserts (DML)
  - Example queries (SELECT)

- **`Sql Database project.pdf`**  
  Project report (design + explanation + diagrams/output).

---

## Database Overview (Core Tables)
The database models typical e-commerce operations:

- **Category**: categories with validation flags (Apparel/Electronics/Makeup/…)
- **Customer2**: customer profile + loyalty balance + customer type
- **Product1**: products with price/stock and category reference
- **Orders**: orders linked to customers + order status
- **Order_Detail**: line items (order × product) with quantity + subtotal rule
- **Inventory**: stock availability + reorder level per product
- **Payment**: payment record linked to an order + payment type rules (CARD / CASH / DEFERRED)
- **Loyalty_Point**: loyalty point transactions per customer

---

## Key Constraints & Business Rules Implemented
Examples of rules enforced in the schema (via constraints):
- Category flags are restricted to **0/1**
- Customer email is **unique**, loyalty points are **non-negative**
- Product price must be **> 0**, stock must be **≥ 0**
- Order status is limited to allowed values (e.g., PENDING/PAID/SHIPPED/…)
- Order detail subtotal is validated as: **Subtotal = Quantity × Price**
- Payment status/type are validated, and payment type controls which fields must be present (card / cash / deferred)

---

## How to Run (Oracle SQL Developer)
This project uses **Oracle SQL syntax** (e.g., `VARCHAR2`, `NUMBER`, `TO_DATE`).

### 1) Open SQL Developer and connect
- Create/open a connection (your schema/user).

### 2) Run the script
- Open **`Online-Retail Store SQL.sql`**
- Click **Run Script (F5)**

### 3) If you prefer to run step-by-step
Inside `Online-Retail Store SQL.sql`, you can run in this order:
1. **CREATE TABLE** statements
2. **ALTER TABLE** statements (if any)
3. **INSERT** statements
4. **SELECT** queries

---

## Example Queries Included
The script includes common business queries such as:
- List customers ordered by newest ID
- Total earned points by customer (with HAVING)
- Total paid amount grouped by payment type
- Products under a certain price
- Join products with their categories
- Join orders with customer + payment details

---

## Notes
- If you run this on **MySQL/PostgreSQL**, you will need small syntax changes (data types + date functions).
- The full explanation, design process, and outputs are included in the report PDF.

---
