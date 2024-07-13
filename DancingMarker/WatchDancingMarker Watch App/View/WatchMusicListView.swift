import SwiftUI

struct WatchMusicListView: View {
    
    @Environment(WatchNavigationManager.self) var navigationManager
    let columns = [ GridItem(.flexible()) ]
    
    let tempMusic = ["NewJeans-SuperNatural", "Music2", "Music3", "Music4"]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(tempMusic, id: \.self) { music in // 여기서 SwiftData 가져오기
                    Button(action: {
                        navigationManager.push(to: .playing)
                    }) {
                        Text(music) // SwiftData title 넣으면 됨.
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                    .buttonBorderShape(.roundedRectangle)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

//#Preview {
//    WatchMusicListView()
//}
