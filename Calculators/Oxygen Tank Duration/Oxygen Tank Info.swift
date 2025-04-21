//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/1/25.
//

import SwiftUI

struct OxygenTankDurationInformationPage: View {
    var body: some View {
        ScrollView{
            VStack{
                                OxygenTankInformation()
                                OxygenTankCaseStudy()
            }
        }
        .applyCalculationToolBar(title: "Oxygen Tank Duration", destination: InfoButtonView())
    }
}

#Preview {
    OxygenTankDurationInformationPage()
}
