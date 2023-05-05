//
//  WeatherModel.swift
//  Clima Project
//
//  Created by sidzhe on 26.04.2023.
//

import Foundation

//MARK: Weather model

struct WeatherModel {
    let conditionId: Int
    let name: String
    let temp: Double
    
    var tempCelsius: String {
        String(format: "%.1f", temp)
    }
    
//MARK: Set weather image
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return Const.weather.cloudBolt
        case 300...321:
            return Const.weather.cloudDrizzle
        case 500...531:
            return Const.weather.cloudRain
        case 600...622:
            return Const.weather.cloudSnow
        case 701...781:
            return Const.weather.cloudFog
        case 800:
            return Const.weather.sunMax
        case 801...804:
            return Const.weather.cloudBolt
        default:
            return Const.weather.cloud
        }
    }
}
