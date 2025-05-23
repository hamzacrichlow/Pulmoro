//
//  ABG Logic.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 4/21/25.
//

import Foundation
func reccomendVentSettings(VT: Double?, PC: Double?, PS: Double?, RR: Double?, FiO2: Double?, PEEP: Double?, IT: Double?, flow: Double?, VTe: Double?, fTOT: Double?, PIP: Double?, MAP: Double?, pPlat: Double?, autoPEEP: Double?, ptLeak: Double? )  {
    

}

///ABG Interpretator
func interpretABG(pH: Double?, paCO2: Double?, HCO3: Double?, PaO2: Double?, FiO2: Double?) -> (String, String, String, String, String) {
    
    var pHInterpretation: String = ""
    var oxygenationInterpretation: String = ""
    var acuteOrChronic: String = ""
    var anionGap: String = ""
    var condition: String = ""
    
    let lowerOxygenationRange =  normalOxygenationRange(FiO2: FiO2 ?? 21).0
    let upperOxygenationRange =  normalOxygenationRange(FiO2: FiO2 ?? 21).1
    
    guard let pH = pH, let paCO2 = paCO2, let HCO3 = HCO3 else {
        return ("", "", "", "", "")
    }
    switch (pH, paCO2, HCO3) {
    case let(pH, paCO2, HCO3) where pH < 7.35 && paCO2 <= 45 && HCO3 < 22:
        anionGap = "Considering Evaluating Anion Gap"
        condition = "Metabolic Acidosis"
        //Low pH, low HCO3, low CO2, We need to figure out how to treat Metabolic Acidosis.
    default:
        anionGap = ""
    }
    
    //Several cautions should be realized regarding the use of temporal adjectives (Acute=Uncompensated, Chronic=Completely compensated). What appears to be compensation may in fact be a primary acid base problem in the opposing direction. The duration of a particular acid-base disturbance is best assessed by carefully reviewing the history and physical examination. And this terminology is appropriate only for primary respiratory acid-base problems.
    switch (pH, paCO2, HCO3) {
    case let (pH, paCO2, HCO3) where pH > 7.45 && paCO2 < 35 && HCO3 >= 22 && HCO3 <= 26:
        acuteOrChronic = "Acute Alveolar Hyperventilation"
        condition = "Acute Alveolar Hyperventilation"
        
    case let (pH, paCO2, HCO3) where pH < 7.35 && paCO2 > 45 && HCO3 >= 22 && HCO3 <= 26:
        acuteOrChronic = "Acute Ventilatory Failure"
        condition = "Acute Ventilatory Failure"
        
    case let (pH, paCO2, HCO3) where pH >= 7.35 && pH <= 7.45 && paCO2 > 45 && HCO3 > 26:
        acuteOrChronic = "Chronic Ventilatory Failure"
        condition = "Chronic Ventilatory Failure"
        
    default:
        acuteOrChronic = ""
    }
    
    switch (pH, paCO2, HCO3) {
    case let (pH, paCO2, HCO3) where pH < 7.35 && paCO2 >= 35 && paCO2 <= 45 && HCO3 >= 22 && HCO3 <= 26:
        pHInterpretation = "ABG Gross Error Acidosis"
        condition = "ABG Gross Error Acidosis"
        
    case let (pH, paCO2, HCO3) where pH > 7.45 && paCO2 >= 35 && paCO2 <= 45 && HCO3 >= 22 && HCO3 <= 26:
        pHInterpretation = "ABG Gross Error Alkalosis"
        condition = "ABG Gross Error Alkalosis"
        
    case let (pH, paCO2, HCO3) where pH >= 7.35 && pH <= 7.45 && (paCO2 < 35 || paCO2 > 45) && HCO3 <= 26 && HCO3 >= 22:
        pHInterpretation = "ABG Gross Error"
        condition = "ABG Gross Error"
        
    case let (pH, paCO2, HCO3) where pH >= 7.35 && pH <= 7.45 && paCO2 >= 35 && paCO2 <= 45 && (HCO3 > 26 || HCO3 < 22):
        pHInterpretation = "ABG Gross Error"
        condition = "ABG Gross Error"
    
    case let (pH, paCO2, HCO3) where pH > 7.45 && paCO2 > 45 || HCO3 < 22:
        pHInterpretation = "ABG Gross Error"
        condition = "ABG Gross Error"
        
    case let (pH, paCO2, HCO3) where pH < 7.35 && (paCO2 < 35 || HCO3 > 28):
        pHInterpretation = "ABG Gross Error"
        condition = "ABG Gross Error"
        //Handle Extremes
    case let (pH, paCO2, HCO3) where pH < 6.6 || pH > 7.7 || paCO2 > 90 || paCO2 < 5 || HCO3 > 60 || HCO3 < 2:
        pHInterpretation = "ABG Gross Error"
        condition = "ABG Gross Error"
    case let (pH, paCO2, HCO3) where pH < 7.35 && paCO2 > 45 && HCO3 >= 22 && HCO3 <= 26:
        pHInterpretation = "Uncompensated Respiratory Acidosis"
        
    case let (pH, paCO2, HCO3) where pH < 7.35 && paCO2 <= 45 && paCO2 >= 35 && HCO3 < 22:
        pHInterpretation = "Uncompensated Metabolic Acidosis"
        
    case let (pH, paCO2, HCO3) where pH > 7.45 && paCO2 < 35 && HCO3 >= 22 && HCO3 <= 26:
        pHInterpretation = "Uncompensated Respiratory Alkalosis"
        
    case let (pH, paCO2, HCO3) where pH > 7.45 && paCO2 <= 45 && paCO2 >= 35 && HCO3 > 26:
        pHInterpretation = "Uncompensated Metabolic Alkalosis"
        
    case let (pH, paCO2, HCO3) where pH < 7.35 && paCO2 > 45 && HCO3 > 26:
        pHInterpretation = "Partially Compensated Respiratory Acidosis"
        
    case let (pH, paCO2, HCO3) where pH < 7.35 && paCO2 < 35 && HCO3 < 22:
        pHInterpretation = "Partially Compensated Metabolic Acidosis"
        
    case let (pH, paCO2, HCO3) where pH > 7.45 && paCO2 < 35 && HCO3 < 22:
        pHInterpretation = "Partially Compensated Respiratory Alkalosis"
        
    case let (pH, paCO2, HCO3) where pH > 7.45 && paCO2 > 45 && HCO3 > 26:
        pHInterpretation = "Partially Compensated Metabolic Alkalosis"
        
    case let (pH, paCO2, HCO3) where pH >= 7.35 && pH < 7.40 && paCO2 > 45 && HCO3 > 26:
        pHInterpretation = "Compensated Respiratory Acidosis"
        
    case let (pH, paCO2, HCO3) where pH > 7.40 && pH <= 7.45 && paCO2 < 35 && HCO3 < 22:
        pHInterpretation = "Compensated Respiratory Alkalosis"
        
    case let (pH, paCO2, HCO3) where pH >= 7.35 && pH < 7.40 && paCO2 < 35 && HCO3 < 22:
        pHInterpretation = "Compensated Metabolic Acidosis"
        
    case let (pH, paCO2, HCO3) where pH > 7.40 && pH <= 7.45 && paCO2 > 45 && HCO3 > 26:
        pHInterpretation = "Compensated Metabolic Alkalosis"
        
    case let (pH, paCO2, HCO3) where pH == 7.40 && paCO2 > 45 && HCO3 > 26:
        pHInterpretation = "Completely Compensated Acid-Base"
        
    case let (pH, paCO2, HCO3) where pH == 7.40 && paCO2 < 35 && HCO3 < 22:
        pHInterpretation = "Completely Compensated Acid-Base"
        
    case let (pH, paCO2, HCO3) where pH < 7.35 && paCO2 > 45 && HCO3 < 22:
        pHInterpretation = "Mixed (Combined) Acidosis"
        
    case let (pH, paCO2, HCO3) where pH > 7.45 && paCO2 < 35 && HCO3 > 26:
        pHInterpretation = "Mixed (Combined) Alkalosis"
        
  
        
    default:
        pHInterpretation = "Normal Acid-Base Status"
    }
    
    if let PaO2 = PaO2 {
        switch PaO2 {
            
        case let PaO2 where PaO2 > upperOxygenationRange:
            oxygenationInterpretation = "Hyperoxemia"
            
        case let PaO2 where PaO2 >= lowerOxygenationRange && PaO2 <= upperOxygenationRange:
            oxygenationInterpretation = "Normal Oxygenation"
            
        case let PaO2 where PaO2 >= 60 && PaO2 <= 79:
            oxygenationInterpretation = "Mild Hypoxemia"
            
        case let PaO2 where PaO2 >= 45 && PaO2 <= 59:
            oxygenationInterpretation = "Moderate Hypoxemia"
            
        case let PaO2 where PaO2 < 45:
            oxygenationInterpretation = "Severe Hypoxemia"
            
        default :
            oxygenationInterpretation = "Normal Oxygenation"
        }
    }
    
    return (acuteOrChronic, pHInterpretation, oxygenationInterpretation, anionGap, condition)
}





