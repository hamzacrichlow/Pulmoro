//
//  CalculatorInformation.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 6/28/25.
//



import SwiftUI

struct CalculatorInformation: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("""
Pulmoro's built in calculators are designed to support clinicians by streamlining critical respiratory calculations used in intensive care and emergency settings. Each calculator focuses on accuracy, clarity, and clinical relevance, making it easier for healthcare professionals to apply evidence based medicine quickly and effectively.
""")
                
 
                
                Divider()
                    .frame(height: 2)
                    .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .leading, endPoint: .trailing))

                
                Text("Educational Integration")
                    .font(.title2)
                    .bold()
                Text("""
Each calculator includes a “More Information” section featuring case studies and background theory. These are crafted not only to aid learning but to reinforce clinical decision making skills through practical application.
""")

                Divider()
                    .frame(height: 2)
                    .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .leading, endPoint: .trailing))

                Text("Accuracy and Safety")
                    .font(.title2)
                    .bold()
                Text("""
While these calculators are built for clinical accuracy, they are intended to supplement, not replace, professional medical judgment. Always cross check values and consult with your care team when making patient decisions.
""")

                Divider()
                    .frame(height: 2)
                    .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .leading, endPoint: .trailing))

            
                Text("""
These tools are designed for ICU, emergency, and step-down environments where speed and precision are critical.
""")
                .font(.footnote)
                .foregroundColor(.secondary)

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationBarTitle("Calculators", displayMode: .automatic)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(systemImage: "chevron.backward")
            }
        }
    }
}

#Preview {
    CalculatorInformation()
}
