SELECT *
FROM marketing_campaign
ORDER BY Dt_Customer
-----Exploring the data 

SELECT MIN(Dt_Customer) AS First_Date , MAX(Dt_Customer) AS Last_Date
FROM marketing_campaign
----The data has enrollment dates between 2012-07-30 and 2014-06-29 

DELETE FROM marketing_campaign
WHERE Income IS NULL
----There were 24 customers that were removed because they had their income NULL and they won't be needed in the analysis.

------Notes
--MntWines: Amount spent on wine in last 2 years.
--MntFruits: Amount spent on fruits in last 2 year.
--MntMeatProducts: Amount spent on meat in last 2 years.
--MntFishProducts: Amount spent on fish in last 2 years.
--MntSweetProducts: Amount spent on sweets in last 2 years.
--MntGoldProds: Amount spent on gold in last 2 years.

SELECT Age
FROM marketing_campaign
WHERE Age >= 90
----The data has 3 customers that are older than 90 years they will not be relied on their purchases as they are probably not alive anymore.

DELETE FROM marketing_campaign
WHERE Age > 90
----Deleting people older than 90 years.

SELECT Max(Age)  Oldest_Customer, MIN(Age) Youngest_Customer
FROM marketing_campaign
----The oldest customer is 84 years old and the youngest is 28 years old.

SELECT DISTINCT Education
FROM marketing_campaign
----There are 5 Education types, Graduation, PHD, Master, 2n Cycle, and Basic.

SELECT DISTINCT Marital_Status, COUNT(Marital_Status) AS Count_marital
FROM marketing_campaign
GROUP BY Marital_Status
----There are 470 Single, 231 Divorced, 572 Together, 857 Married, 76 Widowed, and 3 other categories that do not clearly mean anything.
----I will merge Alone with Single as it means the same.

UPDATE marketing_campaign
SET Marital_Status = 'Single'
WHERE Marital_Status = 'Alone'
----3 rows were affected and changed from alone to single.

DELETE FROM  marketing_campaign
WHERE Marital_Status = 'YOLO' OR Marital_Status = 'Absurd'
----Removing YOLO and Absurd from marital status.
----4 rows were deleted.
 
SELECT TOP 10 Income
FROM marketing_campaign
ORDER BY Income DESC

SELECT TOP 10 Income
FROM marketing_campaign
ORDER BY Income ASC 

DELETE FROM marketing_campaign
WHERE Income > 200000
----This shows that the highest income was 666,666 which is a bit odd compared to the rest of the top 10 income so i will remove it.
----The highest income is going to be 162,397
----The lowest income is 1730.

ALTER TABLE marketing_campaign
ADD Age_Segment VARCHAR(10)

EXEC sp_rename 'marketing_campaign.age_segment', 'age_group', 'COLUMN';

UPDATE marketing_campaign
SET Age_Group =
	CASE 
		WHEN Age BETWEEN 20 AND 29 THEN '20s'
		WHEN Age BETWEEN 30 AND 39 THEN '30s'
		WHEN Age BETWEEN 40 AND 49 THEN '40s'
		WHEN Age BETWEEN 50 AND 59 THEN '50s'
		WHEN Age BETWEEN 60 AND 69 THEN '60s'
		WHEN Age BETWEEN 70 AND 79 THEN '70s'
		WHEN Age BETWEEN 80 AND 89 THEN '80s'
		ELSE 'Other'
	END
----Altering the table and creating Age_Segment to be used in the analysis.

SELECT age_group, COUNT(age_group) AS Total_Count_age_group
FROM marketing_campaign
GROUP BY age_group
ORDER BY age_group
----This query segments people based on their age, grouping them into age groups with a decade difference between them and counting them.
----The first largest age group are customers in their 50s, second largest age group are 60s, and the third largest age group are customers in their 40s.
----This means that the majority of the customers are middle aged people.

SELECT age_group, AVG(Income) AS Avg_Income
FROM marketing_campaign
GROUP BY age_group
ORDER BY Avg_Income
----Knowing the Average income for the customers, as we can see that customer in their 80s have the highest average income.
---- but you need to know that the average of the people in the 80s age group is based on only 15 customers who belong to this age group.

