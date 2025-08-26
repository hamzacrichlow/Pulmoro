//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/13/25.
//

import SwiftUI



/// The UI for inputing a patients ABG reslults
struct ABGView: View {
    @Binding var ABGData: ABG
    var body: some View {
        GroupBox(label: Label("Arterial Blood Gas", systemImage: "syringe.fill")){
            Divider()
                .frame(height: 1)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(.bottom, 5)
            HStack{
                VStack{
                    InputField(label: "pH", units: "", value: Binding(
                        get: {ABGData.pH ?? 0.0},
                        set: {ABGData.pH = $0}
                    ))
                    InputField(label: "PaCO₂", units: "mmHg", value: Binding(
                        get: {ABGData.paCO2 ?? 0.0},
                        set: {ABGData.paCO2 = $0}
                    ))
                    InputField(label: "HCO₃", units: "mEq/L", value: Binding(
                        get: {ABGData.HCO3 ?? 0.0},
                        set: {ABGData.HCO3 = $0}
                    ))
                }
                VStack{
                    InputField(label: "PaO₂", units: "mmHg", value: Binding(
                        get: {ABGData.paO2 ?? 0.0},
                        set: {ABGData.paO2 = $0}
                    ))
                    InputField(label: "SaO₂", units: "%", value: Binding(
                        get: {ABGData.saO2 ?? 0.0},
                        set: {ABGData.saO2 = $0}
                    ))
                    InputField(label: "B.E", units: "mEq/L", value: Binding(
                        get: {ABGData.BE ?? 0.0},
                        set: {ABGData.BE = $0}
                    ))
                }
            }
        }
        .customGroupBoxStyle()
      
            }
        }




/// This is the ABG Analysis page UI for the user to input the patients information and ABG. It consist of the "ABG interpretation button that navigates the user to the page displaying the ABG intepretation and treatment"
struct ABGAnalysis: View {
    
    @StateObject var patientData = PatientData()
    
    @State private var gradientColors: [Color] = [
        Color(.cyan).opacity(0.1),
        Color(.cyan).opacity(0.2),
        Color(.cyan).opacity(0.1)
    ]
    
    var body: some View {
        NavigationStack{
            ZStack{
                MovingGradientView(colors: gradientColors)
                    .ignoresSafeArea(edges: .all)
                ScrollView{
                    
                    VStack{
                        AcidBaseBalanceInstructionsView()
                        
                        PatientInformationView(PatientInformationData: $patientData.PatientInformatioinClass)
                        
                        ABGView(ABGData: $patientData.ABGClass)
                        
                        NavigationLink(destination: ABGInterpretationSheet(ABGData: $patientData.ABGClass, VentData: $patientData.VentSettingsClass)) {
                            Text("Interpret ABG")
                        }
                        .buttonStyle(CustomButtonStyle())
                        .sensoryFeedback(.impact(weight: .medium), trigger: UUID())
                        
                    }
                    
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle("ABG Analysis", displayMode: .automatic)
                .toolbar {
                    
                    //                ToolbarItem(placement: .navigationBarLeading) {
                    //                    BackButton(systemImage: "chevron.backward")
                    //                }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        InfoButtonView2(content: ABGAnalysisPopUp())
                    }
                }
            }
        }
    }
}

struct ABGInterpretationSheet: View {
    
    @Binding var ABGData: ABG
    @Binding var VentData: VentSettings
    
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
        
