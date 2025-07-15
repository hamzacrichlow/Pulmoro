//
//  SwiftUIView 3.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 1/14/25.
//

import SwiftUI



struct CarePlan: View {
    
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
                    CarePlanInstructionsView()
                   
                    PatientInformationView(PatientInformationData: $patientData.PatientInformatioinClass)
                   
                    VitalsView(VitalsData: $patientData.VitalsClass)
                    
                    
                    ABGView(ABGData: $patientData.ABGClass)
                    
                    VentSettingsAndParametersView(VentData: $patientData.VentSettingsClass, VentParametersData: $patientData.VentParametersClass)
                    
                    NavigationLink(destination: Views(ABGData: $patientData.ABGClass, VentData: $patientData.VentSettingsClass, VentParameters: $patientData.VentParametersClass)) {
                                              Text("Create Care Plan")
                                          }
                                          .buttonStyle(CustomButtonStyle())
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Care Plan", displayMode: .automatic)
            .toolbar {
               
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(systemImage: "chevron.backward")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    InfoButtonView(destination: Sources())
                          }
            }
        }
        }
    }
}
        
    
    

#Preview {
    CarePlan()
}




struct PatientInformationView: View{
    
    @Binding var PatientInformationData: PatientInformation
    
    var isCompleted: Bool {
         // You can add stricter conditions here as needed
         return (PatientInformationData.age ?? 0) > 0 &&
                (PatientInformationData.height ?? 0) > 0 &&
                (PatientInformationData.weight ?? 0) > 0 &&
                !(PatientInformationData.gender?.isEmpty ?? true)
     }
    
     var body: some View {
         GroupBox(label: Label("Patient Information", systemImage: "person.fill")){
             Divider()
                 .frame(height: 1)
                 .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                 .padding(.bottom, 5)
          
                 VStack{
                     HStack{
                         InputField(label: "Age", units: "", value: Binding(
                            get: {PatientInformationData.age ?? 0.0},
                            set: {PatientInformationData.age = $0}
                         ))
                         Spacer()
                         patientInformationGenderPicker(gender: $PatientInformationData.gender)
                     }
                     HStack{
                         InputField(label: "Height", units: "inches", value: Binding(
                            get: {PatientInformationData.age ?? 0.0},
                            set: {PatientInformationData.age = $0}
                         ))
                         Spacer()
                         InputField(label: "Weight", units: "lbs", value: Binding(
                            get: {PatientInformationData.age ?? 0.0},
                            set: {PatientInformationData.age = $0}
                         ))
                     }
                 }
             
         }
         .customGroupBoxStyle2(isCompleted: isCompleted)
         
    }
}


struct VitalsView: View {
    
    @Binding var VitalsData: Vitals
    
    var body: some View {
        GroupBox(label: Label("Vital Signs", systemImage: "waveform.path.ecg")){
            Divider()
                .frame(height: 1)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(.bottom, 5)
            HStack{
                ZStack{
                    
                VStack{
                    InputField(label: "HR", units: "b/min", value: Binding(
                        get: {VitalsData.HR ?? 0.0},
                        set: {VitalsData.HR = $0}
                    ))
                    ZStack{
                     
                       
                            Divider()
                                .frame(width: 70)
                                .frame(height:0.1)
                                .padding(.leading, 80)
                                .overlay(.primary)
                        
                    
                        VStack{
                            InputField(label: "Systolic", units: "mmHg", value: Binding(
                                get: {VitalsData.systolicBP ?? 0.0},
                                set: {VitalsData.systolicBP = $0}
                            ))
                            
                            InputField(label: "Diastolic", units: "mmHg", value: Binding(
                                get: {VitalsData.diastolicBP ?? 0.0},
                                set: {VitalsData.diastolicBP = $0}
                            ))
                        }
                    }
                    
                }
            }
                VStack{
                    InputField(label: "SpO2", units: "%", value: Binding(
                        get: {VitalsData.SpO2 ?? 0.0},
                        set: {VitalsData.SpO2 = $0}
                    ))
                    InputField(label: "RR", units: "b/min", value: Binding(
                        get: {VitalsData.f ?? 0.0},
                        set: {VitalsData.f = $0}
                    ))
                    InputField(label: "Temp", units: "C °", value: Binding(
                        get: {VitalsData.temp ?? 0.0},
                        set: {VitalsData.temp = $0}
                    ))
                }
            }
        }
        .customGroupBoxStyle()
    }
}


struct VentSettingsView: View {
    @Binding var VentData: VentSettings
    var body: some View {
        
        GroupBox(label: Label("Vent Settings", systemImage: "inset.filled.tv")) {
            Divider()
                .frame(height: 1)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(.bottom, 5)
            Picker("Ventilation Type", selection: $VentData.ventilationType) {
                Text("Invasive").tag("Invasive")
                Text("Noninvasive").tag("Noninvasive")
            }
            .customSegmentedPickerStyle()
            
            if VentData.ventilationType == "Invasive" {
                InvasiveVentSettingsView(VentData: $VentData)
            } else {
                NonInvasiveVentSettingsView(VentData: $VentData)
            }
        }
        .customGroupBoxStyle()
       
    }
}


