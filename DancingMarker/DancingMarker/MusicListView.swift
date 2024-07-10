//
//  MusicListView.swift
//  DancingMarker
//
//  Created by 변준섭 on 6/27/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct MusicListView: View {
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.modelContext) private var modelContext
    @State private var musicList: [Music] = []
    @State private var isFileImporterPresented: Bool = false

    var body: some View {
        VStack {
            if musicList.isEmpty {
                VStack {
                    Text("추가된 음악이 없어요.")
                    Text("오른쪽 상단의 버튼을 눌러")
                    Text("음악을 추가해주세요.")
                }
                .font(.body)
            } else {
                List(musicList, id: \.self) { music in
                    HStack(spacing: 10){
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.gray)
                            .frame(width: 66, height: 66)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(music.title)
                                .font(.title3)
                                .bold()
                            Text(music.artist)
                                .font(.body)
                        }
                        .contextMenu {
                            musicContextMenu(music: music)
                        }
                        
                    }
                }
                .listStyle(.inset)
            }
        }
        .navigationTitle("내 음악")
        .toolbar {
            ToolbarItem (placement: .topBarTrailing) {
                Button("추가하기") {
                    //navigationManager.push(to: .musicadd)
                    isFileImporterPresented.toggle()
                }
            }
        }
        .fileImporter(
            isPresented: $isFileImporterPresented,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    addMusic(from: url)
                }
            case .failure(let error):
                print("Failed to import file: \(error.localizedDescription)")
            }
        }
    }
    
    private func addMusic(from url: URL) {
        let title = url.deletingPathExtension().lastPathComponent
        let artist = "Unknown Artist" // 실제로는 메타데이터를 사용해야 함
        let path = url.path
        let markers: [TimeInterval] = [] // 추후에 실제 마커 데이터를 추가해야 함
        
        let newMusic = Music(title: title, artist: artist, path: path, markers: markers)
        modelContext.insert(newMusic)
        musicList.append(newMusic)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save music: \(error.localizedDescription)")
        }
    }
    
    private func musicContextMenu(music: Music) -> some View {
        Group {
            Button(action: {
                // 수정 기능
            }) {
                Text("수정하기")
                Image(systemName: "pencil")
            }
            Button(role: .destructive, action: {
                if let index = self.musicList.firstIndex(of: music) {
                    self.musicList.remove(at: index)
                    modelContext.delete(music)
                }
            }) {
                Text("삭제하기")
                Image(systemName: "trash")
            }
            
        }
    }
}

#Preview {
    MusicListView()
        .environment(NavigationManager())
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)

}
