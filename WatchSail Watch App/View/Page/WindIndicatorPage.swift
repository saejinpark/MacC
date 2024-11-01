//
//  WindIndicatorPage.swift
//  WatchSail Watch App
//
//  Created by 박세진 on 10/31/24.
//

import SwiftUI

struct WindIndicatorPage: View {
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var weatherManager = WeatherManager.shared
    @ObservedObject var phoneHeadingReceiver = PhoneHeadingReceiver.shared
    
    @State private var windOffset = 0.0
    
    var body: some View {
        VStack {
            WindIndicator(
                course: locationManager.lastLocation?.course ?? 0.0,
                compassDegree: locationManager.heading?.trueHeading ?? 0.0,
                windOffset: windOffset,
                trueWindDegree: weatherManager.trueWind?.direction ?? 0.0,
                apparentWindDegree: weatherManager.apparentWind?.direction ?? 0.0,
                boomAngle: phoneHeadingReceiver.heading.isNaN ? 0.0 : phoneHeadingReceiver.heading.truncatingRemainder(dividingBy: 360.0)
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WindIndicatorPage()
}
