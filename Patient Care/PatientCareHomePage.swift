//
//  PateintCare.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 4/21/25.
//

import SwiftUI

struct PatientCareHomePage: View {
    
    var body: some View {
        NavigationStack{
            ScrollView{
                NavigationBox(destination: CarePlan(),
                              systemImage: "cross.fill",
                              title: "Create a Care Plan",
                              description: "Generate a comprehensive ventilator management plan tailored to your patient.")
                    
                    NavigationBox(destination: ABGAnalysis(),
                                  systemImage:"syringe.fill",
                                  title: "ABG Analysis",
                                  description: "Interpret your patient's arterial blood gas results and receive treatment recommendations."
                    )
        }
            .navigationTitle("Patient Care")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    InfoButtonView(destination: Sources())
                }
            }
    }
    }
}

#Preview {
    PatientCareHomePage()
}

