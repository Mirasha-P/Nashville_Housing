--Create table in SQL

CREATE TABLE staging.nashville_housing
(
    unique_id bigint PRIMARY KEY,
    parcel_id character varying(20),
    land_use character varying(50),
    property_address character varying(100),
    sale_date date,
    sale_price numeric(10),
    legal_reference varchar(50),
    sold_as_vacant character(5),
    owner_name character varying(100),
    owner_address character varying(100),
    acreage numeric(6, 2),
    tax_district character(50),
    land_value numeric(10),
    building_value numeric(10),
    total_value numeric(10),
    year_built numeric(5),
    bedrooms numeric(3),
    fullbath numeric(3),
    halfbath numeric(3),
	propertysplit_address varchar(200),
	propertysplit_city varchar(200),
	ownersplit_address varchar(200),
	ownersplit_city varchar(200),
	ownersplit_state varchar(200));

SELECT * FROM staging.nashville_housing

INSERT INTO staging.nashville_housing
SELECT *
FROM raw.nashville_housing;


--cleaning data in SQL

SELECT *
FROM staging.nashville_housing;

--standardize date format
SELECT
    sale_date,
    CAST(sale_date AS date)
FROM staging.nashville_housing;
--OR
UPDATE staging.nashville_housing
SET Sale_date = CAST (sale_date AS date)


--populate property address data
SELECT *
FROM staging.nashville_housing
WHERE property_address IS NULL;	

SELECT 
	nh1.parcel_id,
	nh1.property_address,
	nh2.parcel_id,
	nh2.property_address, 
	COALESCE (nh2.property_address,nh1.property_address)
FROM staging.nashville_housing nh1
	JOIN staging.nashville_housing nh2
	ON nh1.parcel_id = nh2.parcel_id
	AND nh1.unique_id <> nh2.unique_id
WHERE nh2.property_address IS NULL


UPDATE staging.nashville_housing nh2
SET property_address = COALESCE (nh2.property_address,nh1.property_address)
FROM staging.nashville_housing nh1
WHERE nh1.parcel_id = nh2.parcel_id
	AND nh1.unique_id <> nh2.unique_id
	AND nh2.property_address IS NULL

--breaking out address into individual columns (Address,City,State)
---property_address
SELECT
SUBSTRING (property_address,1, POSITION (',' IN property_address)-1) AS Address,
SUBSTRING (property_address,POSITION (',' IN property_address)+1) AS City
FROM staging.nashville_housing

ALTER TABLE staging.nashville_housing
ADD propertysplit_address varchar(200)

UPDATE staging.nashville_housing
SET propertysplit_address = SUBSTRING (property_address,1, POSITION (',' IN property_address)-1)

ALTER TABLE staging.nashville_housing
ADD propertysplit_city varchar(200)

UPDATE staging.nashville_housing
SET propertysplit_city = SUBSTRING (property_address,POSITION (',' IN property_address)+1)

---Owner_Address
SELECT
    split_part(Owner_Address, ',', 1) AS Address,
    replace(split_part(Owner_Address, ',', 2), ',', '') AS City,
	replace(replace(split_part(Owner_Address, ',', 3), ',', ''), ',', '') AS State
FROM staging.nashville_housing;


ALTER TABLE staging.nashville_housing
ADD ownersplit_address varchar(200)

UPDATE staging.nashville_housing
SET ownersplit_address = split_part(Owner_Address, ',', 1)

ALTER TABLE staging.nashville_housing
ADD ownersplit_city varchar(200)

UPDATE staging.nashville_housing
SET ownersplit_city = replace(split_part(Owner_Address, ',', 2), ',', '')

ALTER TABLE staging.nashville_housing
ADD ownersplit_state varchar(200)

UPDATE staging.nashville_housing
SET ownersplit_state = replace(replace(split_part(Owner_Address, ',', 3), ',', ''), ',', '')


SELECT *
FROM staging.nashville_housing
--Change Y and N to YES and NO

SELECT DISTINCT (sold_as_vacant),
	COUNT (sold_as_vacant) 
FROM staging.nashville_housing
GROUP BY sold_as_vacant

SELECT 
	sold_as_vacant,
	CASE 
		WHEN sold_as_vacant = 'Y' THEN 'Yes'
		WHEN sold_as_vacant = 'N' THEN 'No'
		ELSE sold_as_vacant
		END
FROM staging.nashville_housing

UPDATE staging.nashville_housing
SET sold_as_vacant = CASE 
		WHEN sold_as_vacant = 'Y' THEN 'Yes'
		WHEN sold_as_vacant = 'N' THEN 'No'
		ELSE sold_as_vacant
		END

--Remove Duplicate
WITH numberedrows AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY
			parcel_id,
			property_address,
			sale_date,
			sale_price,
			legal_reference
	ORDER BY
			unique_id
	)row_num
FROM staging.nashville_housing
)
SELECT *
FROM numberedrows
WHERE row_num >1
ORDER BY Parcel_id;

---Deleting
WITH numberedrows AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY
			parcel_id,
			property_address,
			sale_date,
			sale_price,
			legal_reference
	ORDER BY
			unique_id
	)row_num
FROM staging.nashville_housing
)
DELETE FROM staging.nashville_housing
			WHERE (parcel_id,property_address,sale_date,sale_price,legal_reference) IN
			(SELECT parcel_id,property_address,sale_date,sale_price,legal_reference
			FROM numberedrows
			WHERE row_num >1);

--Delete Unused Coulumns

SELECT *
FROM staging.nashville_housing

ALTER TABLE staging.nashville_housing
DROP COLUMN Owner_Address,
DROP COLUMN property_address,
DROP COLUMN tax_district
