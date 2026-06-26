//
//  ContentView.swift
//  WeatherApp
//
//  Created by Vir Daksh on 25/06/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = WeatherViewModel()
    @State private var city = ""

    var body: some View {
        ZStack {

            Image("A1")
                .resizable()
                .scaledToFill()
                .opacity(0.57)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("City Weather 🌥️")
                    .font(.custom("Noteworthy-Bold", size: 50))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)

                HStack {

                    TextField("Enter city name...", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.custom("Noteworthy-Bold", size: 25))

                    Button {
                        Task {
                            await viewModel.fetch(city: city.isEmpty ? "London" : city)
                        }
                    } label: {
                        Text("Search 👀")
                            .font(.custom("Noteworthy-Bold", size: 20))
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)

                if let weather = viewModel.apiData {

                    AsyncImage(
                        url: URL(
                            string: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
                        )
                    ) { phase in

                        switch phase {

                        case .empty:
                            ProgressView()
                                .frame(width: 200, height: 200)

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)

                        case .failure(_):
                            Image(systemName: "cloud.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.white)

                        @unknown default:
                            EmptyView()
                        }
                    }

                    Text(weather.name)
                        .font(.custom("Noteworthy-Bold", size: 45))
                        .foregroundColor(.white)

                    Text("\(weather.main.temp, specifier: "%.1f")°C")
                        .font(.custom("Noteworthy-Bold", size: 30))
                        .foregroundColor(.white)

                    Text(weather.weather.first?.description.capitalized ?? "")
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(.white)

                    HStack(spacing: 30) {

                        VStack {
                            Image(systemName: "wind")
                            Text("\(weather.wind.speed, specifier: "%.1f") m/s")
                        }

                        VStack {
                            Image(systemName: "humidity")
                            Text("\(weather.main.humidity)%")
                        }
                    }
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white)
                }

                Spacer()
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    ContentView()
}
