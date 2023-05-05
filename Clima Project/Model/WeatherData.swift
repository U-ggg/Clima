//
//  WeatherData.swift
//  Clima Project
//
//  Created by sidzhe on 26.04.2023.
//

import Foundation

//MARK: Model for JSON

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}


struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
