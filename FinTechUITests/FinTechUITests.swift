//
//  FinTechUITests.swift
//  FinTechUITests
//
//  Created by Eren AŞKIN on 8.02.2026.
//

import XCTest

final class FinTechUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_user_can_navigate_to_detail_page() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tableView = app.tables["AssetListTableView"]
        

        let exists = tableView.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "Tablo 10 saniye içinde yüklenemedi!")
        
        let firstCell = tableView.cells.element(boundBy: 0)
        
        let cellExists = firstCell.waitForExistence(timeout: 5)
        XCTAssertTrue(cellExists, "İlk hücre bulunamadı")
        
        firstCell.tap()

        let priceLabel = app.staticTexts["DetailPriceLabel"]
        
        let detailExists = priceLabel.waitForExistence(timeout: 3)
        XCTAssertTrue(detailExists, "Detay sayfasına geçilemedi veya fiyat etiketi yok!")
    }
}
