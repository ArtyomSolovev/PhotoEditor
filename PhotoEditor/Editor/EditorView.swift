import SwiftUI
import PhotosUI

struct EditorView: View {
    
    @EnvironmentObject var viewModel: ImageEditingViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var isPresentedCanvas = false
    
    var body: some View {
        VStack {
            
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
            
            PhotosPicker("Выбрать изображение", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                        }
                    }
                }
                .customButtonModifier()
            
            Button("Открыть камеру") {
                showCamera.toggle()
            }
            .fullScreenCover(isPresented: self.$showCamera) {
                AccessCameraView(selectedImage: self.$selectedImage)
            }
            .customButtonModifier()
            
            Button("Редактировать фото") {
                isPresentedCanvas = true
            }
            .customButtonModifier()
        }
        .padding()
        .sheet(isPresented: $isPresentedCanvas, content: {
            ZStack {
                CanvasView(image: selectedImage,
                           isToolPickerPresented: true)
                .offset(.zero)
                .environmentObject(viewModel)
            }
            .onDisappear {
                viewModel.cancelImageEditing()
            }
        })
    }
}

#Preview {
    EditorView()
}
