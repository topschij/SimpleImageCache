//
//  SimpleImageCache.swift
//  SimpleImageCache
//
//  Created by Michael Topschij on 17/06/2025.
//

import SwiftUI
import Foundation

// MARK: - Public API

/// For images that should never change
public func cachedImage(url: URL, completion: @escaping (UIImage) -> Void) {
    
    // Memory cache
    if let img = SimpleImageCache.memory.object(forKey: url as NSURL) {
        completion(img)
    } else if let img = SimpleImageCache.loadFromDisk(url: url) { // Disk cache
        SimpleImageCache.memory.setObject(img, forKey: url as NSURL)
        completion(img)
    } else {
        // Download if not cached
        loadImageFromURL(url: url) { image in
            completion(image)
        }
    }
}

/// For when we want instant image but also reload it...
public func cachedAndReloadImage(url: URL, completion: @escaping (UIImage) -> Void) {
    // Memory cache
    if let img = SimpleImageCache.memory.object(forKey: url as NSURL) {
        completion(img)
    } else if let img = SimpleImageCache.loadFromDisk(url: url) { // Disk cache
        SimpleImageCache.memory.setObject(img, forKey: url as NSURL)
        completion(img)
    }
    
    loadImageFromURL(url: url) { image in
        completion(image)
    }
}

public func loadImageFromURL(url: URL, completion: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, _, _ in
        
        guard let data, let img = UIImage(data: data) else {
            return
        }
        
        SimpleImageCache.memory.setObject(img, forKey: url as NSURL)
        SimpleImageCache.saveToDisk(img, url: url)
        
        DispatchQueue.main.async {
            completion(img)
        }
    }.resume()
}

// MARK: - Image Cache Implementation

public class SimpleImageCache {
    public static let memory = NSCache<NSURL, UIImage>()
    
    public static func diskURL(for url: URL) -> URL {
        let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDir.appendingPathComponent(fileName)
    }
    
    public static func saveToDisk(_ image: UIImage, url: URL) {
        let diskURL = diskURL(for: url)
        if let data = image.pngData() {
            try? data.write(to: diskURL)
        }
    }
    
    public static func loadFromDisk(url: URL) -> UIImage? {
        let diskURL = diskURL(for: url)
        if let data = try? Data(contentsOf: diskURL) {
            return UIImage(data: data)
        }
        return nil
    }
    
    // MARK: - Cache Management
    
    /// Clear all cached images from memory
    public static func clearMemoryCache() {
        memory.removeAllObjects()
    }
    
    /// Clear all cached images from disk
    public static func clearDiskCache() {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: nil)
            for file in files {
                try? FileManager.default.removeItem(at: file)
            }
        } catch {
            print("Failed to clear disk cache: \(error)")
        }
    }
    
    /// Clear both memory and disk cache
    public static func clearAllCache() {
        clearMemoryCache()
        clearDiskCache()
    }
}
