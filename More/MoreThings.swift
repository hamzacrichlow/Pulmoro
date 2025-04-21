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
    MorePage()
}


