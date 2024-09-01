# NewsApp

![NewsApp Logo](path_to_your_logo_image)

**NewsApp** is a four-paged news listing application built with Swift and UIKit. It fetches news from the Google News API, allowing users to browse, search, filter, and favorite news articles. The app is built using the MVVM architecture, ensuring a clear separation of concerns and maintainability.

## Table of Contents

- [Features](#features)
- [Goals](#goals)
- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Usage](#usage)
- [Localization](#localization)
- [Unit Testing](#unit-testing)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

## Features

1. **Splash Screen**
   - Displays on app launch.
   - Requests push notification permissions asynchronously.
   - Waits for user response before navigating to the next screen.

2. **News List Screen**
   - Displays a list of news articles fetched from the Google News API.
   - Pull to refresh functionality to update news data.
   - Search functionality to find news by text.
   - Filter functionality to filter news by date range (e.g., from 01/08/2024 to 30/08/2024).
   - Uses a table view to display news items.
   - Downloads and caches images using Kingfisher.

3. **News Detail Screen**
   - Shows detailed information about a selected news article.
   - Option to add or remove the article from favorites.

4. **Favorites Screen**
   - Displays a list of favorited news articles.
   - Opens the article in Safari when tapped.
   - Stores favorites using UserDefaults.

5. **Tab Bar Controller**
   - Manages navigation between the News List and Favorites screens.

## Goals

- **Permissions Handling:** Learn how to request and handle push notification permissions.
- **Protocols:** Implement and utilize protocols for asynchronous operations and callbacks.
- **MVVM Architecture:** Understand and apply the MVVM pattern by separating logic between controllers and view models.
- **Third-Party Integration:** Integrate libraries like Alamofire, SnapKit, and Kingfisher.
- **Programmatic UI:** Build the user interface programmatically without using Storyboards or XIBs.
- **Data Persistence:** Use UserDefaults to store and retrieve favorited news articles.
- **Generic Network Layer:** Create a reusable network layer using Alamofire and generics.
- **Codable Models:** Use Codable for parsing and handling JSON data.
- **Localization:** Localize the app to support multiple languages.
- **Unit Testing:** Write unit tests to ensure the reliability of view models and the network layer.

## Architecture

The app follows the **Model-View-ViewModel (MVVM)** architecture, ensuring a clear separation between the UI and business logic.

- **Model:** Represents the data structures (e.g., `News`, `Article`).
- **View:** The UIKit components responsible for the UI (e.g., `UIViewController`, `UITableView`).
- **ViewModel:** Handles the business logic, data manipulation, and communicates with the view via closures.

**Key Points:**

- **No UIKit Imports in ViewModel:** Ensures that the view models remain platform-agnostic and testable.
- **Closures for Communication:** Uses closures to notify the view about data updates or errors.
- **Protocols:** Defines protocols to decouple the network layer from the view models.

## Technologies Used

- **Language & Framework:** Swift, UIKit
- **Dependency Management:** Swift Package Manager (SPM)
- **UI Layout:** SnapKit
- **Image Loading & Caching:** Kingfisher
- **Data Persistence:** UserDefaults
- **Testing:** XCTest
- **Localization:** Supports multiple languages


## Usage

1. **Splash Screen**
   - Upon launching the app, the splash screen appears and requests permission for push notifications. The app will wait for the user's response before proceeding to the next screen.

2. **News List Screen**
   - This screen displays a list of news articles from the most recent to the past. 
   - You can pull to refresh the news list to fetch the latest data from the Google News API.
   - A search bar allows you to search for news articles by text. 
   - A date range filter enables you to filter news articles between specific dates (e.g., from 01/01/2022 to 30/01/2022). The search and filter operations interact with the API, not local data.

3. **News Detail Screen**
   - When a news article is tapped, the detail screen appears showing more information about the selected article.
   - You can add the news article to your favorites by tapping the favorite button. This button updates its state based on whether the news is already in your favorites.

4. **Favorites Screen**
   - This screen displays a list of news articles that have been marked as favorites.
   - Tapping on a favorited news article opens the URL in Safari.
   - There is no search or filter functionality on this screen. 

## Architecture

- **MVVM Pattern:** The project uses the MVVM (Model-View-ViewModel) architecture to separate business logic from UI components.
- **Network Layer:** A generic network layer is implemented using Alamofire for API requests.
- **Local Storage:** Favorites are stored using UserDefaults.
- **UI Design:** The UI is built programmatically using SnapKit for layout and Kingfisher for image loading.

## Localization

- The app supports localization. Texts are available in multiple languages. Ensure that `Localizable.strings` files are updated for new languages.

## Testing

- **Unit Tests:** The project includes unit tests for the view models and network layer to ensure the correct functionality.
- **Testing Tools:** XCTest is used for writing unit tests.

## Screenshots
![Splash Screen](https://raw.githubusercontent.com/metehangurgentepe/NewsApp/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20Max%20-%202024-09-01%20at%2012.41.10.png)
![News List](https://raw.githubusercontent.com/metehangurgentepe/NewsApp/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20Max%20-%202024-09-01%20at%2012.41.14.png)
![News Detail](https://raw.githubusercontent.com/metehangurgentepe/NewsApp/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20Max%20-%202024-09-01%20at%2012.41.40.png)
![Favorites](https://raw.githubusercontent.com/metehangurgentepe/NewsApp/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20Max%20-%202024-09-01%20at%2012.41.26.png)

## Contributing

Contributions are welcome! Please submit a pull request with your changes or improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or feedback, please contact me at [your-email@example.com](mailto:your-email@example.com).

---

Thank you for using the News App!
