import datetime
import hashlib
import logging
import os
from typing import List

import boto3
import requests

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

GOOGLE_API_KEY = os.environ["GOOGLE_API_KEY"]
CSE_ID = os.environ["CSE_ID"]
QUERY = os.environ["SEARCH_QUERY"]
DYNAMODB_TABLE = os.environ["DYNAMODB_TABLE"]
SENDER_EMAIL = os.environ["SENDER_EMAIL"]
RECIPIENT_EMAIL = os.environ["RECIPIENT_EMAIL"]

dynamodb = boto3.resource("dynamodb")
ses = boto3.client("ses")
table = dynamodb.Table(DYNAMODB_TABLE)


def get_search_results(pages: int = 2) -> List[dict]:
    all_results = []
    for i in range(pages):
        start_index = 1 + i * 10
        params = {"key": GOOGLE_API_KEY, "cx": CSE_ID, "q": QUERY, "num": 10, "start": start_index, "sort": "date"}
        response = requests.get("https://www.googleapis.com/customsearch/v1", params=params)
        response.raise_for_status()
        items = response.json().get("items", [])
        if not items:
            break
        for item in items:
            url = item.get("link")
            title = item.get("title")
            if url and title:
                hash_id = hashlib.sha256(url.encode()).hexdigest()
                all_results.append({"id": hash_id, "title": title, "url": url})
    logger.info(f"Found {len(all_results)} postings")
    return all_results


def filter_new_results(results: List[dict]) -> List[dict]:
    new_results = []
    for item in results:
        resp = table.get_item(Key={"id": item["id"]})
        if "Item" not in resp:
            new_results.append(item)
            table.put_item(
                Item={
                    "id": item["id"],
                    "title": item["title"],
                    "url": item["url"],
                    "timestamp": datetime.datetime.utcnow().isoformat(),
                }
            )
    logger.info(f"Found {len(new_results)} new postings")
    return new_results


def send_email(new_jobs: List[dict]):
    if not new_jobs:
        return
    body = "New job postings:\n\n" + "\n".join([f"{j['title']}\n{j['url']}\n" for j in new_jobs])
    response = ses.send_email(
        Source=SENDER_EMAIL,
        Destination={"ToAddresses": [RECIPIENT_EMAIL]},
        Message={"Subject": {"Data": "New Job Postings"}, "Body": {"Text": {"Data": body}}},
    )
    logger.info(f"Email sent with response: {response}")
    logger.info(f"Sent email with {len(new_jobs)} new postings")


def lambda_handler(event, context):
    try:
        results = get_search_results(pages=2)
        new_results = filter_new_results(results)
        send_email(new_results)
        return {"statusCode": 200, "body": f"Sent {len(new_results)} new postings"}
    except Exception as e:
        return {"statusCode": 500, "body": str(e)}
