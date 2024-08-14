# Nashville Housing Data Analysis

## Project Overview
This project involves cleaning and analyzing Nashville housing data using SQL. The analysis provides insights into various aspects of the Nashville housing market, including property distribution, pricing trends, and property characteristics.

## Data Source
The analysis uses a Kaggale dataset containing information about Nashville housing properties, including details such as sale price, property address, owner information, and property characteristics.

## Key Analyses

1. **Data Cleaning:**
   - Standardized date formats
   - Populated missing property addresses
   - Split address fields into individual columns (Address, City, State)
   - Standardized 'Sold as Vacant' field values
   - Removed duplicate entries

2. **Exploratory Data Analysis (EDA):**
   - Properties per City
   - Properties per Owner
   - Properties Sold per Year
   - Price Categories Analysis
   - Land Use Distribution
   - 'Sold as Vacant' Distribution
   - Acreage Distribution
   - Year Built Distribution
   - Bedroom Count Distribution

## SQL Techniques Used

- CTEs (Common Table Expressions)
- Window Functions
- CASE Statements
- Aggregate Functions
- String Manipulation (SUBSTRING, SPLIT_PART)
- Data Type Conversion
- Table Alterations (ADD COLUMN, DROP COLUMN)

## How to Use

1. Clone this repository.
2. Ensure you have access to a SQL database (PostgreSQL recommended).
3. Import the provided dataset into your database.
4. Run the SQL queries in the `nashville_housing_analysis.sql` file.

## Sample Queries

```sql
-- Properties per City
SELECT 
    property_city,
    COUNT(parcel_id) Number_of_properties
FROM staging.nashville_housing
GROUP BY property_city
ORDER BY Number_of_properties DESC;

-- Price Categories Analysis
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

-- More queries can be found in the nashville_housing_analysis.sql file
```


## Future Work

- Develop visualizations based on the SQL query results.
- Perform time series analysis on housing prices.
- Investigate correlations between different property characteristics and sale prices.
