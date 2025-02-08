# ST207 Assignment 1 - AT2024

## Q1 - Conceptual/E-R modelling (max 20 marks)

|   |   |   |
|---|---|---|
| minimal set of entities | | -1 |
| minimal set of attributes | ✔| |
| correct number of primary keys (PK) | | -2 |
| minimal set of relationships | ✔| |
| correct cardinalities (Crow's foot notation) | | -2 |
| meaningful/clear entity/attribute/relationship names | | -2  |
| extra entities/relationships + explanation | ✔| |
| clear/legible diagram | ✔| |
| explanation on report | | -1 |

Model has the minimum number of entities and relationships, but you could consider specialising into physical and digital products, as some attributes of physical attributes do not hold for digital ones, and thus there are several optional attributes that can turn into NULL values. PKs are correct but you could consider whether credit/debit card and voucher/gift cards really need a PK as payment method already has one. Perhaps simplifying that each customer will have a few payment methods will turn your model less complex (less join operations). Some points to revise: (i) whether you need a basket_id if it is associated with only one customer; (ii) whether a delivery is not attached to an order (0 minimal cardinality). You mentioned that for digital products, but if you allow NULL values for Dtrack_number, this will pose problems when joining this table to others or grouping by this attribute; (iii) avoid duplicated relationship names and choose more meaningful names, as some of them will turn into tables in the relational model. Report OK.

## Q2 – Relational modelling (max 15 marks)

|   |   |   |
|---|---|---|
| minimal set of tables | | -1 |
| minimal set of attributes | ✔| |
| data type definition | -2 | |
| correct number of primary keys (PKs) | | -1 |
| minimal set of relationships, mapped from ER model | ✔| |
| correct number of foreign keys (FKs) and M:N tables | | -1 |
| meaningful/clear table/attribute/relationship names | ✔| |
| extra tables/relationships + explanation | ✔| |
| clear/legible diagram | ✔| |
| explanation on report | ✔| |

Model maps from ER with modifications. You must observe: (i) adjustments to the ER model that need to reflect back in the relational model; (ii) optional attributes in Products and whether they will lead to NULL values here, including Category - can we assume that all products will have a category?; (iii) Dtrack_number as optional and NULL values; (iv) any way of merging Basket and Basket_contains, so you can link them to Customer and avoid unnecessary joins;. Report OK.

## Q3 – DATABASE CREATION (max 5 marks)

|   |   |   |
|---|---|---|
| all tables correctly created | ✔| |
| correct number of PKs and FKs | ✔| |
| correct data types | ✔| |
| clear/legible code| ✔| |
| code free from warnings | ✔| |
| code free from errors | ✔| |
| explanation on report (including genAI tools) | ✔| |

Correct code and database creation.

## Q4 – DATA LOADING (max 5 marks)

|   |   |   |
|---|---|---|
| good amount of data (compared to a real e-Commerce scenario) | ✔| |
| consistent FK values across tables | ✔| |
| correct data types | ✔| |
| amount of NULL values (if any) | ✔| |
| code free from warnings | ✔| |
| code free from errors | ✔| |
| explanation on report (including genAI tools) | ✔| |

Correct code and data generation (supported by AI). Good data size and variation.

## Q5.1 – SQL PROGRAMMING (max 10 marks)

Code seems correct with a substantial amount of customer and their respective orders. However, there is a good number of customer with no order, which wouldn't occur due to the first left join.

## Q5.2 – SQL PROGRAMMING (max 10 marks)

Correct code with use of standard SQL and subqueries. Good amount/variation of results.

## Q5.3 – SQL PROGRAMMING (max 10 marks)

Correct code with use of window functions and views. Results are fine and restricted to a few categories (given the size of the database).

## Q5.4 – SQL PROGRAMMING (max 10 marks)

Correct code with use of window functions and views. Results are fine and show sales growth over a year.

## Q6 – DATABASE CONSISTENCY (10 marks)

Good rationale about the trigger to check product stock when placing an order. Positive and negative (violation) cases ok.

## PRESENTATION (5 marks)

Report is well-structured, with sound explanation of methods and discussion of results. Code is organised and documented. Good point about AI, with chat logs provided.

### Marking scheme

| Problem breakdown | Max marks | Your marks |
|--------------| :----------:|:----------:|
| Q1 - Conceptual/E-R modelling | 20 | 12 |
| Q2 – Relational modelling | 15 | 5 |
| Q3 – Database creation | 5 | 5 |
| Q4 – Database loading | 5 | 5 |
| Q5.1 – SQL programming | 10 | 7 |
| Q5.2 – SQL programming | 10 | 10 |
| Q5.3 – SQL programming | 10 | 8 |
| Q5.4 – SQL programming | 10 | 10 |
| Q6 – Database consistency | 10 | 8 |
| Presentation | 5 | 5 |
| Total | 100 | 75 |
