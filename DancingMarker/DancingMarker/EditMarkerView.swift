//
//  EditMarkerView.swift
//  DancingMarker
//
//  Created by Woowon Kang on 7/21/24.
//

import SwiftUI

struct EditMarkerView: View {
    @Environment(NavigationManager.self) var navigationManager
    @EnvironmentObject var playerModel: PlayerModel
    var body: some View {
        VStack {
            // 등록된 마커 버튼
            Button(action: {
                // 해당 시간으로 이동
            }) {
                HStack(spacing: 8) {
                    Image("addedMarker")
                    Text("02:01")
                        .font(.title3)
                        .italic()
                        .foregroundColor(.black)
                }
                .frame(width: 360, height: 60)
                .background(Color.primaryYellow)
                .cornerRadius(12)
            }
            .contextMenu{
                Button(action: {
                    // 수정 기능
                }) {
                    Text("수정하기")
                    Image(systemName: "pencil")
                }
                Button(role: .destructive, action: {
                    // 마커 삭제
                }) {
                    Text("삭제하기")
                    Image(systemName: "trash")
                }
            }
            
            // 마커 수정 버튼
            HStack(spacing: 6) {
                Circle()
                    .frame(width: 40)
                    .foregroundStyle(.inactiveGray)
                    .overlay {
                        Image("backward1SecIcon")
                    }
                    
                HStack(spacing: 8) {
                    Text("02:01") // marker (TimeInterval 들어올자리)
                        .font(.title3)
                        .italic()
                        .foregroundColor(.black)
                }
                .frame(width: 200, height: 60)
                .background(Color.primaryYellow)
                .cornerRadius(12).padding(.horizontal, 6)
                
                Circle()
                    .frame(width: 40)
                    .foregroundStyle(.inactiveGray)
                    .overlay {
                        Image("forward1SecIcon")
                    }
                    
                Circle()
                    .frame(width: 40)
                    .foregroundStyle(.buttonDarkGray)
                    .overlay {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    }
                    .padding(.leading, 10)
            }
            
        }
        
    }
}

#Preview {
    EditMarkerView()
        .environment(NavigationManager())
        .preferredColorScheme(.dark)
}
