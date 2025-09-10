# Basic SQL tasks using BigQuery enviroment
# Task 1: An Overview of Products

### Task 1.1 
You’ve been asked to extract the data on products from the Product table where there exists a product subcategory. Also, include the name of the ProductSubcategory.

- Columns needed: ProductId, Name, ProductNumber, size, color, ProductSubcategoryId, Subcategory name.
- Order results by SubCategory name.

```
--Columns needed: ProductId, Name, ProductNumber, size, color, ProductSubcategoryId, Subcategory name. Order results by SubCategory name.

SELECT product.ProductID,					
  product.Name,					
  product.ProductNumber,					
  product.Size,					
  product.Color,					
  product.ProductSubcategoryID,					
  subcategory.Name as Subcategory					
FROM `tc-da-1.adwentureworks_db.product` as product					
INNER JOIN `tc-da-1.adwentureworks_db.productsubcategory` as subcategory					
  ON product.ProductSubcategoryID = subcategory.ProductSubcategoryID					
ORDER BY Subcategory	
```
Result (abbreviated):
<img width="1282" height="239" alt="image" src="https://github.com/user-attachments/assets/8e459e27-9426-4db2-ba4e-f5e0165377ce" />

### Task 1.2
In 1.1 query you have a product subcategory but see that you could use the category name.

- Find and add the product category name.
- Afterwards order the results by Category name.

```
SELECT product.ProductID,					
  product.Name,					
  product.ProductNumber,					
  product.Size,					
  product.Color,					
  product.ProductSubcategoryID,					
  subcategory.Name as Subcategory,					
  category.Name as Category					
FROM `tc-da-1.adwentureworks_db.product` as product					
INNER JOIN `tc-da-1.adwentureworks_db.productsubcategory` as subcategory					
  ON product.ProductSubcategoryID = subcategory.ProductSubcategoryID					
JOIN `tc-da-1.adwentureworks_db.productcategory` as category					
  ON subcategory.ProductCategoryID = category.ProductCategoryID					
ORDER BY Category
```
Result (abbreviated):
<img width="1284" height="239" alt="image" src="https://github.com/user-attachments/assets/0a777709-f112-4b0a-925e-84c3e54dbc85" />

### Task 1.3
Use the established query to select the most expensive (price listed over 2000) bikes that are still actively sold (does not have a sales end date)

- Order the results from most to least expensive bike.
```
SELECT product.ProductID,					
  product.Name,					
  product.ProductNumber,					
  product.Size,					
  product.Color,					
  product.ProductSubcategoryID,					
  subcategory.Name as Subcategory,					
  category.Name as Category,					
  product.ListPrice,					
  product.SellEndDate					
FROM `tc-da-1.adwentureworks_db.product` as product					
INNER JOIN `tc-da-1.adwentureworks_db.productsubcategory` as subcategory					
  ON product.ProductSubcategoryID = subcategory.ProductSubcategoryID					
JOIN `tc-da-1.adwentureworks_db.productcategory` as category					
  ON subcategory.ProductCategoryID = category.ProductCategoryID					
WHERE category.Name = 'Bikes'					
  AND product.ListPrice > 2000					
  AND product.SellEndDate IS NULL					
ORDER BY ListPrice DESC
```
Result (abbreviated):

<img width="1282" height="240" alt="image" src="https://github.com/user-attachments/assets/0f5ed481-3499-406f-ad9b-a25457f07fc1" />

# Task 2: Reviewing Work Orders
### Task 2.1 
Create an aggregated query to select the:

- Number of unique work orders.
- Number of unique products.
- Total actual cost.

For each location_Id from the 'workorderrouting' table for orders in January 2004.

```
SELECT locationID,							
count(DISTINCT WorkOrderID) as UniqueWorkOrders,							
count(Distinct ProductID) as UniqueProducts,							
SUM(ActualCost) as ActualCost							
FROM `tc-da-1.adwentureworks_db.workorderrouting`							
WHERE ActualStartDate between '2004-01-01' AND '2004-01-31'							
GROUP BY LocationID							
ORDER BY ActualCost DESC
```

Result:

<img width="557" height="217" alt="image" src="https://github.com/user-attachments/assets/6564fe82-8560-4738-b5e7-316ed1980eab" />


### Task 2.2
Build on 2.1 query by making the following updates:

- Include the Location Name in your results.
- For each LocationId, calculate and include the average number of days between the Actual Start Date and the Actual End Date.

```
SELECT
  wor.locationID,
  loc.Name,
  COUNT(DISTINCT WorkOrderID) AS UniqueWorkOrders,
  COUNT(DISTINCT ProductID) AS UniqueProducts,
  SUM(ActualCost) AS ActualCost,
  ROUND(AVG(DATE_DIFF(ActualEndDate, ActualStartDate, DAY)),2) AS AvgDaysForWorkOrder
FROM
  `tc-da-1.adwentureworks_db.workorderrouting` AS wor
LEFT JOIN
  `tc-da-1.adwentureworks_db.location` AS loc
ON
  wor.LocationID = loc.LocationID
WHERE
  ActualStartDate BETWEEN '2004-01-01'
  AND '2004-01-31'
GROUP BY
  LocationID,
  loc.Name
ORDER BY
  ActualCost DESC
```
Result:

