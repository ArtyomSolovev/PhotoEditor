import SwiftUI
import PencilKit
import PhotosUI

final class ImageEditingViewModel: ObservableObject {
    
    @Published var canvasView = PKCanvasView()
    @Published var image: UIImage?
    @Published var toolPicker = PKToolPicker()
    @Published var isEditing: Bool = false
    @Published var rect: CGRect = .zero
    
    func cancelImageEditing() {
        canvasView = PKCanvasView()
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        image = nil
    }

    func cancelTextView() {
        canvasView.becomeFirstResponder()
        withAnimation {
            isEditing = false
        }
    }
}
