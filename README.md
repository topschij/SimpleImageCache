
# SimpleImageCache

A lightweight Swift package for caching images with both memory and disk storage support.

## Features

- **Memory Caching**: Fast access to frequently used images
- **Disk Caching**: Persistent storage for images across app launches
- **Automatic Downloads**: Downloads images from URLs when not cached
- **Cache Management**: Methods to clear memory and disk cache
- **SwiftUI Compatible**: Works seamlessly with SwiftUI projects

## Installation

### Swift Package Manager

Add this package to your project using Swift Package Manager:

1. In Xcode, go to File → Add Package Dependencies
2. Enter the repository URL
3. Select the version you want to use
4. Add to your target

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/topschij/SimpleImageCache.git", from: "1.0.0")
]
```

## Usage

### Basic Image Caching

For images that should never change once cached:

```swift
import SimpleImageCache

let imageURL = URL(string: "https://example.com/image.jpg")!

cachedImage(url: imageURL) { image in
    // Use the cached or downloaded image
    DispatchQueue.main.async {
        self.imageView.image = image
    }
}
```

### Cache and Reload

For images that you want to display immediately from cache but also refresh:

```swift
cachedAndReloadImage(url: imageURL) { image in
    // This will be called twice:
    // 1. Immediately with cached image (if available)
    // 2. Again with fresh downloaded image
    DispatchQueue.main.async {
        self.imageView.image = image
    }
}
```

### Direct URL Loading

To download an image directly (will still cache it):

```swift
loadImageFromURL(url: imageURL) { image in
    // Handle the downloaded image
    DispatchQueue.main.async {
        self.imageView.image = image
    }
}
```

### Cache Management

Clear memory cache:
```swift
SimpleImageCache.clearMemoryCache()
```

Clear disk cache:
```swift
SimpleImageCache.clearDiskCache()
```

Clear both memory and disk cache:
```swift
SimpleImageCache.clearAllCache()
```

## How It Works

1. **Memory Check**: First checks if the image is in memory cache
2. **Disk Check**: If not in memory, checks disk cache and loads to memory
3. **Download**: If not cached anywhere, downloads from URL
4. **Storage**: Downloaded images are stored in both memory and disk cache

## Platform Support

- iOS 13.0+
- macOS 10.15+
- tvOS 13.0+
- watchOS 6.0+

## License

This project is available under the MIT License.
