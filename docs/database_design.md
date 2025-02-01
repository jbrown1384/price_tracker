# Database Design

## Database Choice

- **SQLite:**

## Schema Details

### `prices` Table

| Column        | Type     | Description                             |
|---------------|----------|-----------------------------------------|
| `id`          | INTEGER  | Primary key (auto-incremented).         |
| `product_name`| TEXT     | Name of the product (e.g., "AW SuperFast Roadster"). |
| `price`       | REAL     | The scraped price of the bicycle.       |
| `scraped_at`  | DATETIME | Timestamp of when the price was scraped.|

