//
//  SwiftUIView.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 1/31/25.
//

import SwiftUI

///The A-a Gradient Calculator and Important Information View
struct AaGradientCalculator: View {
    
    //All the inputs for this calculator
    @State private var PaO2: Double = 0
    @State private var PaCO2: Double = 0
    @State private var FiO2: Double = 0
    @State private var age: Double = 0
   
    //All the possible outputs for this calculator
    @State private var normalAaGradient: Double? = nil
    @State private var AaGradient: Double? = nil
    @State private var lungIssueDescription: String?
    
    var body: some View {
        CalculatorView(
            title: "A-a Gradient Calculator",
            systemImage: "lungs.fill",
            instructions: "Enter the patient's age, FiO₂, PaO₂, and PaCO₂ to calculate the patient's A-a gradient.",
            inputs: [
                CalculatorInput(label: "Age", units: "", binding: $age, size: .standard),
                CalculatorInput(label: "PaO₂", units: "mmHg", binding: $PaO2, size: .standard),
                CalculatorInput(label: "PaCO₂", units: "mmHg", binding: $PaCO2, size: .standard),
                CalculatorInput(label: "FiO₂", units: "%", binding: $FiO2, size: .standard),
            ],
            calculateAction: {
                let PAO2 = calculatePAO₂(FiO₂: FiO2, PaCO₂: PaCO2)
                AaGradient = calculateAaGradient(PAO₂: PAO2, PaO₂: PaO2)
                normalAaGradient = calculateNormalAaGradient(age: age)
                
                if let AaGradient = AaGradient, let normalAaGradient = normalAaGradient {
                    lungIssueDescription = intrinsicOrExtrinsic(age: age, AaGradient: AaGradient, NormalAaGradient: normalAaGradient)
                }
            },
                outputView: Group{
                    if let AaGradient = AaGradient {
                        AnswerView(value:AaGradient, unit: "mmHg" )
                            .padding(5)
                    }
                    if let lungIssueDescription = lungIssueDescription {
                        
                        Text(lungIssueDescription)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.scale)
                            .animation(.easeInOut(duration: 0.5), value: lungIssueDescription)
                            .padding(5)
                    }
                },
            info: """
                The A-a gradient is a useful measurement of the efficiency of gas exchange. It can be used to differentiate between intrinsic and extrinsic causes of hypoxemia.

                An elevated A-a gradient can indicate hypoxemia caused by an intrinsic lung issue associated with gas exchange problems. The greater the gradient, the more severe the impairment in gas exchange.

                If the A-a gradient is within the normal range and the patient is hypoxic, the hypoxemia is likely caused by an extrinsic factor rather than intrinsic.
                """,
            infoPage: AnyView(AaGradientInformation())
                )

    }
}

#Preview {
    AaGradientCalculator()
}



