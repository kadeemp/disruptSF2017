//
//  glucoseFile.swift
//  BgLive
//
//  Created by Nabil K on 2017-09-16.
//  Copyright © 2017 Nabil. All rights reserved.
//

import Foundation

struct GlucoseFile{
    
    
    var dateCollected: Date
    var rawValue: Double
    
    init(rawValue: Double, timeStamp: Double){
        
        self.rawValue = rawValue
        
        if let timeInterval = TimeInterval(exactly: timeStamp) {
            
            let dateCollected = Date(timeIntervalSince1970: timeInterval)
            
            self.dateCollected = dateCollected
            
        } else {
            self.dateCollected = Date()
        
        }

    }

}
