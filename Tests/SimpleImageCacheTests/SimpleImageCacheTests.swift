//
//  SimpleImageCacheTests.swift
//  SimpleImageCache
//
//  Created by Michael Topschij on 17/06/2025.
//

import XCTest
@testable import SimpleImageCache

final class SimpleImageCacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clear cache before each test
        SimpleImageCache.clearAllCache()
    }
    
    override func tearDown() {
        // Clean up after each test
        SimpleImageCache.clearAllCache()
        super.tearDown()
    }
    
    func testDiskURLGeneration() {
        let url = URL(string: "https://example.com/image.jpg")!
        let diskURL = SimpleImageCache.diskURL(for: url)
        
        XCTAssertTrue(diskURL.path.contains("Caches"))
        XCTAssertTrue(diskURL.lastPathComponent.count > 0)
    }
    
    func testMemoryCacheStorage() {
        let url = URL(string: "https://example.com/test.jpg")!
        let testImage = UIImage(systemName: "photo") ?? UIImage()
        
        // Store in memory cache
        SimpleImageCache.memory.setObject(testImage, forKey: url as NSURL)
        
        // Retrieve from memory cache
        let cachedImage = SimpleImageCache.memory.object(forKey: url as NSURL)
        
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage, testImage)
    }
    
    func testDiskCacheStorage() {
        let url = URL(string: "https://example.com/disk-test.jpg")!
        let testImage = UIImage(systemName: "photo") ?? UIImage()
        
        // Save to disk
        SimpleImageCache.saveToDisk(testImage, url: url)
        
        // Load from disk
        let loadedImage = SimpleImageCache.loadFromDisk(url: url)
        
        XCTAssertNotNil(loadedImage)
    }
    
    func testClearMemoryCache() {
        let url = URL(string: "https://example.com/clear-test.jpg")!
        let testImage = UIImage(systemName: "photo") ?? UIImage()
        
        // Store in memory
        SimpleImageCache.memory.setObject(testImage, forKey: url as NSURL)
        XCTAssertNotNil(SimpleImageCache.memory.object(forKey: url as NSURL))
        
        // Clear memory cache
        SimpleImageCache.clearMemoryCache()
        XCTAssertNil(SimpleImageCache.memory.object(forKey: url as NSURL))
    }
}
