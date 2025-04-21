//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/2/25.
//

import SwiftUI

struct OxygenIndexInformationPage: View {
    var body: some View {
        ScrollView{
            VStack{
                                OxygenIndexInformation()
                                OxygenIndexCaseStudy()
            }
        }
        .applyCalculationToolBar(title: "Oxygen Index", destination: InfoButtonView())
    }
}


#Preview {
    OxygenIndexInformationPage()
}
