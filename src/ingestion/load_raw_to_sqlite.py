import sys
import sqlite3
from pathlib import Path
import pandas as pd

# Add project root to sys.path to allow imports from config
project_root = Path(__file__).resolve().parents[2]
if str(project_root) not in sys.path:
    sys.path.append(str(project_root))

from config.paths import RAW_DIR, DB_PATH, DATABASE_DIR


def sanitize_table_name(file_name: str) -> str:
    return (
        file_name.lower()
        .replace(".csv", "")
        .replace("-", "_")
        .replace(" ", "_")
    )


def load_csvs_to_sqlite() -> None:
    DATABASE_DIR.mkdir(parents=True, exist_ok=True)

    csv_files = sorted(RAW_DIR.glob("*.csv"))
    if not csv_files:
        raise FileNotFoundError(f"No CSV files found in {RAW_DIR}")

    conn = sqlite3.connect(DB_PATH)

    for file in csv_files:
        table_name = f"raw_{sanitize_table_name(file.name)}"

        df = pd.read_csv(file)
        df.to_sql(table_name, conn, if_exists="replace", index=False)

        print(f"Table loaded: {table_name}")

    conn.close()
    print(f"Loading successfully finished at: {DB_PATH}")


if __name__ == "__main__":
    load_csvs_to_sqlite()