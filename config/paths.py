from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[1]

DATA_DIR = BASE_DIR / "data"
RAW_DIR = DATA_DIR / "raw"

DATABASE_DIR = BASE_DIR / "database"
DB_PATH = DATABASE_DIR / "ecommerce_analytics.db"

SQL_DIR = BASE_DIR / "sql"
STAGING_SQL_DIR = SQL_DIR / "staging"
INTERMEDIATE_SQL_DIR = SQL_DIR / "intermediate"
MARTS_SQL_DIR = SQL_DIR / "marts"
VALIDATION_SQL_DIR = SQL_DIR / "validation"