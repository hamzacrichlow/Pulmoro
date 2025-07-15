//
//  MoreThings.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 3/8/25.
//

import SwiftUI

struct MoreThings : Hashable {
    let name: String
    let systemImageName: String
}


struct MorePage: View {
    
    var moreList: [MoreThings] = [
        .init(name: "About Pulmoro", systemImageName: "lungs.fill") ,
        .init(name: "Legal Disclaimer", systemImageName: "shield.lefthalf.filled.trianglebadge.exclamationmark"),
        .init(name: "ABG Analysis", systemImageName: "syringe.fill"),
        .init(name: "Ventilator Management", systemImageName: "tv.fill"),
        .init(name: "Sources", systemImageName: "info.circle.fill") ,
        .init(name: "Future of Pulmoro", systemImageName: "cross.case.fill")
    ]
    
    var body: some View {
        NavigationStack{
            
            List{
                Section("") {
                    ForEach(moreList, id: \.name) { more in
                        NavigationLink(value: more) {
                            HStack{
                                gradient(name: more.systemImageName)
                                Text(more.name)
                            }
                        
                        }
                    }
                }
            }
            .navigationDestination(for: MoreThings.self) { calculation in
                switch calculation.name {
                case "About Pulmoro":
                    AboutPulmoroPage.init()
                case "Legal Disclaimer":
                    LegalDisclaimer.init()
                case "ABG Analysis":
                    AboutABGAnalysis.init()
                case "Ventilator Management":
                    AboutVentManagement.init()
                case "Sources":
                    AboutSources.init()
                case "Future of Pulmoro":
                    AboutFutureOfPulmoroPage.init()
                default:
                    Text("Coming Soon!")
                }
            }
            .navigationBarTitle("More Information", displayMode: .automatic)
            
        }
    }
    func gradient(name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .overlay(
                LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            .mask(
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                                
            )
            
    }

}

#Preview {
   LegalDisclaimer()
}


struct LegalDisclaimer: View {
    var body: some View {
        ScrollView{
        VStack (alignment: .leading, spacing: 10){
            Divider()
                .frame(height: 3)
                .overlay(LinearGradient(gradient: .init(colors: [.teal, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            Text("""
Pulmoro includes clinical decision support tools and content intended for use by healthcare professionals. Physicians, respiratory therapists, and other healthcare professionals who use these tools should exercise their own clinical judgment regarding the information provided. Nonmedical professionals who use these tools do so at their own risk and are specifically cautioned to seek professional medical advice before making any health related decisions.

Pulmoro's content developers have carefully created content to conform to current standards of professional practice in respiratory care and critical care medicine. However, standards and practices in medicine change as new data become available, and medical professionals should consult current guidelines.

The contents of Pulmoro, including calculations, recommendations, interpretations, and educational materials, are for informational and educational purposes only. Pulmoro does not recommend or endorse any specific treatments, procedures, protocols, or clinical decisions that may be mentioned in the app.

While information in this app has been obtained from sources believed to be reliable and evidence based medical literature, we do not warrant the accuracy, completeness, or reliability of any information contained in Pulmoro.

Important Medical Disclaimers:
We do not provide medical advice, diagnosis, or treatment recommendations
All clinical decisions should be made in consultation with qualified healthcare professionals.
Users should always follow their institution's protocols and guidelines
Medical information and best practices change rapidly
This app is intended as a supplementary tool only

Liability Limitation:
Your reliance upon any information, calculations, or recommendations obtained through Pulmoro is solely at your own risk. We assume no liability or responsibility for any damage, injury, adverse outcomes, or consequences arising from any use of the information, calculations, or recommendations provided by Pulmoro.
Professional Responsibility:
Healthcare professionals using Pulmoro remain fully responsible for all clinical decisions and patient care. This app does not replace clinical judgment, professional training, or institutional protocols.
""")
            .font(.body)
        }
        .padding()
    }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Official Legal Disclaimer", displayMode: .automatic)
        .toolbar {
           
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(systemImage: "chevron.backward")
            }
        }
        
    }
}
