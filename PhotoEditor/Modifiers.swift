import SwiftUI

struct CustomButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(uiColor: UIColor(resource: .text)))
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: UIColor(resource: .background)))
            }
    }
    
}

extension View {
    
    func customButtonModifier() -> some View {
        modifier(CustomButtonModifier())
    }
    
}
