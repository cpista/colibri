###This script works with API gateway, SNS, SQS, DynamoDB

import json
import decimal
from boto3.dynamodb.conditions import Attr
import botocore
import json
import os
import logging
import time
import boto3
import re
from collections import namedtuple
from boto3.dynamodb.conditions import Key as Key_boto3
from botocore.exceptions import ClientError
import sys
from assets_utils.assets_utils import deserialize_to_json
from assets_utils.assets_utils import *
from assets_utils import assets_utils
import assets_utils.simplejson as simplejson
from decimal import Decimal


def lambda_handler(event, context):
  print('## ENVIRONMENT VARIABLES')
  print(os.environ)
  print('## EVENT')
  print(event)
  print('###CONTEXT')
  print(context)
  try:
    api_id = event["requestContext"]["apiId"]
    api = True
  except:
    api = False
    
  # Defining variables
  logger = logging.getLogger()
  AWS_REGION = "eu-central-1"
  sns_client = boto3.client('sns', region_name=AWS_REGION)
  dynamodb = boto3.client('dynamodb')
  sqs = boto3.client('sqs')
  ###ARN of the SNS to send notifications to
  sns_topic_arn = os.environ['sns_topic_arn']
  ### DB table to insert data into
  db_table_name = 'testing-assets-table-tf'
  ### ARN of the SQS to send messages to
  queue_url = os.environ['sqs_url']
  path = event['path']
  message = "Error"
  subject = "API" + event['path'] 
 

  if api: #payload from api gateway, insert in dynamo db
    print(event)
  
    try:
      events=json.loads(event["body"], parse_float=Decimal)
    except:
      pass

    if event['resource'] == '/companies' and event['httpMethod'] == "GET":
      pk = "null"
      sk = "/companies/"
      
      subject = "Lambda queried data from DynamoDb table"
      try:
        dbresponse = dynamodb.query(
            TableName=db_table_name,
            KeyConditionExpression='parent = :parent AND begins_with ( uri , :uri )',
            ExpressionAttributeValues={
                ':parent': {'S': pk},
                ':uri': {'S': sk}
            }
        )
        if not dbresponse['Items']:
          assets_utils.publish_message(sns_topic_arn, assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e) 
        return assets_utils.answer(400, e, path)
            
      #We setup the subject of the message for sns topic

      message=deserialize_to_json(dbresponse['Items'])
      
      #We publish message to sns topic 
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, "message"), subject)
      return assets_utils.answer(200, message)

    elif event['resource'] == '/companies/{id}' and event['httpMethod'] == "GET":
       
      try:
        pk = "null"
        sk = event["path"]
        subject = f"Lambda queried data from DynamoDb {db_table_name} table"
        key_item={
          "parent": {
            'S': pk
          },
          "uri": {
            'S': sk
          }
        }
        dbresponse = dynamodb.get_item(TableName=db_table_name,Key=key_item)
        if not dbresponse['Item']:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message)
      except KeyError as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        return assets_utils.answer(400, message, path)
      message=deserialize_to_json(dbresponse['Item'])
      return assets_utils.answer(200,message)

    elif event['resource'] == '/companies/{id}' and event['httpMethod'] == "PUT":
      try:
        events=json.loads(event["body"], parse_float=Decimal)
        pk = "null"
        sk = event["path"]
        subject = f"Lambda queried data from DynamoDb {db_table_name} table"
        key_item={
          "parent": {
            'S': pk
          },
          "uri": {
            'S': sk
          }
        }
        dbresponse = dynamodb.get_item(TableName=db_table_name,Key=key_item)
        if not dbresponse['Item']:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except KeyError as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        return assets_utils.answer(404, message, path)
      try:

        key_item={
          "parent": "null",
          "uri": "/companies/" + event["pathParameters"]["id"]
        }
        #new_data= ddb_data(event["body"])
        if type(json.loads(event["body"])) is dict:
          dbresponse = {}
          for key in events:
              print(key)
              if type(events['parent']) is str or type(events[key]) is bool:
                if key == "parent" or key == "uri":
                  pass
                else:
                  value = events[key]
                  database_response = assets_utils.dynamo_update_item(db_table_name, AWS_REGION, key_item, key, value)
                  print(database_response)
                  dbresponse.update(database_response)
              elif type(events[key]) is dict:
                for key2 in events[key]:
                  if type(events[key][key2]) is str:
                    value = events[key][key2]
                    database_response=assets_utils.update_map(db_table_name, AWS_REGION, key_item, key, key2, value)
                    dbresponse.update(database_response)
                  elif type(events[key][key2]) is dict:
                    print(key2)
                    for key3 in events[key][key2]:
                      value = events[key][key2][key3]
                      if isinstance(value, float):
                        #replace_num_to_decimal(value)

                        print(value)
                      database_response=update_maps(db_table_name, AWS_REGION, key_item, key, key2, key3, value)
                      dbresponse.update(database_response)
                  else:
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                    return assets_utils.answer(400, message, path)
              else:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
        else:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)
      except KeyError as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      except botocore.exceptions.ClientError as error:
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
        
        

      message=" "
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(201, message)
      
      
    elif event['resource'] == '/companies/{id}' and event['httpMethod'] == "DELETE":
      subject = event['path']
      try:
        if json.loads(event['body'])['deleted'] == True or json.loads(event['body'])['deleted'] == 'true': 
          choice = "true"
          pass
        elif json.loads(event['body'])['deleted'] == False or json.loads(event['body'])['deleted'] == 'false': 
          choice = "false"
          pass
        else:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)
        sk = event["path"]
        response = dynamodb.get_item(
            TableName=db_table_name,
            Key={
                'parent': {'S': 'null'},
                'uri': {'S': sk}
            }
        )
        
        print(response) 
        if not response['Item']:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
  
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400,message, path)
        
      subject = f"Lambda updated data in DynamoDb {db_table_name} table"
      
      dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)

      table = dynamodb.Table(db_table_name)
      try: 
        dbresponse = table.update_item(
          Key={
              "parent": "null",
              "uri": event["path"]
            },
          UpdateExpression="set #deleted = :d",
          ExpressionAttributeNames = {
          '#deleted': 'deleted'
          },
          ExpressionAttributeValues={
              ':d': choice
          },
          ReturnValues="UPDATED_NEW"
        )
      
        message = " "
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(204, message), subject)
        return assets_utils.answer(204, message)
      except TypeError as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      except KeyError  as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400,message, path)

      
    elif event['resource'] == '/companies' and event['httpMethod'] == "POST":
      #We setup the subject of the message for sns topic
      subject = f"Lambda posted data to DynamoDb {db_table_name} table"
      #This will instert in the database 
      try:
        add_id = {"uri": event['resource'] + "/" + event["requestContext"]["requestId"]}
        body=json.loads(event['body'])
        body.update(add_id)
        key_item = serialize_to_dynamodb(body)
        dbresponse = dynamodb.put_item(TableName=db_table_name, Item=key_item)
        print(dbresponse)
        message = deserialize_to_json(key_item)
        assets_utils.publish_message(sns_topic_arn, assets_utils.answer(200, message), subject)
        return assets_utils.answer(201, " ")
      except botocore.exceptions.ClientError as e:
        print(f"1: {e}")
        assets_utils.publish_message(sns_topic_arn, message, subject)
        return assets_utils.answer(400, message, path)      
      except botocore.exceptions.ParamValidationError as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn, message, subject)
        return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn, message, subject)
        return assets_utils.answer(400, message, path)

    
    elif event['resource'] == '/locations' and event['httpMethod'] == "POST":
      try:
        pk=json.loads(event["body"])["parent"]
        for key in json.loads(event["body"]):
              if type(events[key]) is str:
                if key == "parent" or key == "uri":
                  response = dynamodb.get_item(
                      TableName=db_table_name,
                      Key={
                          'parent': {'S': 'null'},
                          'uri': {'S': json.loads(event["body"])["parent"]}
                      }
                  )
                  try:
                    if not response['Item']:
                      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                      return assets_utils.answer(404, message, path)
                    else:
                      break
                  except KeyError as e:
                    print(e) 
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                    return assets_utils.answer(404, message, path)
                    
                elif key != "parent" or key != "uri": 
                  break
              else:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      
      #We setup the subject of the message for sns topic
      subject = f"Lambda posted data to DynamoDb {db_table_name} table"
      try:
      #This will instert in the database 
        add_id = {"uri": event['resource'] + "/" + event["requestContext"]["requestId"]}
        body=json.loads(event['body'])
        body.update(add_id)
        key_item = serialize_to_dynamodb(body)
        dbresponse = dynamodb.put_item(TableName=db_table_name, Item=key_item)
        print(dbresponse)
        message = deserialize_to_json(key_item)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message, path), subject)
        return assets_utils.answer(201, " ")
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)

      
    
    if event['resource'] == '/locations' and event['httpMethod'] == "GET":
      #dynamodb_resource = boto3.resource('dynamodb', region_name=AWS_REGION)
      #table = dynamodb_resource.Table(db_table_name)
      #We setup the subject of the message for sns topic
      try:
        subject = "Lambda queried data from DynamoDb table"
        pattern = event['resource']
        pk = "companies"
        sk = "/locations/"
        dbresponse = assets_utils.get_companies(db_table_name, pattern, pk, sk)
        if not dbresponse:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(404, message, path)
      except BaseException:
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      message=deserialize_to_json(dbresponse)
      #We publish message to sns topic 
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(200, message)
    
    elif event['resource'] == '/locations/{id}' and event['httpMethod'] == "DELETE":
      try:
        if json.loads(event['body'])['deleted'] == True or json.loads(event['body'])['deleted'] == 'true': 
          choice = "true"
          pass
        elif json.loads(event['body'])['deleted'] == False or json.loads(event['body'])['deleted'] == 'false': 
          choice = "false"
          pass
        else:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)
        for key in json.loads(event["body"]):
              if type(events["parent"]) is str:
                if key == "parent" or key == "uri":
                  response = dynamodb.get_item(
                      TableName=db_table_name,
                      Key={
                          'parent': {'S': json.loads(event["body"])["parent"]},
                          'uri': {'S': event["path"]}
                      }
                  )
                  try:
                    if not response['Item']:
                      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                      return assets_utils.answer(404, message, path)
                  except BaseException:
                    print(e)
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                    return assets_utils.answer(404, message, path)
                    
                elif key != "parent" or key != "uri": 
                  break
              else:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
      except KeyError as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      subject = f"Lambda updated data in DynamoDb {db_table_name} table"
      dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)
      table = dynamodb.Table(db_table_name)
      dbresponse = table.update_item(
        Key={
            "parent": "/companies/" + json.loads(event["body"])["parent"].split('/')[2] ,
            "uri": event["path"]
          },
        UpdateExpression="set #deleted = :d",
        ExpressionAttributeNames = {
        '#deleted': 'deleted'
        },
        ExpressionAttributeValues={
            ':d': json.loads(event["body"])["deleted"]
        },
        ReturnValues="UPDATED_NEW"
      )
      
      message = " "
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(204, message), subject)
      return assets_utils.answer(204, message)
    
    elif event['resource'] == '/locations/{id}' and event['httpMethod'] == "PUT":
      try:
        events=json.loads(event["body"], parse_float=Decimal)
        print(events)
        for key in events:
            if type(events['parent']) is str:
              response = dynamodb.get_item(
                  TableName=db_table_name,
                  Key={
                      'parent': {'S': json.loads(event["body"])["parent"]},
                      'uri': {'S': event["path"]}
                  }
              )
              print(response)
              try:
                if not response['Item']:
                  print("Missing Item")
                  assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                  return assets_utils.answer(404, message, path)
              except KeyError as e:
                  print(e)
                  assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                  return assets_utils.answer(404, message, path)
      except KeyError as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(404, message, path)
        
      subject = f"Lambda updated data in DynamoDb {db_table_name} table"

      key_item={
        "parent": '/companies/' + json.loads(event["body"])["parent"].split("/")[2],
        "uri": "/locations/" + event["path"].split("/")[2]
      }

      if type(events) is dict:
        dbresponse = {}
        try:
          for key in events:
              if type(events[key]) is str or type(events[key]) is bool:
                if key == "parent" or key == "uri":
                  pass
                else:
                  value = events[key]
                  database_response = assets_utils.dynamo_update_item(db_table_name, AWS_REGION, key_item, key, value)
                  dbresponse.update(database_response)
              elif type(events[key]) is dict:
                for key2 in events[key]:
                  if type(events[key][key2]) is str:
                    value = events[key][key2]
                    database_response=assets_utils.update_map(db_table_name, AWS_REGION, key_item, key, key2, value)
                    dbresponse.update(database_response)
                  elif type(events[key][key2]) is dict:
                    for key3 in events[key][key2]:
                      value = events[key][key2][key3]
                      database_response=assets_utils.update_maps(db_table_name, AWS_REGION, key_item, key, key2, key3, value)
                      dbresponse.update(database_response)
                  else:
                    print("wrong structure1")
                    print(type(events[key][key2]))
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                    return assets_utils.answer(400, message, path)
              else:
                print("wrong structure2")
                print(type(events[key]))
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                return assets_utils.answer(400, message, path)
        except KeyError as e:
          print(e)
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)
      message = " "
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(201, message, path), subject)
      return assets_utils.answer(201, message)
      
    elif event['resource'] == '/locations/{id}' and event['httpMethod'] == "GET":
      try:
        subject = f"Lambda queried data from DynamoDb {db_table_name} table"
        pk = "null"
        sk = "/locations/" + event["pathParameters"]["id"]
        dbresponse = assets_utils.getitem(db_table_name, pk, sk)
        if not dbresponse:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except KeyError as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      message = deserialize_to_json(dbresponse)
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(200, message)
      
    elif event['resource'] == '/halls' and event['httpMethod'] == "POST":
      try:
        for key in json.loads(event["body"]):
              if type(events['parent']) is str:
                pattern = event['resource']
                pk = "null"
                sk = json.loads(event["body"])["parent"]
                data = assets_utils.getitem(db_table_name, pk, sk)
                print(data)
                try:
                  if not data:
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                    return assets_utils.answer(404, message, path)
                except BaseException as e:
                  print(e)
                  assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                  return assets_utils.answer(404, message, path)
                    
              else:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
      except KeyError as e:
        print(e)  
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      try: 
        #We setup the subject of the message for sns topic
        subject = f"Lambda posted data to DynamoDb {db_table_name} table"
        #This will instert in the database 
        add_id = {"uri": event['resource'] + "/" + event["requestContext"]["requestId"]}
        body=json.loads(event['body'])
        body.update(add_id)
        key_item = serialize_to_dynamodb(body)
        dbresponse = dynamodb.put_item(TableName=db_table_name, Item=key_item)
        print(dbresponse)
        message = deserialize_to_json(key_item)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message, path), subject)
        return assets_utils.answer(201, " ")
      except BaseException as e:
        print(e) 
        return assets_utils.answer(400, message, path)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)

    if event['resource'] == '/halls' and event['httpMethod'] == "GET":
      #dynamodb_resource = boto3.resource('dynamodb', region_name=AWS_REGION)
      #table = dynamodb_resource.Table(db_table_name)
      #We setup the subject of the message for sns topic
      try:
        subject = "Lambda queried data from DynamoDb table"
        pattern = event['resource']
        pk = "null"
        sk = "/halls/" 
        dbresponse = assets_utils.get_companies(db_table_name, pattern, pk, sk)
        if not dbresponse:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      
      message = deserialize_to_json(dbresponse)
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(200, message)
  
    elif event['resource'] == '/halls/{id}' and event['httpMethod'] == "DELETE":
      try:
        if json.loads(event['body'])['deleted'] == True or json.loads(event['body'])['deleted'] == 'true': 
          choice = "true"
          pass
        elif json.loads(event['body'])['deleted'] == False or json.loads(event['body'])['deleted'] == 'false': 
          choice = "false"
          pass
        else:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)
        for key in json.loads(event["body"]):
          if type(events['parent']) is str:
            response = dynamodb.get_item(
                TableName=db_table_name,
                Key={
                    'parent': {'S': json.loads(event["body"])["parent"]},
                    'uri': {'S': event["path"]}
                }
            )
            try:
              if not response['Item']:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                return assets_utils.answer(404, message, path)
            except BaseException:
              assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
              return assets_utils.answer(404, message, path)
                
          else:
            assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
            return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      subject = f"Lambda updated data in DynamoDb {db_table_name} table"
      dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)
      table = dynamodb.Table(db_table_name)
      dbresponse = table.update_item(
        Key={
            "parent": "/locations/" + json.loads(event["body"])["parent"].split('/')[2] ,
            "uri": event["path"]
          },
        UpdateExpression="set #deleted = :d",
        ExpressionAttributeNames = {
        '#deleted': 'deleted'
        },
        ExpressionAttributeValues={
            ':d': json.loads(event["body"])["deleted"]
        },
        ReturnValues="UPDATED_NEW"
      )
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(204, message), subject)
      return assets_utils.answer(204, message)
    
    elif event['resource'] == '/halls/{id}' and event['httpMethod'] == "GET":
      try:
        subject = f"Lambda queried data from DynamoDb {db_table_name} table"
        pk = "null"
        sk = "/halls/" + event["pathParameters"]["id"]
        dbresponse = assets_utils.getitem(db_table_name, pk, sk)
        if not dbresponse:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        return assets_utils.answer(404, message, path)
      message = deserialize_to_json(dbresponse)
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(200, message)

    elif event['resource'] == '/halls/{id}' and event['httpMethod'] == "PUT":
      try: 
        events=json.loads(event["body"], parse_float=Decimal)
        print(events)
        pk = events["parent"]
        sk = event["path"]
        for key in events:
          if type(events['parent']) is str:
              response = dynamodb.get_item(
                  TableName=db_table_name,
                  Key={
                      'parent': {'S': pk},
                      'uri': {'S': sk}
                  }
              )
              print(response)
              try:
                if not response['Item']:
                  assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                  return assets_utils.answer(404, message, path)
                else: 
                  break
              except BaseException:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
          else:
            assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
            return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        assets_utils.answer(400, message, path)
      try:       
        subject = f"Lambda got items from DynamoDb {db_table_name} table"
        key_item={
          "parent": '/locations/' + json.loads(event["body"])["parent"].split("/")[2],
          "uri": "/halls/" + event["path"].split("/")[2]
        }
        if type(events) is dict:
          dbresponse = {}
          print(events)
          for key in events:
              if type(events[key]) is str or type(events[key]) is bool:
                if key == "parent" or key == "uri":
                  pass
                else:
                  value = events[key]
                  database_response = assets_utils.dynamo_update_item(db_table_name, AWS_REGION, key_item, key, value)
                  dbresponse.update(database_response)
              elif type(events[key]) is dict:
                for key2 in events[key]:
                  if type(events[key][key2]) is str or type(events[key][key2]) is bool or type(events[key][key2]) is Decimal:
                    print(events[key][key2])
                    print(key2)
                    value = events[key][key2]
                    database_response=assets_utils.update_map(db_table_name, AWS_REGION, key_item, key, key2, value)
                    dbresponse.update(database_response)
                  elif type(events[key][key2]) is dict:
                    for key3 in events[key][key2]:
                      value = events[key][key2][key3]
                      database_response=update_maps(db_table_name, AWS_REGION, key_item, key, key2, key3, value)
                      dbresponse.update(database_response)
                  else:
                    print()
                    print("#####Key2")
                    print(type(events[key][key2]))
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                    return assets_utils.answer(400, message)
              else:
                print("#####Key1")
                print(type(events[key]))  
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message)
        else:
          print("#####events")
          print(type(events)) 
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message)
        message = " "
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(201, message), subject)
        return assets_utils.answer(201, message)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)

    elif event['resource'] == '/lines' and event['httpMethod'] == "POST":
      try: 
        for key in json.loads(event["body"]):
              if type(events['parent']) is str:
                  pattern = event['resource']
                  pk = "halls"
                  sk = json.loads(event["body"])["parent"]
                  data = assets_utils.getitem(db_table_name, pk, sk)
                  print(type(data))
                  try:
                    if not data:
                      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                      return assets_utils.answer(404, message, path)
                  except:
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                    return assets_utils.answer(404, message, path)
              else:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      
      try:
        #We setup the subject of the message for sns topic
        subject = f"Lambda posted data to DynamoDb {db_table_name} table"
        #This will instert in the database 
        add_id = {"uri": event['resource'] + "/" + event["requestContext"]["requestId"]}
        body=json.loads(event['body'])
        body.update(add_id)
        key_item = serialize_to_dynamodb(body)
        dbresponse = dynamodb.put_item(TableName=db_table_name, Item=key_item)
        print(dbresponse)
        message = deserialize_to_json(key_item)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message, path), subject)
        return assets_utils.answer(201, " ")
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)

    if event['resource'] == '/lines' and event['httpMethod'] == "GET":
      #We setup the subject of the message for sns topic
      try:
        subject = "Lambda queried data from DynamoDb table"
        pattern = event['resource']
        pk = "null"
        sk = "/lines/"
        dbresponse = assets_utils.get_companies(db_table_name, pattern, pk, sk)
        if not dbresponse:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        assets_utils.answer(404, message, path)

      message = deserialize_to_json(dbresponse)
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(200, message)

    elif event['resource'] == '/lines/{id}' and event['httpMethod'] == "DELETE":
      try:
        if json.loads(event['body'])['deleted'] == True or json.loads(event['body'])['deleted'] == 'true': 
          choice = "true"
          pass
        elif json.loads(event['body'])['deleted'] == False or json.loads(event['body'])['deleted'] == 'false': 
          choice = "false"
          pass
        else:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)
        for key in json.loads(event["body"]):
          if type(events['parent']) is str:
            response = dynamodb.get_item(
                TableName=db_table_name,
                Key={
                    'parent': {'S': json.loads(event["body"])["parent"]},
                    'uri': {'S': event["path"]}
                }
            )
            try:
              if not response['Item']:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                return assets_utils.answer(404, message, path)
            except BaseException:
              assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
              return assets_utils.answer(404, message, path)
                
          else:
            assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
            return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      subject = f"Lambda updated data in DynamoDb {db_table_name} table"
      dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)
      table = dynamodb.Table(db_table_name)
      dbresponse = table.update_item(
        Key={
            "parent": "/halls/" + json.loads(event["body"])["parent"].split('/')[2] ,
            "uri": event["path"]
          },
        UpdateExpression="set #deleted = :d",
        ExpressionAttributeNames = {
        '#deleted': 'deleted'
        },
        ExpressionAttributeValues={
            ':d': json.loads(event["body"])["deleted"]
        },
        ReturnValues="UPDATED_NEW"
      )
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(204, message), subject)
      return assets_utils.answer(204, message)
    
    elif event['resource'] == '/lines/{id}' and event['httpMethod'] == "GET":
      try:
        subject = f"Lambda queried data from DynamoDb {db_table_name} table"
        pk = "null"
        sk = "/lines/" + event["pathParameters"]["id"]
        dbresponse = assets_utils.getitem(db_table_name, pk, sk)
        if not dbresponse:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        return assets_utils.answer(404, message, path)
      message = deserialize_to_json(dbresponse)
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(200, message)

    elif event['resource'] == '/lines/{id}' and event['httpMethod'] == "PUT":
      try:
        events=json.loads(event["body"], parse_float=Decimal)
        pk = events["parent"]
        sk = event["path"]
        for key in json.loads(event["body"]):
            if type(events['parent']) is str:
              response = dynamodb.get_item(
                  TableName=db_table_name,
                  Key={
                      'parent': {'S': pk},
                      'uri': {'S': sk}
                  }
              )
              print(response)
              try:
                if not response['Item']:
                  assets_utils.publish_message(sns_topic_arn,assets_utils.answer(500, message, path), subject)
                  return assets_utils.answer(400, message, path)
              except KeyError as e:
                  print(e)
                  assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                  return assets_utils.answer(404, message, path)
            else:
              assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
              return assets_utils.answer(400, message, path)
      except KeyError as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)

      try:
        subject = f"Lambda got items from DynamoDb {db_table_name} table"
        key_item={
          "parent": '/halls/' + json.loads(event["body"])["parent"].split("/")[2],
          "uri": "/lines/" + event["path"].split("/")[2]
        }
      
        if type(json.loads(event["body"])) is dict:
          dbresponse = {}
          for key in json.loads(event["body"]):
              if type(events[key]) is str or type(events[key]) is bool:
                if key == "parent" or key == "uri":
                  pass
                else:
                  value = events[key]
                  database_response = assets_utils.dynamo_update_item(db_table_name, AWS_REGION, key_item, key, value)
                  dbresponse.update(database_response)
              elif type(events[key]) is dict:
                for key2 in events[key]:
                  if type(events[key][key2]) is str:
                    value = events[key][key2]
                    database_response=assets_utils.update_map(db_table_name, AWS_REGION, key_item, key, key2, value)
                    dbresponse.update(database_response)
                  elif type(events[key][key2]) is dict:
                    for key3 in events[key][key2]:
                      value = events[key][key2][key3]
                      database_response=update_maps(db_table_name, AWS_REGION, key_item, key, key2, key3, value)
                      dbresponse.update(database_response)
                  else:
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                    return assets_utils.answer(400, message, path)
              else:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
        else:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)
        message = " "
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
        return assets_utils.answer(201, message)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)

    elif event['resource'] == '/machines' and event['httpMethod'] == "POST":
      try: 
        for key in json.loads(event["body"]):
              if type(events['parent']) is str:
                  pattern = event['resource']
                  pk = "halls"
                  sk = json.loads(event["body"])["parent"]
                  data = assets_utils.getitem(db_table_name, pk, sk)
                  print(type(data))
                  try:
                    if not data:
                      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                      return assets_utils.answer(404, message, path)
                  except:
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                    return assets_utils.answer(404, message, path)
              else:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)

      try:
        #We setup the subject of the message for sns topic
        subject = f"Lambda posted data to DynamoDb {db_table_name} table"
        #This will instert in the database 
        add_id = {"uri": event['resource'] + "/" + event["requestContext"]["requestId"]}
        body=json.loads(event['body'])
        body.update(add_id)
        key_item = serialize_to_dynamodb(body)
        dbresponse = dynamodb.put_item(TableName=db_table_name, Item=key_item)
        print(dbresponse)
        message = deserialize_to_json(key_item)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message, path), subject)
        return assets_utils.answer(201, " ")
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)

    if event['resource'] == '/machines' and event['httpMethod'] == "GET":
      try:
        #We setup the subject of the message for sns topic
        subject = "Lambda queried data from DynamoDb table"
        pattern = event['resource']
        pk = "null"
        sk = "/machines/"
        dbresponse = assets_utils.get_companies(db_table_name, pattern, pk, sk)
        if not dbresponse:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        assets_utils.answer(404, message, path)
      message = deserialize_to_json(dbresponse)
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(200, message)
      
    elif event['resource'] == '/machines/{id}' and event['httpMethod'] == "DELETE":
      try:
        if json.loads(event['body'])['deleted'] == True or json.loads(event['body'])['deleted'] == 'true': 
          choice = "true"
          pass
        elif json.loads(event['body'])['deleted'] == False or json.loads(event['body'])['deleted'] == 'false': 
          choice = "false"
          pass
        else:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)
        for key in json.loads(event["body"]):
          if type(events['parent']) is str:
            response = dynamodb.get_item(
                TableName=db_table_name,
                Key={
                    'parent': {'S': json.loads(event["body"])["parent"]},
                    'uri': {'S': event["path"]}
                }
            )
            try:
              if not response['Item']:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                return assets_utils.answer(404, message, path)
            except BaseException:
              assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
              return assets_utils.answer(404, message, path)
                
          else:
            assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
            return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)
      subject = f"Lambda updated data in DynamoDb {db_table_name} table"
      dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)
      table = dynamodb.Table(db_table_name)
      dbresponse = table.update_item(
        Key={
            "parent": "/lines/" + json.loads(event["body"])["parent"].split('/')[2] ,
            "uri": event["path"]
          },
        UpdateExpression="set #deleted = :d",
        ExpressionAttributeNames = {
        '#deleted': 'deleted'
        },
        ExpressionAttributeValues={
            ':d': json.loads(event["body"])["deleted"]
        },
        ReturnValues="UPDATED_NEW"
      )
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(204, message), subject)
      return assets_utils.answer(204, message)
      
    elif event['resource'] == '/machines/{id}' and event['httpMethod'] == "GET":
      try:
        subject = f"Lambda queried data from DynamoDb {db_table_name} table"
        pk = "null"
        sk = "/machines/" + event["pathParameters"]["id"]
        dbresponse = assets_utils.getitem(db_table_name, pk, sk)
        if not dbresponse:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
          return assets_utils.answer(404, message, path)
      except BaseException as e:
        print(e)
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
        return assets_utils.answer(404, message, path)
      message = deserialize_to_json(dbresponse)
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
      return assets_utils.answer(200, message)

    elif event['resource'] == '/machines/{id}' and event['httpMethod'] == "PUT":
      try:
        events=json.loads(event["body"], parse_float=Decimal)
        pk = events["parent"]
        sk = event["path"]
        for key in json.loads(event["body"]):
          if type(events[key]) is str:
            if key == "parent" or key == "uri":
              response = dynamodb.get_item(
                  TableName=db_table_name,
                  Key={
                      'parent': {'S': pk},
                      'uri': {'S': sk}
                  }
              )
              try:
                if not response['Item']:
                  assets_utils.publish_message(sns_topic_arn,assets_utils.answer(404, message, path), subject)
                  return assets_utils.answer(404, message, path)
                else: 
                  break
              except BaseException as e:
                print(e)
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
          else:
            assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
            return assets_utils.answer(400, message, path)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        assets_utils.answer(400, message, path)
      try:
        subject = f"Lambda got items from DynamoDb {db_table_name} table"
        key_item={
          "parent": '/lines/' + json.loads(event["body"])["parent"].split("/")[2],
          "uri": "/machines/" + event["path"].split("/")[2]
        }
  
        if type(json.loads(event["body"])) is dict:
          dbresponse = {}
          for key in json.loads(event["body"]):
              if type(events[key]) is str or type(events[key]) is bool:
                if key == "parent" or key == "uri":
                  pass
                else:
                  print(key)
                  value = events[key]
                  database_response = assets_utils.dynamo_update_item(db_table_name, AWS_REGION, key_item, key, value)
                  dbresponse.update(database_response)
              elif type(events[key]) is dict:
                for key2 in events[key]:
                  if type(events[key][key2]) is str:
                    print(key2)
                    value = events[key][key2]
                    database_response=assets_utils.update_map(db_table_name, AWS_REGION, key_item, key, key2, value)
                    dbresponse.update(database_response)
                  elif type(events[key][key2]) is dict:
                    for key3 in events[key][key2]:
                      if events[key][key2][key3] is str:
                        value = events[key][key2][key3]
                        database_response=update_maps(db_table_name, AWS_REGION, key_item, key, key2, key3, value)
                        dbresponse.update(database_response)
                      else:
                        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                        assets_utils.answer(400, message, path)
                  elif type(events[key][key2]) is list:
                    for x in range(len(events[key][key2])):
                      for key3 in events[key][key2][x]:
                        print(f"set {key}.{key2}[{x}].#{key3} = :d")
                        value = events[key][key2][x][key3]
                        database_response=assets_utils.update_list_maps(db_table_name, AWS_REGION, key_item, key, key2, key3, x, value)
                        dbresponse.update(database_response)
                  else:
                    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                    return assets_utils.answer(400, message, path)
              else:
                assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
                return assets_utils.answer(400, message, path)
        else:
          assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
          return assets_utils.answer(400, message, path)

        message = " "
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(200, message), subject)
        return assets_utils.answer(201, message)
      except BaseException as e:
        print(e) 
        assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, message, path), subject)
        return assets_utils.answer(400, message, path)

    else:
      #This lambda suports just 2 paths from lambda
      response = "Please call this lambda from known paths in order to access it"
      #Send Mesage to SNS
      assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, response), subject)
      return assets_utils.answer(400, response)

  else:
    #If we do not call this lambda from RestAPI
    response = {
      '@@ERROR@': {
        '########Error:':'Please call this lambda from an RestAPI'
        }
      }
    subject = 'Error, Wrong Call, check lambda'
    #Send Mesage to SNS
    assets_utils.publish_message(sns_topic_arn,assets_utils.answer(400, response), subject)
    return assets_utils.answer(400, response)
