//
//  Helper.swift
//  BgLive
//
//  Created by Nabil K on 2017-09-16.
//  Copyright © 2017 Nabil. All rights reserved.
//

import Foundation

struct Helper {
    
    static func readJson() -> [[String:Any]] {
        do {
            if let file = Bundle.main.url(forResource: "AllData", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                if let object = json as? [String: [Any]] {
                    // json is a dictionary
                    
                    print(object)
                    
                    return object["data"] as! [[String:Any]]
                
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                    return[[:]]
                } else {
                    print("JSON is invalid")
                    return [[:]]
                }
            } else {
                print("no file")
                return [[:]]
            }
        } catch {
            print(error.localizedDescription)
            return [[:]]
        }
    
    }
    
    
    static func getGlucose() -> [GlucoseFile]{
        
        let data = readJson()
        var output : [GlucoseFile] = []
        
        for json in data {
            print(json)
            let rawValue = json["calculated_value"] as! Double
            let timestamp = json["timestamp"] as! Double
            
            let file = GlucoseFile(rawValue: rawValue, timeStamp: timestamp)
        
            output.append(file)
            
        }
        
        return output

    }
    
}


extension String {
    func cleanPhoneNumber() -> String {
        var cleanString: String = self
        
        if let regex = try? NSRegularExpression(pattern: "-|\\s|\\(|\\)") {
            let range = NSMakeRange(0, self.characters.count)
            cleanString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        }
        
        return cleanString
    }
}
