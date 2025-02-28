//
//  Views.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/1/25.
//

import SwiftUI


struct Views: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
#Preview {
    Views()
}


struct TabBar: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab){
            Calculations()
                .tabItem{
                    Image(systemName: "plus.forwardslash.minus")
                    Text("Calculations")
                        .padding()
                }
                
            AcidBaseBalanceInput()
                .tabItem{
                    Image(systemName: "syringe")
                    Text("Acid Base Balance")
                }
                .tag(0)
            MorePage()
                .tabItem{
                    Image(systemName: "circle.hexagonpath.fill")
                    Text("More")
                        .padding()
                }
        }
        .shadow(radius: 20)
    }
}





/// This struct is used to give brief instructions on how to utilize the designated calculator
struct CalculatorInstructions: View {
    
    var instructions: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(instructions)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.caption)
        .padding()
      
    }
}

/// This struct is used to add a title to a navigation view the back button at the top of the page in the tool bar. And the option to add another button to the top right corner in the tool bar
struct CalculationToolBarViewModifier<Destination: View>: ViewModifier {
   
    let title: String
    let destination: Destination
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(title, displayMode: .automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    destination
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(systemImage: "chevron.backward")
                }
            }
    }
}

extension View {
    func applyCalculationToolBar<Destination: View>(
title: String,
    destination: Destination
    ) -> some View {
        self.modifier(CalculationToolBarViewModifier(title: title, destination: destination))
    }
        
}


/// This view is used to present Diagnostics/Labs/Parameters with the name of it and the unit it is measured in. It presents the value as a string. And also changes color of the Diagnostics/Labs/Parameters if it is not within Normal Range.
///
struct Diagnostic: View {
    
    let valueName: String
    let value: Double?
    let unit: String
    let isNormal: Bool
  
    var formattedValue: String {
        if let value = value {
            return String(value)
        } else {
            return "-"
        }
    }

    var body: some View {
        VStack{
            Text(formattedValue)
                    .font(.system(size: 15))
                    .padding(.top,2)
                    .padding(.bottom,0.5)
                    .foregroundColor(value == nil ? .gray : (isNormal ? .primary : .red))
        Text("\(valueName)")
                    .font(.system(size: 10))
                    .padding(.bottom,0.5)
            
        Text("\(unit)")
                .font(.system(size: 8))
               
        }
    }
}

struct VentSettingsInput: View {
    
    let valueName: String
    let value: Double?
    let unit: String
  
  
    var formattedValue: String {
        if let value = value {
            return String(value)
        } else {
            return "-"
        }
    }

    var body: some View {
        VStack{
            Text(formattedValue)
                    .font(.system(size: 15))
                    .padding(.top,2)
                    .padding(.bottom,0.5)

        Text("\(valueName)")
                    .font(.system(size: 10))
                    .padding(.bottom,0.5)
            
        Text("\(unit)")
                .font(.system(size: 8))
               
        }
    }
}
/// This view is used to present the answer to a calculation from the calculator suite.
struct AnswerView: View {
    
    let value: Double
    let unit: String

    var body: some View {
            return Text("\(Int(value)) \(unit)")
                .font(.system(size: 30, weight: .bold))
                .transition(.scale)
                .animation(.easeInOut(duration: 0.5), value: value)
        }
}
    


/// This struct creates a navigating button. It takes a string and a system image icon that can be placed on the button. ANd a destination
struct NewPageButtonView<Content: View>: View {
   
    var text: String
    var icon: String
    var destination: Content

    var body: some View {
        NavigationLink(destination: destination)
        {
            HStack{
                Text(text)
                Image(systemName: icon)
            }
        }
        .buttonStyle(CustomButtonStyle())
    }
    }

/// THis struct is used on all of the calculation pages so you can have a group box that allows you to type in important information related to the calculator and the it has a button that you can use to take the user to the reading information about the calculator.
struct ImportantInfoBox<Content: View>: View {
    
    var ImportantInformation: String
    var infopage: Content
    
    var body: some View {
        GroupBox(label: Label("Important Information", systemImage: "info")){
            
            Text(ImportantInformation)
            .font(.system(size: 15))
            .padding(10)
            
            NewPageButtonView(
                text: "More Information",
                icon: "",
                destination: infopage
            )
            
            
        }
        .customGroupBoxStyle()
        
        Spacer()
    }
}

