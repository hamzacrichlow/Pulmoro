//
//  SwiftUIView.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 2/1/25.
//

import SwiftUI

///The Desired CO2 Calculator and Important Information View
struct DesiredCO2Calculator: View {
    
    //All the inputs for this calculator
    @State private var RR: Double = 0
    @State private var VT: Double = 0
    @State private var VE: Double = 0
    @State private var PaCO₂: Double = 0
    @State private var DesiredPaCO₂: Double = 0
    
    //All the possible outputs for this calculator
    @State private var newRR: Double? = nil
    @State private var newVT: Double? = nil
    @State private var newVE: Double? = nil
    
    //Picker for which vent setting they would like to change
    @State private var VentSetting: String = ""
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                //Desired CO2 Calculator Group Box
                GroupBox(label: Label("Desired PaCO₂ Calculator", systemImage: "lungs.fill")){
                    VStack{
                        CalculatorInstructions(instructions: "Select the ventilation setting you wish to adjust in order to achieve the desired PaCO₂ level.")
                        Picker("Vent Setting", selection: $VentSetting ){
                            Text("RR").tag("RR")
                            Text("VT").tag("VT")
                            Text("VE").tag("VE")
                        }
                        .customSegmentedPickerStyle()
                        
                        if VentSetting == "RR" {
                            VStack{
                                CalculatorInstructions(instructions: "Input the patient's respiratory rate (RR), current PaCO₂, and the desired PaCO₂ to to calculate the required RR adjustment.")
                                    .padding(.bottom, -10)
                                BiggerInputField(label: "RR", units: "b/min", value: $RR)
                                BiggerInputField(label: "PaCO₂", units: "mmHg", value: $PaCO₂)
                                BiggerInputField(label: "Desired CO₂", units: "mmHg", value: $DesiredPaCO₂)
                            }
                        }
                        if VentSetting == "VT" {
                            VStack{
                                CalculatorInstructions(instructions: "Input the patient's tidal volume (VT), current PaCO₂, and the desired PaCO₂ to to calculate the required VT adjustment.")
                                    .padding(.bottom, -10)
                                BiggerInputField(label: "VT", units: "mL", value: $VT)
                                BiggerInputField(label: "PaCO₂", units: "mmHg", value: $PaCO₂)
                                BiggerInputField(label: "Desired CO₂", units: "mmHg", value: $DesiredPaCO₂)
                            }
                        }
                        if VentSetting == "VE" {
                            VStack{
                                CalculatorInstructions(instructions: "Input the patient's minute ventilation (VE), current PaCO₂, and the desired PaCO₂ to calculate the required VE.")
                                    .padding(.bottom, -10)
                                BiggerInputField(label: "VE", units: "L/min", value: $VE)
                                BiggerInputField(label: "PaCO₂", units: "mmHg", value: $PaCO₂)
                                BiggerInputField(label: "Desired CO₂", units: "mmHg", value: $DesiredPaCO₂)
                            }
                        }
                        
                        //Functions applied to this button
                        Button(action: {
                            
                            if VentSetting == "RR" {
                                newRR = calculateNewRR(RR: RR, PaCO₂: PaCO₂, DesiredPaCO₂: DesiredPaCO₂)
                            } else if VentSetting == "VT" {
                                newVT = calculateNewVT(VT: VT, PaCO₂: PaCO₂, DesiredPaCO₂: DesiredPaCO₂)
                            } else if VentSetting == "VE" {
                                newVE = calculateNewVE(VE: VE, PaCO₂: PaCO₂, DesiredPaCO₂: DesiredPaCO₂)
                            }
                        },
                               label: {Text("Calculate")})
                        .buttonStyle(CustomButtonStyle())
                        
                        if VentSetting == "RR", let newRR = newRR {
                            AnswerView(value: newRR, unit: "b/min")
                                .padding(5)
                            Text("Set the RR to \(Int(newRR)) b/min to attain a PaCO₂ of \(Int(DesiredPaCO₂)) mmHg")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .transition(.scale)
                                .animation(.easeInOut(duration: 0.5), value: DesiredPaCO₂)
                                .padding(5)
                        }
                        else if VentSetting == "VT", let newVT = newVT {
                            AnswerView(value: newVT, unit: "mL")
                                .padding(5)
                            Text("Set the VT to \(Int(newVT)) mL to attain a PaCO₂ of \(Int(DesiredPaCO₂)) mmHg")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .transition(.scale)
                                .animation(.easeInOut(duration: 0.5), value: DesiredPaCO₂)
                                .padding(5)
                        }
                        else if VentSetting == "VE", let newVE = newVE {
                            AnswerView(value: newVE, unit: "L/min")
                                .padding(5)
                            Text("Change VE to \(Int(newVE)) L/min to acquire a PaCO₂ of \(Int(DesiredPaCO₂)) mmHg")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .transition(.scale)
                                .animation(.easeInOut(duration: 0.5), value: DesiredPaCO₂)
                                .padding(5)
                        }
                    }
                }
                .customGroupBoxStyle()
               
                ImportantInfoBox(ImportantInformation: """
                                 Normal PaCO₂ typically ranges from 35 mmHg to 45 mmHg in most patients.
                                 
                                 In respiratory alkalosis, or respiratory acidosis, adjusting the patient’s RR, VT, or VE can help restore PaCO₂ balance and improve pH.
                                 
                                 To manage respiratory acidosis, increasing RR, VT, or VE helps expel excess CO₂. Conversely, to correct respiratory alkalosis, reducing RR, VT, or VE aides in retaining CO₂, ultimately working to normalize the patient’s pH.
                                 """, infopage: DesiredCO2InformationPage())
            }
        }
        .applyCalculationToolBar(title: "Desired PaCO₂", destination: InfoButtonView(destination: Sources()))
    }
}

#Preview {
    DesiredCO2Calculator()
}
