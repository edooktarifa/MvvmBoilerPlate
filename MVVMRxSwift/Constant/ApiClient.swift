//
//  ApiClient.swift
//  MVVMRxSwift
//
//  Created by Edo Oktarifa on 26/04/21.
//

import Foundation
import RxSwift
import Alamofire


enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict(error: Any)               //Status code 409
    case internalServerError    //Status code 500
}

enum ErrorMessage: String{
    case forbidden = "Forbidden Error"
    case notFound = "Not Found"
    case conflict = "Conflict Error"
    case internalServerError = "Internal Server Error"
    case unknownError = "Failed Internet Connection"
}

class ApiClient {
    
    static func getPosts(userId: Int) -> Observable<Post> {
        return request(url: "https://jsonplaceholder.typicode.com/posts/\(userId)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:])
    }
    //-------------------------------------------------------------------------------------------------
    //MARK: - The request function to get results in an Observable
    
    private static func request<T: Codable> (url: String, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders) -> Observable<T> {
        
        return Observable<T>.create { observer in
            let request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    
                    guard let data = response.data else {
                        observer.onError(ApiError.notFound)
                        return
                    }
                    
                    do {
                        let dataJson = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(dataJson)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                    
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict(error: error.localizedDescription))
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