<img width="880" height="214" alt="image" src="https://github.com/user-attachments/assets/1538c162-d9a4-44f2-9884-e19dfdebb855" />


### Task 2.3
Write a query to retrieve all Work Orders from January 2004 where the Actual Cost is greater than 300.

```
SELECT
  WorkOrderID,
  SUM(ActualCost) AS actual_cost
FROM
  `tc-da-1.adwentureworks_db.workorderrouting`
WHERE
  ActualStartDate BETWEEN '2004-01-01'
  AND '2004-01-31'
GROUP BY
  WorkOrderID
HAVING
  SUM(ActualCost) > 300
```

Result (abbreviated):

<img width="313" height="243" alt="image" src="https://github.com/user-attachments/assets/af881f78-15e3-4b4a-a07f-2ad61bf20ac7" />


# Task 3 Query Validation
Below are 2 queries that need to be fixed/updated.

### Task 3.1 
Your colleague has written a query to retrieve the list of orders linked to special offers. While the query runs without errors, the results seem incorrect, and the numbers do not match expectations.

Original Query:
```
SELECT sales_detail.SalesOrderId
          ,sales_detail.OrderQty
          ,sales_detail.UnitPrice
          ,sales_detail.LineTotal
          ,sales_detail.ProductId
          ,sales_detail.SpecialOfferID
          ,spec_offer_product.ModifiedDate
          ,spec_offer.Category
          ,spec_offer.Description

FROM `tc-da-1.adwentureworks_db.salesorderdetail`  as sales_detail

    left join `tc-da-1.adwentureworks_db.specialofferproduct` as spec_offer_product
    on sales_detail.productId = spec_offer_product.ProductID

    left join `tc-da-1.adwentureworks_db.specialoffer` as spec_offer
    on sales_detail.SpecialOfferID = spec_offer.SpecialOfferID

    order by LineTotal desc
```
Edited Query:

```
SELECT sales_detail.SalesOrderId
      ,sales_detail.OrderQty
      ,sales_detail.UnitPrice
      ,sales_detail.LineTotal
      ,sales_detail.ProductId
      ,sales_detail.SpecialOfferID
      ,spec_offer_product.ModifiedDate
      ,spec_offer.Category
      ,spec_offer.Description

FROM `tc-da-1.adwentureworks_db.salesorderdetail`  as sales_detail

left join `tc-da-1.adwentureworks_db.specialofferproduct` as spec_offer_product
on sales_detail.productId = spec_offer_product.ProductID

left join `tc-da-1.adwentureworks_db.specialoffer` as spec_offer
on sales_detail.SpecialOfferID = spec_offer.SpecialOfferID

ORDER BY LineTotal desc
```
Result (abbreviated):

<img width="1010" height="241" alt="image" src="https://github.com/user-attachments/assets/01b9dddc-a16d-459f-af0f-971db8284b0a" />

### Task 3.2 
Your colleague has written a query to retrieve basic Vendor information, but the query is not running correctly.

Review the query to identify and fix any errors preventing it from running properly.

Improve its readability and make it easier to debug.

Original Query:
```
SELECT  a.VendorId as Id,vendor_contact.ContactId, b.ContactTypeId,
        a.Name,
        a.CreditRating,
        a.ActiveFlag,
        c.AddressId,d.City

FROM `tc-da-1.adwentureworks_db.Vendor` as a

left join `tc-da-1.adwentureworks_db.vendorcontact` as vendor_contact
on vendor.VendorId = vendor_contact.VendorId
left join `tc-da1.adwentureworks_db.vendoraddress` as c on a.VendorId = c.VendorId

left join `tc-da-1.adwentureworks_db.address` as address
on vendor_address.VendorId = d.VendorId
```

Edited Query:
```
SELECT a.VendorId as Id,vendor_contact.ContactId, b.ContactTypeId, a.Name, a.CreditRating, a.ActiveFlag, c.AddressId,d.City

FROM tc-da-1.adwentureworks_db.Vendor as a

left join tc-da-1.adwentureworks_db.vendorcontact as vendor_contact on vendor.VendorId = vendor_contact.VendorId left join tc-da1.adwentureworks_db.vendoraddress as c on a.VendorId = c.VendorId

left join tc-da-1.adwentureworks_db.address as address on vendor_address.VendorId = d.VendorId
```

Result (abbreviated):
<img width="1209" height="241" alt="image" src="https://github.com/user-attachments/assets/64d3fc89-bd91-4d3b-8ebc-dc8521dfd356" />
