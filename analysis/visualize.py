import pandas as pd
import matplotlib.pyplot as plt
import psycopg2

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="marketplace_analytics",
    user="sonya",
    host="localhost",
    port="5432"
)


# Monthly sales analysis
query = """
SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS month,
    COUNT(o.order_id) AS total_orders,
    SUM(l.price) AS total_sales_value
FROM orders AS o
JOIN listings AS l
    ON o.listing_id = l.listing_id
WHERE o.order_date < DATE '2026-10-01'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;
"""

df = pd.read_sql_query(query, conn)

# Prepare data for visualisation
df["month"] = pd.to_datetime(df["month"])
df["total_sales_value"] = df["total_sales_value"].astype(float)

# Create chart
plt.figure(figsize=(10, 5))
plt.plot(
    df["month"],
    df["total_sales_value"],
    marker="o",
    linewidth=2
)

plt.title("Monthly Marketplace Transaction Value (2026)")
plt.xlabel("Month")
plt.ylabel("Transaction Value (EUR)")
plt.ylim(bottom=0)

# Displaying short month names
plt.xticks(
    df["month"],
    df["month"].dt.strftime("%b")
)
plt.grid(alpha=0.3)
plt.tight_layout()

from pathlib import Path

output_dir = Path(__file__).resolve().parent.parent / "figures"
output_dir.mkdir(exist_ok=True)

plt.savefig(output_dir / "monthly_sales.png", dpi=150, bbox_inches="tight")
plt.show()

conn.close()