//
//  PateintCare.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 4/21/25.
//

import SwiftUI

struct PatientCare: View {
    
    var body: some View {
        NavigationStack{
        ZStack{
            MovingGradientView(colors: [
                Color(.cyan).opacity(0.1),
                Color(.cyan).opacity(0.2),
                Color(.cyan).opacity(0.1)
            ])
                .ignoresSafeArea(.all)
            
            ScrollView{
                
                ClickableGroupBox(title: "Care Plan",
                                  icon: "cross.fill",
                                  destination: CarePlan(),
                                  description:
                                    "Generate a comprehensive ventilator management plan tailored to your patient."
                )
                
                ClickableGroupBox(title: "ABG Analysis",
                                  icon: "syringe.fill",
                                  destination: ABGAnalysis(),
                                  description:
                                    "Interpret your patient's arterial blood gas results and receive treatment recommendations."
                )
            }
        }
        .navigationTitle("Patient Care")
    }
       
    }
}

#Preview {
    PatientCare()
}
