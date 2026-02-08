# 🚀 FinTech - Advanced Crypto Market & Portfolio App

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-lightgrey.svg)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVVM--C-blue.svg)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
[![Concurrency](https://img.shields.io/badge/Concurrency-Combine-blueviolet.svg)](https://developer.apple.com/documentation/combine)
[![CI/CD](https://img.shields.io/badge/Fastlane-Integrated-green.svg)](https://fastlane.tools/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**FinTech**, modern iOS geliştirme standartları kullanılarak geliştirilmiş, ölçeklenebilir ve test edilebilir bir kripto para takip ve portföy yönetimi uygulamasıdır. 

Bu proje; **Clean Architecture**, **MVVM-C (Coordinator)**, **Reactive Programming (Combine)** ve **Programmatic UI** gibi ileri seviye mühendislik pratiklerini bir araya getirir.

---

## 📱 Screenshots

| Market (Home) | Detail & Chart | Portfolio |
|:---:|:---:|:---:|
| <img src="Docs/Screenshots/home.png" width="250"> | <img src="Docs/Screenshots/detail.png" width="250"> | <img src="Docs/Screenshots/portfolio.png" width="250"> |

*(Not: Ekran görüntülerinizi projenizin içinde `Docs/Screenshots` klasörü oluşturarak ekleyebilirsiniz.)*

---

## 🌟 Key Features

* **Real-time Market Data:** CoinGecko API entegrasyonu ile canlı kripto verileri.
* **Reactive UI:** `Combine` framework'ü ile anlık veri akışı ve state yönetimi.
* **Portfolio Management:** `CoreData` ile yerel veri tabanında alım/satım simülasyonu ve bakiye takibi.
* **Advanced Charts:** Özel çizilmiş `SparklineView` ile interaktif fiyat grafikleri.
* **Smart Searching & Sorting:** Combine ile debounced arama ve çoklu sıralama algoritmaları.
* **Pull-to-Refresh:** Akıllı cache yönetimi ile veri yenileme.
* **Safety First:** Güçlü hata yönetimi ve kullanıcı dostu uyarı mekanizmaları.

---

## 🛠 Tech Stack & Tools

Bu projede kullanılan teknolojiler, endüstri standartları ve performans gözetilerek seçilmiştir.

| Category | Technology | Reason |
| :--- | :--- | :--- |
| **Language** | Swift 5.9 | Modern, güvenli ve hızlı. |
| **Architecture** | Clean Architecture + MVVM | Sorumlulukların ayrılması (SoC) ve test edilebilirlik. |
| **Navigation** | Coordinator Pattern | ViewModel'den navigasyon mantığını ayırmak için. |
| **UI** | UIKit (Programmatic) + SnapKit | Storyboard bağımlılığı olmadan, performanslı ve dinamik arayüzler. |
| **Reactive** | Combine | Veri akışını ve UI güncellemelerini deklaratif yönetmek için. |
| **Networking** | Alamofire | Güvenilir, test edilebilir ve generic network katmanı. |
| **Local Storage** | CoreData | Portföy verilerinin kalıcı ve güvenli saklanması. |
| **Image Loading** | Kingfisher | Görsellerin asenkron yüklenmesi ve önbelleğe alınması. |
| **Testing** | XCTest & XCUITest | Business logic ve UI akışlarının doğruluğu için. |
| **CI/CD** | Fastlane | Testlerin ve süreçlerin otomasyonu. |
| **Code Quality** | SwiftLint | Kod standartlarının ve kalitesinin korunması. |

---

## 🏗 Architecture Overview 

[Image of Clean Architecture Diagram]


Proje, **Clean Architecture** prensiplerine sıkı sıkıya bağlı kalarak 4 ana katmana ayrılmıştır:

1.  **Domain Layer (Business Logic):**
    * Uygulamanın "ne yaptığını" tanımlar. Hiçbir framework'e (UIKit, Alamofire vb.) bağımlı değildir.
    * *Entities, UseCases, Repository Protocols.*
2.  **Data Layer (Data Access):**
    * Verinin nereden geldiğini (API veya CoreData) yönetir.
    * *Repositories, DTOs, Endpoints, NetworkManager, CoreDataManager.*
3.  **Presentation Layer (UI):**
    * Verinin kullanıcıya nasıl gösterileceğini yönetir.
    * *ViewModels, Views (Controllers), Coordinators.*
4.  **Infrastructure Layer:**
    * Temel yapı taşları.
    * *Extensions, Constants, Utilities.*

### Dependency Injection
Tüm bağımlılıklar (Repositories, UseCases, ViewModels), `Builder` pattern kullanılarak dışarıdan enjekte edilmiştir. Bu sayede modüller gevşek bağlı (loosely coupled) ve test edilebilir hale gelmiştir.

---

## 🧪 Testing & Quality Assurance

Proje geliştirilirken TDD (Test Driven Development) prensiplerinden esinlenilmiştir.

### ✅ Unit Tests
Business logic (ViewModel ve UseCase katmanları) izole edilerek test edilmiştir.
* **Mocking:** Repository'ler ve Servisler mocklanarak dış bağımlılıklar olmadan test koşulmuştur.
* **Combine Testing:** Asenkron veri akışları `Expectation` ve `Cancellables` kullanılarak test edilmiştir.

### 🤖 UI Tests (Automation)
Kritik kullanıcı akışları (User Journeys) robotlar tarafından test edilmektedir.
* *Örn: Uygulama açılışı -> Liste yüklenmesi -> Detay sayfasına geçiş.*

### 🛡️ Code Quality (Linting)
Projede **SwiftLint** entegre edilmiştir. Her derleme (build) işleminde kod kalitesi taranır ve standart dışı yazımlar otomatik olarak raporlanır.

---

## 🚀 CI/CD & Automation (Fastlane)

Manuel süreçleri ortadan kaldırmak için **Fastlane** kurulmuştur.

Tek bir komut ile:
1.  Proje temizlenir (Clean).
2.  Derlenir (Build).
3.  Tüm Unit Testler ve UI Testler simülatörde çalıştırılır.
4.  Sonuç raporlanır.

Otomasyonu çalıştırmak için:
```bash
bundle exec fastlane tests
