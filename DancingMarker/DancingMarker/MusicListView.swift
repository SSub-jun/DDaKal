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
    @Query var musicList: [Music] = []
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
                        if let albumArtData = music.albumArt, let albumArt = UIImage(data: albumArtData) {
                            Image(uiImage: albumArt)
                                .resizable()
                                .frame(width: 66, height: 66)
                                .cornerRadius(13)
                        } else {
                            RoundedRectangle(cornerRadius: 13)
                                .fill(Color.gray)
                                .frame(width: 66, height: 66)
                        }
                        
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
                    .onTapGesture {
                        navigationManager.push(to: .playing(music: music))
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
                    Task {
                        await addMusic(from: url)
                    }
                }
            case .failure(let error):
                print("Failed to import file: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchMusicMetadata(from url: URL) async throws -> (String, String, Data?) {
        let asset = AVAsset(url: url)
        let metadata = try await asset.load(.commonMetadata)
        
        var title: String = "Unknown Title"
        var artist: String = "Unknown Artist"
        var albumArt: Data? = nil
        
        for item in metadata {
            if item.commonKey == .commonKeyTitle {
                title = try await item.load(.stringValue) ?? "Unknown Title"
            }
            if item.commonKey == .commonKeyArtist {
                artist = try await item.load(.stringValue) ?? "Unknown Artist"
            }
            if item.commonKey == .commonKeyArtwork {
                albumArt = try await item.load(.dataValue)
            }
        }
        
        return (title, artist, albumArt)
    }
    
    private func addMusic(from url: URL) async {
        // 보안 범위 설정 시작
        guard url.startAccessingSecurityScopedResource() else {
            print("Failed to start accessing security scoped resource at \(url)")
            return
        }
        
        do {
            let (title, artist, albumArt) = try await fetchMusicMetadata(from: url)
            let fileName = url.lastPathComponent
            let destinationURL = getDocumentsDirectory().appendingPathComponent(fileName)
            
            // 파일 복사
            try FileManager.default.copyItem(at: url, to: destinationURL)
            
            let markers: [TimeInterval] = [] // 추후에 실제 마커 데이터를 추가해야 함
            
            let newMusic = Music(title: title, artist: artist, path: destinationURL, markers: markers, albumArt: albumArt)
            
            modelContext.insert(newMusic)
            
            try modelContext.save()
        } catch {
            print("Failed to fetch music metadata: \(error.localizedDescription)")
        }
        
        // 보안 범위 설정 종료
        // url.stopAccessingSecurityScopedResource()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
                if self.musicList.firstIndex(of: music) != nil {
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
