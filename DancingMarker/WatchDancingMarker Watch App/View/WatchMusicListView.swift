import SwiftUI
import SwiftData

struct WatchMusicListView: View {
    
    @Environment(WatchNavigationManager.self) var navigationManager
    @EnvironmentObject var viewModel: WatchViewModel
    
    //    @Query var musicList: [watchMusic] = []
    let columns = [ GridItem(.flexible()) ]

    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.musicList, id: \.self) { music in // 여기서 SwiftData 가져오기
                    if music != ""{
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
}
