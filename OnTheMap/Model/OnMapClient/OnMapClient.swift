//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Natasha Stopa on 4/26/20.
//  Copyright © 2020 Stopa Inc. All rights reserved.
//

import Foundation


class OnMapClient {
    
    struct Auth {
        static var sessionId = ""
        static var expirationDate = ""
        static var accountId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        static let session = "session"
        static let studentLocation = "StudentLocation"
        static let limitParam = "?limit="
        static let skipParam = "?skip="
        static let orderParam = "?uniqueKey="
        
        
        case getSession
        case getLocation
        
        var stringValue: String {
            switch self {
            case .getSession:
                return Endpoints.base + Endpoints.session
            case .getLocation:
                return Endpoints.base + Endpoints.studentLocation + Endpoints.limitParam + "10"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func getLocations(completion: @escaping ([StudentLocation], Error?) -> Void) -> Void {
        taskForGETRequest(url: Endpoints.getLocation.url, responseType: GetLocationResponse.self) { response, error in
            if let response = response {
                print("response")
                print(response)
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    print("other error")
                    let errorResponse = try decoder.decode(GetLocationResponse.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    print("decode issue")
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    

class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try! JSONEncoder().encode(body)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request)  { data, response, error in
        if error != nil {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        
        let range = 5..<data.count
        let newData = data.subdata(in: range) /* subset response data! */
        print(String(data: newData, encoding: .utf8)!)
        
        let decoder = JSONDecoder()
        do {
            print(String(data: newData, encoding: .utf8)!)
            let responseObject = try decoder.decode(ResponseType.self, from: newData)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
        }  catch {
            do {
                let errorResponse = try decoder.decode(LoginResponse.self, from: data) as Error
                DispatchQueue.main.async {
                    completion(nil, errorResponse)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    task.resume()
}

class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    let body = PostUdacitySession(udacity: LoginInfo(username: username, password: password))
    taskForPOSTRequest(url: Endpoints.getSession.url, responseType: LoginResponse.self, body: body) { response, error in
        if let response = response {
            Auth.sessionId = response.session.id
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }
}


class func deleteSessionId(completion: @escaping (Bool, Error?) -> Void) {
    var request = URLRequest(url: Endpoints.getSession.url)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        
        if error != nil { // Handle error…
            completion(false, error)
        }
        
        guard let data = data else {
            DispatchQueue.main.async {
                completion(false, error)
            }
            return
        }
        
        let range = 5..<data.count
        let newData = data.subdata(in: range) /* subset response data! */
        print(String(data: newData, encoding: .utf8)!)
        
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(LogoutResponse.self, from: newData)
            DispatchQueue.main.async {
                Auth.sessionId = ""
                Auth.expirationDate = ""
                Auth.accountId = ""
                completion(true, nil)
            }
        }  catch {
            do {
                let errorResponse = try decoder.decode(LogoutResponse.self, from: data) as Error
                DispatchQueue.main.async {
                    completion(false, errorResponse)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    task.resume()
}
}
