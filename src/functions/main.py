import boto3
import datetime
import collections
from datetime import datetime, date, time, timedelta

def handler(event, context):
    yesterday = datetime.combine(date.today() - timedelta(1), time())
    today = datetime.combine(date.today(), time())
    unix_start = datetime(2022,1,1)

    client = boto3.client("logs")
    response = client.create_export_task(
        logGroupName = "/aws-glue/jobs/error",                                          # Group name from which logs are saved
        fromTime = int((yesterday - unix_start).total_seconds() * 1000),                # UTC(miri sec) 2022-01-01 00:00.01
        to = int((today - unix_start).total_seconds() * 1000),                          # UNIX time Now
        destination = "terraform-development-private-bucket-105",                       # Bucket name where logs are saved
        destinationPrefix = 'Glue-result-{}'.format(yesterday.strftime("%Y-%m-%d"))     # Prefix to save the logs
    )
    return {
        "status": "completed",
        "response": response
    }