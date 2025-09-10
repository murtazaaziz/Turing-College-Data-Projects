# Advanced SQL tasks using BigQuery enviroment

## Database Used
https://console.cloud.google.com/bigquery?ws=!1m4!1m3!3m2!1stc-da-1!2sadventureworks_db_v19

## Schema
<img width="1075" height="666" alt="image" src="https://github.com/user-attachments/assets/312a1761-c9c0-4e2a-894b-e0006da0d043" />

## Task 1. An Overview of Customers

### Task 1.1 
You've been tasked with creating a detailed overview of all individual customers. Individual customers are defined by CustomerType = 'I' and/or are stored in the individual customer table.

The output should include the following columns:

Column List: CustomerId, FirstName, LastName, FullName, addressing_title, Email, Phone, AccountNumber, CustomerType, City, State, Country, Address, NumberOfOrders, TotalAmountWithTax, LastOrderDate

Notes:

FullName should be a concatenation of FirstName and LastName.
Addressing_Title should display the customer's title followed by their last name (e.g., Mr. Achong). If the title is missing, default to "Dear {LastName}".
Sales information should include the number of orders, total amount (including tax), and the date of the last order.
Limit the final result to the top 200 rows, ordered by TotalAmountWithTax in descending order.

Query:
```
WITH ind_cust AS (

  SELECT ind.CustomerID as CustomerID,
    con.Firstname AS FrstName,
    con.LastName AS LastName,
    CONCAT(con.Firstname, ' ', con.Lastname) AS FullName,
    CASE WHEN con.Title IS NOT NULL THEN con.Title
      ELSE CONCAT('Dear ',con.LastName) 
      END AS addressingTitle,
    con.emailAddress as Email,
    con.phone as Phone,
    cus.AccountNumber as AccountNumber,
    cus.CustomerType as CustomerType,
    add.city as City,
    add.addressLine1,
    add.addressLine2,
    state.name as State,
    country.name as Country
  FROM
    `tc-da-1.adwentureworks_db.individual` AS ind
  JOIN `tc-da-1.adwentureworks_db.customer` AS cus
    ON ind.CustomerID = cus.CustomerID
  JOIN `tc-da-1.adwentureworks_db.contact` AS con
    ON ind.ContactID = con.ContactId
  JOIN `tc-da-1.adwentureworks_db.customeraddress` AS cus_add
    ON ind.CustomerID = cus_add.CustomerID
  JOIN `tc-da-1.adwentureworks_db.address` AS add
    ON cus_add.AddressID = add.addressID
  JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
    ON state.stateprovinceID = add.stateprovinceID
  JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
    ON country.CountryRegionCode = state.CountryRegionCode
  WHERE cus.CustomerType = 'I'),

  customer_sales AS (
    SELECT
      ind.CustomerID as customerID,
      COUNT(sales.SalesOrderID) as number_orders,
      ROUND(SUM (sales.TotalDue),3) as total_amount,
      MAX (sales.OrderDate) as date_last_order
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
    JOIN `tc-da-1.adwentureworks_db.individual` as ind
      ON sales.CustomerID = ind.CustomerID
    GROUP BY 
      ind.CustomerID
    
  )
SELECT ind_cust.*,
  customer_sales.number_orders,
  customer_sales.total_amount,
  customer_sales.date_last_order
FROM ind_cust
JOIN customer_sales
  ON ind_cust.CustomerID = customer_sales.customerID
ORDER BY customer_sales.total_amount DESC
LIMIT 200
```

Result (abbreviated):
<img width="1283" height="246" alt="image" src="https://github.com/user-attachments/assets/e90c6996-95f0-4b1c-be63-61fcb4a57561" />

### Task 1.2
The business found the original query valuable and now wants to extend it. Specifically, they need the data for the top 200 customers with the highest total amount (including tax) who have not placed an order in the last 365 days.

