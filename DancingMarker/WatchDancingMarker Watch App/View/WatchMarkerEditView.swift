import SwiftUI

struct WatchMarkerEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isButtonEnabled = false // 저장하기 버튼 Enabled/Disabled
    
    @State var data: TimeInterval // 음악 시간 데이터
    @State private var count = 0 // 1초 증가/감소 변수
    @State private var initialData: TimeInterval // 음악시간 초기값 저장
    private var index: Int
    
    @State private var showingAlert = false // EditAlert 띄우기
    @Binding var isPresented: Bool // modal 상태관리 변수
    @Binding var navigationPath: NavigationPath // 네비게이션 경로 관리 변수
    @EnvironmentObject var viewModel: WatchViewModel

    init(data: TimeInterval, isPresented: Binding<Bool>, index: Int, navigationPath: Binding<NavigationPath>) {
        self.data = data
        self.index = index
        self._initialData = State(initialValue: data)
        self._isPresented = isPresented
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                HStack {
                    // MARK: 1초 감소 버튼
                    ZStack {
                        Circle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image("backward1SecIcon")
                    }
                    .onTapGesture {
                        decrementCount() // 임시로 만들어준 1초 감소 함수입니다.
                    }
                    Spacer()
                    
                    // MARK: 현재 마커 시간
                    Text("\(formattedTime(data))")
                        .font(.system(size: 22))
                    
                    Spacer()
                    
                    // MARK: 1초 증가 버튼
                    ZStack {
                        Circle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image("forward1SecIcon")
                    }
                    .onTapGesture {
                        incrementCount() // 임시로 만들어준 1초 감소 함수입니다.
                    }
                }
                .padding(.horizontal)
                Spacer()
                
                // MARK: 저장하기 버튼
                HStack{
                    Button(action: {
                        // 마커 시간 수정한 후 저장하는 기능이 들어가면 됩니다.
                        viewModel.connectivityManager.sendMarkerEditSuccessToIOS(forEdit: [index, count])
                        presentationMode.wrappedValue.dismiss()
                        navigationPath.removeLast(navigationPath.count) // 루트로 이동
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
        DispatchQueue.main.async{
            count += 1
            data += 1
            viewModel.connectivityManager.sendMarkerEditToIOS(forEdit: [index, count])
        }
        
    }
    
    // 1초 감소 함수
    func decrementCount() {
        DispatchQueue.main.async{
            count -= 1
            data -= 1
            viewModel.connectivityManager.sendMarkerEditToIOS(forEdit: [index, count])
        }
    }
    
    func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
