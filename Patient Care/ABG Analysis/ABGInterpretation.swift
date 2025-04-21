//
//  SwiftUIView.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/13/25.
//

import SwiftUI

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
                                              Text("ABG Interpretation")
                                          }
                                          .buttonStyle(CustomButtonStyle())
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("ABG Analysis", displayMode: .automatic)
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
        //Interpretation.1 is Acid Base
        //Interpretation.2 is Oxygenation Status
        //Interpretation.0 is Temporal Adjective (acute or chronic)
        //Interpretation.3 is Anion Gap
        //Interpretation.4 is condition
        
        ZStack{
            
            MovingGradientView(colors: gradientColors)
                .ignoresSafeArea(.all)
        ScrollView {
            
            GroupBox(label: Label("Arterial Blood Gas", systemImage: "syringe.fill")){
                VStack{
                    VStack{
                        //ACID BASE BALANCE
                        if interpretation.1 == ""{
                            HStack{
                                Image(systemName: "waveform.path.ecg")
                                    .foregroundStyle(.red)
                                Text("Input the pH, PaCO₂, and HCO₃ for ABG Interpretation")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 5)
                        } else if interpretation.1 == "ABG Gross Error" {
                            Text(interpretation.1)
                                .font(.title2)
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.5)
                                .padding(.bottom, 2)
                            
                        } else{Text(interpretation.1)
                                .font(.title2)
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.5)
                                .padding(.bottom, 2)
                        }
                        
                        //OXYGENATION
                        if interpretation.2 == ""{
                            HStack{
                                Image(systemName: "waveform.path.ecg")
                                    .foregroundStyle(.red)
                                Text("Input the PaO₂ for Oxygen Status Interpretation")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.red)
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text ("with \(interpretation.2)")
                                .font(.title2)
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.5)
                        }
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(2)
                    
                    
//                    Divider()
//                        .frame(height: 3)
//                        .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                        .padding(.bottom, 5)
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
            .customGroupBoxStyle1()
            
      
            
     
        
            
            VStack{
                if !interpretation.4.isEmpty{
                    if let abgInterpretation = ABGInterpretations[interpretation.4] {
                        if let description = abgInterpretation.description {
                            VStack{
                                Text("Interpretation & Treatment")
                                    .font(.title)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom,5)
                                
                                Divider()
                                    .frame(height: 3)
                                    .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                
                                
                                Text("Interpretation")
                                    .font(.headline)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom,2)
                                
                                Text(description)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                        }
                        if let treatment = abgInterpretation.treatment {
                            VStack{
                                Text("Treatment")
                                    .font(.headline)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom,2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(treatment)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                        }
                    }
                    
                }
                if !interpretation.2.isEmpty {
                    if let o2Interpretation = o2Interpretations[interpretation.2] {
                        if let  oxygenationInterpretation = o2Interpretation.oxygenationInterpretation{
                            VStack{
                                Text("Oxygenation Status")
                                    .font(.headline)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom,2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(oxygenationInterpretation)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                        }
                    }
                }
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
