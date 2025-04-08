//
//  DocumentScanner.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI
import VisionKit
import PDFKit

struct DocumentScannerView: UIViewControllerRepresentable {

    @Binding var pdfURL: URL?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraVC = VNDocumentCameraViewController()
        documentCameraVC.delegate = context.coordinator
        return documentCameraVC
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentScannerView

        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController,
                                          didFinishWith scan: VNDocumentCameraScan) {
            let pdfURL = generatePDF(from: scan)
            parent.pdfURL = pdfURL
            parent.presentationMode.wrappedValue.dismiss()
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        private func generatePDF(from scan: VNDocumentCameraScan) -> URL? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            let timestamp = dateFormatter.string(from: Date())
            let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(timestamp).pdf")

            let pdfDocument = PDFDocument()

            for pageIndex in 0..<scan.pageCount {
                let scannedImage = scan.imageOfPage(at: pageIndex)
                if let pdfPage = PDFPage(image: scannedImage) {
                    pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)
                }
            }

            return pdfDocument.write(to: pdfURL) ? pdfURL : nil
        }
    }

}
