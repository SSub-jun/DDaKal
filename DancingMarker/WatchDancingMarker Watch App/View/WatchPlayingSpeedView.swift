
import SwiftUI

struct WatchPlayingSpeedView: View {
    @State private var speed: Double = 1.0
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text("-")
                    .font(.system(size: 17))
                    .foregroundColor(speed < 0.55 ? .gray : .white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft]))
            .onTapGesture {
                print("Tapped: 배속 - 버튼")
                decreaseSpeed()
            }
            
            HStack {
                Text(String(format: "%.1fx", speed))
                    .font(.system(size: 17))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.gray.opacity(0.2))
            .onTapGesture {
                print("Tapped: 원배 버튼")
                originalSpeed()
            }
            
            HStack {
                Text("+")
                    .font(.system(size: 17))
                    .foregroundColor(speed == 1.5 ? .gray : .white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedCorner(radius: 4, corners: [.topRight, .bottomRight]))
            .onTapGesture {
                print("Tapped: 배속 + 버튼")
                increaseSpeed()
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

// MARK: 특정 모서리만 둥글게
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
