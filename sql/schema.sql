CREATE TABLE users(
    user_id INTEGER PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    country VARCHAR(50) NOT NULL,
    joined_at DATE NOT NULL

);

CREATE TABLE categories(
    category_id INTEGER PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE listings(
    listing_id INTEGER PRIMARY KEY,
    seller_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    created_at DATE NOT NULL,

    FOREIGN KEY (seller_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders(
    order_id INTEGER PRIMARY KEY,
    listing_id INTEGER NOT NULL UNIQUE,
    buyer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,

    FOREIGN KEY (listing_id) REFERENCES listings(listing_id),
    FOREIGN KEY (buyer_id) REFERENCES users(user_id)
);