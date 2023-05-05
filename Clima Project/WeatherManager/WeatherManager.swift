//
//  WeatherManager.swift
//  Clima Project
//
//  Created by sidzhe on 26.04.2023.
//

import Foundation
import CoreLocation

struct WeatherManager {
    
//MARK: Api properties
    
    var delegate: WeaterDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c00ea73421eb103ede0e0f621daa7cae&units=metric"
    
//MARK: Api Methods
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlStr: urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlStr: urlString)
    }
    
    func performRequest(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                delegate?.didFailWithError(error: error!)
            }
            guard let newData = data else { return }
            guard let weather = parseJSON(weatherDate: newData) else { return }
            delegate?.setWeather(self, weather)
        }
        task.resume()
    }
    
//MARK: Parse JSON
    
    func parseJSON(weatherDate: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherDate)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            let weatherModel = WeatherModel(conditionId: id, name: name, temp: temp)
            return weatherModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

//MARK: Protocol WeaterDelegate

protocol WeaterDelegate {
    func setWeather(_ weatherManager: WeatherManager, _ weaterModel: WeatherModel)
    func didFailWithError(error: Error)
}

