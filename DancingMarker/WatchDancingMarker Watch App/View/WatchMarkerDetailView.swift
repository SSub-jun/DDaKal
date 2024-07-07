import SwiftUI

struct WatchMarkerDetailView: View {
    
    @Binding var navigationPath: NavigationPath
    @State private var isShowingEditView = false
    @State private var isShownResetAlert = false
    
    let data: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(convertTime(seconds: data))")
                .padding(.bottom)
            
            Button(action: {
                self.isShowingEditView.toggle()
            }, label: {
                Text("수정하기")
            })
            .buttonStyle(EditButtonStyle())
            .fullScreenCover(isPresented: $isShowingEditView) {
                WatchMarkerEditView(data: data)
            }
            
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
    
    func convertTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

import SwiftUI

struct MarkerResetAlert: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        NavigationView {
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
                    // 마커 초기화 코드
                    navigationPath.removeLast(navigationPath.count)
                }, label: {
                    Text("초기화하기")
                })
                .buttonStyle(ResetButtonStyle())
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
           
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

//#Preview {
//    //    WatchMarkerDetailView(data: "임시 데이터")
//    MarkerResetAlert(navigationPath: Binding<NavigationPath>)
//}