struct O2InterpretationAndTreatment{
    let oxygenationInterpretation: String?
}

let o2Interpretations: [String: O2InterpretationAndTreatment] = [
    "Hyperoxemia": O2InterpretationAndTreatment (
        oxygenationInterpretation: "A PaO₂ exceeding normal limits (> 100 mmHg) may be called hyperoxemia. This can occur due to hyperventilation or excessive oxygen administration. Be aware of oxygen toxicity and decrease the FiO₂."),
    "Normal Oxygenation": O2InterpretationAndTreatment (
        oxygenationInterpretation: "The patient has normal oxygenation (PaO₂: 80-100 mmHg)"),
    "Mild Hypoxemia": O2InterpretationAndTreatment (
        oxygenationInterpretation: "The patient is in mild hypoxemia (PaO₂: 60-79 mmHg). Generally mild hypoxemia is well tolerated. Note that SaO₂ is at 90% when PaO₂ is 60 mmHg."),
    "Moderate Hypoxemia": O2InterpretationAndTreatment (
        oxygenationInterpretation: "The patient is in moderate hypoxemia (PaO₂: 45-59 mmHg). Cardiac output usually increases during moderate hypoxemia to maintain tissue oxygen delivery. Moderate hypoxemia may or may not result in hypoxia depending on the patients cardiovascular system. Oxygen should be administered to alleviate hypoxemia."),
    "Severe Hypoxemia": O2InterpretationAndTreatment (
        oxygenationInterpretation: "The patient is in severe hypoxemia (PaO₂: < 45 mmHg). When hypoxemia is severe its unlikely that tissue oxygenation can be maintained. Patients with severe hypoxemia should be considered hypoxic and requires immediate action"),
]

