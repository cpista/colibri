from botocore.exceptions import ClientError
import logging
import json
import boto3
from assets_utils.dynamodb_json import json_util as db_json
from boto3.dynamodb.conditions import Attr
import assets_utils.simplejson as simplejson
from decimal import Decimal

AWS_REGION = "eu-central-1"
sns_client = boto3.client('sns', region_name=AWS_REGION)

def replace_num_to_decimal(obj):
    if isinstance(obj, list):
        for i in range(len(obj)):
            obj[i] = replace_num_to_decimal(obj[i])
        return obj
    elif isinstance(obj, dict):
        for k in obj.keys():
            obj[k] = replace_num_to_decimal(obj[k])
        return obj
    elif isinstance(obj, float):
            return Decimal(str(obj))
    elif isinstance(obj, int):
        return Decimal(str(obj))
    else:
        return obj

def ddb_data(obj):
    temp=json.loads(json.dumps(obj), parse_float=Decimal)
    return temp


def global_variable(var):
  global choice
  choice = var
  
def getitem(table_name, pk, sk):
    dynamodb = boto3.resource('dynamodb')
    
    table = dynamodb.Table(table_name)

    response = table.scan(
        FilterExpression=Attr("uri").eq(sk) & Attr(pk).ne("null")
    )
    result = response['Items']

    while 'LastEvaluatedKey' in response:
        response = table.scan(
        ExclusiveStartKey=response['LastEvaluatedKey'], 
        FilterExpression=Attr("uri").eq(sk)
        )
        result.extend(response['Items'])
    return result

def get_companies(table_name, pattern, pk, sk):
    dynamodb = boto3.resource('dynamodb')
    
    table = dynamodb.Table(table_name)

    response = table.scan(
        FilterExpression=Attr("uri").begins_with(sk) & Attr(pk).ne("null")
    )
    result = response['Items']

    while 'LastEvaluatedKey' in response:
        response = table.scan(
        ExclusiveStartKey=response['LastEvaluatedKey'], 
        FilterExpression=Attr("uri").begins_with(pattern) 
        )
        result.extend(response['Items'])
    print(result)
    return result

def update_map(table_name, awsRegion, key_item, key, key2, value):
    dynamodb = boto3.resource('dynamodb', region_name=awsRegion)
    table = dynamodb.Table(table_name)
    dbresponse = table.update_item(
        Key=key_item,
        UpdateExpression=f"set {key}.#{key2} = :d",
        ExpressionAttributeNames = {
            f"#{key2}": key2  
        },
        ExpressionAttributeValues={
        ':d': value
        },
        ReturnValues="UPDATED_NEW"
    )
    
    response = {
        'statusCode': 200,
        'body': f"successfully updated data: {dbresponse}",
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
    return response

def update_maps(table_name, awsRegion, key_item, key, key2, key3, value):
    dynamodb = boto3.resource('dynamodb', region_name=awsRegion)
    table = dynamodb.Table(table_name)
    dbresponse = table.update_item(
        Key=key_item,
        UpdateExpression=f"set {key}.{key2}.#{key3} = :d",
        ExpressionAttributeNames = {
            f"#{key3}": key3
        },
        ExpressionAttributeValues={
            ':d': value
        },
        ReturnValues="UPDATED_NEW"
    )
    
    response = {
        'statusCode': 200,
        'body': f"successfully updated data: {dbresponse}",
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
    return response

def update_list_maps(table_name, awsRegion, key_item, key, key2, key3, number, value):
    dynamodb = boto3.resource('dynamodb', region_name=awsRegion)
    table = dynamodb.Table(table_name)
    dbresponse = table.update_item(
        Key=key_item,
        UpdateExpression=f"set {key}.{key2}[{number}].#{key3} = :d",
        ExpressionAttributeNames = {
            f"#{key3}": key3
        },
        ExpressionAttributeValues={
            ':d': value
        },
        ReturnValues="UPDATED_NEW"
    )
    
    response = {
        'statusCode': 200,
        'body': f"successfully updated data: {dbresponse}",
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
    return response


def dynamo_update_item(table_name, awsRegion, key_item, key, value):
    #This function updates 1 or multiple items in dynamodb
    dynamodb = boto3.resource('dynamodb', region_name=awsRegion)
    table = dynamodb.Table(table_name)
    dbresponse = table.update_item(
        Key=key_item,
        UpdateExpression=f"set #{key} = :d",
        ExpressionAttributeNames = {
            f"#{key}": key  
        },
        ExpressionAttributeValues={
            ':d': value
        },
        ReturnValues="UPDATED_NEW"
    )
    
    response = {
        'statusCode': 200,
        'body': f"successfully updated data: {dbresponse}",
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
    return response


def send_sqs_messages(queueurl, message):
    """
    Send Messages to SQSqueue. 
    """
    try:
        response = sqs.send_message(
        QueueUrl = queueurl,
        DelaySeconds=10,
        MessageBody=json.dumps(message),
        #MessageAttributes = message
        )
        print(message)
        return response
    
    except ClientError:
        logger.exception(f'Could not publish message to the sqsqueue.')
        raise
    else:
        return response
    
def publish_message(topic_arn, message, subject):
    """
    Publishes a message to a topic.
    """
    try:
        response = sns_client.publish(
            TopicArn=topic_arn,
            Message=json.dumps(message),
            Subject=subject,
        )['MessageId']
    
    except ClientError:
        logger.exception(f'Could not publish message to the topic.')
        raise
    else:
        return response
    
def answer(status_code, message="b", path="a"):
    if path == "a":
        rp ={
        'statusCode': status_code,
        'body': message,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
            }
        }
        return rp
    elif status_code == 400:
        rp ={
            'statusCode': status_code,
            'body': json.dumps({
                "path" : path,
                "message" : "The request could not be read because of unexpected content."
            }),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
        return rp
    elif status_code == 401:
        rp ={
            'statusCode': status_code,
            'body': json.dumps({
                "path" : path,
                "message" : "User is not allowed to access the requested resource."
            }),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
        return rp
    elif status_code == 404:
        rp ={
            'statusCode': status_code,
            'body': json.dumps({
                "path" : path,
                "message" : "The requested resource cannot be found."
            }),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
        return rp


    # expected type of data: valid python dict
def serialize_to_dynamodb(json_item):
    # converting json to dict
    dict_item = db_json.dumps(json_item)
    #dict_item = json.loads(json_item)
    # converting dict to dynamodb key structured dict
    dynamodb_item = json.loads(dict_item)
    return dynamodb_item

def deserialize_to_json(dynamodb_item):
    # convert dynamodb key to dict
    dict_item = db_json.loads(dynamodb_item)
    # convert dict to valid json
    json_item = json.dumps(dict_item)
    return json_item