        let hasGrossError = interpretation.acidBaseStatus.contains("ABG Gross Error") || interpretation.conditionLabel.contains("ABG Gross Error")
        let everythingIsNormal = interpretation.acidBaseStatus.contains("Normal Acid-Base Status") && interpretation.oxygenationStatus.contains("Normal Oxygenation")

        
        ZStack {
            MovingGradientView(colors: gradientColors)
                .ignoresSafeArea(.all)
                
            ScrollView {
                // ABG Group Box
                GroupBox(label: Label("Arterial Blood Gas", systemImage: "syringe.fill")) {
                    VStack {
                        
                        // Display logic for interpretation results
                        if everythingIsNormal {
                            Text("Normal Acid-Base Balance with Normal Oxygenation")
                        } else if hasGrossError {
                            // Only show Gross Error message
                            Text("ABG Gross Error")
                                .font(.title2)
                                .bold()
                                .padding()
                                .foregroundStyle(.red)
                        } else {
                            let acidBase = interpretation.acidBaseStatus
                            let oxygenation = interpretation.oxygenationStatus

                            if acidBase == "Insufficient Data" && oxygenation == "Insufficient Data" {
                                // Only show once
                                Text("Insufficient Data")
                                    .font(.title2)
                                    .foregroundStyle(.red)
                            } else {
                                if !acidBase.isEmpty && acidBase != "Insufficient Data" {
                                    Text(acidBase)
                                        .font(.title2)
                                        .padding(.bottom, 2)
                                }
                                if !oxygenation.isEmpty && oxygenation != "Insufficient Data" {
                                    Text("with \(oxygenation)")
                                        .font(.title2)
                                }
                                if (acidBase == "Insufficient Data" && oxygenation != "Insufficient Data") ||
                                   (oxygenation == "Insufficient Data" && acidBase != "Insufficient Data") {
                                    Text("Insufficient Data")
                                        .font(.title2)
                                        .foregroundStyle(.red)
                                }
                            }
                        }

                        
                        // Display diagnostic values regardless of error status
                        Divider()
                        HStack {
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
                            Diagnostic(valueName: "SaO₂", value: ABGData.saO2, unit: "%", isNormal: isNormal(value: ABGData.saO2, range: ABGData.normalRanges.saO2))
                            Spacer()
                        }
//                        .padding(8)
                    }
                }
                .customGroupBoxStyle1()
                if everythingIsNormal {
               Text ("All values are within normal physiological ranges. pH, PaCO₂, and HCO₃ indicate balanced acid-base status. Oxygenation parameters are adequate. No intervention required.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
            }else if !hasGrossError {
                // Only display interpretation and treatment sections if there's NO gross error
                    VStack {
                        // Acid-base interpretation section
                        if !interpretation.conditionLabel.isEmpty {
                            if let abgInterpretation = ABGInterpretations[interpretation.conditionLabel] {
                                if let description = abgInterpretation.description {
                                    VStack {
                                        
                                        Divider()
                                            .frame(height: 3)
                                            .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        
                                        Text("Interpretation")
                                            .font(.headline)
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.bottom, 2)
                                        
                                        Text(description)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding()
                                }
                                
                                if let treatment = abgInterpretation.treatment {
                                    VStack {
                                        Text("Treatment")
                                            .font(.headline)
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.bottom, 2)
                                        
                                        Text(treatment)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding()
                                }
                            }
                        }
                        
                        // Oxygenation interpretation section
                        if !interpretation.oxygenationStatus.isEmpty {
                            if let o2Interpretation = o2Interpretations[interpretation.oxygenationStatus] {
                                if let oxygenationInterpretation = o2Interpretation.oxygenationInterpretation {
                                    VStack {
                                        Text("Oxygenation Status")
                                            .font(.headline)
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.bottom, 2)
                                        
                                        Text(oxygenationInterpretation)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                } else {
                    // Show error explanation when there's a gross error
                    VStack {
                        Text("What is an ABG Gross Error?")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 2)
                        
                        Text("The values entered are physiologically implausible or inconsistent with each other. This may indicate measurement errors, incorrect data entry, or extremely abnormal patient conditions requiring immediate clinical assessment.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("ABG Interpretation", displayMode: .automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(systemImage: "chevron.backward")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    InfoButtonView2(content: ABGAnalysisPopUp())
                }
            }
        }
    }
}

struct ABGAnalysisPopUp: View {
    var body: some View {
        Text("Hello, World!")
    }
}



            
struct VentSettingInterpretationSheet: View {
    
    @Binding var VentData: VentSettings
    @Binding var VentParameters: VentParameters
    
    var body: some View {
        VStack{
            if !checkSettings(VT: VentData.VT, RR: VentData.RR, FiO2: VentData.FiO₂, PEEP: VentData.PEEP, IT: VentData.IT, IE: VentData.IE) {
                HStack{
                    Image(systemName: "waveform.path.ecg")
                        .padding(.leading, 20)
                        .foregroundStyle(.red)
                    Text("Input Ventilator Settings and Parameters")
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(.red)
                    
                }
                .padding(.bottom, 5)
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            GroupBox(label: Label("\(VentData.ventilationType) Ventilation", systemImage: "inset.filled.tv")){
                VStack{
                    Divider()
                        .frame(height: 3)
                        .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.bottom, 5)
                    Text("\(VentData.ventilationMode) Settings:")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
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
                Divider()
                    .frame(height: 0.5)
                    .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding()
                
                VStack{
                    Text("Parameters:")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        Spacer()
                        VentSettingsInput(valueName: "VTe", value: VentParameters.VTe, unit: "mL")
                        Spacer()
                        VentSettingsInput(valueName: "fTOT", value: VentParameters.fTOT, unit: "b/min")
                        Spacer()
                        VentSettingsInput(valueName: "PIP", value: VentParameters.PIP, unit: "cmH₂O")
                        Spacer()
                        VentSettingsInput(valueName: "MAP", value: VentParameters.MAP, unit: "cmH₂O")
                        Spacer()
                        VentSettingsInput(valueName: "Pplat", value: VentParameters.pPlat, unit: "cmH₂O")
                        Spacer()
                    }
                }
            }
            .customGroupBoxStyle()
        }
    }
}

struct bloodGasInterpretation: View {
   
    @Binding var ABGData: ABG
    @Binding var VentData: VentSettings
    @Binding var VentParameters: VentParameters
    
    var body: some View {
        ScrollView{
            

            ABGInterpretationSheet(ABGData: $ABGData, VentData: $VentData)
//            VentSettingInterpretationSheet(VentData: $VentData, VentParameters: $VentParameters)
        }
    }
}
 
#Preview {
//    BalancepH(ABGData: ABGClass,
//              VentData: $patientData.VentSettingsClass,
//              VentParameters: $patientData.VentParametersClass)
    let patientData = PatientData()
        return bloodGasInterpretation(
            ABGData: .constant(patientData.ABGClass),
            VentData: .constant(patientData.VentSettingsClass),
            VentParameters: .constant(patientData.VentParametersClass)
            )
}