struct ABGInterpretationAndTreatment{
    let pHInterpretation: String
    let description: String?
    let treatment: String?
}

let ABGInterpretations: [String: ABGInterpretationAndTreatment] = [
    "Acute Alveolar Hyperventilation": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "The patient is in a state of Acute Alveolar Hyperventilation (AAH). This means the patient is acutely hyperventilating at the alveolar level. In blood gas analysis this will result in an Uncompensated Respiratory Alkalosis : Increased pH, decreased PaCO₂, and normal bicarbonate (HCO₃). Because the HCO₃ remains within normal limits, this is what indicates that this is an acute situation. HCO₃ can take up to 72 hours to respond and help fix respiratory acid base imbalances. HCO₃ is slow to respond to pH imbalances but powerful when it does.",
        treatment: "The clinician must ask themselves \"why is the patient hyperventilating?\" There are many causes for hyperventilation such as: pain, anxiety, fear, and hypoxemia. Treat whatever the main cause for the hyperventilation is. If its pain treat the pain. If its due to hypoxemia administer oxygen. In terms of hypoxemia it could be that the patient has pneumonia for example and thats causing them to not have good gas exchange. This, in turn, will cause the chemoreceptors to stimulate the patient to hyperventilate and increase their minute ventilation so to fix this we have to ask why its happening and fix that issue. Note that giVing a patient in AAH caused by anxiety oxygen will not fix the respiratory alkalosis because it was not caused by hypoxemia. "
        
    ),
    "Acute Alveolar Hyperventilation Superimposed by Chronic Vent Failure": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "Do not overcorrect the CO₂ if the patient is a CO₂ retainer. They may chronically have a high CO₂",
        treatment: ""
        
    ),
    "Acute Ventilatory Failure": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "The patient is in a state of Acute Ventilatory Failure (AVF). Anytime the word ventilatory is mentioned this refers to the patients ability to clear CO₂. Therefore the patient is acutely failing to ventilate resulting in a high PaCO₂. In blood gas analysis this will result in an Uncompensated Respiratory Acidosis. Because this is an acute situation bicarbonate (HCO₃) is normal. HCO₃ can take up to 72 hours to respond and help fix respiratory acid base imbalances. HCO₃ is slow to respond to pH imbalances but powerful when it does.The patient could also be hypoxic in this situation but giving oxygen may not fix the situation because hypoxemia can be caused by hypoventilation. There are 2 types of acute respiratory failure. Type 1-Hypoxemic and Type 2-Hypercapnic",
        treatment: "The clinician must ask themselves \"why is the patient hypoventilating?\" You have to fix the root cause of hypoventilation.The patient may need noninvasive ventilation, or invasive ventilation in the mean time. If the patient is already on a vent thing about using the desired CO₂ calculation and adjusting the VT or RR settings on the vent to fix the acidosis"
    ),
    "Acute Ventilatory Failure Superimposed by Chronic Ventilatory Failure": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "",
        treatment: ""
    ),
    "Chronic Ventilatory Failure": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "The patient is in chronic ventilatory failure. Anytime the word ventilatory is mentioned this refers to the patients ability to clear CO₂. This patient chronically fails to ventilate to bring their CO₂ into the typical normal range of 35 - 45 mmHg. However, their bicarbonate is elevated to balance the pH. Because the pH is normal the patient isn't requiring any ventilatory intervention. ",
        treatment: "Examine the patients medical history. If the patient has a history of smoking, digital clubbing, or has COPD, this may be a cause of chronic ventilatory failure. If thats the case, then this ABG is most likely normal for them. No intervention is required for acid-base balance."
    ),
    "Metabolic Acidosis increased Anion Gap": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "",
        treatment: ""
    ),
    "Metabolic Acidosis": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "Metabolic Acidosis check for anion gap",
        treatment: "Metabolic Acidosis check for anion gap"
    ),
    "ABG Gross Error": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "ABG Gross Error. The presence of normal pH with concurrent respiratory and/or metabolic acidosis/alkalosis.",
        treatment: "Draw new ABG for accurate ABG analysis"
    ),
    "ABG Gross Error Alkalosis": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "ABG Gross Error. Alkalemia (pH > 7.45) cannot be present in the absence of a causative alkalosis (PaCO2 < 35 mmHg and/or HCO3 > 26 mEq/L)",
        treatment: "Draw new ABG for accurate ABG analysis"
    ),
    "ABG Gross Error Acidosis": ABGInterpretationAndTreatment (
        pHInterpretation: "",
        description: "ABG Gross Error. Acidemia (pH < 7.35) cannot be present in the absence of a causative acidosis (PaCO2 > 45 mmHg and/or HCO3 < 22 mEq/L)",
        treatment: "Draw new ABG for accurate ABG analysis"
    ),
]