Query:
```
WITH ind_cust AS (

  SELECT ind.CustomerID as CustomerID,
    con.Firstname AS FrstName,
    con.LastName AS LastName,
    CONCAT(con.Firstname, ' ', con.Lastname) AS FullName,
    CASE WHEN con.Title IS NOT NULL THEN con.Title
      ELSE CONCAT('Dear ',con.LastName) 
      END AS addressingTitle,
    con.emailAddress as Email,
    con.phone as Phone,
    cus.AccountNumber as AccountNumber,
    cus.CustomerType as CustomerType,
    add.city as City,
    add.addressLine1,
    add.addressLine2,
    state.name as State,
    country.name as Country
  FROM
    `tc-da-1.adwentureworks_db.individual` AS ind
  JOIN `tc-da-1.adwentureworks_db.customer` AS cus
    ON ind.CustomerID = cus.CustomerID
  JOIN `tc-da-1.adwentureworks_db.contact` AS con
    ON ind.ContactID = con.ContactId
  JOIN `tc-da-1.adwentureworks_db.customeraddress` AS cus_add
    ON ind.CustomerID = cus_add.CustomerID
  JOIN `tc-da-1.adwentureworks_db.address` AS add
    ON cus_add.AddressID = add.addressID
  JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
    ON state.stateprovinceID = add.stateprovinceID
  JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
    ON country.CountryRegionCode = state.CountryRegionCode
  WHERE cus.CustomerType = 'I'),

  customer_sales AS (
    SELECT
      ind.CustomerID as customerID,
      COUNT(sales.SalesOrderID) as number_orders,
      ROUND(SUM (sales.TotalDue),3) as total_amount,
      MAX (sales.OrderDate) as date_last_order
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
    JOIN `tc-da-1.adwentureworks_db.individual` as ind
      ON sales.CustomerID = ind.CustomerID
    WHERE sales.OrderDate < (SELECT DATE_SUB(MAX(sales.OrderDate), INTERVAL 365 DAY) FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales)
    GROUP BY 
      ind.CustomerID
    
  )
  
SELECT ind_cust.*,
  customer_sales.number_orders,
  customer_sales.total_amount,
  customer_sales.date_last_order
FROM ind_cust
JOIN customer_sales
  ON ind_cust.CustomerID = customer_sales.customerID
ORDER BY customer_sales.total_amount DESC
LIMIT 200
```

Result (abbreviated):

<img width="1282" height="243" alt="image" src="https://github.com/user-attachments/assets/c0201f63-7fde-4d38-aa7b-d2432c00c01c" />

### Task 1.3
Enhance your original 1.1 SELECT by adding a new column that flags customers as Active or Inactive, based on whether they have placed an order within the last 365 days.

Return only the top 500 rows, ordered by CustomerId in descending order.

Query:
```
WITH 
  ind_cust AS (
    SELECT ind.CustomerID as CustomerID,
      con.Firstname AS FirstName,
      con.LastName AS LastName,
      CONCAT(con.Firstname, ' ', con.Lastname) AS FullName,
      CASE WHEN con.Title IS NOT NULL THEN con.Title
        ELSE CONCAT('Dear ',con.LastName) 
        END AS addressingTitle,
      con.emailAddress as Email,
      con.phone as Phone,
      cus.AccountNumber as AccountNumber,
      cus.CustomerType as CustomerType,
      add.city as City,
      add.addressLine1,
      add.addressLine2,
      state.name as State,
      country.name as Country
    FROM
      `tc-da-1.adwentureworks_db.individual` AS ind
    JOIN `tc-da-1.adwentureworks_db.customer` AS cus
      ON ind.CustomerID = cus.CustomerID
    JOIN `tc-da-1.adwentureworks_db.contact` AS con
      ON ind.ContactID = con.ContactId
    JOIN `tc-da-1.adwentureworks_db.customeraddress` AS cus_add
      ON ind.CustomerID = cus_add.CustomerID
    JOIN `tc-da-1.adwentureworks_db.address` AS add
      ON cus_add.AddressID = add.addressID
    JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
      ON state.stateprovinceID = add.stateprovinceID
    JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
      ON country.CountryRegionCode = state.CountryRegionCode
    WHERE cus.CustomerType = 'I'),

  customer_sales AS (
    SELECT
      ind.CustomerID as customerID,
      COUNT(sales.SalesOrderID) as number_orders,
      ROUND(SUM (sales.TotalDue),3) as total_amount,
      MAX (sales.OrderDate) as date_last_order
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
    JOIN `tc-da-1.adwentureworks_db.individual` as ind
      ON sales.CustomerID = ind.CustomerID
    GROUP BY 
      ind.CustomerID 
  ),
  recent_date AS (
    SELECT DATE_SUB(MAX(sales.OrderDate), INTERVAL 365 DAY) AS inactive_date
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
  )
  
SELECT ind_cust.*,
  customer_sales.number_orders,
  customer_sales.total_amount,
  customer_sales.date_last_order,
  CASE WHEN 
    customer_sales.date_last_order <= (SELECT inactive_date FROM recent_date)
    THEN 'inactive'
    ELSE 'active'
    END AS active_status
FROM ind_cust
JOIN customer_sales
  ON ind_cust.CustomerID = customer_sales.customerID
JOIN `tc-da-1.adwentureworks_db.salesorderheader` as sales
  ON ind_cust.CustomerID = sales.customerID
ORDER BY ind_cust.CustomerID DESC
LIMIT 500
```

