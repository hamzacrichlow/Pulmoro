//
//  SwiftUIView.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 2/1/25.
//

import SwiftUI

struct  DesiredCO2CalculationInformation: View {
    var body: some View {
        CalculationInformationPage(
            calculationName: "Desired PaCO₂",
            calculation: """
                      Adjust the VT or the RR, and apply it to the desired PaCO₂ equation.
                      """,
            calculationDefinition: "In cases of respiratory acidosis, use the desired PaCO₂ calculation to determine the appropriate vent setting change required to normalize the patient's CO₂ levels.",
            importanceOfCalculation: """
            The desired PaCO₂ should be used more often by clinicians. Instead of guessing what rate to set the vent too to fix acidosis, you can easily use this calculation to quickly determine what the best rate would be to get your desired PaCO₂.
            """,
            howToCalculate: """
                      Decide if you want to adjust the RR or the VT before implementing the desired PaCO₂ equation. To make that decision, decide which one is the better option to change. If the patient is spontaneously breathing and tachypneic already then you may want to adjust the VT setting to help the patient. If the VT is already set too high or the patients peak pressures are high you may not want to increase the VT so you may want to calculate for RR instead. Keep in mind that you can also calculate the desired PaCO₂ calculation for minute ventilation as well. However, there is not a minute ventilation setting that you can adjust therefore you will have to adjust either the VT or RR to acquire the VE you want. Keep in mind that minute ventilation is equal to RR multiplied by VT. Once you have decided on which you want to calculate for use the formula:
                      
                          New RR = (RR x PaCO₂) / Desired PaCO₂
                          New VT = (VT x PaCO₂) / Desired PaCO₂
                          New VE = (VE x PaCO₂) / Desired PaCO₂
                      
                      """)
            

    }
}

#Preview {
    DesiredCO2CalculationInformation()
}

struct   DesireCO2CalculationCaseStudy: View {
    var body: some View {
        ScrollView{
            CaseStudyView(gender: "Male",
                          age: "20",
                          caseStudy: "An overdose patient was admitted to the ER intubated. An ABG has been drawn on the patient and the PaCO₂ is 60 mmHg. The patient's RR is set to 12 b/min on the ventilator and the patient is not spontaneously breathing. Use the desired PaCO₂ calculation to decrease the patients PaCO₂ to 40 mmHg by changing the RR setting on the vent")
            StepsView(step: "1",
                      instructions: "Plug the patient's RR, PaCO₂ and desired PaCO₂ into the desired PaCO₂ calculation :",
                      calculations: """
    New RR = (RR x PaCO₂) / Desired PaCO₂
        New RR = (12 x 60) / 40
            New RR = (720) / 40
                New RR = 18 b/min
    """)
            CaseStudyAnswerView(answerExplanation: "Keep in mind the RR on the vent may need to be set higher on overdose/comatose patients. Set the RR to 18 to blow PaCO₂ off to get to the desired PaCO₂ of 40 mmHg ", answer: "18 b/min")
        }
    }
}
