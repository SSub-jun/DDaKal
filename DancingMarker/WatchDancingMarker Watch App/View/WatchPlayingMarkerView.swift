
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
                    
                    Button(action: {
                        
                        print("Tapped: 마커1")
                        
                    }, label: {
                        
                        Text("추가")
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            ZStack {
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    
                    Button(action: {
                        print("Tapped: 마커2")
                    }, label: {
                        
                        Text("추가")
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    
                    Button(action: {
                        print("Tapped: 마커3")
                    }, label: {
                        
                        Text("추가")
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

#Preview {
    WatchPlayingMarkerView()
}