Result (abbreviated):

<img width="1285" height="242" alt="image" src="https://github.com/user-attachments/assets/aae31326-f9e8-46c3-b16f-4f3787035abd" />

### Task 1.4
The business requires data on all active customers from North America. Only include customers who meet either of the following criteria:

- Total amount (with tax) is no less than 2500, or
- They have placed 5 or more orders.
- Split the customers' address into two separate columns in the output.
- Order the output by country, state, and date_last_order.

  Query:
  ```
  WITH 
  ind_cust AS (
    SELECT ind.CustomerID as CustomerID,
      con.Firstname AS FirstName,
      con.LastName AS LastName,
      CONCAT(con.Firstname, ' ', con.Lastname) AS FullName,
      CASE WHEN con.Title IS NOT NULL THEN con.Title
        ELSE CONCAT('Dear ',con.LastName) 
        END AS addressingTitle,
      con.emailAddress as Email,
      con.phone as Phone,
      cus.AccountNumber as AccountNumber,
      cus.CustomerType as CustomerType,
      add.city as City,
      REGEXP_EXTRACT(add.addressLine1, r'\d+') AS address_no,
      REGEXP_EXTRACT(add.addressLine1, r'\D+') AS address_st,
      state.name as State,
      country.name as Country
    FROM
      `tc-da-1.adwentureworks_db.individual` AS ind
    JOIN `tc-da-1.adwentureworks_db.customer` AS cus
      ON ind.CustomerID = cus.CustomerID
    JOIN `tc-da-1.adwentureworks_db.contact` AS con
      ON ind.ContactID = con.ContactId
    JOIN `tc-da-1.adwentureworks_db.customeraddress` AS cus_add
      ON ind.CustomerID = cus_add.CustomerID
    JOIN `tc-da-1.adwentureworks_db.address` AS add
      ON cus_add.AddressID = add.addressID
    JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
      ON state.stateprovinceID = add.stateprovinceID
    JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
      ON country.CountryRegionCode = state.CountryRegionCode
    WHERE cus.CustomerType = 'I'),

  customer_sales AS (
    SELECT
      ind.CustomerID as customerID,
      COUNT(sales.SalesOrderID) as number_orders,
      ROUND(SUM (sales.TotalDue),3) as total_amount,
      MAX (sales.OrderDate) as date_last_order
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
    JOIN `tc-da-1.adwentureworks_db.individual` as ind
      ON sales.CustomerID = ind.CustomerID
    GROUP BY 
      ind.CustomerID 
  ),
  recent_date AS (
    SELECT DATE_SUB(MAX(sales.OrderDate), INTERVAL 365 DAY) AS inactive_date
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
  )
  
SELECT ind_cust.*,
  customer_sales.number_orders,
  customer_sales.total_amount,
  customer_sales.date_last_order,
  CASE WHEN 
    customer_sales.date_last_order <= (SELECT inactive_date FROM recent_date)
    THEN 'inactive'
    ELSE 'active'
    END AS active_status
FROM ind_cust
JOIN customer_sales
  ON ind_cust.CustomerID = customer_sales.customerID
JOIN `tc-da-1.adwentureworks_db.salesterritory` as territory
  ON ind_cust.Country = territory.Name
WHERE customer_sales.date_last_order > (SELECT inactive_date FROM recent_date)
  AND territory.Group = 'North America' 
  AND (customer_sales.total_amount >= 2500 OR  customer_sales.number_orders >= 5)
ORDER BY ind_cust.Country, ind_cust.State, customer_sales.date_last_order DESC
```

Result (abbreviated):

<img width="1285" height="238" alt="image" src="https://github.com/user-attachments/assets/8e22545c-bcf7-4457-ba2b-b3672e49f00a" />

