# ProductBrowserApp

✅ Architectural Decisions
I used UIKit with MVP (Model–View–Presenter) architecture, which is a classical and well-structured approach in UIKit-based apps.
For UI, I chose UICollectionView with CompositionalLayout and DiffableDataSource — they offer powerful, declarative layouts and performant data handling.
Given my experience and fluency with UIKit, I was able to implement and iterate faster than I would with SwiftUI.
(If using SwiftUI, I would have gone with MVVM.)
Although I intended to go with a modular architecture and extract networking and features into separate modules, due to time constraints I organized code by folders instead.
The architecture is built on protocol-oriented programming (POP) and adheres to SOLID principles where possible.
I implemented Dependency Injection without third-party libraries (though in production I typically use tools like Swinject).
Persistence and settings (favorites, dark mode) are handled via UserDefaults behind a protocol abstraction — allowing for easy replacement (e.g., with Realm or CoreData) in the future.

⚠️ Assumptions & Limitations
I used UserDefaults for simplicity, since the data was lightweight, not sensitive, and didn’t require schema or querying.
In a real-world project, I would replace it with Realm or CoreData depending on complexity.
Due to time limits, I only covered the core presenter (ProductListPresenter) with unit tests.
For mocking protocols, I typically use Sourcery for auto-generation — in this task I manually mocked minimal interfaces.
Ideally, the project would also include:
Unit tests for ApiDataSource (happy path + parsing)
Unit tests for LocalDataSource (state storing, updating)
Snapshot tests for reusable cell UI states
UI tests for full flows (toggle favorite, dark mode)
I encountered a crash with DiffableDataSource due to duplicated product items with identical identifiers (same id, title, etc.). I resolved this by filtering duplicates in the presenter — avoiding this edge case earlier could have saved time.

⏱ Approximate Time Spent
8–10 hours total
~6–7 hours for implementation
~1–2 hours debugging DiffableDataSource issues
~1 hour writing unit tests and cleanup

🤖 AI Assistance
Some parts of this README were refined with the help of ChatGPT, specifically for polishing descriptions and structuring documentation.
All architecture, code, and logic reflect my personal development practices and coding style.


