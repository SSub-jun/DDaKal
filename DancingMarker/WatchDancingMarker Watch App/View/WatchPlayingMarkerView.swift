
import SwiftUI

struct WatchPlayingMarkerView: View {
    
    var body: some View {
        
        HStack{
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    
                    Text("추가")
                }
            }
            .onTapGesture {
                print("마커 1 추가")
            }
            
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    
                    Text("추가")
                }
            }
            .onTapGesture {
                print("마커 2 추가")
            }
            
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    
                    Text("추가")
                }
            }
            .onTapGesture {
                print("마커 3 추가")
            }
        }
    }
}

#Preview {
    WatchPlayingMarkerView()
}