SELECT age_group, Education, COUNT(*) as count_edu
FROM marketing_campaign
GROUP BY age_group, Education
ORDER BY age_group
----This code provides a breakdown of the count of customers based on their age group and education leve.
----Most customers across all age groups are graduates, except those in their 80s, among whom the highest number holds a PhD.
----Graduation, Masters, and PHD are dominated by customer in their 50s as 334 customers are graduated, 115 have masters, and 163 have PHD.

SELECT age_group, Marital_Status, COUNT(Marital_Status) AS Count_marital_status
FROM marketing_campaign
GROUP BY age_group, Marital_Status
ORDER BY age_group
----This query shows what are the marital status for most of the customers based on the age group that they belong to:
--20s single --40s married --60s married
--30s single --50s married --70s married --80s married

SELECT COUNT(DISTINCT Dt_Customer) AS Count_of_Days
FROM marketing_campaign
----This query shows how many enrolment days were in the past 2 years, after running the query it shows that there was 662 days which is less than 2 years.

SELECT 
		SUM(MntWines) AS Total_Wine,
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat, 
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
----This query claculates the total expenditure on different product categories.


SELECT  AVG(Income) AS Average_Income,
		SUM(MntWines) AS Total_Wine,
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat, 
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
WHERE Dt_Customer <= '2013-07-12'
UNION ALL
SELECT AVG(Income) AS Average_Income,
		SUM(MntWines) AS Total_Wine,
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat, 
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
WHERE Dt_Customer > '2013-07-13'
----The query aims to calculate and compare average income and total spending on various product categories for two groups of customers:
-- 1-Customers who joined on or before July 12, 2013.
-- 2-Customers who joined after July 13, 2013.
-- Each group represents 331 days so the first group are people who joined for the first 331 days and the second group is for the people who joined for the next 331 days.
-- First row shows the customers spending before July 12, 2013 and the second row shows the customers spending after July 13, 2013.

SELECT SUM(NumWebPurchases) AS Total_Web_Purchases,
	   SUM(NumDealsPurchases) AS Total_Deals_Purchases,
	   SUM(NumCatalogPurchases) AS Total_Catalog_Purchases,
	   SUM(NumStorePurchases) AS Total_Store_Purchases
FROM marketing_campaign
----This query shows how many purchases were made through various purchasing methods.


SELECT age_group,
		SUM(NumWebPurchases) AS Total_Web,
		SUM(NumDealsPurchases) AS Total_Deals_Purchases,
	    SUM(NumCatalogPurchases) AS Total_Catalog_Purchases,
	    SUM(NumStorePurchases) AS Total_Store_Purchases
FROM marketing_campaign
GROUP BY age_group
ORDER BY age_group
----The primary purpose of this query is to provide a summary of purchase behaviors segmented by age groups
---- 20s age group:                           ---- 30s age group:
-- Most purchases: store(41)                  -- Most purchases: store(1159)   
-- Second most: Catalog(25)                   -- Second most: Web(686)   
-- Least: Deals(9)                            -- Least: Deals(354)

---- 40s age group:                           ---- 50s age group:
-- Most purchases: store(2946)                -- Most purchases: store(3723)   
-- Second most: Web(2074)                     -- Second most: Web(2754)   
-- Least: Deals(1231)                         -- Least: Catalog (1553)
       
---- 60s age group:                           ---- 70s age group:
-- Most purchases: store(2911)                -- Most purchases: store(1921)   
-- Second most: Web(2028)                     -- Second most: Web(1374)   
-- Least: Deals(1147)                         -- Least: Catalog (676)

---- 80s age group:
-- Most purchases: Store(118)
-- Second most: Web(88)
-- Least: Deals(18)


SELECT age_group, 
		AVG(income) AS Average_Income, 
		SUM(MntWines) AS Total_Wine,
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat, 
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
GROUP BY age_group
ORDER BY age_group
----The highest Total spending by customers was on Wine, but for customers in their 20s was on Meat.
----Second highest total spending was on Meat by every age group except customers in their 20s was on Wine.
----Third highest total spending was on Gold by every age group except customers in their 80s was on fish and customers in their 20s was on sweets.
----Fourth highest total spending was on fish by every age group except customers in their 80s was on fruits.
----Fifth highest total spending had major differences in spending among the age group:
-- customers in their 40s, 50s, 70s, and 80s spended on sweets, customers in their 30s, 60s spended on fruits, customers in their 20s spended on gold.
----The least spending by age groups was like that: 20s, 40s, 50, and 70s on  fruits, 30s and 60s sweets, 80s on gold.

