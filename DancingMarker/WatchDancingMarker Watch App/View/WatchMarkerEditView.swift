import SwiftUI

struct WatchMarkerEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var data: Int
    @State private var count = 1
    @State private var initialData: Int
    
    @State private var showingAlert = false
    @Binding var isPresented: Bool
    
    init(data: Int, isPresented: Binding<Bool>) {
        self.data = data
        self._initialData = State(initialValue: data)
        self._isPresented = isPresented
    }
    
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
                    .onTapGesture {
                        decrementCount()
                    }
                    Spacer()
                    
                    Text("\(convertTime(seconds: data))")
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
                    .onTapGesture {
                        incrementCount()
                    }
                }
                
                Spacer()
                
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        if data != initialData {
                            showingAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .fullScreenCover(isPresented: $showingAlert) {
                MarkerEditAlert(isPresented: $isPresented)
            }
        }
    }
    
    func incrementCount() {
        count += 1
        data += 1
    }
    
    func decrementCount() {
        count -= 1
        data -= 1
    }
    
    func convertTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
}

// MARK: 저장하기 버튼 스타일
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


//#Preview {
//    WatchMarkerEditView(data: "2:09")
//}
