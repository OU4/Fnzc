//
//  MainTabView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ProfileView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
            Button("Sign Out") {
                authViewModel.signOut()
            }
            .tabItem {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
            }
        }
    }
}
