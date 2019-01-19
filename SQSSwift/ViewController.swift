//
//  ViewController.swift
//  SQSSwift
//
//  Created by Hills, Dennis on 1/18/19.
//  Copyright © 2018 Hills, Dennis. All rights reserved.
//
import UIKit
import AWSMobileClient
import AWSAuthCore

class ViewController: UIViewController {

    @IBOutlet weak var btnSingleMsg: UIButton!
    @IBOutlet weak var btnBatch: UIButton!
    
    // Make sure this is the QueueURL (https://), not the QueueARN and not the Queue name
    let myQueueURL: String = "<YOUR-SQS-SOURCE-QUEUE-URL-HERE>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Sends 1 message to SQS
    @IBAction func btnSingleGo(_ sender: Any) {
        // Set the current date and formatting
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ssZ"
        
        // Send single message to SQS
        SQS().sendMessage(msg: "Message sent at: \(dateFormatter.string(from: currentDateTime))", queueURL: myQueueURL)
    }
    
    // Sends 10 messages to SQS in a single batch
    // Each name in the array is an individual message within the batch request
    @IBAction func btnBatchGo(_ sender: Any) {
        let names = ["Anna", "Benton", "Chad", "Dave", "Evan", "Frank", "Gary", "Henry", "Ida", "Jack"]
        SQS().sendMessageBatch(msgs: names, queueURL: myQueueURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

