//
//  Calculations.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 3/8/25.
//

import SwiftUI

struct RespiratoryCalculations : Hashable {
    let name: String
}

struct EcmoCalculations: Hashable {
    let name: String
}
struct Calculations: View {
    
    
    var calculationsList: [RespiratoryCalculations] = [
        .init(name: "A-a Gradient") ,
        .init(name: "Anion Gap"),
        .init(name: "Compliance"),
        .init(name: "Desired PaCO₂"),
        .init(name: "Extubation Readiness"),
        .init(name: "Fick Calculation"),
        .init(name: "Oxygen Content") ,
        .init(name: "Oxygen Index"),
        .init(name: "Oxygen Tank Duration") ,
        .init(name: "P/F Ratio"),
        .init(name: "Pack Years"),
        .init(name: "Tidal Volume"),
        .init(name: "Weaning Readiness")
    ]
    
    var ecmoCalculationsList: [EcmoCalculations] = [
        .init(name: "Cardiovascular Calculators"),
        .init(name: "Recirculation Formula"),
        .init(name: "ECMO Flow Calculator"),
        .init(name: "Sweep Gas Management"),
        .init(name: "Oxygneation Performance"),
    ]
    
    var body: some View {
        
        NavigationStack{
            
            List{
                Section("Respiratory") {
                    ForEach(calculationsList, id: \.name) { calculation in
                        NavigationLink(value: calculation) {
                            Text(calculation.name)
                        }
                    }
                }
                Section("Extracorporeal Membrane Oxygenation") {
                    ForEach(ecmoCalculationsList, id: \.name) { calculation in
                        NavigationLink(value: calculation) {
                            Text(calculation.name)
                        }
                    }

                }
            }
            .navigationTitle("Calculators")
            .navigationDestination(for: RespiratoryCalculations.self) { calculation in
                switch calculation.name {
                case "A-a Gradient":
                    AaGradientCalculator.init()
                case "Compliance":
                    ComplianceCalculator.init()
                case "Desired PaCO₂":
                    DesiredCO2Calculator.init()
                case "Oxygen Content":
                    OxygenContentCalculator.init()
                case "Oxygen Index":
                    OxygenIndexCalculator.init()
                case "Oxygen Tank Duration":
                    OxygenTankDurationCalculator.init()
                case "Tidal Volume":
                    TidalVolumeCalculation.init()
                default:
                    Text("Coming Soon!")
                }
            }
            .navigationDestination(for: EcmoCalculations.self) { calculation in
                switch calculation.name {
                case "A-a Gradient":
                    AaGradientCalculator.init()
                default:
                    Text("Coming Soon!")
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    InfoButtonView()
                }
            }
            
        }
        
    }
}


#Preview {
    Calculations()
}




