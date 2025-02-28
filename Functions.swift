//
//  Functions.swift
//  Pulmoro
//
//  Created by Hamza Crichlow on 2/1/25.
//

import Foundation

/// Need to be able to check if a lab value or vital sign is within normal range or not.
/// - Parameters:
///   - value: Any value that has a normal range
///   - range: The normal range of that value
/// - Returns: Returns a bool so that is can be checked if the value is within that normal range or not.
func isNormal(value: Double?, range: ClosedRange<Double>)->Bool {
    guard let value = value else { return false}
    return range.contains(value)
}

/// Function used to calculate a patient's ideal body weight.
/// - Parameters:
///   - height: Patients height in inches
///   - gender: String `"Male"` or `"Female"`
/// - Returns: Returns the ideal body weight
func calculateIBW(height: Double, gender: String)->Double{
    if gender == "Male" {
        return (height - 60) * 2.3 + 50
    } else {
        return (height - 60) * 2.3 + 45.5
    }
}

/// Function used to calculate tidal volume (VT).
/// - Parameters:
///   - IBW: Ideal body weight
///   - mlPerKg: How many mlL/Kg the clinician wants to give the patient
/// - Returns: Returns the appropriate VT for the patient based on their ideal body weight.
func calculateVT(IBW: Double, mLPerKg: Double)->Double{
    return IBW * mLPerKg
}

/// This function is used to calculate the partial pressure of Alveolar oxygen (PAO₂).
///
/// This function uses Pb which is the barometric pressure in mmHg which is 760 at sea level. 47 is the partial pressure of water vapor in an Alveoli. R is the respiratory exchange ratio (VCO2/VO2) which is normally o.8)
/// - Parameters:
///   - FiO₂: Fractional  inspired oxygen (FiO₂) vent setting given as a percentage (%)
///   - PaCO₂: Patients partial pressure of carbon dioxide in arterial blood
/// - Returns: Returns the PaO₂
func calculatePAO₂(FiO₂: Double, PaCO₂: Double) -> Double {
        ((760-47)*(0.01*FiO₂))-(PaCO₂/0.8)
    }

/// This function is used to calculate the A-a gradient.
/// - Parameters:
///   - PAO₂:  Partial pressure of arterial oxygen (PaO₂) dissolved in the alveoli
///   - PaO₂:  Partial pressure of arterial oxygen (PaO₂) dissolved in the blood
/// - Returns: Returns the A-a gradient
func calculateAaGradient(PAO₂:Double, PaO₂:Double) -> Double {
        PAO₂-PaO₂
    }


/// This function is used to calculate a patients normal A-a Gradient
///
/// Our normal A-a gradient changes as we age. If the patients A-a gradient is higher than their normal then this suggests intrinsic lung issues. If the A-a gradient is less than their normal A-a gradient then the patient lung issues are most likely extrinsic.
/// - Parameter age: The patients age
/// - Returns: Returns the normal A-a Gradient for this patient
func calculateNormalAaGradient(age: Double) -> Double {
    Double((age/4)+4)
}

/// This function is used to categories the patients lung issue into intrinsic or extrinsic based on their A-a gradient..
/// - Parameters:
///   - age: The patients age
///   - AaGradient: A-a Gradient
///   - NormalAaGradient: The patients normal A-a Gradient
/// - Returns: Returns a description telling the clinician what the patients A-a gradient is and what it should be considering the patients age. It describes what lung issues the patient may have based on their A-a gradient.
func intrinsicOrExtrinsic(age: Double, AaGradient: Double, NormalAaGradient: Double) -> String {
    if AaGradient > NormalAaGradient
    {
        return """
The normal A-a gradient for \(Int(age))-year-old patients is ≤ \(Int(NormalAaGradient)) mmHg. Since the patient's A-a gradient exceeds \(Int(NormalAaGradient)) mmHg, this suggests the issue is likely intrinsic to the lungs.
"""
    } else {
        return """
    The normal A-a gradient for \(Int(age))-year-old patients is ≤ \(Int(NormalAaGradient)) mmHg. The patient's A-a gradient is within normal limits, suggesting the issue is likely extrinsic rather than pulmonary.
    """
    }
}

