import Foundation
import UIKit

enum ImageServiceError: Error {
    case invalidImage
    case requestFailed
    case decodingFailed
}

class ImageService {
    private let backendURL = URL(string: "http://82.76.112.183:8080/insect/identify")!

    func identify(insectImage image: UIImage) async throws -> Insect {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            throw ImageServiceError.invalidImage
        }

        var request = URLRequest(url: backendURL)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createMultipartBody(data: imageData, boundary: boundary, filename: "insect.jpg")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageServiceError.requestFailed
        }

        do {
            var insect = try JSONDecoder().decode(Insect.self, from: data)
            insect.thumbnail = image
            return insect
        } catch {
            throw ImageServiceError.decodingFailed
        }
    }

    private func createMultipartBody(data: Data, boundary: String, filename: String) -> Data {
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}

