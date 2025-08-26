//
//  Views.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 3/8/25.
//

import SwiftUI


struct CustomGroupBoxStyle2: ViewModifier {
    var isCompleted: Bool
    var cornerRadius: CGFloat
    var borderWidth: CGFloat

    init(isCompleted: Bool, cornerRadius: CGFloat = 8, borderWidth: CGFloat = 0.2) {
        self.isCompleted = isCompleted
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }

    func body(content: Content) -> some View {
        
        if isCompleted {
            content
                .backgroundStyle(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.thickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [.teal, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: borderWidth
                        )
                )
                .padding(.vertical, 8)
                .padding(.horizontal)
        } else {
            content
                .backgroundStyle(.regularMaterial)
                .padding(.vertical, 8)
                .padding(.horizontal)
        }
                  
    }
}


extension View {
    func customGroupBoxStyle2(
        isCompleted: Bool,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0.2
    ) -> some View {
        self.modifier(CustomGroupBoxStyle2(
            isCompleted: isCompleted,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth
        ))
    }
}



struct CustomGroupBoxStyle1: ViewModifier {
    var cornerRadius: CGFloat = 8
    var borderWidth: CGFloat = 0.2
    
    func body(content: Content) -> some View {
        content
            .backgroundStyle(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [.teal, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: borderWidth
                    )
            )
            .padding(.vertical, 8)
            .padding(.horizontal)
    }
}

extension View {
    func customGroupBoxStyle1(backgroundColor: Color = Color(.systemBackground)) -> some View {
        self.modifier(CustomGroupBoxStyle1())
    }
}

struct Views: View {
    
    @Binding var ABGData: ABG
    @Binding var VentData: VentSettings
    @Binding var VentParameters: VentParameters
    @State private var gradientColors: [Color] = [
        Color(.cyan).opacity(0.1),
        Color(.cyan).opacity(0.2),
        Color(.cyan).opacity(0.1)
    ]
    var body: some View {
        
        let interpretation = interpretABG(
            pH: ABGData.pH,
            paCO2: ABGData.paCO2,
            HCO3: ABGData.HCO3,
            PaO2: ABGData.paO2,
            FiO2: VentData.FiO₂
        )
      
        
        NavigationStack{
            ZStack{
                MovingGradientView(colors: gradientColors)
                                 .ignoresSafeArea(.all)
               
                    
            ScrollView{
              
            
                
                GroupBox {
                        
        
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label("Summary", systemImage: "lungs.fill")
                                .font(.headline)
                            Spacer()
                            
                            
                        }
                       
                        
                        Text("""
                                The patient is in an uncompensated metabolic acidosis with severe hypoxemia. FiO2 should be increased to correct oxygenation status. Vent settings can be adjusted temporarily to fix acid-base balance however metabolic intervention should take place. Consider using the anion-gap calculation to determine if bicorbante should be administered.
                                """)
                       
                        .font(.system(size: 14))
                        Text("""
                                Reccomended Vent Settings:
                                """)
                       
                        .font(.system(size: 14))
                       
                   
                        
//                        HStack {
//                            Label("Ventilator Recommendations", systemImage: "inset.filled.tv")
//                                .font(.headline)
//                            Spacer()
//                            
//                            
//                        }
                        
                    
                        VentAdjustmentCardInfo(VentData: $VentData)
                        
                        
                    }
                
                }
                .customGroupBoxStyle1()
//                .shadow(radius: 1)
             
                
               
                
                
                
                
                ClickableGroupBox(title: "Blood Gas Interpretation",
                                  icon: "syringe.fill",
                                  destination: bloodGasInterpretation(ABGData: $ABGData, VentData: $VentData, VentParameters: $VentParameters),
                                  content: ABGCardInfo(ABGData: $ABGData))
                
                ClickableGroupBox(title: "Ventilator Assessment",
                                  icon: "inset.filled.tv",
                                  destination: Text("Ventilator Assessment"),
                                  content: VentCardInfo(VentData: $VentData))
                
                ClickableGroupBox(title: "Clinical Reference",
                                  icon: "book.closed.fill",
                                  destination: Text("Clinical Reference"),
                                  description: "Evidence-based explanations of physiological principles and clinical guidelines for respiratory management.")
                ClickableGroupBox(title: "Risk  Factors",
                                  icon: "exclamationmark.triangle.fill",
                                  destination: Text("Risk  Factors"),
                                  description: "Patient-specific warnings, potential complications, and contraindications based on current clinical status.")
            }
        }
            .applyCalculationToolBar(title: "Care Plan", destination: InfoButtonView(destination: Sources()))
    }
}
}