struct VentParametersView: View {
    @Binding var VentParametersData: VentParameters
    @Binding var VentData: VentSettings
    var body: some View {
        GroupBox(label: Label("Vent Parameters", systemImage: "lungs.fill")) {
            Divider()
                .frame(height: 1)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(.bottom, 5)
            HStack{
                if VentData.ventilationType == "Invasive"{
                    
                    
                    VStack{
                        InputField(label: "VTe", units: "mL", value: Binding(
                            get: {VentParametersData.VTe ?? 0.0},
                            set: {VentParametersData.VTe = $0}
                        ))
                        InputField(label: "fTOT", units: "b/min", value: Binding(
                            get: {VentParametersData.fTOT ?? 0.0},
                            set: {VentParametersData.fTOT = $0}
                        ))
                        InputField(label: "PIP", units: "cmH20", value: Binding(
                            get: {VentParametersData.PIP ?? 0.0},
                            set: {VentParametersData.PIP = $0}
                        ))
                    }
                    
                    VStack{
                        InputField(label: "MAP", units: "cmH20", value: Binding(
                            get: {VentParametersData.MAP ?? 0.0},
                            set: {VentParametersData.MAP = $0}
                        ))
                        InputField(label: "pPlat", units: "cmH20", value: Binding(
                            get: {VentParametersData.pPlat ?? 0.0},
                            set: {VentParametersData.pPlat = $0}
                        ))
                        InputField(label: "autoPEEP", units: "cmH20", value: Binding(
                            get: {VentParametersData.autoPEEP ?? 0.0},
                            set: {VentParametersData.autoPEEP = $0}
                        ))
                        
                    }
                    
                } else {
                    VStack{
                        InputField(label: "VTe", units: "mL", value: Binding(
                            get: {VentParametersData.VTe ?? 0.0},
                            set: {VentParametersData.VTe = $0}
                        ))
                        InputField(label: "fTOT", units: "b/min", value: Binding(
                            get: {VentParametersData.fTOT ?? 0.0},
                            set: {VentParametersData.fTOT = $0}
                        ))
                    }
                    VStack{
                        InputField(label: "PIP", units: "cmH20", value: Binding(
                            get: {VentParametersData.PIP ?? 0.0},
                            set: {VentParametersData.PIP = $0}
                        ))
                        InputField(label: "Leak", units: "%", value: Binding(
                            get: {VentParametersData.ptLeak ?? 0.0},
                            set: {VentParametersData.ptLeak = $0}
                        ))
                    }
                }
            }
        }
        .customGroupBoxStyle()
       
    }
}





///This View handles the changing of parameters based on if the patient is on Invasive or Non-invasive Ventilation ventilation. It will Change the Vent Parameters Group Box to match invasive or noninvasive..
struct VentSettingsAndParametersView: View {
    @Binding var VentData: VentSettings
    @Binding var VentParametersData: VentParameters
    var body: some View {
        VStack {
            VentSettingsView(VentData: $VentData)
            VentParametersView(VentParametersData: $VentParametersData, VentData: $VentData)
        }
    }
}

struct InvasiveVentSettingsView: View {
    @Binding var VentData: VentSettings

    var body: some View {
        Picker("Ventilation Mode", selection: $VentData.ventilationMode) {
            Text("PRVC").tag("PRVC")
            Text("VC/AC").tag("VC/AC")
            Text("PC/AC").tag("PC/AC")
        }
        .customSegmentedPickerStyle()

        if VentData.ventilationMode == "PRVC" {
            PRVCModeView(PRVCData: $VentData)
        } else if VentData.ventilationMode == "VC/AC" {
            VCACView(VCACData: $VentData)
        } else if VentData.ventilationMode == "PC/AC" {
            PCACView(PCACData: $VentData)
        }
    }
}

struct NonInvasiveVentSettingsView: View {
    @Binding var VentData: VentSettings

    var body: some View {
        Picker("Ventilation Mode", selection: $VentData.ventilationMode) {
            Text("CPAP").tag("CPAP")
            Text("BiPAP").tag("BiPAP")
        }
        .customSegmentedPickerStyle()

        if VentData.ventilationMode == "CPAP" {
            CPAPView(CPAPData: $VentData )
        } else if VentData.ventilationMode == "BiPAP" {
            BiPAPView(BiPAPData: $VentData )
        }
    }
}

struct PRVCModeView: View {
@Binding var PRVCData: VentSettings
    
