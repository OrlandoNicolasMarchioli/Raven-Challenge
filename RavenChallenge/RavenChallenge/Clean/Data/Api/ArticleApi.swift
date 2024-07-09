//
//  ArticlesApi.swift
//  RavenChallenge
//
//  Created by Nico on 09/07/2024.
//

import Foundation

protocol ArticlesApiProtocol{
    func getAllArticles(range: String,completion: @escaping ([String: Any]?, Error?) -> Void)
}

class ArticleApi: ArticlesApiProtocol{
    
    static private var shared: ArticleApi?
    private var urlSession: URLSession
    private var baseUrl: String
    private var apiKey: String
    private var cacheKey: String
    
    init(urlSession: URLSession = URLSession.shared, baseUrl: String, apiKey: String, cacheKey: String) {
        self.urlSession = urlSession
        self.baseUrl = baseUrl
        self.apiKey = apiKey
        self.cacheKey = cacheKey
    }
    
    static func getInstance() -> ArticlesApiProtocol{
        if let returnShared = shared{
            return shared ?? returnShared
        }else{
            let newInstance =
            ArticleApi(baseUrl: ProcessInfo.processInfo.environment["baseUrl"] ?? "",
                        apiKey: ProcessInfo.processInfo.environment["apiKey"] ?? "",
                        cacheKey:  ProcessInfo.processInfo.environment["cacheKey"] ?? "")
            shared = newInstance
            return shared ?? newInstance
        }
    }
    
    func getAllArticles(range: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let urlRequest = absoluteURLFactory(host: baseUrl,
                                                  path: "svc/mostpopular/v2/emailed/" + range + ".json",
                                                  param: apiKey) else {
            print("Invalid Url")
            return
        }
        
        performDataTask(urlRequest: urlRequest , completion: completion)
    }
    
    private func performDataTask(urlRequest: URLRequest, completion: @escaping ([String: Any]?, Error?) -> Void) {
        urlSession.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.cacheResponse(jsonResponse)
                    completion(jsonResponse, nil)
                } else {
                    throw NSError(domain: "Invalid JSON format", code: 100, userInfo: nil)
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    if let cachedResponse = self.loadCachedResponse() {
                        completion(cachedResponse, nil)
                    } else {
                        completion(nil, error)
                    }
                    
                }
            }
        }.resume()
    }
    
    private func absoluteURLFactory(host: String, path: String, param: String) -> URLRequest?{
        var hostUrl = URL(string: host)
        hostUrl?.append(path: path)
        hostUrl?.append(queryItems: [URLQueryItem(name: "api-key", value: param)])
        var urlRequest = URLRequest(url: hostUrl ?? URL(fileURLWithPath: ""))
        urlRequest.httpMethod = "GET"
        return  urlRequest
    }
    
    private func cacheResponse(_ response: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: response, options: [])
            UserDefaults.standard.set(data, forKey: cacheKey)
        } catch {
            print("Error caching response: \(error)")
        }
    }
    
    private func loadCachedResponse() -> [String: Any]? {
        if let data = UserDefaults.standard.data(forKey: cacheKey) {
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return response
            } catch {
                print("Error loading cached response: \(error)")
            }
        }
        return nil
    }
}
