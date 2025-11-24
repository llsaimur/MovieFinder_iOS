# MovieFinder

[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-16+-blue)](https://developer.apple.com/xcode/)

A modern **SwiftUI + Firebase** iOS app that allows users to **search for movies**, explore detailed information, and save their favorites — powered by the **OMDb API**.

---

## Features

* **Search Movies**

  * Search by title using the OMDb API.
  * Displays movie poster, title, and release year.

* **Movie Details**

  * View detailed information such as genre, director, cast, runtime, ratings, and plot.
  * Clean layout with async image loading.

* **Favorites**

  * Save and manage your favorite movies.
  * Data persists across sessions using Firebase Firestore.

* **User Authentication**

  * Sign up, log in, and log out securely using FirebaseAuth.

* **Modern Navigation**

  * SwiftUI `NavigationStack` for smooth screen transitions.
  * Tab-based UI with sections for Search, Favorites, and Profile.

* **Realtime Sync**

  * Favorites sync instantly across logged-in devices.

---

## Tech Stack

| Component        | Technology                           |
| ---------------- | ------------------------------------ |
| **Language**     | Swift                                |
| **Framework**    | SwiftUI                              |
| **Architecture** | MVVM                                 |
| **Networking**   | `async/await` + `URLSession`         |
| **Backend**      | Firebase (Auth + Firestore)          |
| **API**          | [OMDb API](https://www.omdbapi.com/) |
| **IDE**          | Xcode 16+                            |

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/MovieFinder.git
cd MovieFinder
```

### 2. Open in Xcode

Open the `.xcodeproj` or `.xcworkspace` file in Xcode 16+.

### 3. Install Dependencies

Ensure you have:

* Xcode Command Line Tools
* CocoaPods or Swift Package Manager (SPM)
* A Firebase project with:

  * Authentication (Email/Password enabled)
  * Cloud Firestore
* Download your `GoogleService-Info.plist` from Firebase and add it to your Xcode project root.

### 4. Get an OMDb API Key

The app uses the OMDb API to fetch movie data.

1. Go to [OMDb API](https://www.omdbapi.com/apikey.aspx)
2. Sign up for a free API key (usually sent via email)
3. Add the key to your Xcode project:

**Option A — Scheme Environment Variable**

* Go to Product → Scheme → Edit Scheme → Run → Arguments.
* Under **Environment Variables**, add:

```text
OMDB_API_KEY = your_api_key_here
```

**Option B — `.xcconfig` File**

* Create a `Config.xcconfig` file in your project:

```text
OMDB_API_KEY = your_api_key_here
```

* Link it in your Xcode project’s build configuration.

---

## App Navigation Overview

| Screen        | Description                                                                |
| ------------- | -------------------------------------------------------------------------- |
| **Search**    | Enter a movie title and browse results from OMDb                           |
| **Details**   | Tap a movie to view detailed info (poster, genre, director, ratings, plot) |
| **Favorites** | View your saved movies (Firestore synced)                                  |
| **Profile**   | Manage user authentication and sign out                                    |

---

## Example Usage

1. Launch the app.
2. Create an account or log in.
3. Enter a movie title (e.g., “Inception”) and tap **Search**.
4. Tap a movie to view its full details.
5. (Optional) Save it to your favorites list.

---

## Screenshots

## Screenshots

![Login](Screenshots/Login.png)
*Login to your account.*

![Register](Screenshots/Register.png)
*Create a new account.*

![Movie Search](Screenshots/MovieSearchView.png)
*Search for movies and browse results.*

![Movie Detail](Screenshots/MovieDetailView.png)
*View detailed information for a selected movie.*

![Favorites](Screenshots/FavoritesView.png)
*Manage your favorite movies synced with Firebase.*

![Add to Favorites](Screenshots/AddFavoritesView.png)
*Add or remove movies from your favorites.*

![Profile](Screenshots/ProfileView.png)
*Manage your account and sign out.*

---

## Project Overview

The Movie Finder App provides a complete demonstration of iOS development fundamentals, including:

* SwiftUI layouts and navigation
* Networking and JSON parsing
* State management using MVVM
* Persistence with Firebase
* Realtime syncing and user authentication

It is designed to be **beginner-friendly**, functional, and visually appealing.
