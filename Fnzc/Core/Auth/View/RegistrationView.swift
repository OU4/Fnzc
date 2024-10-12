//
//  RegistrationView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegiesterViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding()
                
                VStack(spacing: 20) {
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(TextFiledModifire())
                    
                    SecureField("Password", text: $viewModel.password)
                        .modifier(TextFiledModifire())
                    
                    TextField("Full Name", text: $viewModel.fullname)
                        .modifier(TextFiledModifire())
                    
                    TextField("Username", text: $viewModel.username)
                        .modifier(TextFiledModifire())
                }
                
                Button(action: {
                    Task {
                        do {
                            try await viewModel.createUser()
                            dismiss()
                        } catch {
                            print("Registration error: \(error)")
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                }) {
                    Text("Sign Up")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding(.top, 24)
                
                Spacer()
                
                Divider()
                
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Log in")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registration Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
