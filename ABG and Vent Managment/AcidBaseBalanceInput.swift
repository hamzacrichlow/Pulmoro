//
//  SwiftUIView 3.swift
//  RespTherapist
//
//  Created by Hamza Crichlow on 1/14/25.
//

import SwiftUI


struct AcidBaseBalanceInput: View {
    
    @StateObject var patientData = PatientData()
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    AcidBaseBalanceInstructionsView()
                    PatientInformationView(PatientInformationData: $patientData.PatientInformatioinClass)
                    VitalsView(VitalsData: $patientData.VitalsClass)
                  
                    
                    ABGView(ABGData: $patientData.ABGClass)
                    
                    VentSettingsAndParametersView(VentData: $patientData.VentSettingsClass, VentParametersData: $patientData.VentParametersClass)
                    
                    Button("Interpret ABG") {
                        showSheet.toggle()
                    }
                    .sheet(isPresented: $showSheet){
                        Views(ABGData: $patientData.ABGClass, VentData: $patientData.VentSettingsClass, VentParameters: $patientData.VentParametersClass)
                    }
                    .buttonStyle(CustomButtonStyle())
                }
                
            }
            .navigationTitle(Text("Acid Base Balance"))
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    InfoButtonView()
                }
            }
        }
    }
}
        
    
    

#Preview {
    AcidBaseBalanceInput()
}


struct PatientInformation {
    var age: Double?
    var height: Double?
    var gender: String?
}

/// Arterial Blood Gas (ABG) lab values.
struct ABG {
    var FiO2: Double?
    var pH: Double?
    var paCO2: Double?
    var HCO3: Double?
    var paO2: Double?
    var saO2: Double?
    var BE: Double?
    
    /// Normal Ranges for ABG lab values.
    struct NormalRanges {
        let pH: ClosedRange<Double>
        let paCO2: ClosedRange<Double>
        let HCO3: ClosedRange<Double>
        let paO2: ClosedRange<Double>
        let saO2: ClosedRange<Double>
        let BE: ClosedRange<Double>
   
    }
    let normalRanges: NormalRanges = NormalRanges(
        pH: 7.35...7.45,
        paCO2: 35.0...45.0,
        HCO3: 22.0...26.0,
        paO2: 80...100,
        saO2: 97.0...100.0,
        BE: -2.0...2.0
    )
}

struct Vitals {
    var HR: Double?
    var systolicBP: Double?
    var diastolicBP: Double?
    var SpO2: Double?
    var f: Double?
    var temp: Double?
    
    struct NormalRanges {
        let HR: ClosedRange<Double>
        let systolicBP: ClosedRange<Double>
        let diastolicBP: ClosedRange<Double>
        let SpO2: ClosedRange<Double>
        let f: ClosedRange<Double>
        let temp: ClosedRange<Double>
    }
    
    let normalRanges: NormalRanges = NormalRanges(
        HR: 60...100,
        systolicBP: 60...100,
        diastolicBP: 60...100,
        SpO2: 92...100,
        f: 12...20,
        temp: 36...39
        )
}

struct VentSettings {
    var ventilationType: String = "Invasive"
    var ventilationMode: String = "PRVC"
    
    var VT: Double?
    var PC: Double?
    var RR: Double?
    var FiO₂: Double?
    var PEEP: Double?
    var pressureSupport: Double?
    var flow: Double?
    var IT : Double?
    var IE : Double?
}

struct VentParameters {
    var VTe : Double?
    var fTOT : Double?
    var PIP : Double?
    var MAP : Double?
    var pPlat : Double?
    var autoPEEP: Double?
    var ptLeak : Double?
    
    struct NormalRanges {
        let VTe: ClosedRange<Double>
        let fTOT: ClosedRange<Double>
        let PIP: ClosedRange<Double>
        let pPlat: ClosedRange<Double>
        let autoPEEP: ClosedRange<Double>
        let ptLeak: ClosedRange<Double>
    }
    
    let normalRanges: NormalRanges = NormalRanges(
        VTe: 0...600,
        fTOT: 12...20,
        PIP: 0...30,
        pPlat: 0...28,
        autoPEEP: 0...10,
        ptLeak: 0...50
    )
}

class PatientData: ObservableObject{
    @Published var PatientInformatioinClass = PatientInformation()
    @Published var VitalsClass = Vitals()
    @Published var ABGClass = ABG()
    @Published var VentSettingsClass = VentSettings(
        ventilationType: "",
        ventilationMode: "")
    @Published var VentParametersClass = VentParameters()
   
    
   
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
    
    var body: some View {
        HStack{
            Text(label)
                .frame(width: 75, alignment: .center)
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

struct ABGView: View {
    @Binding var ABGData: ABG
    var body: some View {
        GroupBox(label: Label("Arterial Blood Gas", systemImage: "syringe.fill")){
            Divider()
                .frame(height: 2)
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

struct VitalsView: View {
    
    @Binding var VitalsData: Vitals
    
    var body: some View {
        GroupBox(label: Label("Vital Signs", systemImage: "waveform.path.ecg")){
            Divider()
                .frame(height: 2)
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
//                    .background(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.gray.opacity(0.03), lineWidth: 1)
//                            .frame(width: 175, height: 90)
//                    )
                    
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

struct PatientInformationView: View{
    
    @Binding var PatientInformationData: PatientInformation
    
     var body: some View {
         GroupBox(label: Label("Patient Information", systemImage: "person.fill")){
             Divider()
                 .frame(height: 2)
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
                         InputField(label: "Weight", units: "lbs", value: Binding(
                            get: {PatientInformationData.age ?? 0.0},
                            set: {PatientInformationData.age = $0}
                         ))
                     }
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
                .frame(height: 2)
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



struct VentSettingsView: View {
    @Binding var VentData: VentSettings
    var body: some View {
        
        GroupBox(label: Label("Vent Settings", systemImage: "inset.filled.tv")) {
            Divider()
                .frame(height: 2)
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