SELECT Marital_Status,
		SUM(MntWines) AS Total_Wine,
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat,
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
GROUP BY Marital_Status
----Comparing the difference in spending based on the Marital status.
----All customers spend the most on Wine.
----Following wine, meat stands out as the second-highest expenditure.
----Gold ranks third in terms of expenditure.
----Fish comes in fourth place in terms of expenditure.
----For single and divorced customers, fruits rank fifth in expenditure, while for together, married, and widowed customers, sweets take fifth place.
----The lowest spending was on Sweets for Single and Divorced customers, whereas fruits hold the lowest expenditure among together, married, and widowed customers.

SELECT Education,
		SUM(MntWines) AS Total_Wine, 
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat,
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
GROUP BY Education
----Comparing the difference in spending based on the Education
----Customers with graduate, PhD, master's, and 2nd cycle degrees exhibit the highest expenditure on wine, while basic-educated customers allocate the most spending towards gold.
----The least spending was on Fruits for graduated, PhD, 2n Cycle, and Basic customers, whereas customers with master's degrees spend the least on sweets.

ALTER TABLE marketing_campaign
ALTER COLUMN MntMeatProducts BIGINT
ALTER TABLE marketing_campaign
ALTER COLUMN MntFruits BIGINT
----First Altering the column MntMeatProducts and MntFruits to make it BIGINT because there is an arithmetic overflow error.

SELECT 
    'Web' AS Purchase_Method,
    SUM(MntWines * NumWebPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Wine,
    SUM(MntFishProducts * NumWebPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Fish,
    SUM(MntFruits * NumWebPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Fruits,
    SUM(MntGoldProds * NumWebPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Gold,
    SUM(MntMeatProducts * NumWebPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Meat,
    SUM(MntSweetProducts * NumWebPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Sweet
FROM marketing_campaign
UNION ALL
SELECT 
    'Catalog' AS Purchase_Method,
    SUM(MntWines * NumCatalogPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Wine,
    SUM(MntFishProducts * NumCatalogPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Fish,
    SUM(MntFruits * NumCatalogPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Fruits,
    SUM(MntGoldProds * NumCatalogPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Gold,
    SUM(MntMeatProducts * NumCatalogPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Meat,
    SUM(MntSweetProducts * NumCatalogPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Sweet
FROM marketing_campaign
UNION ALL
SELECT 
    'Store' AS Purchase_Method,
    SUM(MntWines * NumStorePurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Wine,
    SUM(MntFishProducts * NumStorePurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Fish,
    SUM(MntFruits * NumStorePurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Fruits,
    SUM(MntGoldProds * NumStorePurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Gold,
    SUM(MntMeatProducts * NumStorePurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Meat,
    SUM(MntSweetProducts * NumStorePurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Sweet
FROM marketing_campaign
UNION ALL
SELECT 
    'Deals' AS Purchase_Method,
    SUM(MntWines * NumDealsPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Wine,
    SUM(MntFishProducts * NumDealsPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Fish,
    SUM(MntFruits * NumDealsPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Fruits,
    SUM(MntGoldProds * NumDealsPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Gold,
    SUM(MntMeatProducts * NumDealsPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Meat,
    SUM(MntSweetProducts * NumDealsPurchases / NULLIF((NumWebPurchases + NumCatalogPurchases + NumStorePurchases + NumDealsPurchases), 0)) AS Total_Sweet
FROM marketing_campaign;

----This query show the total amount spent on each product by the purchase method.
----We multiply the amount spent on each product (Fish, Meat, Fruit, Gold, Sweets) by the count of purchases made through each method (Web, Deals, Catalog, Store)    then divide it by the sum of all purchase platforms to get the total amount spent on each product for each purchasing method.
----Each product is represented by a separate column, making it easy to see the total amount spent on each product through different purchasing methods.
----There is a dedicated column for purchasing method.