/// A segmented Picker that can give the clinician the option of choosing Male or Female for their patient
struct genderPicker: View {
    
    @Binding var gender: String
    
    let genders = ["Male", "Female"]
    
    var body: some View {
        
        HStack{
                Text("Gender")
                .font(.system(size: 15))
            
                VStack{
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender).tag(gender)
                                .font(.system(size: 10))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxHeight: 200)
            }
        }
    }
}

/// This struct is a wheel picker so that the user can input the patients height in inches and it uses a function to convert that height into inches
struct heightPicker: View {
    
    @Binding var height: Int
    @State private var selectedFeet = 0
    @State private var selectedInches = 0
   
    
    var body: some View {
        
        HStack{
            
            Text("Height")
                .font(.system(size: 15))
            
            ZStack{
                
                Picker("Feet", selection: $selectedFeet) {
                    ForEach(0..<9) {feet in
                        Text("\(feet)").tag(feet)
                            .font(.system(size: 13, weight: .bold))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 40)
                .onChange(of: selectedFeet) { _ in
                    convertFeetToInches()
                }
            }
            Text("ft")
                .font(.system(size: 10))
            
            ZStack{
                
                Picker("Inches", selection: $selectedInches) {
                    ForEach(0..<12) {inches in
                        Text("\(inches)").tag(inches)
                            .font(.system(size: 13, weight: .bold))
                    }
                }
                .frame(height: 40)
                .pickerStyle(WheelPickerStyle())
                .onChange(of: selectedInches) { _ in
                    convertFeetToInches()
                }
            }
            Text("in")
                .font(.system(size: 10))
            
        }
    }
    
    func convertFeetToInches (){
      height = selectedFeet * 12 + selectedInches
    }
}

/// This is pretty much a button that takes a sheet and removes it
struct BackButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var systemImage: String
    
var body : some View {
    
    Button(action: {
        presentationMode.wrappedValue.dismiss()
    }) {
        Image(systemName: systemImage)
            
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.teal, .blue]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .mask(
                    Image(systemName: systemImage)
                        
                )
            )
    }
    .padding()
    
}
}

struct CalculationInformationPage: View {
    var calculationName: String
    var calculation: String
    var calculationDefinition: String
    var importanceOfCalculation: String
    var howToCalculate: String
    var priorCalculation: String?
    var priorCalculation2: String?
    var priorCalculation3: String?
    var furtherExplanation: String?
    
    var body: some View {
        
        ScrollView {
            VStack{
                
                ZStack{
                    Rectangle()
                        .fill(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 150)
                        .shadow(radius: 10)
                    Text(calculationDefinition)
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.white)
                        .padding()
                }
                
                
                Text("The Importance of Calculating \(calculationName)")
                    .font(.system(size: 25, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Text(importanceOfCalculation)
                    .padding()
                
                ZStack{
                    Rectangle()
                        .fill(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 150)
                        .shadow(radius: 10)
                    Text(calculation)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color.white)
                        .padding()
                }
                    Text("How to Calculate \(calculationName)")
                        .font(.system(size: 25, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    Text(howToCalculate)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                if let priorCalculation = priorCalculation{
                    VStack{
                        
                            Text(priorCalculation)
                                .font(.system(size: 15, weight: .semibold, design: .serif))
                                .padding()
                        
                    }
                }
                if let furtherExplanation = furtherExplanation{
                    VStack{
                        
                        Text(furtherExplanation)
                                .font(.system(size: 15, weight: .semibold, design: .serif))
                                .padding()
                        
                    }
                }
                    
                }
                
            }
        }
    }


struct CaseStudyView: View {
    
    var gender: String?
    var height: String?
    var age: String?
    var weight: String?
    var HR: String?
    var BP:String?
    var caseStudy: String
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .fill(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 150)
                    .shadow(radius: 10)
                Text("The following case study demonstrates how the calculation is used in a real-world clinical scenario.")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.white)
                    .padding()
            }
               
