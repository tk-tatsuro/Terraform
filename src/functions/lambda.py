import datetime
import time
import boto3

lambda_name = 'lambda_test'
log_group_name = '/aws/lambda/' + lambda_name
s3_bucket_name = 'terraform-development-private-bucket-858'
s3_prefix = lambda_name + '/%s' % (datetime.date.today() - datetime.timedelta(days = 1))

def get_from_timestamp():
    today = datetime.date.today()
    yesterday = datetime.datetime.combine(today - datetime.timedelta(days = 1), datetime.time(0, 0, 0))
    timestamp = time.mktime(yesterday.timetuple())
    return int(timestamp)

def get_to_timestamp(from_ts):
    return from_ts + (60 * 60 * 24) - 1

def handler(event, context):
    from_ts = get_from_timestamp()
    to_ts = get_to_timestamp(from_ts)
    print('Timestamp: from_ts %s, to_ts %s' % (from_ts, to_ts))

    client = boto3.client('logs')
    response = client.create_export_task(
        logGroupName      = log_group_name,
        fromTime          = from_ts * 1000,
        to                = to_ts * 1000,
        destination       = s3_bucket_name,
        destinationPrefix = s3_prefix
    )
    return response
