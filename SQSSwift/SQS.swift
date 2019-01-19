//
//  SQS.swift
//  SQSSwift
//
//  Created by Hills, Dennis on 1/18/19.
//  Copyright © 2018 Hills, Dennis. All rights reserved.
//
//  Description: This class manages the request/response for sending messages directly to an Amazon SQS standard queue

import AWSSQS
import AWSMobileClient

public class SQS {
    
    // Send a single message to SQS - No message attributes
    public func sendMessage(msg: String, queueURL: String) -> () {
        
        // Using the AWSMobileClient as the default Identity provider. This uses the Cognito Identity Pool Id specified in the awsconfiguration.json file. If the app user has not authenticated, they'll be issued an unauthenticated identity Id via Cognito Identity Pool
        let sqs = AWSSQS.default()
        
        // Initialize SQS send message request
        let sendMsgRequest = AWSSQSSendMessageRequest()
        
        // Queue URL (not the queue ARN)
        sendMsgRequest?.queueUrl = queueURL
        
        // Message body string (can be JSON as well)
        sendMsgRequest?.messageBody = msg
        
        // (Optional) message attribute. Using it to pass in the user's Identity Id and fake push token
        var msgAttributes: [String: String] = [:]
        
        if let identityId = AWSMobileClient.sharedInstance().identityId {
            msgAttributes["CognitoIdentityId"] = identityId
        } else {
            msgAttributes["CognitoIdentityId"] = "nil"
        }
        
        sendMsgRequest?.messageAttributes = prepareMsgAttributes(keyValuePairs: msgAttributes)
        
        sqs.sendMessage(sendMsgRequest!) { (result, err) in
            if let result = result {
                print("Successfully sent (1) message. SQS messageId: \(result.messageId)")
            }
            if let err = err {
                print("SQS sendMessage error: \(err)")
            }
        }
    }
    
    // Sends a batch of mesasges to SQS
    public func sendMessageBatch(msgs: [String], queueURL: String) -> () {
        let sqs = AWSSQS.default()
        var entries = [AWSSQSSendMessageBatchRequestEntry]()
        var count = 0
        
        // Iterate over messages, add a unique identifier for ea. msg in the batch and then add message to the list of entries
        for msg in msgs {
            count += 1
            let entry = AWSSQSSendMessageBatchRequestEntry()
            entry?.identifier = String(count) // assign a unique identifier for ea message in batch
            entry?.messageBody = msg
            entries.append(entry!)
        }
        
        // Initialize SQS message batch request
        let sendMessageBatchRequest = AWSSQSSendMessageBatchRequest()
        sendMessageBatchRequest?.queueUrl = queueURL
        sendMessageBatchRequest?.entries = entries
        
        sqs.sendMessageBatch(sendMessageBatchRequest!) { (result, err) in
            if let result = result {
                print("Successfully sent (\(msgs.count)) message(s) via a single batch. SQS result: \(result)")
            }
            if let err = err {
                print("SQS sendMessage error: \(err)")
            }
        }
    }
    
    // Add a message attribute to the SQS message (optional)
    // Each message attribute must have a non-empty name, type, and value
    func prepareMsgAttributes(keyValuePairs: [String: String]) -> [String: AWSSQSMessageAttributeValue] {
        var attributes = [String: AWSSQSMessageAttributeValue]()
    
        for (name, value) in keyValuePairs {
            print("Adding KV pair: '\(name)' : '\(value)' to the message attribute.")
            // Initialize message attribute
            let msgAttribute = AWSSQSMessageAttributeValue()
            
            // Attribute type
            msgAttribute?.dataType = "String" // Can be String, Number, or Binary
            
            // Attribute value
            msgAttribute?.stringValue = value
            
            // Attribute name
            attributes[name] = msgAttribute
        }
        
        return attributes
    }
    
    // Add a message attribute to the SQS message (optional)
    // Each message attribute must have a non-empty name, type, and value
    func msgAttributes(key: String, value: String) -> [String: AWSSQSMessageAttributeValue] {
        var attributes = [String: AWSSQSMessageAttributeValue]()
        
        // Initialize message attribute
        let msgAttribute = AWSSQSMessageAttributeValue()
        
        // Attribute type
        msgAttribute?.dataType = "String" // Can be String, Number, or Binary
        
        // Attribute value
        msgAttribute?.stringValue = value
        
        // Attribute name
        attributes[key] = msgAttribute
        
        return attributes
    }
}
