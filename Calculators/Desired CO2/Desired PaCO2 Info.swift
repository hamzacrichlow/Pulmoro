//
//  SwiftUIView.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 2/1/25.
//

import SwiftUI

struct DesiredCO2InformationPage: View {
    var body: some View {
        ScrollView{
            VStack{
                DesiredCO2CalculationInformation()
              DesireCO2CalculationCaseStudy()
            }
        }
        .applyCalculationToolBar(title: "Desired PaCO₂", destination: InfoButtonView(destination: Sources()))
    }
}
#Preview {
    DesiredCO2InformationPage()
}
