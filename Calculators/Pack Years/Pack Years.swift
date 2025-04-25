//
//  Pack Years.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 4/3/25.
//

import SwiftUI

struct Pack_Years: View {
    
    @State private var pack: Double = 0
    @State private var years: Double = 0
  
    
    @State private var packYear: Double? = nil
    

    var body: some View {
        
        ScrollView{
            
            VStack {
                GroupBox(label: Label("Pack Years Calculator", systemImage: "lungs.fill")){
                    VStack{
                        
                        CalculatorInstructions(instructions: "Enter the amount of packs smoked by the patient per day, and the amopunt of years the patient smoked for.")
                   
                        HStack{
                            InputField(label: "Packs", units: "", value: $pack)
                            InputField(label: "Years", units: "", value: $years)
                        }
                        
                    
                        Button(action: {
                            packYear = calculatePackYear(Pack: pack, Year: years)
                        },
                               label: {
                            Text("Calculate")
                        })
                        .buttonStyle(CustomButtonStyle())
//                        .disabled(!isFormValid)
//                        .disabled(!isFormValid)
                        if let packYear = packYear {
                            
                            AnswerView(value: packYear, unit: "")
                            Text("pack years")
                                .font(.caption)
                        }
                    }
                }
                .customGroupBoxStyle()
               
                
                ImportantInfoBox(ImportantInformation: ("""
                            Low Exposure (< 10 pack years):

                            Lower risk but still significant
                            Some increase in respiratory symptoms
                            Modestly increased risk for lung diseases

                            Moderate Exposure (10-20 pack years):

                            Significantly increased risk for COPD
                            Higher risk for cardiovascular disease
                            Screening for lung cancer may be considered

                            Heavy Exposure (20-40 pack years):

                            High risk for COPD, emphysema
                            Substantially increased lung cancer risk
                            Annual low-dose CT screening recommended (for ages 50-80)
                            Higher risk for other smoking-related cancers

                            Very Heavy Exposure (> 40 pack years):

                            Severe risk for all smoking-related diseases
                            Very high likelihood of developing COPD if not already present
                            Highest risk category for lung cancer
                            Aggressive screening and monitoring recommended
                            """),
                    infopage: TidalVolumeInformationPage())
            }
        }
        .applyCalculationToolBar(title: "P/F Ratio", destination: InfoButtonView())
    }
    
}

#Preview {
    Pack_Years()
}

func calculatePackYear (Pack: Double, Year: Double)-> Double {
    Pack * Year
}
