//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 18.12.2021.
//

//import Foundation
import Alamofire

enum NetworkError: Error {
    case noData
    case invalidURL
}
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    
    
//
//    Alamofire.request(
//        .GET,
//        "http://api.imagga.com/v1/tagging",
//        parameters: ["content": contentID],
//        headers: ["Authorization" : "Basic xxx"]
    //        )
    func fetchData(from url: String, completion: @escaping(Result<[Weather], NetworkError>) -> Void) {
        AF.request(
            url
//            method: .get,
//           // params: {q: "San Francisco"},
//            headers: ["x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
//                      "x-rapidapi-key": "8b2934fbd2mshfdeeb1ca9a70b88p1546eajsnf2236ac4a666"]
            
        )
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
    
    //MARK: временный метод Требуется оптимизация
    func fetchCities(from url: String, completion: @escaping(Result<[Cities], NetworkError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let cities = Cities.getCities(from: value)
                    completion(.success(cities))
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    

}