struct ClickableGroupBox<Destination: View, Content: View>: View {
    var title: String
    var icon: String
    var info: String?  // Make this optional
    var destination: Destination
    var description: String?
    var content: Content?
    
    init(title: String,
         icon: String,
         destination: Destination,
         content: Content) {
        self.title = title
        self.icon = icon
        self.destination = destination
        self.description = nil
        self.content = content
    }
    
    // Standard initializer with content
    init(title: String,
         icon: String,
         info: String,
         destination: Destination,
         content: Content) {
        self.title = title
        self.icon = icon
        self.info = info
        self.destination = destination
        self.description = nil
        self.content = content
    }
    
    // Initializer with description only
    init(title: String,
         icon: String,
         destination: Destination,
         description: String) where Content == EmptyView {
        self.title = title
        self.icon = icon
        self.info = nil 
        self.destination = destination
        self.description = description
        self.content = nil
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            GroupBox {
              
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        Label(title, systemImage: icon)
                            .font(.system(size: 14))
                            
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    Divider()
                        .frame(height: 0.3)
                        .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.bottom, 5)
                    // Use the description parameter if provided, else use info if provided
                    if let description = description {
                        Text(description)
                            .font(.system(size: 14))
                    } else if let info = info {
                        Text(info)
                            .font(.system(size: 14))
                        
                        
                    }
                    
                    // Show content if provided
                    if let content = content {
                        content
                    }
                }
            
            }
            .customGroupBoxStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ABGCardInfo: View {
    
    @Binding var ABGData: ABG
    
    var body: some View {
        HStack{
            Spacer()
            Diagnostic(valueName: "pH", value: ABGData.pH, unit: "", isNormal: isNormal(value: ABGData.pH, range: ABGData.normalRanges.pH))
            Spacer()
            Diagnostic(valueName: "PaCO₂", value: ABGData.paCO2, unit: "mmHg", isNormal: isNormal(value: ABGData.paCO2, range: ABGData.normalRanges.paCO2))
            Spacer()
            Diagnostic(valueName: "HCO₃", value: ABGData.HCO3, unit: "mEq/L", isNormal: isNormal(value: ABGData.HCO3, range: ABGData.normalRanges.HCO3))
            Spacer()
            Diagnostic(valueName: "B.E", value: ABGData.BE, unit: "mEq/L", isNormal: isNormal(value: ABGData.BE, range: ABGData.normalRanges.BE))
            Spacer()
            Diagnostic(valueName: "PaO₂", value: ABGData.paO2, unit: "mmHg", isNormal: isNormal(value: ABGData.paO2, range: ABGData.normalRanges.paO2))
            Spacer()
            Diagnostic(valueName: "SaO₂", value: ABGData.saO2, unit: "%",isNormal: isNormal(value: ABGData.saO2, range: ABGData.normalRanges.saO2))
            Spacer()
        }
    }
}
struct VentCardInfo: View {
    
    @Binding var VentData: VentSettings
    
    var body: some View {
        HStack{
            Spacer()
            VentSettingsInput(valueName: "VT", value: VentData.VT, unit: "mL")
            Spacer()
            VentSettingsInput(valueName: "RR", value: VentData.RR, unit: "b/min")
            Spacer()
            VentSettingsInput(valueName: "FiO₂", value: VentData.FiO₂, unit: "%")
            Spacer()
            VentSettingsInput(valueName: "PEEP", value: VentData.PEEP, unit: "cmH₂O")
            Spacer()
            VentSettingsInput(valueName: "IT", value: VentData.IT, unit: "sec")
            Spacer()
            VentSettingsInput(valueName: "I:E", value: VentData.IE, unit: "ratio")
            Spacer()
        }
    }
}
struct VentAdjustmentCardInfo: View {
    
    @Binding var VentData: VentSettings
    
