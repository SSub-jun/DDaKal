import SwiftUI
import SwiftData

struct WatchMusicListView: View {
    
    @Environment(WatchNavigationManager.self) var navigationManager
    @EnvironmentObject var viewModel: WatchViewModel
    
    //    @Query var musicList: [watchMusic] = []
    let columns = [ GridItem(.flexible()) ]
    
    @State private var drawingHeight = true

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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                if viewModel.musicTitle != "" {
                    Button(action:{
                        navigationManager.push(to: .playing)
                    }, label:{
                        if viewModel.isPlaying {
                            HStack(spacing:0.7) {
                                bar(low: 0.4)
                                    .animation(animation.speed(1.5), value: drawingHeight)
                                bar(low: 0.3)
                                    .animation(animation.speed(1.2), value: drawingHeight)
                                bar(low: 0.5)
                                    .animation(animation.speed(1.0), value: drawingHeight)
                                bar(low: 0.3)
                                    .animation(animation.speed(1.7), value: drawingHeight)
                            }
                            .frame(width:20)
                            .onAppear{
                                drawingHeight.toggle()
                            }
                        } else{
                            HStack(spacing:0.7) {
                                bar(low: 0.7)
                                bar(low: 0.2)
                                bar(low: 0.6)
                                bar(low: 0.3)
                            }
                            .frame(width:20)
                        }
                        
                    })
                }
            }
        }
        .onAppear{
            viewModel.connectivityManager.sendRequireMusicListToIOS()
        }
    }
    
    func bar(low: CGFloat = 0.0, high: CGFloat = 1.0) -> some View {
        RoundedRectangle(cornerRadius: 1.2)
            .fill(.accent)
            .frame(height: (drawingHeight ? high : low) * 20)
            .frame(height: 20, alignment: .bottom)
    }
    
    var animation: Animation {
        return .linear(duration: 0.5).repeatForever()
    }
}

