//
//  Patient .swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 4/18/25.
//

import Foundation

struct PatientInformation {
    var age: Double?
    var height: Double?
    var gender: String?
    var weight: Double?
    var BMI: Double?
    
    //function is undone
    func calculateBMI() -> Double? {
        guard let height = height, let weight = weight else { return nil }
        //
        return weight / (height * height)
    }
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
