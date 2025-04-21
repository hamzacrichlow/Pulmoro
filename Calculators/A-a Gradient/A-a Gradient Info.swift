//
//  SwiftUIView.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 1/31/25.
//

import SwiftUI

struct AaGradientInformation: View {
    var body: some View {
        ScrollView{
            VStack{
        AaGradientCalculationInformation()
        AaGradientCalculationCaseStudy()
            }
        }
        .applyCalculationToolBar(title: "A-a Gradient", destination: InfoButtonView())
    }
}

#Preview {
    AaGradientInformation()
}
