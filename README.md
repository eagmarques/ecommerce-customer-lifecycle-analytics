# 📊 Product & Customer Analytics Dashboard for E-commerce

## 🧠 Project Context

This project simulates a real-world Product Analytics scenario applied to a cosmetics e-commerce platform.

The goal is to analyze user behavior over time, identifying patterns in:

- Engagement
- Purchase recurrence
- Retention
- Churn
- Revenue generation

The project was developed with a focus on a professional portfolio for Data Analyst / Product Analyst positions, using an end-to-end approach: from data ingestion to building an analytical dashboard.

---

## 🎯 Objective

Build a complete analytical pipeline and a dashboard to answer business questions such as:

- How many users are active daily and monthly?
- Do users return frequently?
- What is the retention rate over time?
- Are we losing users (churn)?
- Do customers come back to buy?
- Is revenue concentrated in recurring customers?

---

## 📦 Dataset

- Source: Kaggle  
- Dataset: *E-commerce Events History in Cosmetics Shop*

The dataset contains user interaction events with the e-commerce platform:

- `view` → product view
- `cart` → add to cart
- `purchase` → purchase

### ⚠️ Important Limitations

- No explicit order identifier (`order_id`)
- No complete session structure
- No explicit churn events

Therefore, some metrics were built as **analytical proxies**, following Product Analytics best practices.

---

## 🏗️ Data Architecture

The project follows a layered architecture inspired by modern best practices:

staging → intermediate → marts

- **staging** → initial treatment of raw data  
- **intermediate** → transformation to analytical granularity (user-day)  
- **marts** → aggregated tables ready for analysis and dashboard

---

## 🧱 Data Modeling

### Base Table: `int_user_activity`

Granularity:
- 1 row per user per day

Main Metrics:
- Total events
- Number of sessions
- Purchase events (`purchase`)
- View events (`view`)
- Cart events (`cart`)

This table is the foundation for all analysis in the project.

---

## 📊 Metrics and Definitions

### DAU (Daily Active Users)
Number of unique active users per day.

### MAU (Monthly Active Users)
Number of unique active users per month.

### Stickiness
Measures the frequency of use within the user base:
Stickiness = average DAU of the month / MAU

### Retention
Percentage of users who return after the first month of activity (cohort analysis).

### Churn (proxy)
Active users in the previous month who did not return in the current month.

### Repurchase (proxy)
Users with purchases on more than one:
- Date
- Session
- Or month

### Revenue
Calculated as the sum of values (`price`) from purchase events.

### ⚠️ Important Note

Due to the absence of `order_id`, metrics such as:

- Number of orders
- Average Transaction Value (ATV) per order

were treated as **proxies**, using distinct events, sessions, and days.

---

## 🔍 Key Analyses

- DAU and MAU evolution
- Monthly Stickiness
- Cohort analysis (retention by acquisition month)
- Retention rate over time
- Monthly Churn
- Purchase behavior by customer
- Purchase frequency and time between purchases
- Identification of recurring vs non-recurring customers

---

## 📁 Project Structure
.
├── data/raw/
├── sql/
│   ├── staging/
│   ├── intermediate/
│   ├── marts/
│   └── validation/
├── src/
│   ├── ingestion/
│   └── transform/
├── dashboards/
│   └── commerce_product_analytics_dashboard.pbix
└── docs/

---

## 🚀 How to Run

### 1. Data Ingestion

```bash
python src/ingestion/download_kaggle_dataset.py
python src/ingestion/load_raw_to_sqlite.py
```

### 2. Run SQL Pipeline & Validations

The pipeline script automatically executes all transformations (staging → intermediate → marts) and then runs the data validation suite to ensure metric integrity.

```bash
python src/transform/run_pipeline.py
```

### 3. View Dashboards in Power BI

Open the `commerce_product_analytics_dashboard.pbix` file in the `dashboards/` folder and connect to the SQLite database.

---

## ✅ Data Validation

The project features a robust validation layer to ensure data quality and metric consistency:

- **Pipeline Validations**: 25+ automated checks for duplicates, nulls, negative values, and logical inconsistencies (e.g., retention > 100%).
- **Monitoring Checks**: Identifies business anomalies like unusual purchase price patterns or spikes in activity.
- **Automated Enforcement**: The `run_pipeline.py` will fail and provide detailed error logs if critical validation rules are violated.

---

## 📊 Dashboard Overview

The dashboard is organized into 5 main pages:

### 1. 📊 Overview

- DAU, MAU, and Stickiness
- Total events
- Temporal trend

### 2. 🔄 Retention

- Cohort heatmap
- Retention rate
- Retention curve

### 3. 📉 Churn

- Monthly churn rate
- Lost users
- Retention vs churn comparison

### 4. 💰 Customer Behavior

- Repurchase rate
- Purchase frequency
- Time between purchases
- Revenue per customer

### 5. 🛒 Executive Insights

- Key findings
- Business hypotheses
- Recommendations

---

## 💡 Expected Insights

- Strong drop in retention in the first month
- Low purchase recurrence
- Revenue concentrated in recurring customers
- Opportunity to improve retention and repurchase

---

## 🛠️ Technologies Used

- Python
- SQLite
- Power BI
- Kaggle API
- SQL

---

## 🚀 Next Steps

- Implement simplified LTV
- Improve session modeling
- Migrate to dbt
- Publish dashboard online

---

## 📝 License

This project is open-source and available under the MIT license.

---

## 👨‍💻 Author

- Eduardo Abras Gomes Marques
- Control and Automation Engineer | Data Analytics
- 🔗 https://www.linkedin.com/in/eagmarques/
