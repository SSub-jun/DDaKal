import SwiftUI

struct WatchPlayingMarkerView: View {
    
    @EnvironmentObject var viewModel: WatchViewModel
    
    var body: some View {
        
        HStack{
            // MARK: 마커 1
            ZStack {
                Rectangle()
                    .fill(viewModel.markers[0] == "99:59" ? Color.gray.opacity(0.2) : .yellow) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    Text(viewModel.markers[0] == "99:59" ? "추가" : viewModel.markers[0]) // 마커 추가가 되었다면 ? 마커 시간 : "추가"
                }
            }
            .onTapGesture {
                if viewModel.markers[0] == "99:59"{
                    viewModel.connectivityManager.sendMarkerSaveToIOS(0)
                } else {
                    viewModel.connectivityManager.sendMarkerPlayToIOS(0)
                }
            }
            
            // MARK: 마커 2
            ZStack {
                Rectangle()
                    .fill(viewModel.markers[1] == "99:59" ? Color.gray.opacity(0.2) : .yellow) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    Text(viewModel.markers[1] == "99:59" ? "추가" : viewModel.markers[1]) // 마커 추가가 되었다면 ? 마커 시간 : "추가"
                }
            }
            .onTapGesture {
                if viewModel.markers[1] == "99:59"{
                    viewModel.connectivityManager.sendMarkerSaveToIOS(1)
                } else {
                    viewModel.connectivityManager.sendMarkerPlayToIOS(1)
                }
            }
            
            // MARK: 마커 3
            ZStack {
                Rectangle()
                    .fill(viewModel.markers[2] == "99:59" ? Color.gray.opacity(0.2) : .yellow) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(systemName: "shield.fill")
                    Text(viewModel.markers[2] == "99:59" ? "추가" : viewModel.markers[2]) // 마커 추가가 되었다면 ? 마커 시간 : "추가"
                }
            }
            .onTapGesture {
                if viewModel.markers[2] == "99:59"{
                    viewModel.connectivityManager.sendMarkerSaveToIOS(2)
                } else {
                    viewModel.connectivityManager.sendMarkerPlayToIOS(2)
                }
                
            }
        }
        .padding(.bottom)
    }
}
