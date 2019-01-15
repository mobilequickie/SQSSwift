//
//  SQS.swift
//  SQSSwift
//
//  Created by Hills, Dennis on 1/14/19.
//  Copyright © 2018 Hills, Dennis. All rights reserved.
//
import AWSSQS
import AWSMobileClient

public class SQS {
    
    // Send a single message to SQS - No message attributes
    public func sendMessage(msg: String, queueURL: String) -> () {
        
        // Using the AWSMobileClient as the default Identity provider. This uses the Cognito Identity Pool Id specified
        // in the awsconfiguration.json file.
        let sqs = AWSSQS.default()
        
        // Initialize SQS send message request
        let sendMsgRequest = AWSSQSSendMessageRequest()
        
        // Queue URL (not the queue ARN)
        sendMsgRequest?.queueUrl = queueURL
        
        // Message body string (can be JSON as well)
        sendMsgRequest?.messageBody = "My Queue Message from iOS app"
        
        // (Optional) message attribute
        sendMsgRequest?.messageAttributes = msgAttributes(key: "myName", value: "myValue")
        
        sqs.sendMessage(sendMsgRequest!) { (result, err) in
            if let result = result {
                print("Successfully sent (1) message. SQS result: \(result)")
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
    func msgAttributes(key: String, value: String) -> [String: AWSSQSMessageAttributeValue] {
        var attributes = [String: AWSSQSMessageAttributeValue]()
        
        // Initialize message attribute
        let msgAttribute = AWSSQSMessageAttributeValue()
        
        // Attribute type
        msgAttribute?.dataType = "String"
        
        // Attribute value
        msgAttribute?.stringValue = value
        
        // Attribute name
        attributes[key] = msgAttribute
        
        return attributes
    }
}
