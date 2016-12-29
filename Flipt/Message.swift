//
//  Message.swift
//  Flipt
//
//  Created by Johann Kerr on 12/29/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation

struct Message {
    var text:String
    var sender:String
    var timestamp: Double
    
    init(_ dict: [String:Any]) {
        self.text = dict["message"] as? String ?? ""
        self.sender = dict["name"] as? String ?? ""
        self.timestamp = dict["timestamp"] as? Double ?? 0.0
    }
}
