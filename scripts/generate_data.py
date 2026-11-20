import csv
import random
from pathlib import Path
from datetime import date, timedelta

random.seed(42) 

# Saving files in the project's data folder
data_dir = Path(__file__).resolve().parent.parent / "data"
data_dir.mkdir(exist_ok = True)

def save_csv(filename, columns, rows):
    with open(data_dir / filename, "w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(columns)
        writer.writerows(rows)

# 1. Categories
categories = [
    (1, "Clothing"),
    (2, "Shoes"),
    (3, "Accessories"),
    (4, "Bags"),
    (5, "Jewelry"),
    (6, "Sportswear"),
]

save_csv("categories.csv", ["category_id", "category_name"], categories)

# 2. Users
countries = ["Lithuania", "Finland", "Latvia", "Estonia", "France", "Germany", "Ukraine", "France"]

users = []
for i in range (1, 101):
    joined = date(2025, 1, 1) + timedelta(days=random.randint(0, 300))
    users.append((i, f"user_{i}", random.choice(countries), joined))

save_csv("users.csv", ["user_id", "username", "country", "joined_at"], users)

# 3. Listings
listings = []
for i in range(1, 501):
    seller_id = random.randint(1, 100)
    category_id = random.randint(1, 6)
    price = round(random.uniform(5, 150), 2)
    created = date(2026, 1, 1) + timedelta(days=random.randint(0, 250))

    listings.append((i, seller_id, category_id, price, created))

save_csv("listings.csv",
        ["listing_id", "seller_id", "category_id", "price", "created_at"],
        listings)
# 4. Orders
orders = []
sold_listings = random.sample(listings, 250)

for i, listing in enumerate(sold_listings, start = 1):
    listing_id, seller_id, _, _, created = listing
    buyer_id = random.choice(
        [user_id for user_id in range(1,101) if user_id != seller_id]
    )
    order_date = created + timedelta(days = random.randint(1, 30))

    orders.append((i, listing_id, buyer_id, order_date))

save_csv("orders.csv",
         ["order_id", "listing_id", "buyer_id", "order_date"], orders)

print("Marketplace data generated successfully!")
