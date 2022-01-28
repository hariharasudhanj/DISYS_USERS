//
//  APICalls.swift
//  HARI_DISYS
//
//  Created by Hariharasudhan J on 28/01/22.
//

import Foundation

class ApiCalls{
    class func getDataFrom(urlString: String, completion: @escaping(_ data: NSData)->()) {
        if let url = NSURL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url as URL) { (data, response, error) in
                // print(response)
                if let data = data {
                    completion(data as NSData)
                } else {
                    print(error?.localizedDescription)
                }
            }
            task.resume()
        } else {
            // URL is invalid
        }
    }
  
    class func createuser(urlString: String,parameter:Dictionary<String, String>, completion: @escaping(_ data: NSData)->()) {
        if let url = NSURL(string: urlString) {
            let session = URLSession.shared
            var request = URLRequest(url: url as URL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Bearer aa6ed05a183cc25bc16d46165a2e230863743e59972c44d4844b524149bb36fc", forHTTPHeaderField: "Authorization")
            let dictionary = APIManager.params.parameterDictionary
            
            request.httpBody = try! JSONEncoder().encode(parameter)
            request.httpMethod = "POST"
            let task = session.dataTask(with: request) { (data, response, error) in
                // print(response)
                if let data = data {
                    completion(data as NSData)
                } else {
                    print(error?.localizedDescription)
                }
            }
            task.resume()
        } else {
            // URL is invalid
        }
    }
    class func updateUser(urlString: String,parameter:Dictionary<String, String>, completion: @escaping(_ data: NSData)->()) {
        if let url = NSURL(string: urlString) {
            let session = URLSession.shared
            var request = URLRequest(url: url as URL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Bearer aa6ed05a183cc25bc16d46165a2e230863743e59972c44d4844b524149bb36fc", forHTTPHeaderField: "Authorization")
            let dictionary = APIManager.params.parameterDictionary
            
            request.httpBody = try! JSONEncoder().encode(parameter)
            request.httpMethod = "PUT"
            let task = session.dataTask(with: request) { (data, response, error) in
                // print(response)
                if let data = data {
                    completion(data as NSData)
                } else {
                    print(error?.localizedDescription)
                }
            }
            task.resume()
        } else {
            // URL is invalid
        }
    }
}


