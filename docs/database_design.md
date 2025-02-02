# Database Schema Overview

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

### `migrations` Table

| Column      | Type     | Description                                 |
|-------------|----------|---------------------------------------------|
| `id`        | INTEGER  | Primary key (auto-incremented).             |
| `migration` | VARCHAR(255) | Name of the migration file.             |
| `applied_at`| DATETIME | Timestamp of when the migration was applied.|


## Table Relationships

- **`sites`** to **`products`**: One-to-Many
  - A single site can have multiple products.
  
- **`products`** to **`product_history`**: One-to-Many
  - Each product can have multiple price history records.
