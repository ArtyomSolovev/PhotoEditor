import SwiftUI
import CoreImage.CIFilterBuiltins

final class ImageFilterViewModel: ObservableObject {
    
    @Published var originalImage: UIImage?
    @Published var filteredImage: UIImage?
    
    private let context = CIContext()
    private let filters: [CIFilter] = [
        CIFilter.sepiaTone(),
        CIFilter.photoEffectMono(),
        CIFilter.photoEffectNoir()
    ]

    func applyFilter(_ filter: CIFilter) {
        guard let image = originalImage else { return }
        let ciImage = CIImage(image: image)

        filter.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }

        filteredImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

    func availableFilters() -> [CIFilter] {
        return filters
    }
}
