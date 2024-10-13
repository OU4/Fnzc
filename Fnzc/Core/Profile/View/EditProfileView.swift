//
//  EditProfileView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var fullname: String
    @State private var bio: String
    @State private var location: String
    @State private var avatarImage: UIImage?
    @State private var isShowingImagePicker = false
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _fullname = State(initialValue: viewModel.user?.fullname ?? "")
        _bio = State(initialValue: viewModel.user?.bio ?? "No bio yet!")
        _location = State(initialValue: viewModel.user?.location ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Picture")) {
                    HStack {
                        if let image = avatarImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else if let urlString = viewModel.user?.profileImageUrl,
                                  let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                        
                        Button("Change Avatar") {
                            isShowingImagePicker = true
                        }
                    }
                }
                
                Section(header: Text("Profile Information")) {
                    TextField("Full Name", text: $fullname)
                    TextField("Bio", text: $bio)
                    TextField("Location", text: $location)
                }
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    if let image = avatarImage {
                        viewModel.updateProfileImage(image) { result in
                            switch result {
                            case .success(let url):
                                viewModel.updateProfile(fullname: fullname, bio: bio, location: location, profileImageUrl: url)
                            case .failure(let error):
                                print("Failed to upload image: \(error.localizedDescription)")
                                viewModel.updateProfile(fullname: fullname, bio: bio, location: location)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        viewModel.updateProfile(fullname: fullname, bio: bio, location: location)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $avatarImage)
            }
        }
    }
}
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: ImagePicker
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            picker.dismiss(animated: true)
//            
//            guard let provider = results.first?.itemProvider else { return }
//            
//            if provider.canLoadObject(ofClass: UIImage.self) {
//                provider.loadObject(ofClass: UIImage.self) { image, _ in
//                    DispatchQueue.main.async {
//                        self.parent.image = image as? UIImage
//                    }
//                }
//            }
//        }
//    }
//}
