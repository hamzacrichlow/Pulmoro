//
//  IBWCalculator.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 7/10/25.
//

import SwiftUI

struct IBWCalculator: View {
    //All possible inputs for this calculator
    @State var gender: String = "Male"
    @State private var height: Int = 0
    //All possible outputs for this calculator
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    IBWCalculator()
}
