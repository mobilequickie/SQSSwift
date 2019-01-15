//
//  ViewController.swift
//  SQSSwift
//
//  Created by Hills, Dennis on 1/14/19.
//  Copyright © 2018 Hills, Dennis. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthCore

class ViewController: UIViewController {

    @IBOutlet weak var btnSingleMsg: UIButton!
    @IBOutlet weak var btnBatch: UIButton!
    
    // Make sure this is the QueueURL (https://), not the QueueARN and not the Queue name
    let myQueueURL: String = "<YOUR-SQS-QUEUE-URL-HERE>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Sends 1 message to SQS
    @IBAction func btnSingleGo(_ sender: Any) {
        // send single message to SQS
        SQS().sendMessage(msg: "buttonPress \(Date().timeIntervalSinceNow)", queueURL: myQueueURL)
    }
    
    // Sends 10 messages to SQS in a single batch
    @IBAction func btnBatchGo(_ sender: Any) {
        let names = ["Anna", "Alex", "Brian", "Jack", "Dennis", "Iron", "Benton", "Bob", "Charlie", "Cookie"]
        // send a batch of 10 messages. Each name in the array is an individual message within the batch
        SQS().sendMessageBatch(msgs: names, queueURL: myQueueURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

