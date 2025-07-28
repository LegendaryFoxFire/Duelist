import SwiftUI
import UIKit
import AVFoundation

struct CameraImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var sourceType: UIImagePickerController.SourceType = .camera
    var onImagePicked: (UIImage) -> Void
    var onError: ((String) -> Void)? = nil

    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented, onImagePicked: onImagePicked, onError: onError)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        // Check camera availability
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            context.coordinator.onError?("Camera is not available on this device")
            DispatchQueue.main.async {
                isPresented = false
            }
            return UIViewController() // Return empty controller
        }
        
        // Check camera permissions
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    DispatchQueue.main.async {
                        context.coordinator.onError?("Camera permission is required to take photos")
                        isPresented = false
                    }
                }
            }
        case .denied, .restricted:
            context.coordinator.onError?("Camera permission denied. Please enable in Settings.")
            DispatchQueue.main.async {
                isPresented = false
            }
            return UIViewController()
        @unknown default:
            break
        }
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true // Enable basic editing
        picker.cameraDevice = .front // Default to front camera for selfies
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isPresented: Bool
        let onImagePicked: (UIImage) -> Void
        let onError: ((String) -> Void)?

        init(isPresented: Binding<Bool>, onImagePicked: @escaping (UIImage) -> Void, onError: ((String) -> Void)?) {
            _isPresented = isPresented
            self.onImagePicked = onImagePicked
            self.onError = onError
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            // Try edited image first, then original
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                onImagePicked(image)
            } else {
                onError?("Failed to capture image")
            }
            isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented = false
        }
    }
}
