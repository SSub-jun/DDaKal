
import SwiftUI

struct WatchPlayingSpeedView: View {
    
    @State private var speed: Double = 1.0 // 기본 속도
    
    var body: some View {
        HStack(spacing: 0) {
            
            // MARK: - 버튼
            HStack {
                Text("-")
                    .font(.system(size: 17))
                    .foregroundColor(speed < 0.55 ? .gray : .white) // 0.5배가 되면 Gray색상으로
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft]))
            .onTapGesture {
                print("Tapped: 배속 - 버튼눌렀습니다.")
                decreaseSpeed() // 배속 줄이는 함수
            }
            
            // MARK: 배속 Text & 원배로 돌아가는 버튼
            HStack {
                Text(String(format: "%.1fx", speed))
                    .font(.system(size: 17))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.gray.opacity(0.2))
            .onTapGesture {
                print("Tapped: 원배 버튼눌렀습니다.")
                originalSpeed() // 원배로 돌아가는 함수
            }
            
            // MARK: + 버튼
            HStack {
                Text("+")
                    .font(.system(size: 17))
                    .foregroundColor(speed == 1.5 ? .gray : .white) // 1.5배가 되면 Gray색상으로
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedCorner(radius: 4, corners: [.topRight, .bottomRight]))
            .onTapGesture {
                print("Tapped: 배속 + 버튼눌렀습니다.")
                increaseSpeed() // 배속 증가 함수
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // 배속 감소
    private func decreaseSpeed() {
        if speed > 0.5 {
            speed = max(0.5, speed - 0.1) // 부동소수점 처리
        }
    }
    
    // 배속 증가
    private func increaseSpeed() {
        if speed < 1.5 {
            speed = min(1.5, speed + 0.1) // 부동소수점 처리
        }
    }
    
    // 배속 원배로 돌아오기
    private func originalSpeed() {
        if speed != 1.0 {
            speed = 1.0
        }
    }
}

// MARK: View -> 특정 모서리만 둥글게
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
#Preview {
    WatchPlayingSpeedView()
}
