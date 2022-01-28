//
//  APIManager.swift
//  HARI_DISYS
//
//  Created by Hariharasudhan J on 27/01/22.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    func hostURL() -> String {
        return "https://gorest.co.in"
    }
    
    struct URLPaths {
        static let createUser = "/public/v1/users"
        static let getUsersList = "/public/v1/users"
        
    }
     
    struct EncounterPath {
        
        static func encounterAudio() -> (String, String) {
            let path = "/api/encounters/upload"
            let withName = "encounterFile"
            return (path, withName)
        }
        
    }
    
//    struct Headers {
//
//
//        static let contentHeader = HTTPHeader(name: "Content-Type", value: "application/json")
//        static let multipartContentHeader = HTTPHeader(name: "Content-Type", value: "multipart/form-data")
//
//        static func authorizationHeader(token: String) -> HTTPHeader {
//            return HTTPHeader(name: "Authorization", value: "Bearer " + token)
//        }
//    }
    struct params{
        static let parameterDictionary = ["name" : "Himanshu", "email" : "jdsf@gmail.com","status":"active","gender":"male"]

    }
    
}

