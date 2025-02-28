//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/3/25.
//

import SwiftUI

struct ComplianceInformationPage: View {
    var body: some View {
        ScrollView{
            VStack{
                ComplianceCalculationInformation()
                ComplianceCaseStudy()
                
            }
        }
        .applyCalculationToolBar(title: "Compliance", destination: InfoButtonView())
    }
}


#Preview {
    ComplianceInformationPage()
}
