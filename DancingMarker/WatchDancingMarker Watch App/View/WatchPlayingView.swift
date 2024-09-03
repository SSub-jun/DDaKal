
import SwiftUI

struct WatchPlayingView: View {
    
    @Environment(WatchNavigationManager.self) var navigationManager
    @EnvironmentObject var viewModel: WatchViewModel
    
    @State var showMarkerListOverlay: Bool = false
    
    @State var progress: Double = 0.25 // 현재 진행 상황을 나타내는 변수
    @State private var isIdle = true

    var body: some View {
        
        VStack {
            HStack {
                Text("\(viewModel.musicTitle)")
                    .font(.system(size: 12))
            }
            HStack {
                TabView{
                    WatchPlayingMarkerView()
                    WatchPlayingSpeedView()
                }
            }
            
            HStack{
                Spacer()
                
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    .frame(height: 35)
                    .overlay(
                        Button(action: {
                            viewModel.playBackward()
                        }, label: {
                            Image(systemName: "gobackward.5")
                                .resizable()
                                .frame(width: 20, height: 21)
                        })
                        .buttonStyle(PlainButtonStyle())
                    )
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 44)
                        .overlay(
                            Button(action: {
                                viewModel.playToggle()
                            }, label: {
                                Image(systemName:
                                        viewModel.isPlaying == true ? "pause.fill" : "play.fill"
                                ) // 재생 on/off에 따라 이미지 변경
                                .resizable()
                                .frame(width: 22, height: 22)
                            })
                            .buttonBorderShape(.circle)
                            .buttonStyle(PlainButtonStyle())
                        )
                    
                    CircleProgressView(progress: viewModel.progress) // 현재 노래의 길이를 value로 바꿔서 주면됨.
                        .frame(width: 42, height: 42)
                }
                
                Spacer()
                
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    .frame(height: 35)
                    .overlay(
                        Button(action: {
                            viewModel.playForward()
                        }, label: {
                            Image(systemName: "goforward.5")
                                .resizable()
                                .frame(width: 20, height: 21)
                        })
                        .buttonStyle(PlainButtonStyle())
                    )
                
                Spacer()
            }
            
            HStack {
                Text(viewModel.formattedProgress) // 현재 재생시간 데이터 넣어주기
                    .font(.system(size: 10))
            }
            .padding(.bottom, 10)
        }
        .focusable(true)
        .digitalCrownRotation(detent: $viewModel.crownVolume, from: 0, through: 60, by: 3, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true
        )
        .onChange(of: viewModel.crownVolume) { newValue in
            viewModel.handleCrownValueChange(newValue)
        }
        .scrollIndicators(.hidden)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Button(action:{
                    showMarkerListOverlay = true
                }, label:{
                    Image(systemName: "list.bullet")
                        .foregroundColor(.primaryYellow)
                })
            }
        }
        .fullScreenCover(isPresented: $showMarkerListOverlay, content: {
            WatchMarkerListView()
                .background{
                    Color.black
                }
        })
    }
}

// MARK: 재생 버튼 ProgressBar
struct CircleProgressView: View {
    
    //    @Binding var progress: Double
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color.white, lineWidth: 3)
                .rotationEffect(Angle(degrees: -90))
        }
    }
}

#Preview {
    WatchPlayingView()
        .environment(WatchNavigationManager())
}
