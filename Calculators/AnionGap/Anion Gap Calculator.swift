//
//  Anion Gap Calculator.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 4/3/25.
//

import SwiftUI

/// A calculator view for determining a patient's anion gap.
///
/// This calculator uses sodium (Na⁺), potassium (K⁺), chloride (Cl⁻), and bicarbonate (HCO₃⁻)
/// levels to estimate the anion gap, which reflects acid-base balance in the blood.
///
/// The formula used:
/// ```
/// Anion Gap = Na⁺ + K⁺ − (Cl⁻ + HCO₃⁻)
/// ```
///
/// A typical reference range is 8–12 mEq/L, and deviations may suggest metabolic disorders.
///
/// - Important: This view uses the reusable `CalculatorView` structure to simplify layout
///   and ensure consistency with other calculators in the app.
///
/// ### UI Elements
/// - Input fields: Na⁺, K⁺, Cl⁻, HCO₃⁻
/// - Result: Displays calculated anion gap in mEq/L
/// - Info Section: Provides context and clinical interpretation
///
/// - SeeAlso: `CalculatorView`, `CalculatorInput`, `calculateAnionGap`
struct AnionGapCalculator: View {
    @State private var Na: Double = 0
    @State private var K: Double = 0
    @State private var Cl: Double = 0
    @State private var HCO3: Double = 0
    @State private var result: Double?

    var body: some View {
        CalculatorView(
            title: "Anion Gap",
            systemImage: "lungs.fill",
            instructions: "Enter the patient's Na, K, Cl, and HCO₃ to calculate the anion gap.",
            inputs: [
                CalculatorInput(label: "Na +", units: "mEq/L", binding: $Na, size: .standard),
                CalculatorInput(label: "K +", units: "mEq/L", binding: $K, size: .standard),
                CalculatorInput(label: "Cl -", units: "mEq/L", binding: $Cl, size: .standard),
                CalculatorInput(label: "HCO₃ -", units: "mEq/L", binding: $HCO3, size: .standard)
            ],
            calculateAction: {
                result = calculateAnionGap(Na: Na, K: K, Cl: Cl, HCO3: HCO3)
            },
            outputView: Group {
                if let result = result {
                    AnswerView(value: result, unit: "mEq/L")
                }
            },
            info: """
The anion gap is a calculation used to assess the difference between positively and negatively charged electrolytes in the blood.

The normal anion gap range can vary slightly but it's generally considered to be around 8-12 mEq/L

Elevated anion gap maay indicate metabolic acidosis.

Decreased anion gap may indicate certain conditions, such as hyperchloremia. 
""",
            infoPage: AnyView(AnionGapInformation())
        )
    }
}

#Preview {
    AnionGapCalculator()
}

func calculateAnionGap(Na: Double, K: Double, Cl: Double, HCO3: Double) -> Double {
   return (Na + K) - (Cl + HCO3)
}
