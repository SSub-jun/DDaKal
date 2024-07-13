import SwiftUI

struct WatchMusicListView: View {
    
    @Environment(WatchNavigationManager.self) var navigationManager
    let columns = [ GridItem(.flexible()) ]

    let tempMusic = ["Music1", "Music2", "Music3", "Music4"]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(tempMusic, id: \.self) { music in // 여기서 SwiftData 노래목록 가져오기
                    Button(music) {
                        navigationManager.push(to: .playing)
                    }
                    .buttonBorderShape(.roundedRectangle)
                }
            }
            
        }
    }
}

//#Preview {
//    WatchMusicListView()
//}
