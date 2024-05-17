# Customers-Personality-Analysis
## Scenario
Customer personality analysis helps a business to modify its product based on its target customers from different types of customer segments. For example, instead of spending money to market a new product to every customer in the company’s database, a company can analyze which customer segment is most likely to buy the product and then market the product only on that particular segment.
## Busines task 
Analyze customer behavior and segment them based on various factors to get the company's ideal customer.


## Process

- First, Explore the data. 
```SQL
SELECT *
FROM marketing_campaign
ORDER BY Dt_Customer;
```
![Screenshot (142)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/6698d93a-813c-4c22-89e6-774f935d5247)

- checking the date of enrollment, The data has enrollment dates between 2012-07-30 and 2014-06-29 
```SQL
SELECT MIN(Dt_Customer) AS First_Date , MAX(Dt_Customer) AS Last_Date
FROM marketing_campaign
```
![Screenshot (143)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/2a9188fc-c191-4ba9-b0c1-ed84a1a064ae)

- There were 24 customers that were removed because they had their income as `NULL` and they won't be needed in the analysis.
```SQL
DELETE FROM marketing_campaign
WHERE Income IS NULL
```
![Screenshot (144)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/7e00fa5e-c598-47a8-aa2f-1166cbb99fb5)

- The data includes three customers over the age of 90; their purchasing patterns will not be considered as they are likely not alive anymore.
```SQL
SELECT Age
FROM marketing_campaign
WHERE Age >= 90
```
![Screenshot (145)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/441b42cf-c106-4b12-858e-71b132648439)

- Deleting people older than 90 years.
```SQL
DELETE FROM marketing_campaign
WHERE Age > 90
```
![Screenshot (146)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/09391fa5-f34d-4cba-8934-4b2bfdb13c10)

- This query shows the oldest and the youngest customer after deleting customer that are older than 90, the oldest customer is 84 years old and the youngest is 28 years old.
```SQL
SELECT Max(Age)  Oldest_Customer, MIN(Age) Youngest_Customer
FROM marketing_campaign
```
![Screenshot (147)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/73895e45-b3ac-456c-9edc-dab63ef6f137)

- Exploring the Education category, there are 5 Education types, Graduation, PHD, Master, 2n Cycle, and Basic.
```SQL
SELECT DISTINCT Education
FROM marketing_campaign
```
![Screenshot (148)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/7fbd64db-a1b1-4599-921c-524c5f60511e)

- Exploring the marital status, there are 470 Single, 231 Divorced, 572 Together, 857 Married, 76 Widowed, and 3 other categories that do not clearly mean anything.
- I will merge Alone with Single as it means the same.

```SQL
SELECT DISTINCT Marital_Status, COUNT(Marital_Status) AS Count_marital
FROM marketing_campaign
GROUP BY Marital_Status
```
![Screenshot (149)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/38e5b2d2-f9ae-4b15-8ae1-f37f111d91e8)

```SQL
UPDATE marketing_campaign
SET Marital_Status = 'Single'
WHERE Marital_Status = 'Alone'
```
![Screenshot (150)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/ff6a3be3-735f-4c39-989d-2006ce8d321c)

- Removing YOLO and Absurd from marital status.
```SQL
DELETE FROM  marketing_campaign
WHERE Marital_Status = 'YOLO' OR Marital_Status = 'Absurd'
```
![Screenshot (151)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/81cc93f2-1945-4639-88e4-62da56b6283f)

- This shows that the highest and lowest income, the highest was 666,666 which is a bit odd compared to the rest of the top 10 income so I will remove it.

```SQL 
SELECT TOP 10 Income
FROM marketing_campaign
ORDER BY Income DESC
```
![Screenshot (152)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/9f491c84-03c9-4d5b-a1b6-54ee89ced3dd)

```SQL
SELECT TOP 10 Income
FROM marketing_campaign
ORDER BY Income ASC 
```
![Screenshot (153)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/b3befa76-05a4-4c34-95aa-f381c1897cba)

```SQL
DELETE FROM marketing_campaign
WHERE Income > 200000
```
![Screenshot (154)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/342efc8e-1a4d-4f8d-85d6-0dfe2daaa914)