    var body: some View {
        HStack{
            VStack{
                InputField(label: "VT", units: "mL", value: Binding(
                    get: {PRVCData.VT ?? 0.0},
                    set: {PRVCData.VT = $0}
                ))
                InputField(label: "RR", units: "b/min", value: Binding(
                    get: {PRVCData.RR ?? 0.0},
                    set: {PRVCData.RR = $0}
                ))
                InputField(label: "FiO₂", units: "%", value: Binding(
                    get: {PRVCData.FiO₂ ?? 0.0},
                    set: {PRVCData.FiO₂ = $0}
                ))
            }
            VStack{
                InputField(label: "PEEP", units: "cmH₂0", value: Binding(
                    get: {PRVCData.PEEP ?? 0.0},
                    set: {PRVCData.PEEP = $0}
                ))
                InputField(label: "IT", units: "sec", value: Binding(
                    get: {PRVCData.IT ?? 0.0},
                    set: {PRVCData.IT = $0}
                ))
                InputField(label: "I:E", units: "", value: Binding(
                    get: {PRVCData.IE ?? 0.0},
                    set: {PRVCData.IE = $0}
                ))
            }
        }
    }
}



struct VCACView: View {
    
    @Binding var VCACData: VentSettings
    
    var body: some View {
        HStack{
            VStack{
                InputField(label: "VT", units: "mL", value: Binding(
                    get: {VCACData.VT ?? 0.0},
                    set: {VCACData.VT = $0}
                ))
                InputField(label: "RR", units: "b/min", value: Binding(
                    get: {VCACData.RR ?? 0.0},
                    set: {VCACData.RR = $0}
                ))
                InputField(label: "FiO₂", units: "%", value: Binding(
                    get: {VCACData.FiO₂ ?? 0.0},
                    set: {VCACData.FiO₂ = $0}
                ))
             
            }
            VStack{
                InputField(label: "PEEP", units: "cmH₂0", value: Binding(
                    get: {VCACData.PEEP ?? 0.0},
                    set: {VCACData.PEEP = $0}
                ))
                InputField(label: "flow", units: "l/min", value: Binding(
                    get: {VCACData.flow ?? 0.0},
                    set: {VCACData.flow = $0}
                ))
                InputField(label: "I:E", units: "", value: Binding(
                    get: {VCACData.IE ?? 0.0},
                    set: {VCACData.IE = $0}
                ))
            }
        }
    }
}

struct PCACView: View {
    
    @Binding var PCACData: VentSettings

    var body: some View {
        HStack{
            VStack{
                InputField(label: "PC", units: "cmH₂0", value: Binding(
                    get: {PCACData.PC ?? 0.0},
                    set: {PCACData.PC = $0}
                ))
                InputField(label: "RR", units: "b/min", value: Binding(
                    get: {PCACData.RR ?? 0.0},
                    set: {PCACData.RR = $0}
                ))
                InputField(label: "FiO₂", units: "%", value: Binding(
                    get: {PCACData.FiO₂ ?? 0.0},
                    set: {PCACData.FiO₂ = $0}
                ))
             
            }
            VStack{
    
                InputField(label: "PEEP", units: "cmH₂0", value: Binding(
                    get: {PCACData.PEEP ?? 0.0},
                    set: {PCACData.PEEP = $0}
                ))
                InputField(label: "IT", units: "sec", value: Binding(
                    get: {PCACData.IT ?? 0.0},
                    set: {PCACData.IT = $0}
                ))
                InputField(label: "I:E", units: "", value: Binding(
                    get: {PCACData.IE ?? 0.0},
                    set: {PCACData.IE = $0}
                ))
            }
        }
    }
}


struct CPAPView: View {
    
    @Binding var CPAPData: VentSettings
    
    var body: some View {
        
        HStack{
            VStack{
                InputField(label: "PEEP", units: "cmH₂0", value: Binding(
                    get: {CPAPData.PEEP ?? 0.0},
                    set: {CPAPData.PEEP = $0}
                ))
            
                Spacer()
            }
            VStack{
                InputField(label: "FiO₂", units: "%", value: Binding(
                    get: {CPAPData.FiO₂ ?? 0.0},
                    set: {CPAPData.FiO₂ = $0}
                ))
               Spacer()
            }
        }
    }
}

struct BiPAPView: View {
    
    @Binding var BiPAPData: VentSettings
    
    var body: some View {
        HStack{
            VStack{
                InputField(label: "PEEP", units: "cmH₂0", value: Binding(
                    get: {BiPAPData.PEEP ?? 0.0},
                    set: {BiPAPData.PEEP = $0}
                ))
                InputField(label: "FiO₂", units: "%", value: Binding(
                    get: {BiPAPData.FiO₂ ?? 0.0},
                    set: {BiPAPData.FiO₂ = $0}
                ))
                    InputField(label: "PS", units: "cmH₂0", value: Binding(
                        get: {BiPAPData.PEEP ?? 0.0},
                        set: {BiPAPData.PEEP = $0}
                    ))
                Spacer()
            }
            VStack{
                
              Spacer()
            }
        }
    }
}


