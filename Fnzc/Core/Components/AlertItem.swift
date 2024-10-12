//
//  AlertItem.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 13/10/2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button = .default(Text("OK"))
}
