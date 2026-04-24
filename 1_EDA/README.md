# 🔬 Data Engineer Job Market Analysis (EDA Project)

## 🎯 Overview

This project explores the **remote Data Engineer job market** using SQL-based analysis.  
The goal is to understand:

- 🔥 Most in-demand skills in job postings  
- 💰 Skills that are associated with higher salaries  
- ⚖️ Balanced skills that offer both demand and good pay  

This is part of my learning journey in **Data Engineering and Analytics**.

---

## 📊 What I Analyzed

I worked with real job posting data to answer three key questions:

---

## 1️⃣ Most In-Demand Skills

### ❓ Question:
Which skills appear most frequently in Data Engineer job listings?

### 📌 Key Findings:
- SQL and Python are the most commonly required skills
- Cloud platforms like AWS and Azure are highly in demand
- Big data tools like Spark and Airflow are widely used

| Rank | Skill   | Job Count |
|------|--------|-----------|
| 1    | SQL    | 29,221    |
| 2    | Python | 28,776    |
| 3    | AWS    | 17,823    |
| 4    | Azure  | 14,143    |
| 5    | Spark  | 12,799    |

👉 **Insight:** SQL + Python are the true baseline skills for Data Engineering roles.

---

## 2️⃣ Top Paying Skills

### ❓ Question:
Which skills are associated with higher salaries?

### 📌 Key Findings:
- Some niche tools offer very high salaries
- DevOps and infrastructure tools are highly valued
- Big data tools also show strong earning potential

| Skill      | Median Salary | Job Count |
|------------|--------------|-----------|
| Rust       | $210K        | 232       |
| Terraform  | $184K        | 3,248     |
| Golang     | $184K        | 912       |
| Kubernetes | $150K        | 4,202     |
| Airflow    | $150K        | 9,996     |

👉 **Insight:** High salary does not always mean high demand (e.g., Rust is high-paying but niche).

---

## 3️⃣ Balanced / Optimal Skills

### ❓ Question:
Which skills provide the best balance between demand and salary?

### 📌 Approach:
A simple score was used combining:
- Salary
- Job demand frequency

### 📌 Top Balanced Skills:
- Terraform → strong demand + high salary  
- Python → essential foundation skill  
- Kubernetes → growing demand in DevOps  

👉 **Insight:** The best skills are those that are both widely used and well-paid.

---

## 🧠 Key Learnings

- SQL and Python are must-have foundational skills  
- Cloud platforms (AWS/Azure) are essential in modern data roles  
- DevOps tools like Terraform and Kubernetes are increasingly important  
- Big Data tools (Spark, Airflow) are widely used in production systems  

---

## 🛠️ Tech Stack Used

- SQL (Data analysis)
- Python (Exploration logic)
- Job posting dataset (remote data engineer roles)

---

## 🚀 Personal Takeaway

This project helped me understand that Data Engineering is not about learning everything, but about:

- 📌 Building strong fundamentals first (SQL + Python)
- 📌 Adding cloud and big data skills next
- 📌 Then specializing in high-impact tools

I’m using this analysis to guide my own learning path in Data Engineering.

---

## 📌 Next Steps (My Learning Plan)

- Strengthen SQL and Python
- Learn AWS or Azure deeply
- Practice Spark and Airflow with projects
- Build end-to-end data engineering pipelines