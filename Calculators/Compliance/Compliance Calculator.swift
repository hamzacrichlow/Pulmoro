//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/3/25.
//

import SwiftUI

struct ComplianceCalculator: View {
    
    @State private var VT: Double = 0
    @State private var Pplat: Double = 0
    @State private var PIP: Double = 0
    @State private var PEEP: Double = 0
    
    @State private var Cdyn: Double? = nil
    @State private var Cstat: Double? = nil
    @State private var drivingPressure: Double? = nil
    
    @State private var complianceType: String = ""
    
    var isFormValid: Bool {
        if complianceType == "Static" {
            return VT > 0.00 && Pplat > 0.00 && PEEP > 0.00
        } else {
            return VT > 0.00 && PIP > 0.00 && PEEP > 0.00
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                GroupBox(label: Label("Compliance Calculator", systemImage: "lungs.fill")){
                    VStack{
                        CalculatorInstructions(instructions: "Select static compliance (Cstat) or dynamic compliance (Cdyn).")
                          
                        Picker("Compliance Type", selection: $complianceType) {
                            Text("Cstat").tag("Static")
                            Text("Cdyn").tag("Dynamic")
                        }
                        .customSegmentedPickerStyle()
                        
                        if complianceType == "Static" {
                            CalculatorInstructions(instructions: "Enter the patient's tidal volume (VT), plateau pressure (Pplat), and positive end expiratory pressure (PEEP).")
                              
                            InputField(label: "VT", units: "mL", value: $VT)
                            InputField(label: "Pplat", units: "cmH₂0", value: $Pplat)
                            InputField(label: "PEEP", units: "cmH₂0", value: $PEEP)
                        }
                        if complianceType == "Dynamic" {
                            CalculatorInstructions(instructions: "Enter the patient's tidal volume (VT), peak inspiratory pressure (PIP), and positive end expiratory pressure (PEEP).")
                               
                            InputField(label: "VT", units: "mL", value: $VT)
                            InputField(label: "PIP", units: "cmH₂0", value: $PIP)
                            InputField(label: "PEEP", units: "cmH₂0", value: $PEEP)
                        }
                        Button(action: {
                            
                            Cstat = nil
                            Cdyn = nil
                            
                            if complianceType == "Dynamic" {
                                Cdyn=calculateCdyn(VT: VT, PIP: PIP, PEEP: PEEP)
                            } else if complianceType == "Static" {
                                Cstat=calculateCstat(VT: VT, Pplat: Pplat, PEEP: PEEP)
                            }
                            drivingPressure=calculateDrivingPressure(PIP: PIP, PEEP: PEEP)
                        },
                               label: {
                            Text("Calculate")
                        })
                        .buttonStyle(CustomButtonStyle())
                        .disabled(!isFormValid)
                       
                        
                        
                        if let Cstat = Cstat {
                            
                            Text("\(Int(Cstat)) mL/cmH₂O")
                                .font(.system(size: 20, weight: .bold))
                              
               
                                .padding(.top, -10)
                                .padding()
                            Text("Normal Cstat range is 50 - 100 mL/cmH₂O")
                                .font(.caption)
                                .padding(.top, -20)
                                
                        
                        }
                        if let Cdyn = Cdyn {
                            Text("\(Int(Cdyn)) mL/cmH₂O")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.top, -10)
                                .padding()
                            Text("Normal Cdyn range is 100 - 200 mL/cmH₂O")
                                .font(.caption)
                                .padding(.top, -20)
                                
                        }

                    }
                }
                .customGroupBoxStyle()
                
                ImportantInfoBox(ImportantInformation: """
Compliance refers to the lung's ability to expand and contract with each breath.

Static compliance measures the lung's ability to expand at rest, while dynamic compliance provides insight into airway resistance during breathing.

A higher lung compliance means it's easier for the lungs to expand. Conditions like emphysema increase compliance because the lung loses elasticity and cannot recoil properly, which can lead to air trapping.

Lower lung compliance means the lungs are stiffer, requiring more effort to expand. This makes lung inflation more difficult, as seen in conditions like ARDS.
""", infopage: ComplianceInformationPage())
            }
        }
        .applyCalculationToolBar(title: "Compliance", destination: InfoButtonView())
    }
}


#Preview {
    ComplianceCalculator()
}