    var body: some View {
        HStack{
            Spacer()
            VentSettingAdjustment(valueName: "VT", value: VentData.VT, unit: "mL", arrowDirection: "arrowtriangle.up.fill")
            Spacer()
            VentSettingAdjustment(valueName: "RR", value: VentData.RR, unit: "b/min", arrowDirection: "arrow.up")
            Spacer()
            VentSettingAdjustment(valueName: "FiO₂", value: VentData.FiO₂, unit: "%", arrowDirection: "arrow.up.circle.dotted")
            Spacer()
            VentSettingAdjustment(valueName: "PEEP", value: VentData.PEEP, unit: "cmH₂O", arrowDirection: "arrowshape.up.fill")
            Spacer()
            VentSettingAdjustment(valueName: "IT", value: VentData.IT, unit: "sec", arrowDirection: "")
            Spacer()
            VentSettingAdjustment(valueName: "I:E", value: VentData.IE, unit: "ratio", arrowDirection: "")
            Spacer()
        }
    }
}
//#Preview {
//    // Create a preview data instance
//    let previewData = PatientData()
//    
//    // Set up ABG preview data with reasonable values
//    previewData.ABGClass.pH = 7.30
//    previewData.ABGClass.paCO2 = 40
//    previewData.ABGClass.HCO3 = 18
//    previewData.ABGClass.paO2 = 40
//    previewData.ABGClass.saO2 = 95
//    previewData.ABGClass.BE = 0
//    
//    // Set up VentSettings preview data
//    previewData.VentSettingsClass.VT = 500
//    previewData.VentSettingsClass.RR = 12
//    previewData.VentSettingsClass.FiO₂ = 40
//    previewData.VentSettingsClass.PEEP = 5
//    previewData.VentSettingsClass.IT = 1.0
//    previewData.VentSettingsClass.IE = 1.2
//    previewData.VentSettingsClass.ventilationMode = "VC/AC"
//    previewData.VentSettingsClass.ventilationType = "Invasive"
//    
//    // Return the Views with constant bindings for preview
//    return Views(
//           ABGData: .constant(previewData.ABGClass),
//           VentData: .constant(previewData.VentSettingsClass),
//           VentParameters: .constant(previewData.VentParametersClass) // Add this line
//       )
//}

#Preview{
    TabBar()
}

struct TabBar: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab)
        {
//            VentSim()
//                .tabItem {
//                    Image(systemName: "lungs.fill")
//                    Text("Simulator")
//                }
         
            ABGAnalysis()
                .tabItem{
                    Image(systemName: "syringe.fill")
                    Text("ABG Analysis")
                }
                .tag(0)
            Calculations()
                .tabItem{
                    Image(systemName: "lightswitch.on.fill")
                    Text("Calculators")
                        .padding()
                }
                
            MorePage()
                .tabItem{
//                    Image(systemName: "circle.hexagonpath.fill")
                    Image(systemName: "ellipsis")
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
            .minimumScaleFactor(0.1)
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
                    .font(.system(size: 14))
                    .padding(.top,2)
                    .padding(.bottom,0.5)
                    .foregroundColor(value == nil ? .gray : (isNormal ? .primary : .red))
        Text("\(valueName)")
                    .font(.system(size: 10))
                    .padding(.bottom,0.5)
            
        Text("\(unit)")
                .font(.system(size: 8))
                .foregroundColor(.secondary)
               
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
                    .font(.system(size: 14))
                    .padding(.top,2)
                    .padding(.bottom,0.5)

        Text("\(valueName)")
                    .font(.system(size: 10))
                    .padding(.bottom,0.5)
            
        Text("\(unit)")
                .font(.system(size: 8))
                .foregroundColor(.secondary)
               
        }
    }
}
struct VentSettingAdjustment: View {
    
    let valueName: String
    let value: Double?
    let unit: String
    let arrowDirection: String?
  
    var formattedValue: String {
        if let value = value {
            return String(value)
        } else {
            return "-"
        }
    }

