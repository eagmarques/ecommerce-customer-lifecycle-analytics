import pytest
from pathlib import Path
from src.ingestion.load_raw_to_sqlite import sanitize_table_name

def test_sanitize_table_name():
    assert sanitize_table_name("2019-Oct.csv") == "2019_oct"
    assert sanitize_table_name("Data-File 2020.csv") == "data_file_2020"
    assert sanitize_table_name("random_Name-123.CSV") == "random_name_123"

# Mocking sqlite3 and pandas would be better for a full test, 
# but for now we focus on the logic utility.
