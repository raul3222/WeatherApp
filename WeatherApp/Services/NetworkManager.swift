//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 18.12.2021.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case noData
    case invalidURL
}
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData(from url: String, completion: @escaping(Result<[Weather], NetworkError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let weather = Weather.getWeather(from: value)
                    completion(.success(weather))
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func fetchImage(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void){
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                    
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    print("error")
                }
            }
    }

}
