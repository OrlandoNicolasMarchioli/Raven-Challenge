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
    
    init(urlSession: URLSession = URLSession.shared, baseUrl: String, apiKey: String) {
        self.urlSession = urlSession
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }
    
    static func getInstance() -> ArticlesApiProtocol{
        if let returnShared = shared{
            return shared ?? returnShared
        }else{
            let newInstance =
            ArticleApi(baseUrl: ProcessInfo.processInfo.environment["baseUrl"] ?? "", apiKey: ProcessInfo.processInfo.environment["apiKey"] ?? "")
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
                    completion(jsonResponse, nil)
                } else {
                    throw NSError(domain: "Invalid JSON format", code: 100, userInfo: nil)
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, error)
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
}
