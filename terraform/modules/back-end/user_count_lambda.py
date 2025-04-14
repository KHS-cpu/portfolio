import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitor_count')

def lambda_handler(event, context):
    allowed_origins = ['https://www.kaunghtetsan.tech', 'https://kaunghtetsan.tech']
    request_origin = event['headers'].get('origin') or event['headers'].get('Origin')

    # Choose the correct origin
    origin_to_use = allowed_origins[0]
    if request_origin in allowed_origins:
        origin_to_use = request_origin

    # Get current visitor count
    try:
        response = table.get_item(Key={'obj': '0'})
        views = int(response.get('Item', {}).get('views', 0))
    except Exception as e:
        print(f"Error fetching item from DynamoDB: {e}")
        views = 0

    # Increment the view count
    views += 1

    # Update the visitor count in DynamoDB
    try:
        table.put_item(Item={'obj': '0', 'views': Decimal(views)})
    except Exception as e:
        print(f"Error updating item in DynamoDB: {e}")
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': origin_to_use,
                'Access-Control-Allow-Methods': 'GET, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
            },
            'body': json.dumps({'error': 'Failed to update visitor count'})
        }

    # Return the updated count
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': origin_to_use,
            'Access-Control-Allow-Methods': 'GET, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
        },
        'body': json.dumps({'visitor_count': views})
    }
