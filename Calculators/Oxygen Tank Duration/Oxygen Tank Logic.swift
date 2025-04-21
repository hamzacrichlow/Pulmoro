//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/1/25.
//

import SwiftUI

struct OxygenTankInformation: View {
    var body: some View {
        CalculationInformationPage(
            calculationName: "Oxygen Tank Duration",
            calculation: """
            E Tanks: 0.28 
            G Tanks: 2.39 
            H Tanks: 3.14 
            """,
            calculationDefinition: "The amount of time it will take a cylinder filled with compressed gas to provide a set flow rate of gas can be calculated with this formula.",
            importanceOfCalculation: """
            Transporting patients with oxygen is a very common and necessary practice. All clinicians transporting patients utilizing oxygen tanks must keep safety measures in mind.
            
            When transporting a patient using a cylinder, it is important to note that cylinders should not be dropped, dragged, slid, or allowed to strike each other violently. Cylinders must be transported on an appropriate cart, secured by a chain or strap.
            
            The gas volume contained in a cylinder is related to the regulator's gauge pressure. Every cylinder size has a correlating conversion factor. To know the volume of gas remaining in a cylinder, multiply the gauge pressure by the cylinder factor. This will give you the volume of gas remaining in the tank. The resultant volume can then be divided by the flow rate of gas being used to determine the 
            
            Common cylinders and their cylinder factor:
            
                        E Tanks - 0.28 Cylinder Factor
                        G Tanks - 2.39 Cylinder Factor
                        H Tanks - 3.14 Cylinder Factor
            """,
            howToCalculate: """
                      Calculating the duration is easy. Look at the oxygen tank pressure gauge to see how much pressure is left within the oxygen tank. Multiply that pressure by the tanks cylinder factor and divide it by the flow you plan on delivering to the patient.
                      
                      (Cylinder Pressure (psi) x Cylinder Factor) / Flow rate of gas (L/min)
                      """)
    }
}

#Preview {
    OxygenTankInformation()
}



struct OxygenTankCaseStudy: View {
    
    var body: some View {
        CaseStudyView(gender: "Male",
                      age: "6",
                      caseStudy: """
A 6 year old pediatric patient is being transported from the his ICU room to get a CT done. THe child is requiring 2L of oxygen. THe respiratory grabs an E Tank with 1000 psi left in it. How long will the tank last?
""")
        StepsView(step: "1",
                  instructions: "Figure out the cylinder factor for an E tank",
                  calculations: "E Tank Cylinder Factor : 0.28")
        StepsView(step: "2",
                  instructions: "Plug the psi, flow, and cylinder factor into the oxygen tank duration equation",
                  calculations: """
(psi x cylinder factor) / flow
(1000 x 0.28) / 2
280 / 2
140 min
""")
        
        CaseStudyAnswerView(answerExplanation: "The tank will last for 140 minutes if it stays set at 2 L/min",
                            answer: "140 min")
    }
}
