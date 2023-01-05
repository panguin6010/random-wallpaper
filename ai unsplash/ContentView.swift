//
//  ContentView.swift
//  ai unsplash
//
//  Created by Shlomo Isaacs on 12/29/22.
//

// Import the necessary frameworks
import SwiftUI
import Alamofire
import UIKit

// Define the main content view
struct ContentView: View {
  // Declare state variables to store the image, loading status, error message, and image history
  @State private var image: UIImage?
  @State private var loading = false
  @State private var errorMessage: String?
  @State private var imageHistory: [UIImage] = []

  var body: some View {
    NavigationView {
      VStack {
        // If an image is available, display it and show the share and save buttons
        if image != nil {
          Image(uiImage: image!)
            .resizable()
            .aspectRatio(contentMode: .fit)
          HStack {
            Button(action: shareImage) {
              Image(systemName: "square.and.arrow.up")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button(action: saveImage) {
              Image(systemName: "tray.and.arrow.down")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
          }
        // If an error message is available, display it
        } else if errorMessage != nil {
          Text(errorMessage!)
            .font(.title)
            .foregroundColor(.red)
        // If no image or error is available, show a message prompting the user to fetch an image
        } else {
          Text("Tap the button to fetch an image")
            .font(.title)
        }

        Spacer()

        // Fetch image button
        Button(action: fetchRandomImage) {
          Text("Fetch Image")
        }
        .disabled(loading) // Disable the button while the image is being fetched
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
      }
      .padding()
      .navigationBarTitle("Random Walpaper")
      // Add a button to the navigation bar to access the image history view
      .navigationBarItems(trailing:
        NavigationLink(destination: ImageHistoryView(imageHistory: $imageHistory)) {
          Image(systemName: "book.fill")
        }
      )
    }
  }

  // Function to fetch a random image from the Unsplash API
    func fetchRandomImage() {
        let screenSize = UIScreen.main.bounds.size
        var ScreenHeight = "\(screenSize.height)"
        var ScreenWidth = "\(screenSize.width)"
         ScreenHeight = ScreenHeight.replacingOccurrences(of: ".0", with: "")
         ScreenWidth = ScreenWidth.replacingOccurrences(of: ".0", with: "")

        self.loading = true
        AF.request("https://source.unsplash.com/random/\(ScreenWidth)x\(ScreenHeight)").response { response in
          self.loading = false
          if let data = response.data, let newImage = UIImage(data: data) {
            // Update the image and add it to the history if the request is successful
            self.image = newImage
            self.imageHistory.append(newImage)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
          } else {
              // If the request fails, show an error message
                      self.errorMessage = "Failed to load image"
                      print(self.errorMessage)
                      print("https://source.unsplash.com/random/\(ScreenWidth)x\(ScreenHeight)")
                    }
                  }
                }
            // Function to share the current image
            func shareImage() {
              if let image = image {
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
              }
            }

            // Function to save the current image to the user's photo library
            func saveImage() {
              if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
              }
            }
          }

          // View to display the image history
          struct ImageHistoryView: View {
            @Binding var imageHistory: [UIImage]

            var body: some View {
              List(imageHistory, id: \.self) { image in
                VStack {
                  // Display the image
                  Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                  HStack {
                    // Share button
                    Button(action: {
                      let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                      UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                    }) {
                      Image(systemName: "square.and.arrow.up")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    // Save button
                    Button(action: {
                      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }) {
                      Image(systemName: "tray.and.arrow.down")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                  }
                }
              }
            }
          }

