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
                ForEach(viewModel.musicList.indices, id:\.self) { index in
                    if  viewModel.musicList[index][0] != ""{
                        Button(action: {
                            DispatchQueue.main.async{
                                viewModel.sendUUID(id: viewModel.musicList[index][1])
                                navigationManager.push(to: .playing)
                            }
                        }) {
                            Text(viewModel.musicList[index][0])
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
        .onAppear{
            viewModel.connectivityManager.sendRequireMusicListToIOS()
        }
    }
}
