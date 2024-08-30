import SwiftUI
import Mixpanel

struct WatchPlayingMarkerView: View {
    
    @EnvironmentObject var viewModel: WatchViewModel
    
    var body: some View {
        HStack{
            // MARK: 마커 1
            ZStack {
                Rectangle()
                    .fill(viewModel.markers[0] == "99:59" ? Color.gray.opacity(0.2) : .primaryYellow) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(viewModel.markers[0] != "99:59" ? "addedMarker" : "emptyMarker")
                    Text(viewModel.markers[0] == "99:59" ? "추가" : viewModel.markers[0]) // 마커 추가가 되었다면 ? 마커 시간 : "추가"
                        .foregroundColor(viewModel.markers[0] == "99:59" ? .white : .black)
                        .font(.system(size: 12))
                        .italic()
                }
            }
            .onTapGesture {
                if viewModel.markers[0] == "99:59"{
                    viewModel.connectivityManager.sendMarkerSaveToIOS(0)
                    saveMarker1()
                } else {
                    viewModel.connectivityManager.sendMarkerPlayToIOS(0)
                    playMarker1()
                }
            }
            
            // MARK: 마커 2
            ZStack {
                Rectangle()
                    .fill(viewModel.markers[1] == "99:59" ? Color.gray.opacity(0.2) : .primaryYellow) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(viewModel.markers[1] != "99:59" ? "addedMarker" : "emptyMarker")
                    Text(viewModel.markers[1] == "99:59" ? "추가" : viewModel.markers[1]) // 마커 추가가 되었다면 ? 마커 시간 : "추가"\
                        .foregroundColor(viewModel.markers[1] == "99:59" ? .white : .black)
                        .font(.system(size: 12))
                        .italic()
                }
            }
            .onTapGesture {
                if viewModel.markers[1] == "99:59"{
                    viewModel.connectivityManager.sendMarkerSaveToIOS(1)
                    saveMarker2()
                } else {
                    viewModel.connectivityManager.sendMarkerPlayToIOS(1)
                    playMarker2()
                }
            }
            
            // MARK: 마커 3
            ZStack {
                Rectangle()
                    .fill(viewModel.markers[2] == "99:59" ? Color.gray.opacity(0.2) : .primaryYellow) // 마커 추가가 되었다면 ? .yellow : Color.gray.opacity(0.2)
                    .cornerRadius(4)
                    .frame(height: 52)
                
                VStack {
                    Image(viewModel.markers[2] != "99:59" ? "addedMarker" : "emptyMarker")
                    Text(viewModel.markers[2] == "99:59" ? "추가" : viewModel.markers[2]) // 마커 추가가 되었다면 ? 마커 시간 : "추가"
                        .foregroundColor(viewModel.markers[2] == "99:59" ? .white : .black)
                        .font(.system(size: 12))
                        .italic()
                }
            }
            .onTapGesture {
                if viewModel.markers[2] == "99:59"{
                    viewModel.connectivityManager.sendMarkerSaveToIOS(2)
                    saveMarker3()
                } else {
                    viewModel.connectivityManager.sendMarkerPlayToIOS(2)
                    playMarker3()
                }
            }
        }
        .padding(.bottom)
    }
    
    private func saveMarker1() {
        Mixpanel.mainInstance().track(event: "saveMarker1")
        Mixpanel.mainInstance().people.increment(property: "saveMarker1", by: 1)
    }
    
    private func saveMarker2() {
        Mixpanel.mainInstance().track(event: "saveMarker2")
        Mixpanel.mainInstance().people.increment(property: "saveMarker2", by: 1)
    }
    
    private func saveMarker3() {
        Mixpanel.mainInstance().track(event: "saveMarker3")
        Mixpanel.mainInstance().people.increment(property: "saveMarker3", by: 1)
    }
    
    private func playMarker1() {
        Mixpanel.mainInstance().track(event: "playMarker1")
        Mixpanel.mainInstance().people.increment(property: "playMarker1", by: 1)
    }
    
    private func playMarker2() {
        Mixpanel.mainInstance().track(event: "playMarker2")
        Mixpanel.mainInstance().people.increment(property: "playMarker2", by: 1)
    }
    
    private func playMarker3() {
        Mixpanel.mainInstance().track(event: "playMarker3")
        Mixpanel.mainInstance().people.increment(property: "playMarker3", by: 1)
    }
}
