# Chinook Notes

This document describes SQL queries in *chinook_analysis.sql*  
Each entry includes: **SQL techniques used** and a concise **business insight**.

---

## 💰 Sales & Revenue Analysis

### 1. Total Revenue
- **SQL techniques:** Aggregation (SUM)  
- **Business insight:**  Shows overall sales performance.

 ### 2. Total Revenue by Country
- **SQL techniques:** GROUP BY, aggregation (SUM), ordering  
- **Business insight:** Highlights top-selling countries.

### 3. Monthly Revenue Trend
- **SQL techniques:** Date formatting (STRFTIME), GROUP BY, time-series aggregation  
- **Business insight:** Tracks monthly sales patterns.

### 4. Revenue by Genre
- **SQL techniques:** JOINs, GROUP BY, aggregation  
- **Business insight:** Identify top-earning genres

### 5. Top 10 Revenue-Contributing Albums
- **SQL techniques:** JOINs across invoice lines, GROUP BY, LIMIT  
- **Business insight:** Lists best-selling albums.

---

## 👥 Customer Insights

### 6. Total Sales per Customer
- **SQL techniques:** JOINs, GROUP BY, aggregation  
- **Business insight:** Finds top-spending customers.
  
### 7. Customer Lifetime Value (CLV) Segments
- **SQL techniques:** Subquery/derived table, CASE WHEN for segmentation  
- **Business insight:** Groups customers by total spend.

### 8. Repeat Purchase Behavior (Repeat vs One-time)
- **SQL techniques:** CTE/aggregation, conditional grouping  
- **Business insight:** Measures customer loyalty.

### 9. Customer Purchase Frequency (Top)
- **SQL techniques:** GROUP BY, ordering, LIMIT  
- **Business insight:** Lists most frequent buyers.

### 10. Average Invoice Value by Customer Tier
- **SQL techniques:** CTE, aggregation, tiering with CASE WHEN  
- **Business insight:** Compares spending across customer tiers.

---

## 🎵 Product & Genre Performance

### 11. Top-selling Tracks by Quantity
- **SQL techniques:** JOINs, GROUP BY, aggregation, ordering  
- **Business insight:** Highlights most popular tracks.

### 12. Tracks Never Sold
- **SQL techniques:** LEFT JOIN with NULL filter  
- **Business insight:** Identifies unsold tracks.

### 13. Genre Cross-Sell Pairs (Co-purchase)
- **SQL techniques:** CTE, self-join on invoice/transaction, aggregation  
- **Business insight:** Shows genres often bought together.
- 
### 14. Average Price per Track by Genre
- **SQL techniques:** JOIN, AVG, GROUP BY  
- **Business insight:** Compares genre-level pricing.

### 15. Revenue Contribution by Top 10 Tracks
- **SQL techniques:** Derived table/CTE, proportional calculation, aggregation  
- **Business insight:** Shows how much top tracks contribute.

---

## 🏢 Employee & Sales Agent Performance

### 16. Employee Revenue Contribution
- **SQL techniques:** JOIN chain (Employee->Customer->Invoice), GROUP BY, aggregation  
- **Business insight:** Tracks revenue per employee.

### 17. Employee Average Revenue per Customer
- **SQL techniques:** Subquery/derived aggregation, AVG, JOIN  
- **Business insight:** Measures rep performance per customer

### 18. Top 5 Employees by Revenue
- **SQL techniques:** JOINs, GROUP BY, ORDER BY, LIMIT  
- **Business insight:** Lists top-performing employees.

---

## 🌍 Regional / Country Analysis

### 19. Average Invoice Value by Country
- **SQL techniques:** GROUP BY, AVG, aggregation  
- **Business insight:** Compares average spend by country.

### 20. Revenue Contribution by Top Countries
- **SQL techniques:** GROUP BY, aggregation, percentage-of-total calculation  
- **Business insight:** Shows which countries drive revenue.
---

*End of Chinook Notes*
