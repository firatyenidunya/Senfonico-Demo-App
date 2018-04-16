//
//  ServiceConnector.swift
//  Senfonico Flickr Demo
//
//  Created by Firat on 14.04.2018.
//  Copyright © 2018 resoft. All rights reserved.
//


import Moya
import SwiftyJSON

enum SenfenicoService {
    case getRecentPhotos(apiKey:String,format:String,noJsonCallback:String)
}

class ServiceConnector {
    
    static let shared = ServiceConnector()
    
    var headers = Dictionary<String, String>()
    
    static var sessionIdCookie : HTTPCookie?
    
    private init() {}
    
    let endpointClosure = { (target: SenfenicoService) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint.adding(newHTTPHeaderFields: ServiceConnector.shared.headers)
    }
    
    func headers(_ headers: Dictionary<String, String>) -> ServiceConnector {
        for (k, v) in headers {
            ServiceConnector.shared.headers[k] = v
        }
        return .shared
    }
    
    func connect(_ target : SenfenicoService) {
        self.connect(target, success: nil)
    }
    
    func connect(_ target : SenfenicoService, success: ((_ target : SenfenicoService, _ response : JSON) -> ())?) {
        self.connect(target, success: success, error: nil)
    }
    
    func connect(_ target : SenfenicoService, success: ((_ target : SenfenicoService, _ response : JSON) -> ())?, error: ((_ target: SenfenicoService, _ error: MoyaError) -> ())?) {
        let provider = MoyaProvider<SenfenicoService>(endpointClosure: endpointClosure)
        _ = provider.request(target) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(moyaResponse):
                
                let statusCode = moyaResponse.statusCode
                let dataString = String(data: moyaResponse.data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                if let ds = dataString {
                    print("Status Code : ", statusCode)
                    print("Response : ", ds)
                    if let s = success {
                        s(target, JSON(parseJSON: ds))
                    }
                }
                break
            case let .failure(err):
                print("Error : ", err.errorDescription!)
                if let e = error {
                    e(target, err)
                }
                break
            }
        }
    }
}

// MARK: - TargetType Protocol Implementation
extension SenfenicoService: TargetType {
  
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    static let base = "https://www.flickr.com/services/rest/"
    
    static let port = ""
    
    var baseURL: URL {
        get {
            return URL(string: SenfenicoService.base)!
        }
    }
    
    var path: String {
        switch self {
        case .getRecentPhotos(let api_key, let method, let noJsonCallback):
            return "?method=flickr.photos.getRecent&api_key="+api_key+"&format="+method+"&nojsoncallback="+noJsonCallback
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    var parameters: [String:Any]{
        switch self {
        default:
            return ["":""]
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}

// MARK: - Helpers
private extension String {
    
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
    
    mutating func stringByRemovingRegexMatches(pattern: String, replaceWith: String = "") {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.characters.count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return
        }
    }
}

