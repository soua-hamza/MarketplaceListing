//
//  AdView.swift
//  MarketplaceListing
//
//  Created by Hamza on 18/12/2024.
//

import CoreLocation
import SwiftUI

struct AdView: View {
    let item: Item
    let location: CLLocation?

    var body: some View {
        VStack {
            if let stringUrl = item.pictures.first?.squares64 {
                AsyncImage(url: URL(string: stringUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                }
                placeholder: {
                    Image("")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            ProgressView()
                        }
                }
                HStack {
                    Text(item.title)
                        .bold()
                        .lineLimit(2)
                        .foregroundStyle(.black)
                    Spacer()
                }.padding(.trailing, 5)
                    .padding(.leading, 5)
                Spacer(minLength: 30)
                HStack {
                    if let location = location {
                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(calculateTime(from: location, to: CLLocation(latitude: item.location.latitude, longitude: item.location.longitude)))
                            .foregroundStyle(.black)
                            .font(.system(size: 10))
                    }
                    Spacer()
                    if let location = location {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(calculateDistance(from: location, to: CLLocation(latitude: item.location.latitude, longitude: item.location.longitude)))
                            .foregroundStyle(.black)
                            .font(.system(size: 10))
                    }
                }.padding(.trailing, 5)
                    .padding(.leading, 5)
                    .padding(.bottom, 5)
            }
        }
        .background(.white)
        .cornerRadius(15)
    }

    func calculateDistance(from currentLocation: CLLocation, to destination: CLLocation) -> String {
        let distance = currentLocation.distance(from: destination) // Distance in meters
        let distanceInKilometers = distance / 1000.0
        return String(format: "%.2f km", distanceInKilometers)
    }

    func calculateTime(from currentLocation: CLLocation, to destination: CLLocation) -> String {
        let speed = 13.9 // Average driving speed in m/s
        let distance = currentLocation.distance(from: destination) // Distance in meters
        let time = distance / speed // Time in seconds
        return formatTimeInterval(time)
    }

    func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let totalMinutes = Int(timeInterval) / 60
        let minutes = totalMinutes % 60
        let hours = totalMinutes / 60 % 24
        let days = totalMinutes / 1440 // 1440 = 60 * 24 (minutes in a day)

        var components: [String] = []

        if days > 0 {
            components.append("\(days) day\(days > 1 ? "s" : "")")
        }
        if hours > 0 {
            components.append("\(hours) hr\(hours > 1 ? "s" : "")")
        }
        if minutes > 0 || components.isEmpty { // Include minutes if they exist or it's the only component
            components.append("\(minutes) min")
        }

        return components.joined(separator: " ")
    }
}
