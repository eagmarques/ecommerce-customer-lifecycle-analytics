import pytest
from src.transform.run_pipeline import split_sql_statements

def test_split_sql_statements():
    sql = "SELECT * FROM table1; SELECT * FROM table2;"
    statements = split_sql_statements(sql)
    assert len(statements) == 2
    assert statements[0] == "SELECT * FROM table1"
    assert statements[1] == "SELECT * FROM table2"

def test_split_sql_statements_empty():
    sql = "   "
    statements = split_sql_statements(sql)
    assert len(statements) == 0

def test_split_sql_statements_trailing_semicolon():
    sql = "SELECT 1;  "
    statements = split_sql_statements(sql)
    assert len(statements) == 1
    assert statements[0] == "SELECT 1"
