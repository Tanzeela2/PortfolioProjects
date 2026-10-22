# COVID-19 Data Exploration (SQL Server)

## 📌 Project Overview
This project performs exploratory data analysis (EDA) on global COVID-19 data using **Microsoft SQL Server**. The goal is to analyze vaccination progress, mortality rates, and population impact globally and regionally.

## 🛠️ SQL Skills & Features Used
* **Joins** (INNER JOIN between Covid Deaths & Vaccinations tables)
* **CTE's** (Common Table Expressions for sub-query organization)
* **Temp Tables** (To store intermediate calculations for percentage metrics)
* **Window Functions** (`SUM() OVER (PARTITION BY ... ORDER BY ...)`)
* **Views** (Stored data structures ready for Power BI / Tableau visualization)

## 📊 Key Findings / Analysis Included
* Total Cases vs. Total Deaths (Death Percentage)
* Total Cases vs. Population (Infection Rate)
* Rolling vaccination counts by Location
* Percentage of population vaccinated over time

## 📁 Repository Structure
* `Covid Data Analysis.sql` — Main SQL script containing all queries and view definitions.
