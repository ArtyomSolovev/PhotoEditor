import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: ImageEditingViewModel
    var image: UIImage?
    var isToolPickerPresented: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        if isToolPickerPresented {
            viewModel.canvasView.isOpaque = false
            viewModel.canvasView.backgroundColor = .clear
            viewModel.canvasView.drawingPolicy = .anyInput
        }

        if let image {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true

            let subView = viewModel.canvasView.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)

            if isToolPickerPresented {
                viewModel.toolPicker.setVisible(true, forFirstResponder: viewModel.canvasView)
                viewModel.toolPicker.addObserver(viewModel.canvasView)
            }

            viewModel.canvasView.becomeFirstResponder()
        }

        return viewModel.canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {

    }
}
