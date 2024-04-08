---EDA
---Properties per City

SELECT 
	property_city,
	COUNT(parcel_id) Number_of_properties
FROM staging.nashville_housing
GROUP BY property_city
ORDER BY Number_of_properties DESC


---Properties per Owner
SELECT 
	Owner_Name,
	COUNT(parcel_id) Number_of_properties
FROM staging.nashville_housing
GROUP BY Owner_Name
ORDER BY Number_of_properties DESC

---Properties Sold per Year
SELECT 
	EXTRACT(YEAR FROM sale_date) AS Year,
	COUNT(parcel_id) Number_of_properties
FROM staging.nashville_housing
GROUP BY Year
ORDER BY Number_of_properties DESC


---Price Categories and Analysis

WITH PriceCat AS (
	SELECT 
		*,
		CASE
			WHEN sale_price <= '100000' THEN 'Cheap'
		WHEN sale_price > '100000' AND sale_price <= '1000000' THEN 'Average'
		ELSE 'Expensive'
		END AS price_Category
	FROM staging.nashville_housing)

SELECT 
	price_Category,
	COUNT(unique_id) Number_of_Properties
FROM PriceCat
GROUP BY price_Category
ORDER BY price_Category;

---properties from each price cat per City
WITH PriceCat AS (
	SELECT 
		*,
		CASE
			WHEN sale_price <= '100000' THEN 'Cheap'
		WHEN sale_price > '100000' AND sale_price <= '1000000' THEN 'Average'
		ELSE 'Expensive'
		END AS price_Category
	FROM staging.nashville_housing)

SELECT 
	property_city,
	price_Category,
	COUNT(unique_id) Number_of_Properties
FROM PriceCat
GROUP BY price_Category,property_city
ORDER BY property_city DESC;


---properties from each price cat per City
WITH PriceCat AS (
	SELECT 
		*,
		CASE
			WHEN sale_price <= '100000' THEN 'Cheap'
		WHEN sale_price > '100000' AND sale_price <= '1000000' THEN 'Average'
		ELSE 'Expensive'
		END AS price_Category
	FROM staging.nashville_housing)

SELECT 
	property_city,
	price_Category,
	COUNT(unique_id) Number_of_Properties
FROM PriceCat
GROUP BY price_Category,property_city
ORDER BY property_city DESC;


---land use

SELECT 
	land_use,
COUNT(unique_id) Number_of_Properties	
FROM staging.nashville_housing
GROUP BY land_use
ORDER BY Number_of_Properties DESC;


--sold as vacant

SELECT 
	sold_as_Vacant,
COUNT(unique_id) Number_of_Properties	
FROM staging.nashville_housing
GROUP BY sold_as_Vacant
ORDER BY Number_of_Properties DESC;


---Acreage

SELECT 
	Acreage,
COUNT(unique_id) Number_of_Properties	
FROM staging.nashville_housing
GROUP BY Acreage
ORDER BY Number_of_Properties DESC;


--year built
SELECT 
	Year_Built,
COUNT(parcel_id) Number_of_Properties	
FROM staging.nashville_housing
GROUP BY Year_Built
ORDER BY Number_of_Properties DESC;

--bedrooms
SELECT 
	bedrooms,
COUNT(unique_id) Number_of_Properties	
FROM staging.nashville_housing
GROUP BY bedrooms
ORDER BY Number_of_Properties DESC;

