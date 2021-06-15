//
//  StorageManager.swift
//  Messenger
//
//  Created by 강민성 on 2021/05/28.
//

import Foundation
import FirebaseStorage

/// 파이어베이스 스토리지에 파일을 get / fetch / upload 할 수 있게함
final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    /*
     /images/kang-gmail-com_profile_picture.png
     */
    
    /// 사진을 파이어베이스 스토리지에 업로드한뒤 다운로드할 url string과 completion을 반환함
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(
        with data: Data,
        fileName: String,
        completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                // 실패
                print("파이어베이스에 사진 업로드 실패")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("다운로드 url을 가져오는데 실패")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("다운로드 url return -> \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    
    /// 대화 메세지에 사진을 업로드 하여 전송
    
    public func uploadMessagePhoto(
        with data: Data,
        fileName: String,
        completion: @escaping UploadPictureCompletion) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // 실패
                print("파이어베이스에 사진 업로드 실패")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("다운로드 url을 가져오는데 실패")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("다운로드 url return -> \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public func uploadMessageVideo(
        with fileUrl: URL,
        fileName: String,
        completion: @escaping UploadPictureCompletion) {
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // 실패
                print("파이어베이스에 동영상 업로드 실패")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("다운로드 url을 가져오는데 실패")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("다운로드 url return -> \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let refrence = storage.child(path)
        
        refrence.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            
            completion(.success(url))
        })
    }
}
