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

struct Calculations: View {
    
    @State private var gradientColors: [Color] = [
        Color(.cyan).opacity(0.1),
        Color(.cyan).opacity(0.2),
        Color(.cyan).opacity(0.1)
    ]
    
    var calculationsList: [RespiratoryCalculations] = [
        .init(name: "A-a Gradient") ,
        .init(name: "Anion Gap"),
        .init(name: "Cardiac Index"),
        .init(name: "Compliance"),
        .init(name: "Dead Space Fraction"),
        .init(name: "Desired PaCO₂"),
        .init(name: "Ideal Body Weight"),
        .init(name: "Oxygen Content") ,
        .init(name: "Oxygen Delivery") ,
        .init(name: "Oxygen Index"),
        .init(name: "Oxygen Tank Duration") ,
        .init(name: "P/F Ratio"),
        .init(name: "Pack Years"),
        .init(name: "Rapid Shallow Breathing Index"),
        .init(name: "Tidal Volume"),
       
    ]
    
//    var ecmoCalculationsList: [EcmoCalculations] = [
//        .init(name: "Fick Calculation"),
//        .init(name: "Cardiovascular Calculators"),
//        .init(name: "Recirculation Formula"),
//        .init(name: "ECMO Flow Calculator"),
//        .init(name: "Sweep Gas Management"),
//        .init(name: "Oxygneation Performance"),
//    ]
    
    var body: some View {
    
        NavigationStack {
            ZStack {
        
                MovingGradientView(colors: gradientColors)
                    .ignoresSafeArea()

                // Content layer
                List {
                    ForEach(calculationsList, id: \.name) { calculation in
                        NavigationLink(value: calculation) {
                            Text(calculation.name)
                        }
                    }
                }
                .scrollContentBackground(.hidden) // 🔑 This hides default List background
                .background(Color.clear) // Optional for extra clarity
                .navigationTitle("Calculators")
                .navigationDestination(for: RespiratoryCalculations.self) { calculation in
                    switch calculation.name {
                        case "A-a Gradient": AaGradientCalculator()
                        case "Anion Gap": AnionGapCalculator()
                        case "Cardiac Index": CardiacIndexCalculator()
                        case "Compliance": ComplianceCalculator()
                        case "Dead Space Fraction": DeadSpaceCalculator()
                        case "Desired PaCO₂": DesiredCO2Calculator()
                        case "Ideal Body Weight": IBWCalculator()
                        case "Oxygen Content": OxygenContentCalculator()
                        case "Oxygen Delivery": OxygenDeliveryCalculator()
                        case "Oxygen Index": OxygenIndexCalculator()
                        case "Oxygen Tank Duration": OxygenTankDurationCalculator()
                        case "P/F Ratio": PFRatioCalculator()
                        case "Pack Years": Pack_Years()
                        case "Rapid Shallow Breathing Index": RSBiCalculator()
                        case "Tidal Volume": TidalVolumeCalculation()
                        default: Text("Coming Soon!")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        InfoButtonView(destination: CalculatorInformation())
                    }
                }
            }
        }

    }
        
    }



#Preview {
    Calculations()
}




/// The available input field sizes used to determine styling.
///
/// - standard: A regular-sized input field.
/// - large: A larger input field used for more prominent values.
enum InputSize {
    case standard
    case large
}

/// A model representing a calculator input field.
///
/// Use this structure to define input fields dynamically in your calculator views.
///
/// Example usage:
/// ```swift
/// CalculatorInput(label: "PaCO₂", units: "mmHg", binding: $paCO2, size: .standard)
/// ```
///
/// - Parameters:
///   - label: The text displayed above the input field.
///   - units: The unit displayed beside the input field value.
///   - binding: A SwiftUI `Binding<Double>` to connect to the value.
///   - size: The visual size of the input field, either `.standard` or `.large`.

struct CalculatorInput {
    let label: String
    let units: String
    let binding: Binding<Double>
    let size: InputSize
}

/// A reusable layout for building calculator-style views.
///
/// `CalculatorView` displays a title, instructions, input fields, a calculation button, a result view,
/// and an important information section. It can be used to quickly prototype and reuse calculator logic
/// without duplicating UI code.
///
/// - Parameters:
///   - title: The name of the calculator shown at the top.
///   - systemImage: A symbol name used in the `GroupBox` label.
///   - instructions: Brief description or directions shown above the inputs.
///   - inputs: An array of `CalculatorInput` used to render input fields dynamically.
///   - calculateAction: A closure triggered when the "Calculate" button is pressed.
///   - outputView: A custom SwiftUI view that displays the calculated result.
///   - info: A string shown in the `ImportantInfoBox`, offering medical guidance or explanation.
///   - infoPage: A destination view shown when users tap the info button.
struct CalculatorView<Output: View>: View {
    let title: String
    let systemImage: String
    let instructions: String
    let inputs: [CalculatorInput]
    let calculateAction: () -> Void
    let outputView: Output
    let info: String
    let infoPage: AnyView
    @State private var hapticTrigger = false
    @State private var gradientColors: [Color] = [
        Color(.cyan).opacity(0.1),
        Color(.cyan).opacity(0.2),
        Color(.cyan).opacity(0.1)
    ]
    
    
    var body: some View {
        ScrollView {
            VStack {
                GroupBox(label: Label(title, systemImage: systemImage)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                ) {
                    VStack {
                        CalculatorInstructions(instructions: instructions)
                            .lineLimit(4)
                            .minimumScaleFactor(0.1)
            
                        HStack {
                            VStack {
                                ForEach(inputs.prefix(inputs.count / 2), id: \.label) {
                                    inputField(for: $0)
                                }
                            }
                            VStack {
                                ForEach(inputs.suffix(inputs.count / 2), id: \.label) {
                                    inputField(for: $0)
                                }
                            }
                        }

                     
                        Button("Calculate") {
                            calculateAction()
//                            hapticTrigger.toggle()
                        }
                            .buttonStyle(CustomButtonStyle())
                           
                            .sensoryFeedback(.success, trigger:hapticTrigger)
                        

                    
                        outputView
                    }
                }
                .customGroupBoxStyle()

          
                ImportantInfoBox(ImportantInformation: info, infopage: infoPage)
            }
            
        }
        .applyCalculationToolBar(title: title, destination: InfoButtonView(destination: Sources()))
   
        
    }

    /// Dynamically chooses between a standard or large input field.
    ///
    /// - Parameter input: A `CalculatorInput` describing label, units, binding, and size.
    /// - Returns: A view representing the appropriate input field based on its size.
    @ViewBuilder
    func inputField(for input: CalculatorInput) -> some View {
        switch input.size {
        case .standard:
            InputField(label: input.label, units: input.units, value: input.binding)
        case .large:
            BiggerInputField(label: input.label, units: input.units, value: input.binding)
        }
    }
}
