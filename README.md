# Retail-Customer-Transaction-Analysis-SQL
SQL case study analyzing retail customer transactions — revenue, returns, customer segmentation using joins, subqueries, and aggregate functions

## 📌 Overview
An advanced SQL case study analyzing a retail company's customer, product, and transaction data to answer real-world business questions around sales performance, customer behavior, returns, and revenue.

## 🗂️ Database Structure
- **Customer** — customer demographics (Gender, City, DOB)
- **prod_cat_info** — product category & sub-category mapping
- **Transactions** — transaction-level sales data (Qty, Amount, Store Type, Dates)

## 🛠️ Skills & Concepts Used
- Joins (multi-table)
- Aggregate Functions (SUM, COUNT, AVG, MAX)
- Subqueries & Correlated Subqueries
- HAVING clause for conditional aggregation
- Date functions (DATEDIFF, DATEADD, CONVERT)
- TOP N analysis
- CTE-style nested queries for % calculations

## 🔍 Key Business Questions Solved
- Data understanding: row counts, date range, category mapping, data type fixes
- Most frequently used transaction channel (store type)
- Gender & city-wise customer distribution
- Revenue analysis by category (Electronics, Books, Clothing) and by store type
- Customers with >10 transactions (excluding returns)
- Revenue from male customers in Electronics, broken down by sub-category
- **Top 5 sub-categories by sales % and return %**
- Revenue from customers aged 25–35 in the last 30 days of available data
- Product category with maximum returns in the last 3 months
- Categories with above-average revenue
- **Top 5 categories by quantity sold — average & total revenue by sub-category**

## 💡 Key Insights
- Identified top-performing and highest-return product categories
- Found high-value customer segments (age-based, frequency-based)
- Quantified channel-wise and category-wise revenue contribution