## Task 2 Reporting Sales Numbers
Main tables to start from: salesorderheader.

### Task 2.1
Create a query to report monthly sales figures by Country and Region. For each month, include:

- Number of orders
- Number of unique customers
- Number of salespersons
- Total amount (with tax) earned
- Sales data should cover all customer types.

Query:
```
SELECT 
  LAST_DAY(CAST(sales.OrderDate AS DATE), MONTH) as order_month,
  ter.CountryRegionCode,
  ter.Name as Region,
  COUNT(DISTINCT sales.SalesOrderID) as number_orders,
  COUNT(DISTINCT sales.CustomerID) as number_customers,
  COUNT(DISTINCT sales.SalesPersonID) as no_salesPersons,
  CAST(ROUND(SUM(sales.TotalDue),0) AS INTEGER) as Total_w_tax
FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
JOIN `tc-da-1.adwentureworks_db.salesterritory` AS ter
  ON ter.TerritoryID = sales.TerritoryID
GROUP BY
  LAST_DAY(CAST(sales.OrderDate AS DATE), MONTH),
  ter.CountryRegionCode,
  ter.Name
```

Result (abbreviated):

<img width="1082" height="239" alt="image" src="https://github.com/user-attachments/assets/10bb9e13-a3e6-456d-9a14-cc2604cd6cb5" />

### Task 2.2
Enhance the 2.1 query by adding a cumulative sum of the total amount (with tax) earned, calculated per Country and Region.

Query:
```
WITH 
  temp_table AS(
    SELECT 
      LAST_DAY(CAST(sales.OrderDate AS DATE), MONTH) as order_month,
      ter.CountryRegionCode as Country,
      ter.Name as Region,
      COUNT(DISTINCT sales.SalesOrderID) as number_orders,
      COUNT(DISTINCT sales.CustomerID) as number_customers,
      COUNT(DISTINCT sales.SalesPersonID) as no_salesPersons,
      CAST(ROUND(SUM(sales.TotalDue),0) AS INTEGER) as Total_w_tax
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
    JOIN `tc-da-1.adwentureworks_db.salesterritory` AS ter
      ON ter.TerritoryID = sales.TerritoryID
    GROUP BY
      LAST_DAY(CAST(sales.OrderDate AS DATE), MONTH),
      ter.CountryRegionCode,
      ter.Name
)
SELECT 
      temp_table.*,
      SUM(temp_table.Total_w_tax) OVER (PARTITION BY temp_table.Country,temp_table.Region ORDER BY temp_table.order_month) as cumulative_sum
    FROM temp_table
```

Result (abbreviated):

<img width="944" height="239" alt="image" src="https://github.com/user-attachments/assets/dfd4a307-af8f-48fe-9ab1-50b0f54ecce4" />

### Task 2.3
Enhance the 2.2 query by adding a sales_rank column that ranks rows from highest to lowest total amount (with tax) earned per country and month.

For each country, assign rank 1 to the region with the highest total amount in a given month, and so on.

Query:
```
WITH 
  temp_table AS(
    SELECT 
      LAST_DAY(CAST(sales.OrderDate AS DATE), MONTH) as order_month,
      ter.CountryRegionCode as Country,
      ter.Name as Region,
      COUNT(DISTINCT sales.SalesOrderID) as number_orders,
      COUNT(DISTINCT sales.CustomerID) as number_customers,
      COUNT(DISTINCT sales.SalesPersonID) as no_salesPersons,
      CAST(ROUND(SUM(sales.TotalDue),0) AS INTEGER) as Total_w_tax
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
    JOIN `tc-da-1.adwentureworks_db.salesterritory` AS ter
      ON ter.TerritoryID = sales.TerritoryID
    GROUP BY
      LAST_DAY(CAST(sales.OrderDate AS DATE), MONTH),
      ter.CountryRegionCode,
      ter.Name
)

SELECT 
      temp_table.*,
      RANK() OVER (PARTITION BY temp_table.Country ORDER BY temp_table.Total_w_tax DESC) as country_sales_rank,
      SUM(temp_table.Total_w_tax) OVER (PARTITION BY temp_table.Country,temp_table.Region ORDER BY temp_table.order_month) as cumulative_sum
    FROM temp_table
    WHERE temp_table.Region = 'France'
    ORDER BY country_sales_rank
```