So now the highest income is 162,397 and the lowest income is 1730.

- Altering the table and creating Age_Segment to be used in the analysis.

```SQL
ALTER TABLE marketing_campaign
ADD age_group VARCHAR(10)
```
![Screenshot (155)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/3551c05c-f387-45a6-ba16-60c482513949)

```SQL
UPDATE marketing_campaign
SET age_group =
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
```
![Screenshot (156)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/d455c749-78ca-4224-84a0-111c4bcacaee)

- This query segments people based on their age, grouping them into age groups with a decade difference between them and counting them.
The first largest age group is customers in their 50s, the second largest age group are customers in their 60s, and the third largest age group is customers in their 40s.
This means that the majority of the customers are middle-aged people.

```SQL
SELECT age_group, COUNT(age_group) AS Total_Count_age_group
FROM marketing_campaign
GROUP BY age_group
ORDER BY age_group
```
![Screenshot (157)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/afcd1d57-01ec-476e-bd35-d28b415eae39)

- This query lets us know the Average income for the customers, as we can see that customers in their 80s have the highest average income.
You need to know that the average income of the people in the 80s age group is based only on 15 customers who belong to this age group.
```SQL
SELECT age_group, AVG(Income) AS Avg_Income
FROM marketing_campaign
GROUP BY age_group
ORDER BY Avg_Income
```
![Screenshot (158)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/61e60eb5-898c-4c42-913e-c9d5826ced80)

- This code provides a breakdown of the count of customers based on their age group and education level.
Most customers across all age groups are graduates, except those in their 80s, among whom the highest number holds a PhD.
Graduation, Masters, and PHD are dominated by customer in their 50s as 334 customers are graduated, 115 have masters, and 163 have PHD.x
```SQL
SELECT age_group, Education, COUNT(*) as count_edu
FROM marketing_campaign
GROUP BY age_group, Education
ORDER BY age_group
```
![Screenshot (159)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/f58fd453-bbbb-4b0d-b3d1-6520a9e7b149)

- This query lets us explore  the marital status of the customers based on the age group that they belong to
This is a summary based on the query that shows the most marital status for customers by each age group.
20s single 
40s married
60s married
30s single
50s married
70s married
80s married
```SQL
SELECT age_group, Marital_Status, COUNT(Marital_Status) AS Count_marital_status
FROM marketing_campaign
GROUP BY age_group, Marital_Status
ORDER BY age_group
```
![Screenshot (160)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/c442bb64-b760-4dbe-a0f1-e3ea34acbe8f)

- This query shows how many enrolment days were in the past 2 years, after running the query it shows that there were 662 days which is less than 2 years.
```SQL
SELECT COUNT(DISTINCT Dt_Customer) AS Count_of_Days
FROM marketing_campaign
```
![Screenshot (161)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/1e59ebdb-039d-43be-9eaf-c1ad9ab7a531)

- This query calculates the total expenditure on different product categories.
```SQL
SELECT 
		SUM(MntWines) AS Total_Wine,
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat, 
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
```
![Screenshot (162)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/3cf5a201-5422-4128-94f1-c8688b670759)

- The query aims to calculate and compare average income and total spending on various product categories for two groups of customers:
1- Customers who joined on or before July 12, 2013.
2- Customers who joined after July 13, 2013.
Each group represents 331 days so the first group are people who joined for the first 331 days and the second group is for the people who joined for the next 331 days.
```SQL
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
```
![Screenshot (163)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/abe5a436-47ab-4798-b2fb-02b44d159402)

- This query shows how many purchases were made through various purchasing methods.

```SQL
SELECT SUM(NumWebPurchases) AS Total_Web_Purchases,
	   SUM(NumDealsPurchases) AS Total_Deals_Purchases,
	   SUM(NumCatalogPurchases) AS Total_Catalog_Purchases,
	   SUM(NumStorePurchases) AS Total_Store_Purchases
FROM marketing_campaign
```
![Screenshot (164)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/108b96e0-8e38-4732-b19d-cce396016986)

