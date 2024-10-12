//
//  EditProfileView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import SwiftUI

struct EditProfileView: View {
    @State private var bio = ""
    @State private var link = ""
    @State private var isPrivateProfile = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                
                VStack{
                    
                    // Name and profile mage
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text("name")
                                .fontWeight(.semibold)
                            
                            Text("khaled abdulaziz")
                        }
                       
                        
                        Spacer()
                        
//                        profileImageUrl()
                        
                        
                    }
                    Divider()
                    
                    // bio filed
                    
                    VStack(alignment: .leading){
                        Text("Bio")
                            .fontWeight(.semibold)
                        TextField("Enter you Bio", text:$bio, axis: .vertical)
                    }
                    
                    
                    Divider()
                    
                    VStack(alignment: .leading){
                        Text("Link")
                            .fontWeight(.semibold)
                        TextField("Add Link...", text:$link)
                    }
                   
                    
                    Divider()
                    
                    Toggle("Priavte Profile", isOn: $isPrivateProfile )
                    
                    
                }
                .padding()
                .background(.white)
                .cornerRadius(10)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth:1)
                }
                .padding()
                
                .font(.footnote)
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("Cancel") {
                            
                        }
                        
                        .font(.subheadline)
                        .foregroundColor(.black)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button("Done") {
                            
                        }
                        
                        .font(.subheadline)
                        .fontWidth(.standard)
                        .foregroundColor(.black)
                    }
                    
                }
            }
        }
    }
}