/// This function is used to calculate the total amount of oxygen in the blood.
///
///The first part of the equation is (Hb * 1.34 * SO₂) . This part calculates the oxygen bound to Hb. 1.34 is a constant that represents the number of mLs of O₂ carried by each gram of Hb. Each gram of Hb can carry 1.34 Ml of O₂. The second part of the equation calculates how much Oxygen is dissolved in the plasma represented by (PaO₂* 0.003 ) . 0.003 is a solubility constant that allows us to*/*/ convert the mmHg in pressure into a VOL %
/// - Parameters:
///   - Hb: Hemoglobin
///   - SaO₂: Oxygen saturation of arterial blood
///   - PaO₂: Partial pressure of arterial oxygen (PaO₂) dissolved in the blood
/// - Returns: Returns the Oxygen Content
func calculateContentOfO2(Hb: Double, SaO₂: Double, PaO₂: Double)->Double {
    return (Hb*1.34*(0.01*SaO₂))+(PaO₂*0.003)
}

/// This functions calculates the arteriovenous oxygen content difference (C(a-v)O₂).
///
/// C(a-v)O₂ measures the difference in the oxygen content between the arterial blood and the venous blood. It represents the amount of oxygen extracted by the tissue from the blood.
/// - Parameters:
///   - Hb:Hemoglobin
///   - SaO₂: Oxygen saturation of arterial blood
///   - PaO₂: Partial pressure of arterial oxygen (PaO₂) dissolved in the blood
///   - SvO₂: Oxygen saturation of venous blood
///   - PvO₂: Partial pressure of venous oxygen (PvO₂) dissolved in the blood
/// - Returns: Returns the oxygen content difference
func calculateCavO₂(Hb: Double, SaO₂: Double, PaO₂: Double, SvO₂: Double, PvO₂: Double)->Double {
  return  ((Hb*1.34*(0.01*SaO₂))+(PaO₂*0.003))-((Hb*1.34*(0.01*SvO₂))+(PvO₂*0.003))
}

/// This function calculates the static compliance (Cstat).
///
/// Static Compliance will tell you more about the compliance of the lung because it uses Pplat. Pplat is the pressure i the lungs when there is no flow. Normal Cstat is 60-100ml/ cmH₂O
/// - Parameters:
///   - VT: VT that the patient is currently breathing
///   - Pplat: Plateau pressure (Pplat) ventilator parameter. Acquired by doing an inspiratory hold.
///   - PEEP: Positive end-expiratory pressure (PEEP) ventilator setting
/// - Returns: Returns the patients static compliance.
func calculateCstat(VT: Double, Pplat: Double, PEEP: Double)->Double{
    return VT/(Pplat-PEEP)
}

/// Function used to calculate the dynamic compliance (Cdyn).
///
///Dynamic Compliance is how much volume is delivered per cmH₂O. PIP can increased due to airway resistance or a decreased in alveolar compliance. The more compliant the lung the easier it is to inflate the lungs. The less compliant the lung the less pressure needed to inflate it.
///
/// - Parameters:
///   - VT: VT that the patient is currently breathing
///   - PIP: Peak inspiratory pressure (PIP) ventilator parameter
///   - PEEP: Positive end-expiratory pressure (PEEP) ventilator setting
/// - Returns: Returns the patients dynamic compliance.
func calculateCdyn(VT: Double, PIP: Double, PEEP: Double)-> Double {
        return VT/(PIP-PEEP)
    }

/// Function used to calculate the driving pressure to assess the stress or strain placed on patients lungs during mechanical ventilation.
/// - Parameters:
///   - PIP: Peak inspiratory pressure (PIP) ventilator parameter
///   - PEEP: Positive end-expiratory pressure (PEEP) ventilator setting
/// - Returns: Returns the driving pressure``Double``
func calculateDrivingPressure(PIP: Double, PEEP: Double)->Double {
    return PIP-PEEP
}

/// Function used to calculate the oxygenation index (OI) to assess the severity of hypoxemia
/// - Parameters:
///   - MAP: Mean Airway Pressure (MAP) ventilator parameter
///   - FiO₂: Fraction of inspired oxygen (FiO₂) vent setting given as a percentage (%)
///   - PaO₂: Partial pressure of arterial oxygen (PaO₂) dissolved in the blood
/// - Returns: Returns the OI
func calculateOI(MAP: Double, FiO₂: Double, PaO₂: Double) -> Double {
    return (MAP * FiO₂) / PaO₂
}

