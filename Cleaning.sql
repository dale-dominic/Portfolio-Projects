SELECT 
	*
FROM 
	housing_data;

-- Standardize Date Format

SELECT
	SaleDate, CAST(SaleDate AS date)
FROM
	housing_data;


ALTER TABLE housing_data ALTER COLUMN SaleDate DATE;


UPDATE housing_data
SET SaleDate = CAST(SaleDate AS date);


SELECT
	SaleDate
FROM
	housing_data;

-- Populate PropertyAddress Data

SELECT
	*
FROM
	housing_data
WHERE
	PropertyAddress IS NULL;

SELECT
	a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
	housing_data a
JOIN housing_data b
	ON a.ParcelID = b.ParcelID AND
	a.[UniqueID ]<>b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
	housing_data a
JOIN housing_data b
	ON a.ParcelID = b.ParcelID AND
	a.[UniqueID ]<>b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL;

-- Breaking down Address into Individal Columns (Address, City, State)

 SELECT
	SUBSTRING	
	(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
	SUBSTRING
	(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM 
	housing_data;

-- ALTERING TABLE
ALTER TABLE 
	housing_data
ADD PropertySplitAddress NVARCHAR(255);

UPDATE 
	housing_data
SET 
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE 
	housing_data
ADD 
	PropertySplitCity NVARCHAR(255);

UPDATE 
	housing_data
SET 
	PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));
-- END


SELECT 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM
	housing_data;	

--ALTERING TABLE
ALTER TABLE 
	housing_data
ADD 
	OwnerSplitAddress NVARCHAR(255);
UPDATE 
	housing_data
SET 
	OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);


ALTER TABLE 
	housing_data
ADD 
	OwnerSplitCity NVARCHAR(255);
UPDATE 
	housing_data
SET 
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE 
	housing_data
ADD 
	OwnerSplitState NVARCHAR(255);
UPDATE 
	housing_data
SET 
	OwnerSplitState =PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);
--END


-- Change Y and N to 'Yes' and 'No' in 'Sold as Vacant' Field -- 
SELECT 
	DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM 
	housing_data
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant) DESC;


SELECT 
	SoldAsVacant, 
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES' 
	WHEN SoldAsVacant = 'N' THEN 'No' 
	ELSE SoldAsVacant
	END
FROM 
	housing_data

--ALTERING TABLE
  UPDATE 
	housing_data
SET 
	SoldAsVacant = 
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES' 
	WHEN SoldAsVacant = 'N' THEN 'No' 
	ELSE SoldAsVacant
	END


-- Removing Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
 FROM housing_data
)
Select 
	*
FROM 
	RowNumCTE
WHERE 
	row_num > 1
ORDER BY 
	PropertyAddress;


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
 FROM housing_data
)
DELETE
FROM 
	RowNumCTE
WHERE 
	row_num > 1;

-- Delete Unused Rows
ALTER TABLE 
	housing_data
DROP COLUMN
	OwnerAddress, TaxDistrict, PropertyAddress;

SELECT
	*
FROM 
	housing_data;