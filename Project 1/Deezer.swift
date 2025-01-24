import Foundation

struct Track {
    let title: String
    let artist: String
    let previewURL: String
    let coverImageURL: String
}

func fetchRockTracksWithPreview(completion: @escaping ([Track]) -> Void) {
    let searchQuery = "rock"
    // Adding the limit parameter to the search query to get only 10 results
    let urlString = "https://api.deezer.com/search?q=\(searchQuery)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching tracks: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            print("No data received")
            return
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let tracks = json["data"] as? [[String: Any]] {
                
                // Filter tracks to only include those with a preview URL and limit the result to 10
                let tracksWithPreview = tracks.compactMap { track -> Track? in
                    guard let title = track["title"] as? String,
                          let artist = track["artist"] as? [String: Any],
                          let artistName = artist["name"] as? String,
                          let previewURL = track["preview"] as? String,
                          let album = track["album"] as? [String: Any],
                          let coverImage = album["cover_big"] as? String else {
                        return nil
                    }
                    return Track(title: title, artist: artistName, previewURL: previewURL, coverImageURL: coverImage)
                }

                // Pass the filtered tracks to the completion handler
                completion(tracksWithPreview)
            } else {
                print("Error: Invalid JSON structure")
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }

    task.resume()
}