/// Function used to calculate the Respiratory Rate (RR)  needed to acquire the desired PaCO₂ that the clinician wants for the patient.
/// ```swift
///if VentSetting == "RR" {
///    newRR = calculateNewRR(RR: RR, PaCO2: PaCO₂, DesiredPaCO₂: DesiredPaCO₂)
///}
///```
/// - Parameters:
///   - RR: RR that the patient is currently breathing
///   - PaCO₂: Patients PaCO₂ from their ABG
///   - DesiredPaCO₂: Desired PaCO₂ that the clinician wants
/// - Returns: Returns  the new RR to set the vent too so the patient can get the desired PaCO₂
func calculateNewRR(RR:Double, PaCO₂:Double, DesiredPaC₂:Double)->Double{
   return  (RR*PaCO₂)/DesiredPaC₂
}

/// Function used to calculate the Tidal Volume (VT)  needed to acquire the desired PaCO₂ that the clinician wants for the patient.
/// ```swift
///if VentSetting == "VT" {
///newVT = calculateNewVT(VT: VT, PaCO₂: PaCO₂, DesiredPaCO₂: DesiredPaCO₂)
///}
///```
/// - Parameters:
///   - VT: VT that the patient is currently breathing
///   - PaCO₂: Patients PaCO₂ from their ABG
///   - DesiredPaCO₂: Desired PaCO₂ that the clinician wants
/// - Returns: Returns  the new VT to set the vent too so the patient can get the desired PaCO₂
func calculateNewVT(VT: Double, PaCO₂:Double, DesiredPaCO₂:Double)->Double{
    return (VT*PaCO₂)/DesiredPaCO₂
}

/// Function used to calculate the Minute Ventilation (VE)  needed to acquire the desired PaCO₂ that the clinician wants for the patient.
/// >Tip: VE is not a setting on the vent. You will have to change the RR or VT to achieve a specific VE. (VT *  RR = VE)
/// ```swift
///if VentSetting == "VE" {
///newVE = calculateNewVE(VE: VE, PaCO₂: PaCO₂, DesiredPaCO₂: DesiredPaCO₂)
///}
///```
/// - Parameters:
///   - VE: VE that the patient is currently breathing
///   - PaCO₂: Patients PaCO₂ from their ABG
///   - DesiredPaCO₂: Desired PaCO₂ that the clinician wants
/// - Returns: Returns  the new VE to set the vent too so the patient can get the desired PaCO₂
func calculateNewVE(VE: Double, PaCO₂:Double, DesiredPaCO₂:Double)->Double{
    return (VE*PaCO₂)/DesiredPaCO₂
}


/// This function calculates the duration of time left in the oxygen tank.
/// - Parameters:
///   - cylinderFactor: the cylinder factor is a specific constant designated to each oxygen tank
///   - pressure: the psi left within the oxygen tank
///   - flow: the flow of oxygen set by the clinician
/// - Returns: returns the amount of time left in the tank in minutes
func calculateO2TankDuration(cylinderFactor: Double, pressure: Double, flow: Double) -> Double {
   return (pressure*cylinderFactor)/flow
}


func normalOxygenationRange(FiO2: Double) -> (Double, Double) {
   
    var lowerEnd: Double = 0
    var upperEnd: Double = 0
    
    lowerEnd = FiO2 * 4
    upperEnd = FiO2  * 5
    
    return (lowerEnd, upperEnd)
}

/// <#Description#>
/// - Parameters:
///   - VT: <#VT description#>
///   - RR: <#RR description#>
///   - FiO2: <#FiO2 description#>
///   - PEEP: <#PEEP description#>
///   - IT: <#IT description#>
///   - IE: <#IE description#>
/// - Returns: <#description#>
func checkSettings(VT: Double?, RR: Double?, FiO2:Double?, PEEP: Double?, IT: Double?, IE: Double?) -> Bool {
    return [VT, RR, FiO2, PEEP, IT, IE].contains {$0 != nil}
}
