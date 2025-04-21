//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/2/25.
//

import SwiftUI

struct OxygenIndexInformation: View {
    var body: some View {
        CalculationInformationPage(
            calculationName: "Oxygen Index",
            calculation: "OI = (MAP x FiO₂) / PaO₂",
            calculationDefinition: "Oxygen Index helps clinicians evaluate the effectiveness of oxygen therapy and determine the need for more intensive interventions.",
            importanceOfCalculation: """
                      When a patient is not oxygenating well it may be a good time to calculate the oxygen index. Once the oxygen index gets above 40 you want to star considering extracorporeal membrane oxygenation (ECMO). Its a goof measurement to use to determine if they patient will have a good outcome on the current vent settings or not
                      """,
            howToCalculate: """
                      To calculate oxygen index (OI) the patient needs to be on a ventilator. Use the mean airway pressure (MAP) and FiO2 vent settings and the PaO₂ from the patients arterial blood gas and plug them into the OI equation.
                      
                                  OI = (MAP x FiO₂) / PaO₂
                      """)
    }
}

#Preview {
    OxygenIndexInformation()
}

//                OxygenIndexInformation()
struct OxygenIndexCaseStudy: View {
    var body: some View {
        CaseStudyView(gender: "Female",
                      age: "80",
                      caseStudy: """
An 80 year old female has been admitted to the ICU with acute respiratory distress syndrome (ARDS). The patient is intubated and on mechanical ventilation. The mean airway pressure (MAP) is 20 cmH₂O and the patient is receiving 80% FiO₂. An ABG has been drawn revealing the patient's PaO₂ to be 40mmHg. Calculate the patient's oxygenation index (OI).
""")
        StepsView(step: "1",
                  instructions: "Input the MAP, FiO₂, and PaO₂ into the OI calculation and solve for OI",
                  calculations: """
OI = (MAP x FiO₂) / PaO₂
OI = (20 x 80) / 40
OI = 1600 / 40
OI = 40
""")
        
        CaseStudyAnswerView(answerExplanation: "The patients oxygenation index is 40. OI greater than 40 indicates severe hypoxemia. ", answer: "40")
    }
}
