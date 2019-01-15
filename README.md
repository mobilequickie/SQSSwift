
## About
This is starter iOS Swift 4.2 client for sending single and batch messages directly to Amazon SQS. It demonstrates the event-driven design pattern for using SQS as an event source to AWS Lambda. 

The iOS client uses Amazon Cognito Identity Pool for authenticated/unauthenticated access for app users to send messages to said SQS queue.

Check out my blog here to read more about SQS as an event source and deep dive into the inner workings of this architecture: https://medium.com/p/cb9b4215e8d3

## PART 1 - Getting Started (BACKEND)
I created a CloudFormation template that will provision: 
1. A standard SQS queue
2. A dead letter queue
3. AWS Lambda function for handling messages
4. Event source mapping
5. Lambda execution permissions. 

Click on the template to launch the CloudFormation console to begin building your stack. The template defaults to the US West Oregon region (us-west-2). Should only take about 2 minutes.

1.	Click on the Launch Stack button
    
    [![Launch Stack](https://s3-us-west-2.amazonaws.com/mobilequickie/speechtranslator/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/new?stackName=my-sqs-event&templateURL=https://s3-us-west-2.amazonaws.com/mobilequickie/sqs-events/cf-templates/SQS-EventSource-LambdaHandler-CFTemplate-NodeJS.yaml)

## PART 2 - Get Started (iOS Swift Client)

In this part, we'll clone this repo, update Cocoapods, update the awsconfiguration.json file with your own backend Cognito Identity pool Id generated in PART 1, and update the ViewController.swift file with your SQS queue URL.

1. Download or clone this project
    ```
    $ git clone https://github.com/mobilequickie/SQSSwift.git

    $ cd SQSSwift
    ```
2. Install Cocoapods
    ```
    $ sudo gem install cocoapods

    $ pod install --repo-update
    ``` 
3. Launch project in Xcode
    ```
    $ open SQSSwift.xcworkspace
    ``` 

4. Update the *awsconfiguration.json* file with YOUR Cognito Identity Pool Id and AWS region.
    ```json
    "CredentialsProvider": {
        "CognitoIdentity": {
            "Default": {
                "PoolId": "<YOUR-IDENTITY-POOL-ID-HERE>",
                "Region": "us-west-2"
            }
        }
    },
    ```

5. Change the QueueURL in the *ViewController.swift* file to match YOUR Amazon SQS QueueURL that was created by the CloudFormation template in STEP 1.
    ```swift
    let myQueueURL: String = "<YOUR-SQS-QUEUE-URL-HERE>"
    ```
## Requirements
- [Cocoapods](https://github.com/CocoaPods/CocoaPods) 1.5.0 +
- iOS 11.0+ / Mac OS X 10.13+
- Xcode 10.0+