            Text("Case Study")
                .font(.system(size: 25, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .padding(.bottom, -20)
          if let gender = gender {
                Text("Gender: \(gender)")
                  .font(.system(size: 16, design: .monospaced))
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding()
                  .padding(.bottom, -40)
            }
            if let height = height {
                Text("Height: \(height)")
                    .font(.system(size: 16, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, -40)
                
            }
            if let age = age {
                Text("Age: \(age)")
                    .font(.system(size: 16, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, -40)
            }
            Text(caseStudy)
                .font(.system(size: 16, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top, 20)
            
                Divider()
                    .frame(width: 375, height: 1)
            
        }
    }
}

struct StepsView : View {
    
    var step: String
    var instructions: String
    var calculations: String
    
    var body: some View {
        Text("Step \(step)")
            .font(.system(size: 18, weight: .semibold))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .padding(.bottom, -30)
        Text(instructions)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .padding(.bottom, -20)
        Text(calculations)
            .font(.system(size: 15, design: .monospaced))
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        Divider()
            .background(Color.white)
            .frame(width: 300, height: 1)
    }
}

struct CaseStudyAnswerView: View {
    var answerExplanation: String
    var answer: String
    var body: some View {
        Text("Evidence Based Conclusion")
        .font(.system(size: 18, weight: .semibold))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .padding(.bottom, -30)
        Text(answerExplanation)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, -20)
        Text(answer)
            .font(.system(size: 20, weight: .semibold, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        Divider()
            .frame(width: 375, height: 1)
            .padding()
    }
}

struct InfoButtonView: View {
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        Button(action: {
            showSheet.toggle()
        }) {
            Image(systemName: "info.circle")
                
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.teal, .blue]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .mask(
                        Image(systemName: "info.circle")
                            
                    )
                )
        }
        .sheet(isPresented: $showSheet) {
            Sources()
                .presentationDetents([.large])
        }
        .padding()
        
    }
}






struct CustomGroupBoxStyle: ViewModifier {
    func body(content: Content) -> some View {
        content

            .cornerRadius(5)
            .shadow(radius: 0.2)
            .padding(.vertical, 5)
            .padding(.horizontal)
           
    }
}

extension View {
    func customGroupBoxStyle() -> some View {
        self.modifier(CustomGroupBoxStyle())
    }
}

struct CustomSegmentedPickerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(SegmentedPickerStyle())
//            .frame(width: 350)
            .cornerRadius(5)
            .padding(5)
    }
}

extension View {
    func customSegmentedPickerStyle() -> some View {
        self.modifier(CustomSegmentedPickerStyle())
    }
}








struct mlPerKgPicker: View {
  
    @Binding  var mlPerKg: Int
    
    var body: some View {
        VStack{
            
        HStack{
            Text("Volume")
                .font(.system(size: 15))
            
                VStack{
                    Picker("Volume", selection: $mlPerKg) {
                        ForEach(4..<9) {ml in
                                Text("\(ml)")
                                .tag(ml)
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxHeight: 200)
                }
            
            Text("mL/kg")
                .font(.system(size: 10))
        }
    }
        
    }
}



struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
     configuration.label
        .font(.system(size: 15, weight: .semibold))
        .frame(width: 175)
        .foregroundStyle(Color.white)
        .padding(10)
        .background(LinearGradient(gradient: .init(colors: [.blue, .teal]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.top, 10)
    }
}

struct AcidBaseBalanceInstructionsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter the patient's ABG results, vent settings, and vent parameters to receive recommended treatment for acid-base balance.")
        }
        .font(.caption)
        .padding()
    }
}

struct AboutPulmoroPage: View {
    var body: some View {
        ScrollView{
            
            
        Text("Pulmoro")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .padding(.bottom, -30)
            Divider()
                .frame(width: 370)
                .frame(height: 3)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
        Text("""
                Pulmoro is a specialized tool designed to assist medical professionals in managing patients with respiratory conditions, particularly those requiring mechanical ventilation support. It supports clinical practice by providing quick and accurate recommendations and calculations that help minimize medical errors.
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
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
        
            .padding(20)
            .padding(.bottom, -30)
        Text("Acid-Base Balance:")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
        
            .padding(20)
            .padding(.bottom, -40)
        Text("""
                Arterial blood gas (ABG) interpretation.
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
                Includes a suite of calculators for respiratory parameters such as tidal volume, A-a gradient, desired PaCO₂, and more.
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
            .bold()
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
    }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("More Information", displayMode: .inline)
        .toolbar {
           
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(systemImage: "chevron.backward")
            }
        }
    }
}

