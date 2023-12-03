#source = https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example.html#with-s3-example-create-function
import json
import urllib.parse
import boto3
from PIL import Image
from io import BytesIO

print('Loading function')

s3 = boto3.client('s3')


def resize_image(bucket, key):
    size = 500, 500
    in_mem_file = BytesIO()
    client = boto3.client('s3')

    file_byte_string = client.get_object(Bucket=bucket, Key=key)['Body'].read()
    im = Image.open(BytesIO(file_byte_string))

    im.save(in_mem_file, format=im.format)
    in_mem_file.seek(0)

    response = client.put_object(
        Body=in_mem_file,
        Bucket=bucket,
        Key='resized-small/resized_' + key
        )
    
    return response


def image_processor(event, context):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    resize_image(bucket, key)
