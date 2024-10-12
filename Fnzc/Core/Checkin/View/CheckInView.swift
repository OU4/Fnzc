////
////  CheckInView.swift
////  Fnzc
////
////  Created by Abdulaziz dot on 13/10/2024.
////
//import SwiftUI
//
//struct CheckInView: View {
//    let checkIn: CheckIn
//    
//    var body: some View {
//        HStack(alignment: .top, spacing: 12) {
//            VStack(spacing: 0) {
//                Text(checkIn.checkInTime.formatted(.dateTime.weekday(.abbreviated)))
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                
//                Circle()
//                    .fill(Color.orange)
//                    .frame(width: 40, height: 40)
//                    .overlay(Image(systemName: "building.2").foregroundColor(.white))
//            }
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(checkIn.placeName)
//                    .font(.headline)
//                
//                if !checkIn.placeDetail.isEmpty {
//                    Text(checkIn.placeDetail)
//                        .font(.subheadline)
//                }
//                
//                Text("Saudi Arabia")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                
//                HStack(spacing: 4) {
//                    Image(systemName: "medal.fill")
//                        .foregroundColor(.yellow)
//                    Text("105")
//                        .foregroundColor(.orange)
//                    Text("•")
//                    Text(checkIn.checkInTime.formatted(.dateTime.hour().minute()))
//                }
//                .font(.caption)
//                
//                if !checkIn.message.isEmpty {
//                    Text(checkIn.message)
//                        .font(.subheadline)
//                        .padding(.top, 2)
//                }
//            }
//        }
//        .padding(.vertical, 8)
//    }
//}
//
//struct CheckIn: Identifiable {
//    let id: String
//    let placeName: String
//    let placeDetail: String
//    let checkInTime: Date
//    let message: String
//}
//
//// Preview
//struct CheckInView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckInView(checkIn: CheckIn(
//            id: "1",
//            placeName: "Dhahban",
//            placeDetail: "ذهبان",
//            checkInTime: Date(),
//            message: "Hi"
//        ))
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