struct AboutABGAnalysis: View {
    var body: some View {
        ScrollView{
        Text("Arterial Blood Gas Analysis")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .padding(.bottom, -30)
            Divider()
                .frame(width: 370)
                .frame(height: 3)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
            
            Text("""
        Arterial Blood Gases (ABG) are lab tests drawn from a patient's arterial blood. It is most commonly drawn from the radial artery but can also be drawn from the brachial or femoral arteries. Once the sample is obtained and analyzed in the lab, the values provide information about the oxygen levels, carbon dioxide levels, and pH, giving clinicians an overview of the patient's acid-base balance.
        
        Interpreting ABG results is complex and challenging, and treating abnormalities can be even more intricate. Accurate interpretations help clinicians assess lung function, metabolic function, and overall acid-base balance.
        
        Pulmoro simplifies this process by providing clinicians with quick and accurate ABG interpretations. 
        """)
            .padding(20)
            Divider()
                .frame(width: 350)
                .frame(height: 1)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
    }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("More Information", displayMode: .inline)
        .toolbar {
           
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(systemImage: "chevron.backward")
            }
        }
    }
}
struct AboutVentManagement: View {
    var body: some View {
        ScrollView{
            Text("Ventilator Management")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .padding(.bottom, -30)
            Divider()
                .frame(width: 370)
                .frame(height: 3)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
            Text("""
        Mechanical ventilation is a life-saving process where a ventilator moves air in and out of the lungs to assist patients with breathing. It is used in critical situations, such as during surgery or when someone has a severe illness or injury affecting their ability to breathe.
        
        Optimizing the settings of a mechanical ventilator is complex. Ventilators have multiple functions but often the primary goal is to provide enough oxygen and remove carbon dioxide from the blood while avoiding further lung injury. Incorrect vent settings can lead to problems such as acidosis (where the blood becomes too acidic) or lung trauma (damage to the lungs from the ventilator).
        
        Pulmoro assists clinicians by offering a suite of calculations to determine the best ventilator settings for optimal patient care.
        """)
            .padding(20)
            Divider()
                .frame(width: 350)
                .frame(height: 1)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("More Information", displayMode: .inline)
        .toolbar {
           
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(systemImage: "chevron.backward")
            }
        }
    }
    }

struct AboutSources: View {
    var body: some View {
        ScrollView{
        Text("Sources")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .padding(.bottom, -30)
            Divider()
                .frame(width: 370)
                .frame(height: 3)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
        Text("""

All information, calculations, and guidelines provided by Pulmoro are derived from the following medical literature:
""")
        .font(.body)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .padding(.top, -30)
            
        
        Divider()
            .frame(width: 375)
            .frame(height: 1)
            .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .padding()
       
        
        
        Text("""
Malley, W. (2nd ed.). Clinical Blood Gases Assessment and Intervention. Saunders

Kacmarek, R. M., Stoller, J. K., & Heuer, A. J. (12th ed.). Egan's Fundamentals of Respiratory Care. Elsevier

Cairo, J. M. (10th ed.). Mosby's Respiratory Care Equipment. Elsevier
""")
        
        .font(.body)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        .padding(20)
        .padding(.top, -20)
            Divider()
                .frame(width: 350)
                .frame(height: 1)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
    }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("More Information", displayMode: .inline)
        .toolbar {
           
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(systemImage: "chevron.backward")
            }
        }
}
}
struct AboutFutureOfPulmoroPage: View {
    var body: some View {
        ScrollView{
            Text("Future of Pulmoro")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .padding(.bottom, -30)
            
            Divider()
                .frame(width: 370)
                .frame(height: 3)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
            
            
            Text("""
Pulmoro is in its early stages of development, but its vision is ambitious and transformative.

The goal is for Pulmoro to take in a patient's ABG results and ventilator settings and then create a comprehensive treatment plan for correcting acid-base imbalances. Pulmoro is a powerful educational tool, helping clinicians learn and apply best practices right at their fingertips.

In the future, the plan is to integrate HealthKit and ResearchKit to enhance the app's functionality and value for medical institutions.

Looking beyond respiratory care, the goal is to expand Pulmoro's capabilities to other medical fields like cardiovascular care, pediatrics, nursing etc. By leveraging advanced algorithms and specialized code it can provide targeted support across various medical disciplines.

The main goal is always to save lives and improve patient outcomes by providing the highest standard of care.
""")
            .padding(20)
            .padding(.top, -15)
            Divider()
                .frame(width: 350)
                .frame(height: 1)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
         
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("More Information", displayMode: .inline)
        .toolbar {
           
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(systemImage: "chevron.backward")
            }
        }
    }
}

