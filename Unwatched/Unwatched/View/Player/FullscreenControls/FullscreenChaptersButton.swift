//
//  FullscreenChaptersButton.swift
//  Unwatched
//

import SwiftUI
import UnwatchedShared

struct FullscreenChaptersButton: View {
    @Environment(PlayerManager.self) var player
    @State var showChapters = false

    var arrowEdge: Edge
    @Binding var menuOpen: Bool
    var size: CGFloat

    var body: some View {
        Button {
            if !showChapters {
                showChapters = true
                menuOpen = true
            }
        } label: {
            Image(systemName: "line.3.horizontal.circle.fill")
                .resizable()
                .modifier(PlayerControlButtonStyle())
                .frame(width: size, height: size)
        }
        .fontWeight(.bold)
        .accessibilityLabel("chapters")
        .padding(.horizontal) // workaround: safearea pushing content in pop over
        .popover(isPresented: $showChapters, arrowEdge: arrowEdge) {
            if let video = player.video {
                ZStack {
                    Color.sheetBackground
                        .scaleEffect(1.5)

                    ScrollViewReader { proxy in
                        ScrollView {
                            ChapterList(video: video, isCompact: true)
                                .padding(6)
                        }
                        .onAppear {
                            proxy.scrollTo(player.currentChapter?.persistentModelID, anchor: .center)
                        }
                        .scrollIndicators(.hidden)
                    }
                    .frame(
                        minWidth: 200,
                        idealWidth: 350,
                        maxWidth: 350
                    )
                }
                .environment(\.colorScheme, .dark)
                .presentationCompactAdaptation(.popover)
                .onDisappear {
                    menuOpen = false
                }
                .fontWeight(nil)
            }
        }
    }
}

#Preview {
    FullscreenChaptersButton(
        arrowEdge: .bottom,
        menuOpen: .constant(true),
        size: 40
    )
    .environment(PlayerManager())
}
