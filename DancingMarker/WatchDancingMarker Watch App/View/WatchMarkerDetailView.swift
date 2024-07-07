
import SwiftUI

struct WatchMarkerDetailView: View {
    
    @State var isShownFullScreenCover = false
    
    let data: String
    
    var body: some View {
        
        VStack(spacing: 10){
            
            Text("\(data)")
                .padding(.bottom)
            
            Button(action: {
                
            }, label: {
                Text("수정하기")
            })
            .buttonStyle(EditButtonStyle())
            
            Button(action: {
                self.isShownFullScreenCover.toggle()
            }, label: {
                Text("초기화하기")
            })
            .buttonStyle(ResetButtonStyle())
            .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                MarkerResetAlert()
            })
        }
        .padding()
    }
}

struct MarkerResetAlert: View {
    
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("이 마커를\n초기화시키겠습니까?")
                .padding()
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
            
            Button(action: {
                // 마커 초기화
            }, label: {
                Text("초기화하기")
            })
            .buttonStyle(ResetButtonStyle())
        }
        .padding()
    }
}

struct EditButtonStyle: ButtonStyle {
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

struct ResetButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .bold()
            .background(Color.red.opacity(0.4))
            .foregroundColor(.red)
            .cornerRadius(9)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    WatchMarkerDetailView(data: "임시 데이터")
}
