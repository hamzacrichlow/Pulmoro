//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/2/25.
//

import SwiftUI

struct OxygenContentInformationPage: View {
    var body: some View {
        ScrollView{
            VStack{
                                OxygenContentInformation()
                                OxygenContentCaseStudy()
            }
        }
        .applyCalculationToolBar(title: "Oxygen Content", destination: InfoButtonView())
    }
}
#Preview {
    OxygenContentInformationPage()
}
