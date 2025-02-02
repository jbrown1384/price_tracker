# Database Design

## Database Choice

- **SQLite:**

## Schema Details

### `sites` Table

| Column         | Type    | Description                                     |
|----------------|---------|-------------------------------------------------|
| `id`           | INTEGER | Primary key (auto-incremented).                 |
| `name`         | TEXT    | Name of the site (e.g., "glitch").              |
| `active_status`| BOOLEAN | Indicates if the site is active.                |

### `products` Table

| Column         | Type     | Description                                                |
|----------------|----------|------------------------------------------------------------|
| `id`           | INTEGER  | Primary key (auto-incremented).                            |
| `site_id`      | INTEGER  | Foreign key referencing `sites(id)`.                       |
| `name`         | TEXT     | Name of the product                                        |
| `active_status`| BOOLEAN  | Indicates if the product is active.                        |

### `product_history` Table

| Column       | Type     | Description                                               |
|--------------|----------|-----------------------------------------------------------|
| `id`         | INTEGER  | Primary key (auto-incremented).                           |
| `product_id` | INTEGER  | Foreign key referencing `products(id)`.                   |
| `price`      | REAL     | The scraped price of the product.                         |
| `scraped_at` | DATETIME | Timestamp of when the price was scraped.                  |
