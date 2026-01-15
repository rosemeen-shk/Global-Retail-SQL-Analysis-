-- Fix order date formats
UPDATE sales
SET OrderDate_fixed =
CASE
    WHEN `Order Date` LIKE '%/%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
    WHEN `Order Date` LIKE '%-%-%' THEN STR_TO_DATE(`Order Date`, '%d-%m-%Y')
END;
UPDATE stores
SET OpenDate_converted =
CASE
    WHEN `Open Date` LIKE '%/%/%' THEN STR_TO_DATE(`Open Date`, '%m/%d/%Y')
    WHEN `Open Date` LIKE '%-%-%' THEN STR_TO_DATE(`Open Date`, '%d-%m-%Y')
END;
UPDATE exchange_rates
SET Date_fixed =
CASE
    WHEN `Date` LIKE '%/%/%' THEN STR_TO_DATE(`Date`, '%m/%d/%Y')
    WHEN  `Date` LIKE '%-%-%' THEN STR_TO_DATE(`Date`, '%d-%m-%Y')
END;