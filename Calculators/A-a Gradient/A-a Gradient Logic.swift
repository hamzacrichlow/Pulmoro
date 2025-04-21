//
//  SwiftUIView.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 1/31/25.
//

import SwiftUI

struct AaGradientCalculationInformation: View {
    var body: some View {
        ScrollView{
            CalculationInformationPage(
                calculationName: "P(A-a)O₂",
                calculation: " P(A-a)O₂ = PAO₂ - PaO₂",
                calculationDefinition: """
The A-a gradient is also known as the alveolar and arterial oxygen tension difference.  P(A-a)O₂
""",
                importanceOfCalculation: """
The A-a gradient calculation helps clinicians determine if the reason for their patients hypoxemia is due to a gas exchange issues or an issue extrinsic to the lungs. For example it would be important for a clinician to determine if the patient needs more PEEP to open alveoli to help with oxygenation or if the issue is extrinsic.
""",
                howToCalculate: """
Calculating the A-a gradient is simple once you have the PAO₂ and PaO₂. The PaO₂ come from the ABG and the PAO₂ is calculated. The equation to calculate PAO₂ is as follows: 

PAO₂ = [(PB - PH₂O)(FiO₂)-(PaCO₂/0.8)]
            
PB is barometric pressure which is normally 760 mmHg at sea level
            
PH₂O is water vapor pressure which is always 47 mmHg
            
FiO₂ is whatever FiO₂ you have the patient set too
            
PaCO₂ is gathered from the patient's ABG

Once you have the PAO₂ you can plug that into the P(A-a)O₂ equation: 

P(A-a)O₂ = PAO₂ - PaO₂

The PaO₂ is gathered from the patient ABG

""")
        }
    }
}

#Preview {
    AaGradientCalculationCaseStudy()
}

struct AaGradientCalculationCaseStudy: View {
    var body: some View {
        ScrollView{
        CaseStudyView(gender: "Male",
                      age: "70",
                      caseStudy: """
A new patient has been admitted to the ICU intubated and sedated. The patient is on 60% FiO₂. An ABG has been drawn revealing that the patient has a PaO₂ of 50 mmHg and a PaCO₂ of 40 mmHg. Calculate the A-a gradient to determine the efficiency of gas exchange.

Note: The patient is at sea level. Barometric pressure is 760 mmHg and water vapor pressure is 47 mmHg
""")
        StepsView(step: "1",
                  instructions: "Calculate the alveolar oxygen (PAO₂) :",
                  calculations: """
PAO₂ = [(PB-PH₂O)(FiO₂) - (PaCO₂/0.8)]
PAO₂ = [(760-47)(0.60) - (40/0.8)]
PAO₂ = [(713)(0.60) - (50)]
PAO₂ = 427.8 - 50
PAO₂ = 377.8 mmHg

""")
        StepsView(step: "2",
                  instructions: "Now that we have the PAO₂ we can plug it into the P(A-a)O₂ equation :",
                  calculations: """
P(A-a)O₂ = PAO₂ - PaO₂
P(A-a)O₂ = 377.8 - 50
P(A-a)O₂ = 327.8 mmHg
""")
        StepsView(step: "3", instructions: "Now that we have the patients A-a gradient lets compare it to what their normal A-a gradient should be using the patient's age : ", calculations: """
   (Age/4) + 4
   (70/4) + 4
   (17.5) + 4
    21.5 mmHg
""")
            
            StepsView(step: "4", instructions: "Now we have the patients A-a gradient and we have what their normal A-a gradient should be. Lets compare the two and make a conclusion about the patient's gas exchange", calculations: """
                      P(A-a)O₂ = 327.8 mHg
                      
                      Normal P(A-a)O₂ for a 70 year old patient is  21.5 mmHg
                      """)
            
            CaseStudyAnswerView(answerExplanation: "Normal P(A-a)O₂ for this patient is 21.5 mmHg. This patients A-a gradient is very elevated. This means that the patient is having a deficiency in gas exchange. This should be obvious to the clinician considering the patient is on 60% FiO₂ and the PaO₂ is only 50 mmHg", answer: "327.8 mmHg")
    }
    }
}
