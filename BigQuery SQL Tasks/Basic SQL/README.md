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


### Task 2.2
Update your 2.1 query by adding the name of the location and also add the average days amount between actual start date and actual end date per each location.

Result hint:


### Task 2.3
Select all the expensive work Orders (above 300 actual cost) that happened throught January 2004.

Result hint:


# Task 3 Query Validation
Below you will find 2 queries that need to be fixed/updated.

Doubleclick on the cell of the query and you will see it in the original format, copy it into your Bigquery interface and try to fix it there.
Once you have it fixed, copy into your spreadsheet of results among previous task results.

### Task 3.1 
Your colleague has written a query to find the list of orders connected to special offers. The query works fine but the numbers are off, investigate where the potential issue lies.

Query below:

Image:


Code:

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

### Task 3.2 
Your colleague has written this query to collect basic Vendor information. The query does not work, look into the query and find ways to fix it. Can you provide any feedback on how to make this query be easier to debug/read?

Query below:

Image:


Code:

SELECT a.VendorId as Id,vendor_contact.ContactId, b.ContactTypeId, a.Name, a.CreditRating, a.ActiveFlag, c.AddressId,d.City

FROM tc-da-1.adwentureworks_db.Vendor as a

left join tc-da-1.adwentureworks_db.vendorcontact as vendor_contact on vendor.VendorId = vendor_contact.VendorId left join tc-da1.adwentureworks_db.vendoraddress as c on a.VendorId = c.VendorId

left join tc-da-1.adwentureworks_db.address as address on vendor_address.VendorId = d.VendorId
