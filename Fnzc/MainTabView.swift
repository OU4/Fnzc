//
//  MainTabView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var feedViewModel = FeedViewModel()
    
    var body: some View {
        TabView {
            FeedView()
                .environmentObject(feedViewModel)
                .tabItem {
                    Label("Feed", systemImage: "list.bullet")
                }
            
            Text("Explore")
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
            
            Text("Check In")
                .tabItem {
                    Label("Check In", systemImage: "plus.circle.fill")
                }
            
            ProfileView(viewModel: profileViewModel)
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
