//
//  ConversationOperationQueue.swift
//  Yep
//
//  Created by kevinzhow on 15/5/30.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class ConversationOperationQueue: NSObject {

    static let sharedManager = ConversationOperationQueue()
    
    var modifyLock = false
}
