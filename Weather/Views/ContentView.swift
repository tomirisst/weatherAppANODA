//
//  ContentView.swift
//  Weather
//
//  Created by Tomiris Sayat on 22.02.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longtitude: location.longitude)
                            } catch {
                                print("Error getting weather data: \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    IntroView()
                        .environmentObject(locationManager)
                }
            }
            
            
        }
        .background(Image("backPhoto")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
