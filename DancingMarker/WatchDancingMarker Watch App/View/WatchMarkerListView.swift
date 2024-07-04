
import SwiftUI

struct WatchMarkerListView: View {
    
    let tempData = ["추가1", "추가2", "추가3"]
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack{
                
                ScrollView{
                    HStack {
                        Text("마커 관리")
                            .bold()
                            .padding([.leading, .bottom])
                        
                        Spacer()
                    }
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(tempData, id: \.self) { item in
                            NavigationLink(destination: WatchMarkerDetailView(data: item)) {
                                WatchMarkerListCellView(data: item)
                            }
                            .buttonStyle(PlainButtonStyle()) // <- 이 부분을 추가해 탭 가능 영역을 제한합니다.
                        }
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
    }
}

struct WatchMarkerListCellView: View {
    
    let data: String
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.blue)
                .cornerRadius(4)
                .frame(height: 44)
            
            HStack {
                markerImage()
                markerTime()
            }
        }
    }
    
    func markerImage() -> some View {
        Image(systemName: "shield.fill")
    }
    
    func markerTime() -> some View {
        Text("\(data)")
            .bold()
    }
}

#Preview {
    WatchMarkerListView()
}
