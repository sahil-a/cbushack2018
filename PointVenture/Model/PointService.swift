//
//  PointService.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/16/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import AWSAuthCore
import AWSCore
import AWSAPIGateway
import AWSMobileClient
import AWSS3

class PointService {
    
    class var individual: Individual? {
        set {
            UserDefaults.standard.set(newValue?.serialize(), forKey: "individual")
        }
        get {
            return Individual.deserialize(json: UserDefaults.standard.string(forKey: "individual") ?? "") as? Individual
        }
    }
    
    class var family: Family? {
        set {
            UserDefaults.standard.set(newValue?.serialize(), forKey: "family")
        }
        get {
            return Family.deserialize(json: UserDefaults.standard.string(forKey: "family") ?? "") as? Family
        }
    }

    class func new(family: Family, completion: @escaping (Bool) -> Void) {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/registerNewFamily"
        let queryStringParameters: [String:String] = [:]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let httpBody = "{ \n  " +
            "\"hashedCode\":\"\(family.hashedCode)\", \n  " +
            "\"familyName\":\"\(family.name)\", \n  " +
            "\"parentDisplayName\":\"\(family.individuals[0].displayName)\", \n  " +
            "\"manualOverrideEnabled\":\"\(family.manualOverrideEnabled)\", \n  " +
            "\"parentName\":\"\(family.individuals[0].name)\"\n}"
        
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient =
            AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle result here
            let result = task.result!
            let responseString =
                String(data: result.responseData!, encoding: .utf8)
            
            if let _ = responseString, result.statusCode == 200 {
                parseResponseData(data: result.responseData!)
                completion(true)
            } else {
                completion(false)
            }
            
            return nil
        }
    }
    
    class func new(user: Individual, hashedCode: String, completion: @escaping (Bool) -> Void) {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/registerUser"
        let queryStringParameters: [String:String] = [:]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        
        let httpBody = "{ \n  " +
            "\"displayName\":\"\(user.displayName)\", \n  " +
            "\"hashedCode\":\"\(hashedCode)\", \n  " +
            "\"isParent\":\(user.isParent), \n  " +
        "\"name\":\"\(user.name)\"\n}"
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient =
            AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle result here
            let result = task.result!
            let responseString =
                String(data: result.responseData!, encoding: .utf8)
            
            if let _ = responseString, result.statusCode == 200 {
                parseResponseData(data: result.responseData!)
                completion(true)
            } else {
                completion(false)
            }
            
            return nil
        }
    }
    
    class func complete(gainUser: String, loseUser: String, points: Int, completion: @escaping (Bool) -> Void) {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/complete"
        let queryStringParameters: [String:String] = [:]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        
        let httpBody = "{ \n  " +
            "\"gainUser\":\"\(gainUser)\", \n  " +
            "\"loseUser\":\"\(loseUser)\", \n  " +
            "\"points\":\(points) \n }"
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient =
            AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle result here
            let result = task.result!
            let responseString =
                String(data: result.responseData!, encoding: .utf8)
            
            if let _ = responseString, result.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
            
            return nil
        }
    }
    
    class func login(name: String, hashedCode: String, completion: @escaping (Bool) -> Void) {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/login"
        let queryStringParameters: [String:String] = [:]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let httpBody = "{ \n  " +
            "\"hashedCode\":\"\(hashedCode)\", \n  " +
            "\"name\":\"\(name)\"\n}"
        
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient =
            AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle result here
            let result = task.result!
            let responseString =
                String(data: result.responseData!, encoding: .utf8)
            
            if let _ = responseString, result.statusCode == 200 {
                parseResponseData(data: result.responseData!)
                completion(true)
            } else {
                completion(false)
            }
            
            return nil
        }
    }
    
    class func getIndividual(primaryKey: String, completion: @escaping (Individual?) -> Void) {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/getIndividual"
        let queryStringParameters: [String:String] = [:]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let httpBody = "{ \n  " +
        "\"primaryKey\":\"\(primaryKey)\"\n}"
        
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient =
            AWSAPI_8MCG2UHAHA_PointAPIMobileHubClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle result here
            let result = task.result!
            let responseString =
                String(data: result.responseData!, encoding: .utf8)
            
            if let responseString = responseString, result.statusCode == 200 {
                let user = Individual.deserialize(json: responseString) as! Individual
                completion(user)
            } else {
                completion(nil)
            }
            
            return nil
        }
    }
    
    private class func parseResponseData(data: Data) {
        let object = try! JSONSerialization.jsonObject(with: data, options: [])
        func parseIndividual(data: [String: Any]) -> Individual {
            let primaryKey = data["primaryKey"] as! String
            let isParent = data["isParent"] as! Bool
            let displayName = data["displayName"] as! String
            let imageURL = data["imageURL"] as! String
            let name = data["name"] as! String
            let points = data["points"] as! Int
            var individual = Individual(isParent: isParent, name: name, displayName: displayName)
            individual.primaryKey = primaryKey
            individual.imageURL = imageURL
            individual.points = points
            return individual
        }
        if let object = object as? [String : [String : Any]] {
            if let individualData = object["individual"] {
                let individual = parseIndividual(data: individualData)
                PointService.individual = individual
                if let familyData = object["family"] {
                    let name = familyData["name"] as! String
                    let imageURL = familyData["imageURL"] as! String
                    let hashedCode = familyData["hashedCode"] as! String
                    let points = familyData["points"] as! Int
                    let individualKeys = familyData["individualKeys"] as! [String]
                    let primaryKey = familyData["primaryKey"] as! String
                    let manualOverrideEnabled = (familyData["manualOverrideEnabled"] as! String) == "true"
                    var family = Family(name: name, hashedCode: hashedCode, individuals: [individual])
                    family.imageURL = imageURL
                    family.points = points
                    family.primaryKey = primaryKey
                    family.individualKeys = individualKeys
                    family.manualOverrideEnabled = manualOverrideEnabled
                    PointService.family = family
                }
            }
        }
    }
    
    class func upload(image: UIImage, individualKey: String, completion: @escaping (Bool) -> Void) {
        let dataOptional = UIImagePNGRepresentation(image)
        guard let data = dataOptional else {
            completion(false)
            return
        }
            
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                completion(error == nil)
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(data,
                                   bucket: "pointventure-userfiles-mobilehub-1424110637",
                                   key: individualKey,
                                   contentType: "text/plain",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject! in
                                    if let _ = task.error {
                                    }
                                    
                                    if let _ = task.result {
                                    }
                                    return nil;
        }
    }
    
    class func downloadImage(primaryKey: String, completion: @escaping (UIImage?) -> Void) {
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            // Do something e.g. Update a progress bar.
        })
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    completion(nil)
                }
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(
            fromBucket: "pointventure-userfiles-mobilehub-1424110637",
            key: primaryKey,
            expression: expression,
            completionHandler: completionHandler
            ).continueWith {
                (task) -> AnyObject! in if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    // Do something with downloadTask.
                    
                }
                return nil;
        }
    }
}
