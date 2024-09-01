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
    @EnvironmentObject var playerModel: PlayerModel
    
    var body: some View {
        VStack {
            if musicList.isEmpty {
                VStack {
                    Spacer()
                    
                    Image("emptyBox")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 332)
                        .padding(.bottom, 20)
                    Text("추가된 음악이 없어요.")
                    Text("오른쪽 상단의 버튼을 눌러")
                    Text("음악을 추가해주세요.")
                    
                    Spacer(minLength: 220)
                }
                .font(.body)
                .foregroundStyle(.inactiveGray)
                
            } else {
                List(musicList, id: \.self) { music in
                    HStack(spacing: 10) {
                        if let albumArtData = music.albumArt, let albumArt = UIImage(data: albumArtData) {
                            Image(uiImage: albumArt)
                                .resizable()
                                .frame(width: 66, height: 66)
                                .cornerRadius(13)
                        } else {
                            RoundedRectangle(cornerRadius: 13)
                                .fill(.textLightGray)
                                .frame(width: 66, height: 66)
                                .overlay {
                                    Image(systemName: "music.note")
                                        .resizable()
                                        .padding()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                }
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
                        Spacer()
                        
                    }
                    //MARK: - 코드 정리 필요
                    .contentShape(Rectangle())
                    .onTapGesture {
                        //DispatchQueue.main.async {
                            
                            let selectedMusic = music
                            
                            if playerModel.music == nil {
                                // 음원이 nil 일 때 (처음 노래를 켤 때)
                                playerModel.music = selectedMusic
                                playerModel.isPlaying = true
                                playerModel.initAudioPlayer(for: selectedMusic)
                                playerModel.playAudio()
                                print("음원 \(playerModel.music?.title)으로 처음 재생됨")
                            } else if playerModel.music?.id == selectedMusic.id {
                                // 현재 재생 중인 음원과 동일할 때
                                print("음원 그대로임 \(playerModel.music?.title)")
                                if !playerModel.isPlaying {
                                    // 음원이 정지된 상태라면 재생 시작
                                    print("정지였었삼: \(playerModel.music?.title)")
                                    playerModel.isPlaying = true
                                    playerModel.playAudio()
                                }
                            } else {
                                // 새로운 음원으로 변경되었을 경우
                                playerModel.stopAudio()
                                playerModel.stopTimer() // 기존 타이머 중지
                                
                                playerModel.music = selectedMusic
                                playerModel.isPlaying = true
                                playerModel.initAudioPlayer(for: selectedMusic)
                                print("음원 \(playerModel.music?.title)으로 바뀜")
                                
                                playerModel.playAudio()
                            }
                        playerModel.sendPlayingInformation()
                        
                        // PlayingView로 이동
                        navigationManager.push(to: .playing)
                    }
                }
                .listStyle(.inset)
                
                NowPlayingView()
                    .frame(height: 240) // 미니 플레이어의 높이 조정
                    .background(.nowPlayingGray)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 20
                        )
                    )
                    .padding(.bottom, 0)
            }
            
        }
        .navigationTitle("내 음악")
        .toolbar {
            ToolbarItem (placement: .topBarTrailing) {
                Button(action: {
                    isFileImporterPresented.toggle()
                }) {
                    Text("추가하기")
                        .foregroundStyle(.primaryYellow)
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
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    private func tipButton() -> some View {
        TipButtonView()
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
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let uniqueFileURL = documentsDirectory.appendingUniquePathComponent(url.lastPathComponent)
            
            try FileManager.default.copyItem(at: url, to: uniqueFileURL)
            
            let newMusic = Music(
                title: title,
                artist: artist,
                path: uniqueFileURL,
                markers: [-1, -1, -1],
                albumArt: albumArt
            )
            
            modelContext.insert(newMusic)
            try modelContext.save()
            
            playerModel.sendMusicListToWatch(with: musicList)
        } catch {
            print("Failed to fetch music metadata: \(error.localizedDescription)")
        }
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
                DispatchQueue.main.async {
                    if let index = self.musicList.firstIndex(of: music) {
                        modelContext.delete(musicList[index])
                        do{
                            try modelContext.save()
                        } catch {
                            print("Failed to fetch music metadata: \(error.localizedDescription)")
                        }
                    }
                    playerModel.sendMusicListToWatch(with: musicList)
                }
            }) {
                Text("삭제하기")
                Image(systemName: "trash")
            }
        }
    }
}

extension URL {
    func appendingUniquePathComponent(_ component: String) -> URL {
        var newURL = self.appendingPathComponent(component)
        let fileManager = FileManager.default
        var fileExists = fileManager.fileExists(atPath: newURL.path)
        
        // Loop to find a unique name
        while fileExists {
            let baseName = newURL.deletingPathExtension().lastPathComponent
            let extensionName = newURL.pathExtension
            let uniqueName = "\(baseName)-\(UUID().uuidString).\(extensionName)"
            newURL = self.appendingPathComponent(uniqueName)
            fileExists = fileManager.fileExists(atPath: newURL.path)
        }
        
        return newURL
    }
}
