//
//  SwiftUIView.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 7/10/25.
//

import SwiftUI

/// A calculator for determinint a patients Rapid Shallow Breathing Index
///
/// This calculator uses RR and Vt to determine the patients RSBI which is a good indicator of likelihood of successful weaning from mechanical ventialtion.
/// ```
///RSBi = RR/Vt
/// ```
///
/// Typically an RSBi <105 successfull wean to extubation and >105 liekly to fail extubation
///
/// -Important: Thive view uses the reusable `CalculatorView` structure to simplify layout and ensure consistenct with other calculators in the app.
///
/// ###UI Elements
/// - Input fields: RR, Vt
/// - Result : Displays caclulated RSBi in breaths/min/L
/// - Info Section: Provides context and clinical interpretation
///
///
struct RSBiCalculator: View {
    @State private var RR: Double = 0
    @State private var Vt: Double = 0
    
    @State private var result: Double?
    @State private var RSBidescription: String?
    var body: some View {
        CalculatorView(
            title: "RSBi",
            systemImage: "lungs.fill",
            instructions: "Enter the patient's RR and Vt",
            inputs: [
                CalculatorInput(label: "RR", units: "b/min", binding: $RR, size: .standard),
                CalculatorInput(label: "Vt", units: "ml", binding: $Vt, size: .standard)
            ],
            calculateAction: {
               result = calculateRSBi(RR: RR, Vt:Vt)
                
                if let result = result {
                    RSBidescription=lessThan105(RSBi: result)
                }
            },
            outputView: Group {
                if let result = result {
                    AnswerView(value: result, unit: "b/min/L")
                }
                if let RSBidescription = RSBidescription {
                    Text(RSBidescription)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.scale)
                        .animation(.easeInOut(duration: 0.5), value: RSBidescription)
                        .padding(5)
                }
            },
            info: "",
            infoPage: AnyView(AnionGapInformation())
            )
    }
}

#Preview {
    RSBiCalculator()
}

func calculateRSBi(RR:Double, Vt: Double) -> Double{
    let VtinL = Vt / 1000
    return RR / VtinL
    
}
func lessThan105(RSBi: Double) -> String {
    if RSBi >= 105
    {
        return """
YOur patient is fucked
"""
    } else {
        return """
    Good Job
    """
    }
}
