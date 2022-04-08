//
//  ViewController.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 18.12.2021.
//

import UIKit

protocol CurrentCityDelegate {
    func saveCity(city: String)
}

class WeatherViewController: UIViewController {
    @IBOutlet weak var directionView: CircleView!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var conditionTextLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var imagePhoto: UIImageView!
    @IBOutlet weak var chooseCityLabel: UILabel!
    
    @IBOutlet weak var directionStack: UIStackView!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet var weatherLogo: UIImageView!
    private var activityIndicator: UIActivityIndicatorView?
    var cities: [City] = []
    //var citiesFromApi: [Cities] = []
    var city = "Moscow"

    lazy var link = "https://api.weatherapi.com/v1/current.json?key=284d7d06687e411e9dd211536211812&q=\(city)&aqi=no"
    var currentDirection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = showActivityIndicator(in: view)
//        if let currentCity = UserDefaults.standard.string(forKey: "LastCity") {
//                  city = currentCity
//              }
        fetchCitiesFromCoreData()
        hideLabels()
        //requestWeather()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! UINavigationController
        let cityChooseVC = destVC.topViewController as! CityChooseViewController
        cityChooseVC.delegate = self
        if !cities.isEmpty {
            print(cities.count)
            cityChooseVC.cities = cities
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        link = "https://api.weatherapi.com/v1/current.json?key=284d7d06687e411e9dd211536211812&q=\(city)&aqi=no"
        hideLabels()
        requestWeather()
        fetchCitiesFromCoreData()
    }
}

extension WeatherViewController: CurrentCityDelegate {
    func saveCity(city: String) {
        self.city = city
        UserDefaults.standard.set(city, forKey: "LastCity")
//        guard let lastCity = UserDefaults.standard.string(forKey: "LastCity") else {return}
        //print(lastCity)
    }
}

//:MARK Network
extension WeatherViewController {
    private func fetchAlamofire() {
        activityIndicator?.startAnimating()
        NetworkManager.shared.fetchData(from: link) { result in
            switch result {
            case .success(let weather):
                self.configureUI(with: weather)
            case .failure(let error):
                print(error)
            }
        }
    }
    private func fetchLogo(from url: String) {
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                self.weatherLogo.image = UIImage(data: imageData)
            case .failure(_):
                print("error")
            }
        }
    }
    
    private func configureUI(with weather: [Weather]) {
        cityName.text = weather[0].location.name
        temperatureLabel.text = String(weather[0].current.temp_c)  + "°"
        conditionTextLabel.text = weather[0].current.condition.text
       // windSpeedLabel.text = "Wind " + String(weather[0].current.wind) + " kph"
        humidity.text = "Humidity: \(weather[0].current.humidity) %"
        windDirectionLabel.text = weather[0].current.wind_dir
        windSpeed.text = String(weather[0].current.wind) + " kph"
        var logoUrl = weather[0].current.condition.icon
        logoUrl = "https:\(logoUrl)"
        fetchLogo(from: logoUrl)
        rotateDirection(direction: weather[0].current.wind_dir, directionView: directionView, directionStack: directionStack)
        
        self.activityIndicator?.stopAnimating()
        showLabels()
    }
    
    private func requestWeather() {
        if !city.isEmpty{
            print("fetch")
        fetchAlamofire()
        } else {
            print("choose city")
        }
    }
    private func hideLabels() {
        cityName.isHidden = true
        temperatureLabel.isHidden = true
        conditionTextLabel.isHidden = true
        //windSpeedLabel.isHidden = true
        weatherLogo.isHidden = true
        chooseCityLabel.isHidden = false
    }
    private func showLabels() {
        cityName.isHidden = false
        temperatureLabel.isHidden = false
        conditionTextLabel.isHidden = false
        //windSpeedLabel.isHidden = false
        weatherLogo.isHidden = false
        chooseCityLabel.isHidden = true
    }
    
    private func translateCondition (condition: String) -> String {
        switch condition {
        case "Sunny": return "Солнечно"
        
        default: return condition
        }
    }
}

extension WeatherViewController {
    
    private func fetchCitiesFromCoreData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let cities):
                self.cities = cities
            case .failure(_):
                print("Error")
            }
        }
    }
    
    private func save(city cityName: String) {
        StorageManager.shared.save(cityName) { city in
            print("saved")
        }
    }
}

extension WeatherViewController {
    private func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
    
    private func rotateDirection(direction: String, directionView: UIView, directionStack: UIStackView) {
        if currentDirection == direction {
            return
        }
        directionView.transform = .identity
        directionStack.transform = .identity
        currentDirection = direction
        switch direction {
        case "N":
            directionView.transform = directionView.transform.rotated(by: .pi)
            directionStack.transform = directionStack.transform.rotated(by: -.pi)
        case "E":
            directionView.transform = directionView.transform.rotated(by: -.pi / 4)
            directionStack.transform = directionStack.transform.rotated(by: .pi / 4)
        case "W":
            directionView.transform = directionView.transform.rotated(by: .pi / 2)
            directionStack.transform = directionStack.transform.rotated(by: -.pi / 2)
        case "SSE":
            directionView.transform = directionView.transform.rotated(by: -.pi / 8)
            directionStack.transform = directionStack.transform.rotated(by: .pi / 8)
        case "SSW":
            directionView.transform = directionView.transform.rotated(by: .pi / 8)
            directionStack.transform = directionStack.transform.rotated(by: -.pi / 8)
        case "SW":
            directionView.transform = directionView.transform.rotated(by: .pi / 4)
            directionStack.transform = directionStack.transform.rotated(by: -.pi / 4)
        case "SE":
            directionView.transform = directionView.transform.rotated(by: -.pi / 4)
            directionStack.transform = directionStack.transform.rotated(by: .pi / 4)
        case "NW":
            directionView.transform = directionView.transform.rotated(by: 3 * .pi / 4)
            directionStack.transform = directionStack.transform.rotated(by: -3 * .pi / 4)
        case "NE":
            directionView.transform = directionView.transform.rotated(by: -3 * .pi / 4)
            directionStack.transform = directionStack.transform.rotated(by: 3 * .pi / 4)
        case "NNW":
            directionView.transform = directionView.transform.rotated(by: 3.5 * .pi / 4)
            directionStack.transform = directionStack.transform.rotated(by: -3.5 * .pi / 4)
        case "NNE":
            directionView.transform = directionView.transform.rotated(by: -3.5 * .pi / 4)
            directionStack.transform = directionStack.transform.rotated(by: 3.5 * .pi / 4)
        default:
            directionView.transform = .identity
            directionStack.transform = .identity
        }
    }
    
    
    
}
