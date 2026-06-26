//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Vir Daksh on 26/06/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Models

struct WeatherResponse: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

struct Weather: Codable, Hashable {
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}

// MARK: - ViewModel

@MainActor
class WeatherViewModel: ObservableObject {

    @Published var apiData: WeatherResponse?

    func fetch(city: String = "New York") async {

        let cityName = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city

        guard let url = URL(
            string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=2c13825a337ac54820603614e5157149&units=metric"
        ) else {
            return
        }

        do {
            // Perform the network call off the main actor
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decode off the main actor as well
            let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
            // Update published state on the main actor (class is already @MainActor)
            self.apiData = result
        } catch {
            print("Network/Decoding Error: \(error)")
        }
    }
}
