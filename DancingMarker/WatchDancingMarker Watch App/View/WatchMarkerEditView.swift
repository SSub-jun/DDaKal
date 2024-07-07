
import SwiftUI

struct WatchMarkerEditView: View {
    
    let data: String
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                            
                       Image(systemName: "gobackward")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text("1")
                        
                    }
                    Spacer()
                    
                    Text("\(data)")
                        .font(.system(size: 22))
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                            
                       Image(systemName: "goforward")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text("1")
                    }
                }
                
                Spacer()
                
                HStack{
                    Button(action: {
                        
                    }, label: {
                        Text("저장하기")
                    })
                    .buttonStyle(SaveButtonStyle())
                }
            }
            .navigationTitle {
                Text("수정하기")
                    .fontWeight(.heavy)
                    .foregroundColor(.yellow)
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct SaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .bold()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(9)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


#Preview {
    WatchMarkerEditView(data: "2:09")
}
