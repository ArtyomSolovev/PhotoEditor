import SwiftUI
import PhotosUI

struct EditorView: View {
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack {
            PhotosPicker("Select a picture",
                         selection: $pickerItem,
                         matching: .images)
            selectedImage?
                .resizable()
                .scaledToFit()
        }
        .onChange(of: pickerItem) { 
            Task {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            }
        }
    }
}

#Preview {
    EditorView()
}
