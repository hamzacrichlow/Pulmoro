//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/2/25.
//

import SwiftUI

struct OxygenIndexCalculator: View {
   
    @State private var FiO₂: Double = 0
    @State private var MAP: Double = 0
    @State private var PaO₂: Double = 0
    
    @State private var OI: Double? = nil
    @State private var PFRatio: Double? = nil
    
    var isFormValid: Bool {
         FiO₂ > 0.00 && MAP > 0.00 && PaO₂ > 0.00
    }
    var body: some View {
        
        ScrollView{
        
            VStack{
                
                GroupBox(label: Label("Oxygen Index Calculator", systemImage: "lungs.fill")){
                    VStack{
                        CalculatorInstructions(instructions: "Enter the patient's FiO₂, MAP, and PaO₂ to calculate the oxygenation index (OI).")
                            .padding(.bottom, 15)
                            .padding(.top, -15)
                        InputField(label: "FiO₂", units: "%", value: $FiO₂)
                        InputField(label: "MAP", units: "cmH2O", value: $MAP)
                        InputField(label: "PaO₂", units: "mmHg", value: $PaO₂)
                        
                        Button(action: {
                            OI = calculateOI(MAP: MAP, FiO₂: FiO₂, PaO₂: PaO₂)
                            PFRatio = calculatePFRatio(PaO2: PaO₂, FiO2: FiO₂)
                        },
                               label: {
                            Text("Calculate")
                        })
                        .buttonStyle(CustomButtonStyle())
                        .disabled(!isFormValid)
                        if let OI = OI, let PFRatio = PFRatio {
                            
                            Text("OI : \(Int(OI))")
                                .font(.system(size: 30, weight: .bold))
                                .transition(.scale)
                                .animation(.easeInOut(duration: 0.5), value: OI)
                            Text("PF Ratio : \(Int(PFRatio))")
                                .font(.caption)
                                .transition(.scale)
                                .animation(.easeInOut(duration: 0.5), value: OI)
                        }
                    }
                }
                .customGroupBoxStyle()
                
                
                ImportantInfoBox(ImportantInformation: """
                                 Oxygenation Index is an important clinical measure used to assess the severity of hypoxemia and the effectiveness of oxygen therapy, especially in critically ill patients. It provides a numerical value that helps clinicians evaluate the need for more intensive respiratory support, like mechanical ventilation or extracorporeal membrane oxygenation (ECMO).
                                 
                                 OI < 20: Normal
                                 
                                 OI > 30: ALIModerate hypoxemia (requires close monitoring and possible therapeutic interventions).
                                 
                                 OI > 40: ARDS, Severe hypoxemia (indicates a critical situation with potential need for mechanical ventilation or ECMO)
                                 """, infopage: OxygenIndexInformationPage())
            }
        } .applyCalculationToolBar(title: "Oxygen Index", destination: InfoButtonView())
    }
}

#Preview {
    OxygenIndexCalculator()
}