    var body: some View {
        if arrowDirection == nil {
            VStack{
                    Text(formattedValue)
                        .font(.system(size: 14))
                        .padding(.top,2)
                        .padding(.bottom,0.5)
                
                Text("\(valueName)")
                    .font(.system(size: 10))
                    .padding(.bottom,0.5)
                
                Text("\(unit)")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
        } else {
            VStack{
             
                    Text(formattedValue)
                        .font(.system(size: 14))
                        .padding(.top,2)
                        .padding(.bottom,0.5)
                
                HStack{
                    Image(systemName: arrowDirection!)
                        .font(.system(size: 9))
                        .foregroundStyle(.blue)
                    Text("\(valueName)")
                        .font(.system(size: 10))
                        .padding(.bottom,0.5)
                }
                Text("\(unit)")
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
               
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
           
                Text(text)
       
            
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
            VStack(spacing: 10){
                NewPageButtonView(
                    text: "How to Calculate?",
                    icon: "",
                    destination: infopage
                )
                NewPageButtonView(
                    text: "View Case Study",
                    icon: "",
                    destination: AaGradientCalculationCaseStudy()
                )
            }
            
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
struct patientInformationGenderPicker: View {
    
    @Binding var gender: String?
    
    let genders = ["M", "F"]
    
    var body: some View {
        HStack {
            Text("Gender")
                .frame(width: 75, alignment: .center) // Match InputField label width
            
            ZStack {
                // Create a container to match the TextField's appearance
//                RoundedRectangle(cornerRadius: 6)
//                    .fill(Color(UIColor.systemBackground))
//                    .frame(width: 80, height: 35) // Match TextField size
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 6)
//                            .stroke(Color(UIColor.systemGray4), lineWidth: 0.5)
//                    )
                
                // Picker inside the ZStack
                Picker("", selection: Binding(
                    get: { gender ?? "M" },
                    set: { gender = $0 }
                )) {
                    ForEach(genders, id: \.self) { option in
                        Text(option)
                            .font(.system(size: 13)) // Smaller font to fit
                            .tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 80) // Slightly smaller to fit in the container
                .scaleEffect(0.9) // Scale down slightly if needed
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
                .onChange(of: selectedFeet) { oldValue, NewValue in
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
                .onChange(of: selectedInches) { oldValue, newValue in
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

struct patientInformationHeightPicker: View {
    
    @Binding var height: Double?
    @State private var selectedFeet = 0
    @State private var selectedInches = 0
   
    
    var body: some View {
        
        HStack{
            
            Text("Height")
                .frame(width: 75, alignment: .center)
            
            ZStack{
                
                Picker("Feet", selection: $selectedFeet) {
                    ForEach(0..<9) {feet in
                        Text("\(feet)").tag(feet)
                            .font(.system(size: 13, weight: .bold))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 40)
                .onChange(of: selectedFeet) { oldValue, NewValue in
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
                .frame(width: 100, height: 40)
                .pickerStyle(WheelPickerStyle())
                .onChange(of: selectedInches) { oldValue, newValue in
                    convertFeetToInches()
                }
            }
            Text("in")
                .font(.system(size: 10))
            
        }
    }
    
    func convertFeetToInches (){
      height = Double(selectedFeet * 12 + selectedInches)
    }
}

/// This is pretty much a button that takes a sheet and removes it
struct BackButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var systemImage: String
    var title: String?
    
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

struct InfoButtonView <Content: View>: View {
    
    @State private var showSheet: Bool = false
    var destination: Content
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
           destination
                .presentationDragIndicator(.visible)
                .presentationDetents([.large])
                .presentationCornerRadius(20)
           
        }
        .padding()
        
    }
}


struct InfoButtonView2<Content: View>: View {
    
    @State private var showSheet: Bool = false
    var content: Content
    
    // This initializer allows passing content directly
    init(content: Content) {
        self.content = content
    }
    
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
            content
                .presentationDetents([.large])
        }
        .padding()
    }
}


struct CustomGroupBoxStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .backgroundStyle(.regularMaterial)
            .padding(.vertical, 8)
            .padding(.horizontal)
        
    }
}

extension View {
    func customGroupBoxStyle(backgroundColor: Color = Color(.systemBackground)) -> some View {
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
    
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .bold()
            .lineLimit(1)
            .padding(.horizontal)
            .frame(width: 200, height: 18)
            .padding(.vertical, 5)
            .multilineTextAlignment(.center)
            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            .padding(10)
            .background(.regularMaterial)
            .cornerRadius(30)
            .shadow(color:.black.opacity(0.1),radius: 2, x: 2 , y: 2)
//            .background(
//                LinearGradient(
//                    gradient: colorScheme == .dark ? Gradient(colors: [.cyan,.blue]) : Gradient(colors: [.cyan.opacity(0.8), .cyan, .cyan.opacity(0.8)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
////                    gradient: colorScheme == .dark ? Gradient(colors: [.cyan.opacity(0.8), .cyan, .cyan.opacity(0.8)]) : Gradient(colors: [.cyan, .blue, .cyan]),
////                    startPoint: .topLeading,
////                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke((colorScheme == .dark ? Color.cyan : Color.white), lineWidth: 1)
            )
//            .shadow(color:.black.opacity(0.2),radius: 1, x: 1 , y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            gradient: colorScheme == .dark ? Gradient(colors: [.black.opacity(0.1), .clear,.black.opacity(0.1)]) : Gradient (colors: [.white.opacity(0.2),.clear, .clear, .clear, .white.opacity(0.2)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .padding(2)
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 1, y: 1)
            .padding(.top, 10)
    }
}


struct AcidBaseBalanceInstructionsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter your patient's information and ABG results to receive an ABG interpretation and treatment recommendations.")
        }
        .padding()
    }
}

struct CarePlanInstructionsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter your patient's information, vital signs, ABG results, vent settings, and vent parameters to receive recommended vent setting changes and treatment for acid-base balance.")
        }
        .padding()
    }
}

