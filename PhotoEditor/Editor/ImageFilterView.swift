import SwiftUI

struct ImageFilterView: View {
    
    @StateObject private var viewModel = ImageFilterViewModel()
    var image: UIImage

    var body: some View {
        VStack {
            if let image = viewModel.filteredImage ?? viewModel.originalImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            VStack {
                ForEach(viewModel.availableFilters(), id: \.name) { filter in
                    Button(action: {
                        viewModel.applyFilter(filter)
                    }, label: {
                        Text(filter.name)
                            .customButtonModifier()
                    })
                }
            }
            .padding(.vertical)
        }
        .padding()
        .onAppear {
            viewModel.originalImage = image
        }
    }
}

#Preview {
    ImageFilterView(image: .add)
}
