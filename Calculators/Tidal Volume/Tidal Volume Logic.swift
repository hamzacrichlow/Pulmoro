//
//  SwiftUIView.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 1/30/25.
//

import SwiftUI



#Preview {
    TidalVolumeCaseStudy()
}

struct TidalVolumeCalculationInformation: View {
    var body: some View {
        CalculationInformationPage(
            calculationName: "Tidal Volume",
            calculation: "VT = IBW x 4 - 8 mL/kg",
            calculationDefinition: "Tidal Volume is the amount of air that is inhaled or exhaled during a single normal breath.",
            importanceOfCalculation: """
                    Accurate tidal volume (VT) settings are crucial for preventing complications such as volutrauma, barotrauma, and atelectasis. Giving a patient too large of a tidal volume can cause over-distention, resulting in volutrauma and barotrauma. Conversely, if the VT setting is too low, a patient can be under-ventilated. Atelectasis occurs when parts of the lung collapse due to insufficient ventilation.
                    
                    By calculating the appropriate tidal volumes, healthcare professionals can reduce the risk of these complications and promote better patient outcomes. Proper calculations aid in maintaining optimal respiratory function and ensuring patient safety.
                    
                    Calculating the appropriate VT setting for a patient requires knowing their ideal body weight (IBW). IBW is determined based on gender and height. It's important to understand that even though a patient may be physically large, their lung sizes are based on height, not weight or body habitus.
                    
                    To put this into perspective, a 6-foot man weighing 160 pounds should have roughly the same lung size as a 6-foot man weighing 350 pounds. Although the latter appears larger, lung capacity is based on height rather than weight.
                    
                    Furthermore, gender plays a significant role in lung sizes. For example, a 6-foot woman will have a smaller lung size compared to a 6-foot man, despite being the same height. This is why it is important to use IBW for calculations, rather than just assuming a VT based on the patient's physical size.
                    """,
            howToCalculate: """
Calculating the appropriate VT setting for your patient requires knowing their IBW. These are the equations used to calculate IBW:

Males: 
IBW = 50 + (Height in inches - 60) x 2.3

Females: 
IBW = 45.5 + (Height in inches - 60) x 2.3

Once you have the patients IBW, you can plug that value into the VT calculation and multiply it by your desired volume per kg. The VT equation is:

VT = IBW x 4 - 8 mL/kg

The patient's VT should be set between 6 to 8 mL per kg of ideal body weight. In cases of Acute Respiratory Distress Syndrome (ARDS), smaller tidal volumes are recommended to prevent lung damage. Refer to the ARDSnet protocol, which advises keeping VT between 4 to 6 mL per kg.


""")
             
             }
}

struct TidalVolumeCaseStudy: View {
    var body: some View {
        ScrollView{
            
            CaseStudyView(
                gender: "Male",
                height: "6'0\"",
                caseStudy: "The patient is undergoing a procedure and is requiring Volume Control Ventilation with a tidal volume (VT) setting of 6 mL/per kg. What should the VT be set too?")
            
            StepsView(
                step: "1",
                instructions: "Convert the patient's height from feet to inches :",
                calculations: "6'0 feet = 72 inches")
            
            StepsView(
                step: "2",
                instructions: ("""
                Calculate the patients's ideal body weight (IBW), by plugging the "height in inches" into the IBW equation for males and simplifying :
                """),
                calculations: ("""
            IBW = 50 + (Height in inches - 60) x 2.3
            IBW = 50 + (72 − 60) × 2.3
            IBW = 50 + 12 × 2.3
            IBW = 50 + 27.6
            IBW = 77.6kg
            """)
            )
            StepsView(
                step: "3",
                instructions: ("""
Calculate VT by plugging the IBW into the VT equation and multiple by 6mL/kg and simplify :
"""),
                calculations: ("""
VT = IBW x 4 - 8 mL/kg
VT = 77.6kg x 6mL/kg
VT = 465 mL
""")
            )
            
            CaseStudyAnswerView(
                answerExplanation: "The appropriate tidal volume setting for this patient is :",
                answer: "465 mL"
            )
            
            
        }
    }
    
}
