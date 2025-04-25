//
//  PFRatio.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 4/3/25.
//

import SwiftUI

struct PFRatioCalculator: View {
    
    @State private var PaO2: Double = 0
    @State private var FiO2: Double = 0
  
    
    @State private var PFRatio: Double? = nil
    

    var body: some View {
        
        ScrollView{
            
            VStack {
                GroupBox(label: Label("PaO₂/FiO₂ Ratio Calculator", systemImage: "lungs.fill")){
                    VStack{
                        
                        CalculatorInstructions(instructions: "Enter the patient's PaO₂ and FiO₂ to calculate the PaO₂/FiO₂ Ratio.")
                   
                        HStack{
                            InputField(label: "PaO₂", units: "mEq/L", value: $PaO2)
                            InputField(label: "FiO₂", units: "mEq/L", value: $FiO2)
                        }
                        
                    
                        Button(action: {
                            PFRatio = calculatePFRatio(PaO2: PaO2, FiO2: FiO2)
                        },
                               label: {
                            Text("Calculate")
                        })
                        .buttonStyle(CustomButtonStyle())
//                        .disabled(!isFormValid)
//                        .disabled(!isFormValid)
                        if let PFRatio = PFRatio {
                            AnswerView(value: PFRatio, unit: "mEq/L")
                        }
                    }
                }
                .customGroupBoxStyle()
               
                
                ImportantInfoBox(ImportantInformation: ("""
                            Measurement to asses how severe someoens respiratoy staatus is. Normal PaO2 is 80-100 mmHg and  
                            
                            The lower the number the worse the respiratory status they are going into ards
                            
                            <300 is ARDS
                            <200 is Moderate
                            < 100 severe
                            """),
                    infopage: TidalVolumeInformationPage())
            }
        }
        .applyCalculationToolBar(title: "P/F Ratio", destination: InfoButtonView())
    }
    
}

#Preview {
    PFRatioCalculator()
}

func calculatePFRatio(PaO2: Double, FiO2: Double)-> Double {
    PaO2 / (FiO2/100)
}
