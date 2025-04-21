//
//  TidalVolumeCalculationPage.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 12/23/24.
//

import SwiftUI

struct TidalVolumeInformationPage: View {
    
    var body: some View {
        
        ScrollView{
            VStack{
                TidalVolumeCalculationInformation()
                TidalVolumeCaseStudy()
            }
        }
        .applyCalculationToolBar(title: "Tidal Volume", destination: InfoButtonView())
    }
}

#Preview {
    TidalVolumeInformationPage()
}



