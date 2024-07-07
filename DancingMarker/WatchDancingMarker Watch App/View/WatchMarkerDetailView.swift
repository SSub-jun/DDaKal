
import SwiftUI

struct WatchMarkerDetailView: View {
    
    @Binding var navigationPath: NavigationPath
    
    @State private var isShowingEditView = false // EditView로 이동 상태관리 변수
    @State private var isShownResetAlert = false // ResetAlert
    
    let data: String
    
    var body: some View {
        
        VStack(spacing: 10){
            
            Text("\(data)")
                .padding(.bottom)
            
            Button(action: {
                self.isShowingEditView.toggle()
            }, label: {
                Text("수정하기")
            })
            .buttonStyle(EditButtonStyle())
            .fullScreenCover(isPresented: $isShowingEditView, content: {
                WatchMarkerEditView(data: data)
            })
            
            Button(action: {
                self.isShownResetAlert.toggle()
            }, label: {
                Text("초기화하기")
            })
            .buttonStyle(ResetButtonStyle())
            .fullScreenCover(isPresented: $isShownResetAlert) {
                MarkerResetAlert(navigationPath: $navigationPath)
            }
        }
        .padding()
    }
}

struct MarkerResetAlert: View {
    
    @Binding var navigationPath: NavigationPath
    
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text("이 마커를\n초기화시키겠습니까?")
                    .font(.system(size: 14))
                    .padding()
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                navigationPath.removeLast(navigationPath.count) // Navigation Stack 초기화
                // 마커 초기화 구현해야함
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

//#Preview {
//    //    WatchMarkerDetailView(data: "임시 데이터")
//    MarkerResetAlert(navigationPath: Binding<NavigationPath>)
//}
