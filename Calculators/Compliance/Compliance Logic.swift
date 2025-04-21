//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/3/25.
//

import SwiftUI

struct ComplianceCalculationInformation: View {
    var body: some View {
        CalculationInformationPage(calculationName: "Compliance",
                                   calculation: """
Cstat = VT / (Pplat-PEEP)

Cdyn = VT / (PIP-PEEP)
""",
                                   calculationDefinition: """
Lung compliance is a measure of the lungs ability to stretch and retract.
""",
                                   importanceOfCalculation: """
                                   Calculating lung compliance is essential for optimizing patient care in respiratory management. Lung compliance is divided into two categories: static and dynamic. Static compliance is measured when there is no airflow utilizing the plateau pressure and positive end-expiratory pressure (PEEP). Dynamic compliance, on the other hand, considers the peak inspiratory pressure (PIP) and PEEP. Understanding these calculations helps clinicians adjust ventilator settings accurately and ensures optimal patient outcomes.
                                   
                                   An increase in PIP can be due to higher airway resistance or decreased alveolar compliance. Alveolar compliance refers to the lung's ability to inflate; more compliant lungs require less pressure to inflate, while less compliant, stiffer lungs require more pressure. Recognizing these factors enables clinicians to identify the causes of increased PIP and address them accordingly, such as suctioning, using bronchodilators, or inserting a bite block. 
                                   
                                   Static compliance is measured using an inspiratory hold maneuver, which provides the Pplat when there is no airflow. The difference between PIP and Pplat represents airway resistance. Calculating and monitoring compliance helps clinicians identify issues such as increased airway resistance or decreased chest wall compliance and take appropriate actions to improve patient care and prevent complications.
                                   """,
                                   howToCalculate: """
Calculating Lung Compliance is very simple. For static compliance it requires doing an inspiratory hold to attain the patient's Pplat. Once you have the Pplat insert the necessary values into the calculation: 

Cstat = VT / Pplat - PEEP

For VT remember to use the patient's exhaled VT rather then the VT you have the vent set too.
PEEP is whatever PEEP you have the vent set too.

Cdyn = VT / PIP - PEEP

For VT remember to use the patient's exhaled VT rather then the VT you have the vent set too.
PIP is whatever the patient's peak pressures are
PEEP is whatever you have the vent set too.
""")
    }
}

#Preview {
    ComplianceCaseStudy()
}

struct ComplianceCaseStudy: View {
    var body: some View {
        ScrollView{
            CaseStudyView(gender: "Female",
                          height: "5'5",
                          age: "45",
                          caseStudy: """
The patient is continuously experiencing high peak pressures on the ventilator. Peak pressures are 35 cmH20. The PEEP is 5 cmH20 and the VT is 400 mL. Calculate the patient's static compliance. 
""")
            
            StepsView(step: "1",
                      instructions: "To calculate static compliance this requires the patient's Pplat so you have to perform an inspiratory hold :",
                      calculations: "Pplat = 30")
            
            StepsView(step: "2",
                      instructions: "Now we plug the VT, Pplat, and PEEP into the static compliance equation : ",
                      calculations: """
Cstat = VT / Pplat - PEEP
Cstat = 400 / 30 - 5 
Cstat = 400 / 25
Cstat = 16 mL/cmH20
""")
            CaseStudyAnswerView(answerExplanation: "Normal Static Compliance is 50 - 100 mL/cmH20. The patient has a static compliance of 16 mL/cmH20 which is below the normal range. This means the patient has stiff lungs this is why the patient is peak pressuring so much on the ventilator", answer: "16 mL/cmH20")
        }
    }
    
}
