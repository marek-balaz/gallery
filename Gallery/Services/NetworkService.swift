//
//  NetworkService.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case apiError
    case unknown
    case taskAlreadyExists
    case noInternetConnection
}

struct TaskInfo {
    let task: URLSessionDataTask
    let url: URL
}

protocol NetworkServiceProtocol {
    
}

class NetworkService: NetworkServiceProtocol {
    
    typealias Handler = (_ error: Error?, _ statusCode: Int?, _ data: Data?) -> ()
    typealias HTTPHeaders = [String: String]
    
    // MARK: - Constants
    
    static let shared: NetworkService = NetworkService()
    final let TIMEOUT_INTERVAL_FOR_REQUEST: TimeInterval = 30
    final let TIMEOUT_INTERVAL_FOR_RESOURCE: TimeInterval = 300
    final let MAXIMUM_NUMBER_TASKS: Int = 3
    
    // MARK: - Variables
    
    var tasks: [TaskInfo] = []
    var session: URLSession?
    
    init() {
    }
    
    func getSession() -> URLSession {
        if let session {
            return session
        } else {
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = TIMEOUT_INTERVAL_FOR_REQUEST
            sessionConfig.timeoutIntervalForResource = TIMEOUT_INTERVAL_FOR_RESOURCE
            return URLSession(configuration: sessionConfig)
        }
    }
    
    func request(url: URL, method: HTTPMethod, body: [String : AnyObject]?, action: @escaping Handler, headers: HTTPHeaders? = nil) {
        
        let session = getSession()
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: session.configuration.timeoutIntervalForRequest)
        for (key, value) in (headers ?? [:]) as [String : String] {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                Log.d("Couldn't serialize data.")
            }
        }
    
        let task = session.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if let data = data {
                    action(error, httpResponse.statusCode, data)
                } else {
                    action(error, httpResponse.statusCode, nil)
                }
            } else {
                if let nsError = error as NSError?, nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet {
                    action(NetworkError.noInternetConnection, nil, nil)
                } else {
                    action(NetworkError.invalidResponse, nil, nil)
                }
            }
        }
        
        task.resume()
    }
    
    func download(from url: URL, action: @escaping Handler) {
        
        if containsTask(for: url) {
            Log.d("Task for \(url) already exist.")
            return
        }
        
        if tasks.count > MAXIMUM_NUMBER_TASKS {
            Log.d("Maximum number of tasks reached.")
            return
        }
        
        let session = self.getSession()
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.sync {
                self.removeTask(for: url)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if let jsonData = data {
                    action(error, httpResponse.statusCode, jsonData)
                } else {
                    action(error, httpResponse.statusCode, nil)
                }
            } else {
                if let nsError = error as NSError?, nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet {
                    action(NetworkError.noInternetConnection, nil, nil)
                } else {
                    action(NetworkError.invalidResponse, nil, nil)
                }
            }
        }
        
        let taskInfo = TaskInfo(task: task, url: url)
        tasks.append(taskInfo)
        
        task.resume()

    }
    
    func containsTask(for url: URL) -> Bool {
        return tasks.contains(where: { $0.url == url } )
    }
    
    func removeTask(for url: URL) {
        if let index = tasks.firstIndex(where: { $0.url == url }) {
            let task = tasks[index].task
            task.cancel()
            tasks.remove(at: index)
        }
    }
    
}
