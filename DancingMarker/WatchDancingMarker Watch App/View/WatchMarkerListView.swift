import SwiftUI

struct WatchMarkerListView: View {
    
    @State private var navigationPath = NavigationPath()
    let columns = [ GridItem(.flexible()) ]
    
    @EnvironmentObject var viewModel: WatchViewModel
    
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
                    // 여기서 임시데이터가 아닌 스위프트에 저장되어있는 data를 cell 변수로 넣어서 보여주기
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.timeintervalMarkers.indices, id: \.self) { index in
                            if viewModel.timeintervalMarkers[index] != -1{
                                NavigationLink(value: index) {
                                    WatchMarkerListCellView(data: viewModel.timeintervalMarkers[index])
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else{
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .frame(height: 44)
                                    HStack {
                                        Image("emptyMarker")
                                            .resizable()
                                            .frame(width: 12, height: 20)
                                            .padding()
                                        Text("없음")
                                            .font(.system(size: 14))
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationDestination(for: Int.self) { index in
                WatchMarkerDetailView(navigationPath: $navigationPath, index: index)
            }
        }
    }
}

// 여기서 marker 데이터가 있을경우 없을경우 나눠서 CellView 다르게 나오게
struct WatchMarkerListCellView: View {
    
    let data: TimeInterval
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.primaryYellow)
                .cornerRadius(4)
                .frame(height: 44)
            HStack {
                markerImage()
                markerTime()
            }
        }
    }
    
    func markerImage() -> some View {
        Image("addedMarker")
            .resizable()
            .frame(width: 12, height: 20)
            .padding()
    }
    
    func markerTime() -> some View {
        Text("\(formattedTime(data))")
            .font(.system(size: 14))
            .foregroundColor(.black)
            .italic()
    }
    
    func formattedTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: time)!
    }
}

func formattedTime(_ time: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = [.pad]
    return formatter.string(from: time)!
}

#Preview {
    WatchMarkerListView()
}
