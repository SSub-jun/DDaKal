import SwiftUI

struct WatchPlayingMarkerView: View {
    
    var body: some View {
        
        HStack{
            // MARK: 마커 1
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2)) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    
                    Text("추가") // 마커 추가가 되었다면 ? 마커 시간 : "추가"
                }
            }
            .onTapGesture {
                print("마커 추가 #")
                // 마커 추가
            }
            
            // MARK: 마커 2
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2)) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    
                    Text("추가")  // 마커 추가가 되었다면 ? 마커 시간 : "추가"
                }
            }
            .onTapGesture {
                print("마커 추가 ##")
                // 마커 추가
            }
            
            // MARK: 마커 3
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2)) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    
                    Text("추가")  // 마커 추가가 되었다면 ? 마커 시간 : "추가"
                }
            }
            .onTapGesture {
                print("마커 추가 ###")
                // 마커 추가
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    WatchPlayingMarkerView()
}
