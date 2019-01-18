
## About
This is starter iOS Swift 4.2 client for sending single and batch messages directly to Amazon SQS. It demonstrates the event-driven design pattern for using SQS as an event source to AWS Lambda. The "Launch Stack" button in Part 1 will deploy and configure the necessary backend resources. Part 2 is this client app connecting to the backend resources via the [AWS SDK for iOS](https://aws-amplify.github.io/docs/ios/manualsetup#direct-aws-service-access).

Check out my blog below to read more about SQS as an event source and deep dive into the inner workings of this architecture: 
<p align="center"><a href="https://dzone.com/articles/amazon-sqs-as-an-event-source-to-aws-lambda-a-deep"><img src="https://s3-us-west-2.amazonaws.com/mobilequickie/sqs-events/bannerimage.png" alt="blog banner" width="450"></a></p>

## PART 1 - Get Started (BACKEND)
I created a CloudFormation template that will provision: 
1. A standard Amazon SQS queue
2. A dead letter Amazon SQS queue
3. An AWS Lambda function (Node.js 8) for handling messages
4. Event source mapping
5. Lambda execution permissions to SQS and SNS for sending SMS text message. 
6. Amazon Cognito Identity Pool (with IAM roles) allowing unauthenticated and authenticated mobile users to send messages directly to the source queue.

Click on the template to launch the CloudFormation console to begin building your stack. The template defaults to the US West Oregon region (us-west-2). Should only take about 2 minutes.

* Click on the Launch Stack button to provision the resources in your AWS account
    
    [![Launch Stack](https://s3-us-west-2.amazonaws.com/mobilequickie/speechtranslator/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/new?stackName=my-sqs-event&templateURL=https://s3-us-west-2.amazonaws.com/mobilequickie/sqs-events/cf-templates/SQS-EventSource-LambdaHandlerSMS-CFTemplate-Nodejs.yaml)

**Note**: The stack creation will ask for your phone number as an optional parameter so that it'll automatically send you an SMS via SNS when a message arrives into the queue :) Your phone number is stored as a Lambda function environment variable.

`Quick Test`: Use the following AWS CLI command (replace _SourceSQSQueueURL_ with the SourceSQSQueueURL output of the stack results from above) to immediately test that new messages sent directly to SQS are getting picked up by your Lambda function. If you provided a valid E.164 formatted mobile number, you should see an SMS text messages with "Test message from AWS CLI" sent from an Amazon SNS phone number.
![Source SQS Queue](https://s3-us-west-2.amazonaws.com/mobilequickie/sqs-events/source-sqs-queue-url.jpg)

```bash
$ aws sqs send-message --queue-url <SourceSQSQueueURL>
--message-body "Test message from AWS CLI"
```

## PART 2 - Get Started (iOS Swift CLIENT)

In this part, we'll clone this repo, update Cocoapods, update the awsconfiguration.json file with your own backend Cognito Identity pool Id generated in PART 1, and update the ViewController.swift file with your SQS queue URL, also created in PART 1. Note: To see the outputs from CloudFormation, head to the [CloudFormation management console](https://console.aws.amazon.com/cloudformation/home?region=us-west-2), select your stack, and then choose the Output tab.

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

4. Update the *awsconfiguration.json* file with YOUR Cognito Identity Pool Id and AWS region. Shown as `CognitoIdentityPoolId` in the output tab of the CloudFormation stack created in Step 1.
![Cognito Idenity Pool Id](https://s3-us-west-2.amazonaws.com/mobilequickie/sqs-events/cognito-identity-pool-id.jpg)
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

5. Change the string value in the *ViewController.swift* file to match YOUR Amazon SQS queue. Shown as `SourceSQSQueueURL` in the output tab of the CloudFormation stack created in Step 1.
![Source SQS Queue](https://s3-us-west-2.amazonaws.com/mobilequickie/sqs-events/source-sqs-queue-url.jpg)

    ```swift
    let myQueueURL: String = "<YOUR-SQS-SOURCE-QUEUE-URL-HERE>"
    ```
## Build and run the app

## Requirements
- [Cocoapods](https://github.com/CocoaPods/CocoaPods) 1.5.0 +
- iOS 11.0+ / Mac OS X 10.13+
- Xcode 10.0+