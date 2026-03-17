import os
import sys
from pathlib import Path
from dotenv import load_dotenv, find_dotenv

# Load environment variables from .env file BEFORE importing Kaggle Api
load_dotenv(find_dotenv())

from kaggle.api.kaggle_api_extended import KaggleApi

DATASET = "mkechinov/ecommerce-events-history-in-cosmetics-shop"
RAW_DIR = Path("data/raw")


def download_dataset():
    """
    Downloads the Kaggle dataset using credentials from environment variables.
    Requires KAGGLE_USERNAME and KAGGLE_KEY to be set in .env or system environment.
    """
    # Create target directory
    RAW_DIR.mkdir(parents=True, exist_ok=True)

    # Validate credentials before starting
    username = os.getenv("KAGGLE_USERNAME")
    key = os.getenv("KAGGLE_KEY")

    if not username or not key:
        print("Error: Kaggle credentials not found.")
        print("Please ensure KAGGLE_USERNAME and KAGGLE_KEY are set in your .env file or environment.")
        print("Example .env file content:")
        print("KAGGLE_USERNAME=your_username")
        print("KAGGLE_KEY=your_api_key")
        sys.exit(1)

    try:
        api = KaggleApi()
        api.authenticate()

        print(f"Authenticated as {username}. Downloading {DATASET}...")
        
        api.dataset_download_files(
            DATASET,
            path=str(RAW_DIR),
            unzip=True
        )

        print(f"Successfully downloaded and extracted dataset to {RAW_DIR}")
        
    except Exception as e:
        print(f"An error occurred during download: {e}")
        sys.exit(1)


if __name__ == "__main__":
    download_dataset()