- The primary purpose of this query is to provide a summary of purchase behaviors segmented by age groups.
```SQL
SELECT age_group,
		SUM(NumWebPurchases) AS Total_Web,
		SUM(NumDealsPurchases) AS Total_Deals_Purchases,
	    SUM(NumCatalogPurchases) AS Total_Catalog_Purchases,
	    SUM(NumStorePurchases) AS Total_Store_Purchases
FROM marketing_campaign
GROUP BY age_group
ORDER BY age_group
```
![Screenshot (165)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/54e74130-cbd9-4b76-b17c-50273397195a)

- This query show the spending of the customers and their income based on their age group.
The highest Total spending by customers was on Wine, but for customers in their 20s was on Meat.
The second highest total spending was on Meat by every age group except customers in their 20s was on Wine.
The third highest total spending was on Gold by every age group except customers in their 80s on fish and customers in their 20s on sweets.
The fourth highest total spending was on fish by every age group except customers in their 80s was on fruits.
Fifth highest total spending had major differences in spending among the age groups:
customers in their 40s, 50s, 70s, and 80s spended on sweets, customers in their 30s, 60s spended on fruits, customers in their 20s spended on gold.
The least spending by age groups was like that: 20s, 40s, 50s, and 70s on  fruits, 30s and 60s sweets, and 80s on gold.

```SQL
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
```
![Screenshot (166)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/c6149ef4-a13b-458a-8a53-91caedeb7c8f)

- Comparing the difference in spending based on the Marital status.
All customers spend the most on Wine.
Following wine, meat stands out as the second-highest expenditure.
Gold ranks third in terms of expenditure.
Fish comes in fourth place in terms of expenditure.
For single and divorced customers, fruits rank fifth in expenditure, while for together, married, and widowed customers, sweets take fifth place.
The lowest spending was on Sweets for Single and Divorced customers, whereas fruits hold the lowest expenditure among together, married, and widowed customers.
```SQL
SELECT Marital_Status,
		SUM(MntWines) AS Total_Wine,
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat,
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
GROUP BY Marital_Status
```
![Screenshot (167)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/1caa8dcd-2765-4aa6-9db7-0793fe3b6e67)

- Comparing the difference in spending based on the Education
Customers with graduate, PhD, master's, and 2nd cycle degrees exhibit the highest expenditure on wine, while basic-educated customers allocate the most spending towards gold.
The least spending was on Fruits for graduated, PhD, 2n Cycle, and Basic customers, whereas customers with master's degrees spent the least on sweets.
```SQL
SELECT Education,
		SUM(MntWines) AS Total_Wine, 
		SUM(MntFishProducts) AS Total_Fish,
		SUM(MntFruits) AS Total_Fruits,
		SUM(MntGoldProds) AS Total_Gold,
		SUM(MntMeatProducts) AS Total_Meat,
		SUM(MntSweetProducts) AS Total_Sweet
FROM marketing_campaign
GROUP BY Education
```
![Screenshot (168)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/0cc81862-56ef-45dd-acef-6588c88938cd)

- The next and final query shows the total amount spent on each product by the purchase method.
But first, we need to alter the column MntMeatProducts and MntFruits to make it `BIGINT` because there is an arithmetic overflow error.
```SQL
ALTER TABLE marketing_campaign
ALTER COLUMN MntMeatProducts BIGINT
ALTER TABLE marketing_campaign
ALTER COLUMN MntFruits BIGINT
```
![Screenshot (169)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/b3a20281-9198-4f0c-8ed1-4f12c57a01da)

We multiply the amount spent on each product (Fish, Meat, Fruit, Gold, Sweets) by the count of purchases made through each method (Web, Deals, Catalog, Store) then divide it by the sum of all purchase platforms to get the total amount spent on each product for each purchasing method.
Each product is represented by a separate column, making it easy to see the total amount spent on each product through different purchasing methods.
There is a dedicated column for purchasing methods called `Purchase_Method`.
```SQL
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
```
![Screenshot (170)](https://github.com/Karemelshimi/Customers-Personality-Analysis/assets/153403784/417978b4-a306-482a-82ce-0366608b604d)


