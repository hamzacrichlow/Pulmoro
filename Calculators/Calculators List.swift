//
//  Calculators List.swift
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
    
    @State private var gradientColors: [Color] = [
        Color(.cyan).opacity(0.1),
        Color(.cyan).opacity(0.2),
        Color(.cyan).opacity(0.1)
    ]
    
    var calculationsList: [RespiratoryCalculations] = [
        .init(name: "A-a Gradient") ,
        .init(name: "Anion Gap"),
        .init(name: "Compliance"),
        .init(name: "Desired PaCO₂"),
        .init(name: "Oxygen Content") ,
        .init(name: "Oxygen Index"),
        .init(name: "Oxygen Tank Duration") ,
        .init(name: "P/F Ratio"),
        .init(name: "Pack Years"),
        .init(name: "Tidal Volume"),
        .init(name: "Weaning Readiness")
    ]
    
    var ecmoCalculationsList: [EcmoCalculations] = [
        .init(name: "Fick Calculation"),
        .init(name: "Cardiovascular Calculators"),
        .init(name: "Recirculation Formula"),
        .init(name: "ECMO Flow Calculator"),
        .init(name: "Sweep Gas Management"),
        .init(name: "Oxygneation Performance"),
    ]
    
    var body: some View {
    
        NavigationStack{
          
            ZStack{
                MovingGradientView(colors: gradientColors)
                    .ignoresSafeArea(edges: .all)
          
//                    Text("Each calculator includes a comprehensive guide with detailed explanations, step-by-step instructions for real-world application, and practical case studies demonstrating clinical usage in the 'More Information' section.")
                       
                        .padding()
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
                        case "Anion Gap":
                            AnionGapCalculator.init()
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
                        case "P/F Ratio":
                            PFRatioCalculator.init()
                        case "Pack Years":
                            Pack_Years.init()
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
        
    }



#Preview {
    Calculations()
}




