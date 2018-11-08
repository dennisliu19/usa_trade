# United States Trade Data

This repo contains US Trade Data from World Bank from 1991 to 2016. 

## Files

 - xxxxUSA.xlsx is the original files from WITS on World Bank  website. https://wits.worldbank.org/Default.aspx?lang=en
 - Data Combination.R contains script to extract data from each years workbook and combine them together
 - USATradeData.csv is the final worksheet contains data from 1996 to 2016. 
 - Initial Plot contains draft of intentional plot. 

## Data Cleaning Process

### Step 1

Combine all dataset together and delete unnecessary columns. Dataset is combined from xlsx sheets each year separately.

### Step 2

Add in region information for each country.

### Step 3

Add in GDP information for each country 