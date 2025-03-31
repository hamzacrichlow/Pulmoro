//
//  SwiftUIView 3.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 12/13/24.
//

import SwiftUI

struct TidalVolumeCalculation: View {
    
    @State private var gender: String  = "Male"
    @State private var height: Int = 0
    @State private var mlPerKg: Int = 6
    @State private var tidalVolume: Double? = nil
    
    var isFormValid: Bool {
        height > 42
    }
    
    var body: some View {
        
        ScrollView{
            
            VStack {
                GroupBox(label: Label("Tidal Volume Calculator", systemImage: "lungs.fill")){
                    VStack{
                        
                        CalculatorInstructions(instructions: "Enter the patient's gender, height, and desired mL/kg to calculate the recommended tidal volume (VT).")
                           
                        genderPicker(gender: $gender)
                        heightPicker(height: $height)
                        mlPerKgPicker(mlPerKg: $mlPerKg)
                        
                        Button(action: {
                            let IBW = calculateIBW(
                                height: Double(height),
                                gender: gender
                            )
                            tidalVolume = calculateVT(
                                IBW: IBW,
                                mLPerKg:Double(mlPerKg)
                            )
                        },
                               label: {
                            Text("Calculate")
                        })
                        .buttonStyle(CustomButtonStyle())
                        .disabled(!isFormValid)
                        .disabled(!isFormValid)
                        if let tidalVolume = tidalVolume {
                            AnswerView(value: tidalVolume, unit: "mL")
                        }
                    }
                }
                .customGroupBoxStyle()
               
                
                ImportantInfoBox(ImportantInformation: ("""
                            Appropriate tidal volumes are set based on the patient's gender and ideal body weight.
                            
                            Ensure that the patient’s vital signs and ventilator parameters remain stable and within normal limits, after making vent changes.
                            
                            Ensure peak inspiratory pressures are within normal ranges and that the exhaled tidal volumes are within a ±50 mL of set tidal volume.
                            """),
                    infopage: TidalVolumeInformationPage())
            }
        }
        .applyCalculationToolBar(title: "Tidal Volume", destination: InfoButtonView())
    }
    
}
    
#Preview {
    TidalVolumeCalculation()
}