Result (abbreviated):

<img width="1071" height="238" alt="image" src="https://github.com/user-attachments/assets/621d3c4b-e164-4dcb-8c63-a0560c98478c" />

### Task 2.4
Enhance the 2.3 query by adding country-level tax details. Since tax rates can vary by province, include the mean_tax_rate column to reflect the average tax rate per country. Additionally, for transparency, add the perc_provinces_w_tax column to show the percentage of provinces with available tax data for each country.

- mean_tax_rate: The average tax rate per country. If a province/state has multiple tax rates, use the highest rate. Do not double-count provinces/states when calculating the average.
- perc_provinces_w_tax: The percentage of provinces/states within each country that have available tax rates. Example: If a country has 5 provinces and tax rates exist for 2, the value should be 0.40.

Query:
```
WITH 
  temp_table AS(
    SELECT 
      LAST_DAY(CAST(sales.OrderDate AS DATE), MONTH) as order_month,
      ter.CountryRegionCode as Country,
      ter.Name as Region,
      COUNT(DISTINCT sales.SalesOrderID) as number_orders,
      COUNT(DISTINCT sales.CustomerID) as number_customers,
      COUNT(DISTINCT sales.SalesPersonID) as no_salesPersons,
      CAST(ROUND(SUM(sales.TotalDue),0) AS INTEGER) as total_w_tax,
    FROM `tc-da-1.adwentureworks_db.salesorderheader` as sales
    JOIN `tc-da-1.adwentureworks_db.salesterritory` AS ter
      ON ter.TerritoryID = sales.TerritoryID
    GROUP BY
      LAST_DAY(CAST(sales.OrderDate AS DATE), MONTH),
      ter.CountryRegionCode,
      ter.Name
  ),

  max_tax_rate_by_province AS (
    SELECT 
      StateProvinceID,
      MAX(TaxRate) as tax_rate
    FROM `tc-da-1.adwentureworks_db.salestaxrate` as sales_tax
    GROUP BY StateProvinceID
  ),

  tax_rate_by_country AS (
    SELECT CountryRegionCode,
    ROUND(AVG(max_tax_rate_by_province.tax_rate), 1) as mean_tax_rate
    FROM `tc-da-1.adwentureworks_db.stateprovince` as province
    JOIN max_tax_rate_by_province
      ON province.StateProvinceID = max_tax_rate_by_province.StateProvinceID
    GROUP BY CountryRegionCode
  ),

  cnt_provinces AS (
    SELECT CountryRegionCode,
    COUNT(StateProvinceCode) as cnt
    FROM `tc-da-1.adwentureworks_db.stateprovince` as province
    GROUP BY CountryRegionCode
  ),
  cnt_provinces_with_tax AS (
    SELECT 
      CountryRegionCode,
      COUNT(*) as cnt
    FROM `tc-da-1.adwentureworks_db.stateprovince` as province
    JOIN `tc-da-1.adwentureworks_db.salestaxrate` as sales_tax
      ON province.StateProvinceID = sales_tax.StateProvinceID
    WHERE sales_tax.TaxRate IS NOT NULL
    GROUP BY CountryRegionCode
  )
  
SELECT 
      temp_table.*,
      RANK() OVER (PARTITION BY temp_table.Country ORDER BY temp_table.total_w_tax DESC) as country_sales_rank,
      SUM(temp_table.total_w_tax) OVER (PARTITION BY temp_table.Country,temp_table.Region ORDER BY temp_table.order_month) as cumulative_sum,
      tax_rate_by_country.mean_tax_rate as mean_tax_rate,
      ROUND(cnt_provinces_with_tax.cnt/cnt_provinces.cnt, 2) as perc_provinces_w_tax
    FROM temp_table
    JOIN tax_rate_by_country
      ON tax_rate_by_country.CountryRegionCode = temp_table.Country
    JOIN cnt_provinces
      ON cnt_provinces.CountryRegionCode = temp_table.Country
    JOIN cnt_provinces_with_tax
      ON cnt_provinces_with_tax.CountryRegionCode = temp_table.Country
    WHERE temp_table.Country = 'US'
    ORDER BY country_sales_rank
```

Result (abbreviated):

<img width="1255" height="238" alt="image" src="https://github.com/user-attachments/assets/5cdc5d77-483f-48bb-a7d0-bebd3a3cfdda" />


