import logging
import boto3
from botocore.exceptions import ClientError
import json
import sys

AWS_REGION = 'us-west-2'

# logger config
logger = logging.getLogger()
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s: %(levelname)s: %(message)s')

sqs_client = boto3.client("sqs", region_name=AWS_REGION)

def get_queue(queue_name):
    """
    Returns the URL of an existing Amazon SQS queue.
    """
    try:
        response = sqs_client.get_queue_url(QueueName=queue_name)['QueueUrl']

    except ClientError:
        logger.exception(f'Could not get the {queue_name} queue.')
        raise
    else:
        return response

def get_queues_message_totals(queue_url):
    try:
        response = sqs_client.get_queue_attributes(QueueUrl=queue_url, AttributeNames=['All',])
    except ClientError:
        logger.exception(f'Could not get the message count for {queue_url}.')
        raise
    else:
        return response
    

if __name__ == '__main__':

    n = len(sys.argv)
    for i in range(1, n):
        j = sys.argv[i]
        queue = get_queue(j)
        response_out = get_queues_message_totals(queue)
        queue_count = json.loads(response_out['Attributes']['ApproximateNumberOfMessages'])
        dlq = json.loads(response_out['Attributes']['RedrivePolicy'])
        logger.info(f' Queue {j} consists {queue_count} messages, Its deadlettertarget queue and count is {dlq}')