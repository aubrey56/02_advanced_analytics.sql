# 🛒 E-Commerce Advanced SQL Analytics (PostgreSQL)

## 📌 Project Overview
An end-to-end analytical project exploring customer purchasing trends, revenue trajectories, operational performance, and customer segmentation on the **Olist Brazilian E-Commerce Dataset** (~100k+ orders). 

The goal of this portfolio project is to model real-world business challenges using enterprise-grade **PostgreSQL** syntax, window functions, and Common Table Expressions (CTEs).

---

## 🛠️ Tech Stack & Database Architecture
* **Database Engine:** PostgreSQL 16
* **Database Client:** DBeaver
* **SQL Techniques Used:** Common Table Expressions (CTEs), Window Functions (`LAG`, `NTILE`, `SUM OVER`), Conditional Aggregations (`COUNT CASE`), Data Type Casting, and String Sanitization.

---

## 📊 Key Analytical Workflows

### 1. Monthly Order Trends & Growth Performance
* **Business Value:** Evaluates Month-over-Month (MoM) order volume growth and monitors long-term operational scaling.
* **Key Insights:** Identified baseline growth trajectories and seasonal peak order periods across multi-year historical order data.
* **Core SQL Features:** `LAG()` for MoM percentage calculation, `SUM() OVER()` for running cumulative counts.

### 2. Customer RFM Segmentation
* **Business Value:** Segments individual buyers into strategic tiers (**VIP**, **Big Spenders**, **Frequent Shoppers**) to enable targeted marketing campaigns.
* **Core SQL Features:** `NTILE(4)` quartile scoring, multi-table joins across orders, payments, and customers.

---

## 🚀 How to Run locally
1. Clone this repository:
   ```bash
   git clone [https://github.com/aubrey56/sql-practice-ecommerce.git](https://github.com/aubrey56/sql-practice-ecommerce.git)
