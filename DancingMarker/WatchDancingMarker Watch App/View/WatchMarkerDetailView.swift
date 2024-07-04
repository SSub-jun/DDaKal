
import SwiftUI

struct WatchMarkerDetailView: View {
    
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
                
            }, label: {
                Text("초기화하기")
            })
            .buttonStyle(ResetButtonStyle())
           
        }
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
