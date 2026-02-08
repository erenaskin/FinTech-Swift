🚀 FinTech - Advanced Crypto Market & Portfolio App
===================================================

**FinTech**, modern iOS geliştirme standartları kullanılarak geliştirilmiş, ölçeklenebilir ve test edilebilir bir kripto para takip ve portföy yönetimi uygulamasıdır.

Bu proje; **Clean Architecture**, **MVVM-C (Coordinator)**, **Reactive Programming (Combine)** ve **Programmatic UI**gibi ileri seviye mühendislik pratiklerini bir araya getirir.

📱 Screenshots
--------------

**Market (Home)Detail & ChartPortfolio**_\[Ekran Görüntüsü\]\[Ekran Görüntüsü\]\[Ekran Görüntüsü\]_E-Tablolar'a aktar

_(Not: Ekran görüntülerinizi projenizin içinde Docs/Screenshots klasörü oluşturarak ekleyebilirsiniz.)_

🌟 Key Features
---------------

*   **Real-time Market Data:** CoinGecko API entegrasyonu ile canlı kripto verileri.
    
*   **Reactive UI:** Combine framework'ü ile anlık veri akışı ve state yönetimi.
    
*   **Portfolio Management:** CoreData ile yerel veri tabanında alım/satım simülasyonu ve bakiye takibi.
    
*   **Advanced Charts:** Özel çizilmiş SparklineView ile interaktif fiyat grafikleri.
    
*   **Smart Searching & Sorting:** Combine ile debounced arama ve çoklu sıralama algoritmaları.
    
*   **Pull-to-Refresh:** Akıllı cache yönetimi ile veri yenileme.
    
*   **Safety First:** Güçlü hata yönetimi ve kullanıcı dostu uyarı mekanizmaları.
    

🛠 Tech Stack & Tools
---------------------

Bu projede kullanılan teknolojiler, endüstri standartları ve performans gözetilerek seçilmiştir.

*   **Language:** Swift 5.9 (Modern, güvenli ve hızlı)
    
*   **Architecture:** Clean Architecture + MVVM (Sorumlulukların ayrılması ve test edilebilirlik)
    
*   **Navigation:** Coordinator Pattern (ViewModel'den navigasyon mantığını ayırmak için)
    
*   **UI:** UIKit (Programmatic) + SnapKit (Storyboard bağımlılığı olmadan, performanslı arayüzler)
    
*   **Reactive:** Combine (Veri akışını ve UI güncellemelerini deklaratif yönetmek için)
    
*   **Networking:** Alamofire (Güvenilir, test edilebilir ve generic network katmanı)
    
*   **Local Storage:** CoreData (Portföy verilerinin kalıcı ve güvenli saklanması)
    
*   **Image Loading:** Kingfisher (Görsellerin asenkron yüklenmesi ve önbelleğe alınması)
    
*   **Testing:** XCTest & XCUITest (Business logic ve UI akışlarının doğruluğu için)
    
*   **CI/CD:** Fastlane (Testlerin ve süreçlerin otomasyonu)
    
*   **Code Quality:** SwiftLint (Kod standartlarının ve kalitesinin korunması)
    

🏗 Architecture OverviewShutterstock
------------------------------------

Proje, **Clean Architecture** prensiplerine sıkı sıkıya bağlı kalarak 4 ana katmana ayrılmıştır:

1.  **Domain Layer (Business Logic):**
    
    *   Uygulamanın "ne yaptığını" tanımlar. Hiçbir framework'e (UIKit, Alamofire vb.) bağımlı değildir.
        
    *   _Entities, UseCases, Repository Protocols._
        
2.  **Data Layer (Data Access):**
    
    *   Verinin nereden geldiğini (API veya CoreData) yönetir.
        
    *   _Repositories, DTOs, Endpoints, NetworkManager, CoreDataManager._
        
3.  **Presentation Layer (UI):**
    
    *   Verinin kullanıcıya nasıl gösterileceğini yönetir.
        
    *   _ViewModels, Views (Controllers), Coordinators._
        
4.  **Infrastructure Layer:**
    
    *   Temel yapı taşları.
        
    *   _Extensions, Constants, Utilities._
        

**Dependency Injection:** Tüm bağımlılıklar (Repositories, UseCases, ViewModels), Builder pattern kullanılarak dışarıdan enjekte edilmiştir. Bu sayede modüller gevşek bağlı (loosely coupled) ve test edilebilir hale gelmiştir.

🧪 Testing & Quality Assurance
------------------------------

Proje geliştirilirken TDD (Test Driven Development) prensiplerinden esinlenilmiştir.

**✅ Unit Tests** Business logic (ViewModel ve UseCase katmanları) izole edilerek test edilmiştir.

*   **Mocking:** Repository'ler ve Servisler mocklanarak dış bağımlılıklar olmadan test koşulmuştur.
    
*   **Combine Testing:** Asenkron veri akışları Expectation ve Cancellables kullanılarak test edilmiştir.
    

**🤖 UI Tests (Automation)** Kritik kullanıcı akışları (User Journeys) robotlar tarafından test edilmektedir.

*   _Örn: Uygulama açılışı -> Liste yüklenmesi -> Detay sayfasına geçiş._
    

**🛡️ Code Quality (Linting)** Projede **SwiftLint** entegre edilmiştir. Her derleme (build) işleminde kod kalitesi taranır ve standart dışı yazımlar otomatik olarak raporlanır.

🚀 CI/CD & Automation (Fastlane)
--------------------------------

Manuel süreçleri ortadan kaldırmak için **Fastlane** kurulmuştur.

Tek bir komut ile:

1.  Proje temizlenir (Clean).
    
2.  Derlenir (Build).
    
3.  Tüm Unit Testler ve UI Testler simülatörde çalıştırılır.
    
4.  Sonuç raporlanır.
    

Otomasyonu çalıştırmak için terminal komutu:

bundle exec fastlane tests

📥 Installation & Setup
-----------------------

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

**1\. Projeyi Klonlayın:**

git clone https://github.com/username/FinTech.git cd FinTech

**2\. Gerekli Araçları Yükleyin (Opsiyonel - Fastlane için):** Eğer testleri terminalden koşacaksanız Bundler'ı yükleyin.

gem install bundler bundle install --path vendor/bundle

**3\. Projeyi Açın:** Paketler (Alamofire, SnapKit vb.) **Swift Package Manager (SPM)** ile yönetildiği için ekstra bir pod install işlemine gerek yoktur.

open FinTech.xcodeproj

**4\. Paketlerin Yüklenmesini Bekleyin:** Xcode açıldığında SPM paketleri otomatik olarak indirecektir.

**5\. Çalıştırın:** Cmd + R ile projeyi başlatın!

🧠 Engineering Highlights (What makes this special?)
----------------------------------------------------

*   **Memory Management:** \[weak self\] kullanımı ile Retain Cycle'lar titizlikle engellenmiş, Memory Graph Debugger ile doğrulanmıştır.
    
*   **SOLID Principles:** Tüm sınıflar Single Responsibility ve Dependency Inversion prensiplerine uygun tasarlanmıştır.
    
*   **Protocol Oriented Programming:** Soyutlamalar (Interfaces) üzerinden iletişim kurularak test edilebilirlik artırılmıştır.
    
*   **Strategy Pattern:** Varlıkların (Assets) görsel durumları (Yükseliş, Düşüş, Nötr) Strategy tasarım deseni ile yönetilmiştir.
