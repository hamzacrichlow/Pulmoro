//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/2/25.
//

import SwiftUI

struct OxygenContentCalculator: View {
    
    @State private var Hb: Double = 0
    @State private var SaO2: Double = 0
    @State private var PaO2: Double = 0
    @State private var SvO2: Double = 0
    @State private var PvO2: Double = 0
    
    @State private var VenousOrArterial: String = ""
    @State private var CaO2: Double? = nil
    @State private var CvO2: Double? = nil
    @State private var CavO2: Double? = nil
    
    var body: some View {
        ScrollView{
            VStack{
                GroupBox(label: Label("Total Oxygen Content Calculator", systemImage: "lungs.fill")){
                    VStack{
                        CalculatorInstructions(instructions:"""
                Select one of the following options: arterial oxygen content (CaO₂), venous oxygen content (CvO₂), or arteriovenous oxygen content difference (C(a-v)O₂)
                """)
                        
                        Picker("Venous or Arterial", selection: $VenousOrArterial){
                            Text("CaO₂").tag("CaO2")
                            Text("CvO₂").tag("CvO2")
                            Text("C(a-v)O₂").tag("C(a-v)O₂")
                        }
                        .customSegmentedPickerStyle()
                        
                        if VenousOrArterial == "CaO2" {
                            CalculatorInstructions(instructions: "Input the patient's hemoglobin (Hb), SaO₂, and PaO₂ to receive the total content of arterial oxygen.")
                             
                            InputField(label: "Hb", units: "g/dL", value: $Hb)
                            InputField(label: "SaO₂", units: "%", value: $SaO2)
                            InputField(label: "PaO₂", units: "mmHg", value: $PaO2)
                        }
                        if VenousOrArterial == "CvO2" {
                            CalculatorInstructions(instructions: "Input the patient's hemoglobin (Hb), SvO₂, and PvO₂ to receive the total content of venous oxygen.")
                             
                            InputField(label: "Hb", units: "g/dL", value: $Hb)
                            InputField(label: "SvO₂", units: "%", value: $SvO2)
                            InputField(label: "PvO₂", units: "mmHg", value: $PvO2)
                            
                        }
                        if VenousOrArterial == "C(a-v)O₂" {
                            CalculatorInstructions(instructions: "Input the patient's hemoglobin (Hb).")
                                .padding(.bottom, -5)
                            HStack{
                                InputField(label: "Hb", units: "g/dL", value: $Hb)
                                Spacer()
                            }
                            CalculatorInstructions(instructions: "Input the patient's SaO₂, SvO₂, PaO₂, and PvO₂ to receive the arteriovenous oxygen content difference.")
                                .padding(.top, -10)
                                .padding(.bottom, -5)
                            HStack{
                                InputField(label: "SaO₂", units: "%", value: $SaO2)
                                InputField(label: "SvO₂", units: "%", value: $SvO2)
                            }
                            HStack{
                                InputField(label: "PaO₂", units: "mmHg", value: $PaO2)
                                InputField(label: "PvO₂", units: "mmHg", value: $PvO2)
                            }
                        }
                     
                        Button(action: {
                             if VenousOrArterial == "CaO2" {
                                CaO2 = calculateContentOfO2(Hb: Hb, SaO₂: SaO2, PaO₂: PaO2)
                            } else if VenousOrArterial == "CvO2" {
                                CvO2 = calculateContentOfO2(Hb: Hb, SaO₂: SvO2, PaO₂: PvO2)
                            } else if VenousOrArterial == "C(a-v)O₂" {
                                CavO2 = calculateCavO₂(Hb: Hb, SaO₂: SaO2, PaO₂: PaO2, SvO₂: SvO2, PvO₂: PvO2)
                            }
                        },
                               label: {
                            Text("Calculate")
                        })
                        .buttonStyle(CustomButtonStyle())
                        if VenousOrArterial == "CaO2", let CaO2 = CaO2 {
                            AnswerView(value: CaO2, unit: "VOL%")
                            Text("Normal CaO₂ is 18-20 vol%")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        if VenousOrArterial == "CvO2",let CvO2 = CvO2 {
                            AnswerView(value: CvO2, unit: "VOL%")
                            Text("Normal CvO₂ is 12 - 15 vol%")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        if VenousOrArterial == "C(a-v)O₂",let CavO2 = CavO2 {
                            AnswerView(value: CavO2, unit: "VOL%")
                            Text("Normal C(a-v)O₂ is 4 - 5 vol%")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .customGroupBoxStyle()
                
                ImportantInfoBox(ImportantInformation: """
                                 Total oxygen content determines whether the blood has sufficient oxygen-carrying capacity to adequately oxygenate tissues.

                                 Hemoglobin is the primary transporter of oxygen in the blood, binding approximately 98% of the oxygen. The oxygen content of arterial blood is influenced by factors such as hemoglobin concentration, arterial oxygen tension (PaO₂), and the oxygen saturation of hemoglobin (SaO₂). A proper balance between oxygen delivery and tissue demand is crucial for maintaining normal organ function and overall homeostasis.
                                 """, infopage: OxygenContentInformationPage())
            }
        }
        .applyCalculationToolBar(title: "Oxygen Content", destination: InfoButtonView())
    }
}

#Preview {
    OxygenContentCalculator()
}

