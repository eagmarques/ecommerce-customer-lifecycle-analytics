import sys
import sqlite3
from pathlib import Path


# Add project root to sys.path to allow imports from config
project_root = Path(__file__).resolve().parents[2]
if str(project_root) not in sys.path:
    sys.path.append(str(project_root))

from config.paths import (
    DB_PATH,
    STAGING_SQL_DIR,
    INTERMEDIATE_SQL_DIR,
    MARTS_SQL_DIR,
    VALIDATION_SQL_DIR,
)


def execute_sql_folder(conn: sqlite3.Connection, folder: Path) -> None:
    """
    Executes all .sql files in a folder using executescript.
    Ideal for staging, intermediate and marts.
    """
    if not folder.exists():
        print(f"[INFO] Folder not found, skipping: {folder}")
        return

    sql_files = sorted(folder.glob("*.sql"))

    if not sql_files:
        print(f"[INFO] No SQL files found in: {folder}")
        return

    for sql_file in sql_files:
        sql = sql_file.read_text(encoding="utf-8")
        conn.executescript(sql)
        print(f"[OK] Executed: {sql_file.relative_to(project_root)}")


def split_sql_statements(sql: str) -> list[str]:
    """
    Splits a SQL file into statements based on ';'.
    Simple and sufficient for this project, assuming no internal ';'.
    """
    return [stmt.strip() for stmt in sql.split(";") if stmt.strip()]


def run_validation_folder(conn: sqlite3.Connection, folder: Path) -> None:
    """
    Executes SQL validations.
    Each statement should return 0 rows when everything is correct.
    If it returns rows, it is treated as an inconsistency.
    """
    if not folder.exists():
        print(f"[INFO] Validation folder not found, skipping: {folder}")
        return

    sql_files = sorted(folder.glob("*.sql"))

    if not sql_files:
        print(f"[INFO] No validation SQL files found in: {folder}")
        return

    total_failed_checks = 0
    total_failed_rows = 0

    for sql_file in sql_files:
        print(f"\n[VALIDATION] File: {sql_file.relative_to(project_root)}")
        sql = sql_file.read_text(encoding="utf-8")
        statements = split_sql_statements(sql)

        for idx, statement in enumerate(statements, start=1):
            try:
                cursor = conn.execute(statement)
                rows = cursor.fetchall()

                if rows:
                    total_failed_checks += 1
                    total_failed_rows += len(rows)

                    print(
                        f"[FAIL] {sql_file.name} | bloco {idx} "
                        f"returned {len(rows)} row(s)"
                    )

                    # show up to 5 examples
                    for sample_row in rows[:5]:
                        print(f"       Example: {sample_row}")
                else:
                    print(f"[OK] {sql_file.name} | block {idx} no inconsistencies")

            except sqlite3.Error as exc:
                print(f"[ERROR] Failed to execute validation {sql_file.name} | block {idx}")
                print(f"        Reason: {exc}")
                raise

    print("\n[VALIDATION SUMMARY]")
    print(f"Failed checks: {total_failed_checks}")
    print(f"Total problematic rows: {total_failed_rows}")

    if total_failed_checks > 0:
        raise ValueError(
            f"Validations failed: {total_failed_checks} check(s) with inconsistencies."
        )


def main() -> None:
    if not DB_PATH.exists():
        raise FileNotFoundError(
            f"Database not found at {DB_PATH}. Run the ingestion script first."
        )

    try:
        with sqlite3.connect(DB_PATH) as conn:
            print("[START] Running SQL pipeline...\n")

            execute_sql_folder(conn, STAGING_SQL_DIR)
            execute_sql_folder(conn, INTERMEDIATE_SQL_DIR)
            execute_sql_folder(conn, MARTS_SQL_DIR)

            # commit transformations before validation
            conn.commit()

            run_validation_folder(conn, VALIDATION_SQL_DIR)

            print("\n[SUCCESS] SQL pipeline executed successfully.")

    except Exception as exc:
        print(f"\n[PIPELINE ERROR] {exc}")
        raise


if __name__ == "__main__":
    main()