struct AboutPulmoroPage: View {
    var body: some View {
        ScrollView{
            
            
  
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
        .navigationBarTitle("About Pulmoro", displayMode: .automatic)
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
        .navigationBarTitle("Arterial Blood Gas Analysis", displayMode: .automatic)
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

//struct MovingGradientView: View {
//    @State private var startPoint = UnitPoint(x: 0.4, y: 0.4)
//    @State private var endPoint = UnitPoint(x: 0.6, y: 0.6)
//    
//
//    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
//    let colors: [Color]
//    
//    var body: some View {
//        Rectangle()
//            .fill(
//                LinearGradient(
//                    gradient: Gradient(colors: colors),
//                    startPoint: startPoint,
//                    endPoint: endPoint
//                )
//            )
//            .onReceive(timer) { _ in
//               
//                withAnimation(.easeInOut(duration: 4)) {
//                    
//                    startPoint = UnitPoint(x: CGFloat.random(in: 0.35...0.45),
//                                           y: CGFloat.random(in: 0.35...0.45))
//                    endPoint = UnitPoint(x: CGFloat.random(in: 0.50...0.65),
//                                         y: CGFloat.random(in: 0.50...0.65))
//                }
//            }
//    }
//}
struct MovingGradientView: View {
    @State private var startPoint = UnitPoint(x: 0.1, y: 0.1)
    @State private var endPoint = UnitPoint(x: 0.9, y: 0.9)
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    let colors: [Color]
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            )
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 4)) {
                 
                    startPoint = UnitPoint(x: CGFloat.random(in: 0.05...0.60),
                                           y: CGFloat.random(in: 0.05...0.60))
                    endPoint = UnitPoint(x: CGFloat.random(in: 0.85...0.95),
                                         y: CGFloat.random(in: 0.85...0.95))
                }
            }
    }
}


struct InputField: View {
    //THis is the label that appears next to the text field
    var label: String
    // THe unit of measurment will appear in the box for example if the text field is labeled Time then the unit can be named sec for seconds, or min for minutes.
    var units: String
    //The binding variable is whats going to bind the information in the text field.
    @Binding var value: Double
    //
    @State private var text : String = ""
    
@FocusState private var amountIsFocused: Bool
    
    var body: some View {
        HStack{
            Text(label)
                .frame(width: 75, alignment: .center)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            ZStack{
                //This is the textfield
                TextField("", text: $text)
                                .keyboardType(.decimalPad)
                                .onChange(of: text) { oldValue, newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered.count <= 4 {
                                        text = filtered
                                        if let numberedValue = Double(text) {
                                            value = numberedValue
                                        }
                                    }
                                }
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                                .keyboardType(.decimalPad)
                                .focused($amountIsFocused)
                               
                
                              
                //This is where the units will appear
                            Text(units)
                                .font(.system(size: 10, weight: .thin))
                                .frame(width: 70, alignment: .trailing)
                                .padding(5)
            }
        }
    }
 
}

struct BiggerInputField: View {
    var label: String
    var units: String
    
    @Binding var value: Double
    @State private var text : String = ""
    
    var body: some View {
        HStack{
            Text(label)
                .frame(width: 100, alignment: .center)
            ZStack{
                
                TextField("", text: $text)
                                .keyboardType(.decimalPad)
                                .onChange(of: text) { oldValue, newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered.count <= 4 {
                                        text = filtered
                                        if let numberedValue = Double(text) {
                                            value = numberedValue
                                        }
                                    }
                                }
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 90)
                            Text(units)
                                .font(.system(size: 10, weight: .thin))
                                .frame(width: 70, alignment: .trailing)
                                .padding(5)
                }
        }
    }
}

struct NavigationBox<Content: View>: View {
    var destination: Content
var systemImage: String
    var title: String
    var description: String
    var body: some View {
        NavigationLink(destination: destination) {
            GroupBox {
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(Image(systemName: systemImage))  \(title)")
                            .font(.title)
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)

                        
                    }
                    Divider()
                        .frame(height: 1)
                        .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.bottom, 5)
                    Text(description)
                    .font(.body)
                }
                
            }
            .customGroupBoxStyle3()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomGroupBoxStyle3: ViewModifier {
 
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0.5, y: 0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
            content
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension View {
    func customGroupBoxStyle3(backgroundColor: Color = Color(.systemBackground)) -> some View {
        self.modifier(CustomGroupBoxStyle3())
        
    }
}

