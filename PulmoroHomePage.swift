//
//  PulmoroAppApp.swift
//  PulmoroApp
//
//  Created by Hamza Crichlow on 3/8/25.
//

import SwiftUI

@main
struct PulmoroApp: App{
  
    
    
    @State private var gradientColors: [Color] = [
        Color(.cyan).opacity(0.1),
        Color(.cyan).opacity(0.2),
        Color(.cyan).opacity(0.1)
    ]
    
    
    var body: some Scene {
        WindowGroup {
            TabBar()
                .background( MovingGradientView(colors: gradientColors)
                    .ignoresSafeArea())
        }
        
    }
}


#Preview {
  TabBar()
}

/*
 Commit Messages
 New Feature:
 [Feature] Description of the feature
 
 Bug in Production:
 [Patch] Description of patch
 
 Bug not in production:
 [Bug] Description of the bug
 
 Mundane Tasks:
 [Clean] Description of changes
 
 Release:
[Release] Description of release
 
 */
