import SwiftUI


struct WatchMarkerListView: View {
    
    @State private var navigationPath = NavigationPath()
    let columns = [ GridItem(.flexible()) ]
    
    let tempData = [47, 97, 206] // 임시 데이터
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                ScrollView {
                    HStack {
                        Text("마커 관리")
                            .fontWeight(.heavy)
                            .padding([.leading, .bottom])
                        Spacer()
                    }
                    
                    // 여기서 스위프트에 저장되어있는 data를 cell 변수로 넣어서 보여주기
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(tempData, id: \.self) { item in
                            NavigationLink(value: item) {
                                WatchMarkerListCellView(data: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationDestination(for: Int.self) { item in
                WatchMarkerDetailView(navigationPath: $navigationPath, data: item)
            }
        }
    }
}

// 여기서 marker 데이터가 있을경우 없을경우 나눠서 CellView 다르게 나오게
struct WatchMarkerListCellView: View {
    
    let data: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
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
            .resizable()
            .frame(width: 12, height: 20)
            .padding()
    }
    
    func markerTime() -> some View {
        Text("\(convertTime(seconds: data))")
    }
    
    func convertTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    WatchMarkerListView()
}
