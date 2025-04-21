//
//  SwiftUIView.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 1/25/25.
//

import SwiftUI

struct Sources: View {
    
    var body: some View {
        NavigationStack{
            ScrollView{
                
               
                    VStack{
                        Text("Pulmoro")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                            .padding(20)
                            .padding(.bottom, -30)
                        Text("""
                            Pulmoro is a specialized tool designed to assist medical professionals in managing patients with respiratory conditions, particularly those requiring mechanical ventilation support. It supports clinical practice by providing quick and accurate recommendations and calculations that minimize medical errors.
                            """)
                        
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        
                        Divider()
                            .frame(width: 350)
                            .frame(height: 1)
                            .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding()
                        Text("Key Features")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(20)
                            .padding(.bottom, -30)
                        Text("Acid-Base Balance:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(20)
                            .padding(.bottom, -40)
                        Text("""
                            Interprets arterial blood gases (ABG) and provides recommended ventilator setting changes to balance ABGs.
                            """)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        .padding(20)
                        .padding(.bottom, -30)
                        Text("Medical Calculators:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(20)
                            .padding(.bottom, -40)
                        Text("""
                            Includes multiple calculators for respiratory parameters such as tidal volume, A-A gradient, desired CO2, and more.
                            """)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        .padding(20)
                        .padding(.bottom, -30)
                        Text("Educational Tool:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(20)
                            .padding(.bottom, -40)
                        
                        Text("""
                            Emphasizes the importance of medical calculations and highlights their real-world applications.
                            """)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        .padding(20)
                        .padding(.bottom, -30)
                        Text("Case Studies:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(20)
                            .padding(.bottom, -40)
                        
                        Text("""
                            Includes case study examples to enhance learning, making it a valuable resource for both education and clinical practice.
                            """)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        .padding(20)
                        
                        
                        
                        Divider()
                            .frame(width: 350)
                            .frame(height: 1)
                            .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding()
                        
                        Text("Disclaimer")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(20)
                            .padding(.bottom, -30)
                        Text("""
                            Pulmoro offers precise calculations and recommendations. However, it is intended to be a supplementary tool and should not be solely relied upon for diagnosis or treatment. All recommendations and calculations should be reviewed with the patient’s care team, and decisions regarding patient care should align with facility and hospital protocols.
                            """)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        .padding(20)
                        
                        
                        Divider()
                            .frame(width: 350)
                            .frame(height: 1)
                            .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding()
                        
                        Text("Sources")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(20)
                            .padding(.bottom, -30)
                        Text("""
        
        All information, calculations, and guidelines provided by Pulmoro are derived from the following medical literature:
        """)
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        .padding(20)
                        .padding(.bottom, -20)
                        
                        
                        Text("""
        Malley, W. (2nd ed.). Clinical Blood Gases Assessment and Intervention. Saunders
        
        Kacmarek, R. M., Stoller, J. K., & Heuer, A. J. (12th ed.). Egan's Fundamentals of Respiratory Care. Elsevier
        
        Cairo, J. M. (10th ed.). Mosby's Respiratory Care Equipment. Elsevier
        """)
                        
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        .padding(20)
                        .padding(.top, -20)
                    }
                    
                    
                    
                    
                    
                
                
            }
            .navigationBarTitle("About Pulmoro", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    BackButton(systemImage: "x.circle")
                }
            }
            
        }
    }
}


#Preview {
    Sources()
}




