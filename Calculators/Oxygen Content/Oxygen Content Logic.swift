//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/2/25.
//

import SwiftUI

struct OxygenContentInformation: View {
   
   
    var body: some View {
        CalculationInformationPage(
            calculationName: "Oxygen Content",
            calculation: "CaO₂ = (Hb x 1.34 x SaO₂) + (PaO₂ x 0.003)",
            calculationDefinition: "",
            importanceOfCalculation: """
              If hemoglobin concentration, arterial saturation or PaO2 decrease then CaO2 decreases .
                 The effectiveness of increased FiO₂ in the management of hypoxemia depends on the cause of hypoxemia. Hypoxemia caused by a decrease in V/Q Ratio or hypoventilation is more responsive to increased FiO2 than hypoxemia caused by a diffusion defect or shunt. Diffusion deficits and shunts usually respond better to pressure o a n increase in PEEP.IF PaO2 responds well to an increased in FiO2 then a low VQ ratio is probably the cause of hypoxemia. If the patient is not responding well to high amounts of FiO2 on the vent then that is likely meaning that the cause of hypoxemia is
                 
                 Hypoventilation may be the cause of hypoxemia in patients with central nervous system depression, apnea, and neuromuscular disease,

              In other causes of hypoxemia increasing arterial O₂ content usually fixes the problem.
      """,
            howToCalculate: """
                          """)

    }
}

#Preview {
    OxygenContentCaseStudy()
}

struct OxygenContentCaseStudy: View {
    var body: some View {
        ScrollView{
            CaseStudyView(gender: "Female",
                          age: "74",
                          caseStudy: """
A GI bleed patient is hypoxic. A complete blood count and arterial blood gas have been drawn on the patient. The patient's hemoglobin is 8 g/dL, the PaO₂ is 80 mmHg,and the SaO₂ is 95%. Calculate the patients oxygen content to assess overall oxygenation status and determine the appropriate treatment plan.
""")
            StepsView(step: "1",
                      instructions: "Take the ",
                      calculations: """
(Hb x 1.34 x SaO₂) + (PaO₂ x 0.003)
(8 x 1.34 x 0.95) + (80 x 0.003)
10.184 + 0.24
CaO₂ = 10.424 VOL %
""")
            CaseStudyAnswerView(answerExplanation: "Normal CaO₂ is 18 - 20 VOL%. The patient's CaO₂ is very low. This is probably due to the low amount of Hb caused by the GI bleeding. The patient may need a blood transfusion to increase their CaO₂", answer: "10 VOL %")
        }
    }
}
