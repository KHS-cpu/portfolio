import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitor_count_2')

def lambda_handler(event, context):
    allowed_origins = ['https://www.kaunghtetsan.tech', 'https://kaunghtetsan.tech']
    request_origin = event['headers'].get('origin') or event['headers'].get('Origin')

    # Default to first allowed origin if not matched
    origin_to_use = allowed_origins[0]
    if request_origin in allowed_origins:
        origin_to_use = request_origin

    # Get current visitor count
    response = table.get_item(Key={'obj': '0'})
    views = response['Item']['views']
    views = views + 1

    # Update in DynamoDB
    table.put_item(Item={'obj': '0', 'views': views})

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': origin_to_use,
            'Access-Control-Allow-Methods': 'GET, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
        },
        'body': json.dumps({'visitor_count_2': views}, default=str)
    }
