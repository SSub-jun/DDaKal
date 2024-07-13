
import SwiftUI

struct WatchPlayingView: View {
    
    @Environment(WatchNavigationManager.self) var navigationManager
    @State var showMarkerListOverlay: Bool = false
    
    var body: some View {
        
        VStack {
            HStack {
                Text("NewJeans-Supernatural") // SwiftData 음원 Title 들어가면 됨
                    .font(.system(size: 12))
            }
            
            HStack {
                TabView{
                    WatchPlayingMarkerView()
                    WatchPlayingSpeedView()
                }
            }
            
            
            HStack{
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                        .frame(height: 44)
                    Button(action:{
                        
                        // 5초 뒤로 가는 기능
                        
                    }, label:{
                        Image(systemName: "gobackward.5")
                            .resizable()
                            .frame(width: 22, height: 22)
                        
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Button(action:{
                        
                        // 재생 & 일시정지
                        
                    }, label:{
                        Image(systemName: "play.fill")
                    })
                }
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                        .frame(height: 44)
                    Button(action:{
                        
                        // 5초 앞으로 가는 기능
                        
                    }, label:{
                        Image(systemName: "goforward.5")
                            .resizable()
                            .frame(width: 22, height: 22)
                        
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity)
                
            }
            
            HStack {
                Text("00:25") // 현재 재생시간 데이터 넣어주기
                    .font(.system(size: 10))
            }
            .padding(.bottom, 10)
        }
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Button(action:{
                    showMarkerListOverlay = true
                }, label:{
                    Image(systemName: "list.bullet")
                        .foregroundColor(.yellow)
                })
                .frame(width:50)
            }
        }
        .fullScreenCover(isPresented: $showMarkerListOverlay, content: {
            WatchMarkerListView()
        })
    }
}

#Preview {
    WatchPlayingView()
        .environment(WatchNavigationManager())
}
