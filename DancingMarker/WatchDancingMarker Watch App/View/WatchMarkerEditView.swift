import SwiftUI

struct WatchMarkerEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isButtonEnabled = false // 저장하기 버튼 Enabled/Disabled
    
    @State var data: Int // 음악 시간 데이터
    @State private var count = 1 // 1초 증가/감소 변수
    @State private var initialData: Int // 음악시간 초기값 저장
    
    @State private var showingAlert = false // EditAlert 띄우기
    @Binding var isPresented: Bool // modal 상태관리 변수
    
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
                        decrementCount() // 1초 감소 함수
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
                        incrementCount() // 1초 증가 함수
                    }
                }
                
                Spacer()
                
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        
                        Text("저장하기")
                            .foregroundColor(data != initialData ? .white : .gray) // 처음의 시간이 아니라면 색상으로 활성화/비활성화 여부
                    })
                    .buttonStyle(SaveButtonStyle())
                    .disabled(data == initialData)
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
    
    // 1초 증가 함수
    func incrementCount() {
        count += 1
        data += 1
    }
    
    // 1초 감소 함수
    func decrementCount() {
        count -= 1
        data -= 1
    }
    
    // [분:초] formatter
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
