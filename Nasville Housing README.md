# Nashville Housing Data Cleaning Project

## Overview
This is a data cleaning project where Nashville housing market data was imported from Excel into SQL for cleaning and transformation. The dataset contained missing values, duplicates, unstructured address fields, and other inconsistencies. The aim of this project was to showcase data cleaning techniques to improve the structure of the data before it is used for analysis.

---

## Tools Used
- **SQL Server**

---

## Skills
- Data cleaning
- Data standardisation
- Removing duplicates
- Dealing with missing values
- CTEs
- Window functions

---

## Data Cleaning Process
- Standardised date values by converting the fields in the `SaleDate` column.
- Populated missing property address values to handle missing data.
- Broke down addresses into individual columns (address, city, state).
- Standardised categorical values by changing `Y` and `N` into `Yes` and `No`.
- Used CTEs and window functions to identify and remove duplicate records.

---

## Key Outcomes
Overall data quality was improved by removing inconsistent and duplicate values. This resulted in a more structured and analysis-ready dataset.
