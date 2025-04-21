//
//  Anion Gap Calculator.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 4/3/25.
//

import SwiftUI

struct AnionGapCalculator: View {
    
    @State private var Cl: Double = 0
    @State private var K: Double = 0
    @State private var Na: Double = 0
    @State private var HCO3: Double = 0
    
    @State private var anionGap: Double? = nil
    

    var body: some View {
        
        ScrollView{
            
            VStack {
                GroupBox(label: Label("Anion Gap Calculator", systemImage: "lungs.fill")){
                    VStack{
                        
                        CalculatorInstructions(instructions: "Enter the patient's Na, K, Cl, and HCO3 to calculate the anion gap.")
                        HStack{
                        VStack{
                            InputField(label: "Na +", units: "mEq/L", value: $Na)
                            InputField(label: "K +", units: "mEq/L", value: $K)
                        }
                        VStack{
                            InputField(label: "Cl -", units: "mEq/L", value: $Cl)
                            InputField(label: "HCO3 -", units: "mEq/L", value: $HCO3)
                        }
                    }
                        Button(action: {
                            anionGap = calculateAnionGap(Na: Na, K: K, Cl: Cl, HCO3: HCO3)
                        },
                               label: {
                            Text("Calculate")
                        })
                        .buttonStyle(CustomButtonStyle())
//                        .disabled(!isFormValid)
//                        .disabled(!isFormValid)
                        if let anionGap = anionGap {
                            AnswerView(value: anionGap, unit: "mEq/L")
                        }
                    }
                }
                .customGroupBoxStyle()
               
                
                ImportantInfoBox(ImportantInformation: ("""
                            The anion gap is a calculation used to assess the balance of electrolytes in the blood, specifically the difference between positively and negatively charged electrolytes.
                            
                            The normal anion gap range can vary slightly but it's generally considered to be around 8-12 mEq/L
                            
                            Elevated Anion Gap: May indicate metabolic acidosis, where the blood is too acidic.
                            
                            Low Anion Gap: May indicate certain conditions, such as hyperchloremia (high chloride levels). 
                            """),
                    infopage: TidalVolumeInformationPage())
            }
        }
        .applyCalculationToolBar(title: "Anion Gap", destination: InfoButtonView())
    }
    
}

#Preview {
    AnionGapCalculator()
}

func calculateAnionGap(Na: Double, K: Double, Cl: Double, HCO3: Double) -> Double {
   return (Na + K) - (Cl + HCO3)
}
