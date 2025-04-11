import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitor_count_2')

def lambda_handler(event, context):
    # Get the current visitor count
    response = table.get_item(Key={'obj': '0'})
    views = response['Item']['views']
    views = views + 1

    # Update the visitor count in DynamoDB
    table.put_item(Item={'obj': '0', 'views': views})

    # Return the updated visitor count with CORS headers
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',  # Or use your domain: 'https://www.kaunghtetsan.tech'
            'Access-Control-Allow-Methods': 'GET, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
        },
        'body': json.dumps({'visitor_count_2': views}, default=str)
    }
