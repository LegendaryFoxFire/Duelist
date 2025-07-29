import SwiftUI

struct LoadingSpinnerView: View {
    var body: some View {
        ZStack {
            // System background color (automatically adapts)
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("transparentbgswords")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .opacity(0.8)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(.label)))
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .foregroundColor(Color(.label))
                    .font(.title2)
            }
        }
    }
}
