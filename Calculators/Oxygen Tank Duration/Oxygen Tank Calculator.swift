//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/1/25.
//

import SwiftUI

struct OxygenTankDurationCalculator: View {
    @State private var cylinderSize: String  = ""
    @State private var cylinderFactor: Double = 0
    @State private var pressure: Double  = 0
    @State private var flow: Double = 0
    
    @State private var duration: Double? = nil
    
    var isFormValid: Bool {
            return pressure > 0.00 && flow > 0.00
    }
    
    var body: some View {
        

        ScrollView{
            
            VStack{
                GroupBox(label: Label("Oxygen Tank Duration Calculator", systemImage: "")){
                    VStack{
                        
                        CalculatorInstructions(instructions: "Select the size of the oxygen cylinder.")
                      
                        Picker("Cylinder Size", selection: $cylinderSize ){
                            Text("H").tag("H")
                            Text("G").tag("G")
                            Text("D").tag("D")
                            Text("E").tag("E")
                        }
                        .customSegmentedPickerStyle()
                       
                        CalculatorInstructions(instructions: "Enter the current pressure in the oxygen tank and the set flow rate to calculate the remaining time left in the tank.")
                           
                        
                        InputField(label: "Pressure", units: "psi", value: $pressure)
                        InputField(label: "Flow", units: "L/min", value: $flow)
                        
                        Button(action: {
                            
                            switch cylinderSize {
                            case "H":
                                cylinderFactor = 3.14
                            case "G":
                                cylinderFactor = 2.41
                            case "D":
                                cylinderFactor = 0.16
                            case "E":
                                cylinderFactor = 0.28
                            default:
                                cylinderFactor = 0.0
                            }
                            duration = calculateO2TankDuration(cylinderFactor: cylinderFactor, pressure: pressure, flow: flow)
                        },
                               label: {
                            Text("Calculate")
                        })
                        .buttonStyle(CustomButtonStyle())
                        .disabled(!isFormValid)
                        if let duration = duration {
                            
                            AnswerView(value: duration, unit: "min")
                        }
                    }
                }
                .customGroupBoxStyle()
                
                ImportantInfoBox(ImportantInformation: """
Keep cylinders upright and secured to prevent tipping. Use appropriate stands or brackets to stabilize the tanks.

Before transport, verify that all connections are secure. Continuously monitor the patient's oxygen saturation levels and adjust the flow rate as needed to maintain appropriate oxygenation.

Carry a backup oxygen source and be prepared to manage any equipment malfunctions or changes in the patient's condition during transport.
""", infopage: OxygenTankDurationInformationPage())
            }
            
        }.applyCalculationToolBar(title: "Oxygen Tank Duration", destination: InfoButtonView())
    }
}

#Preview {
    OxygenTankDurationCalculator()
}

