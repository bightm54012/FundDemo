# FundDemo - SwiftUI Clean Architecture

這是一個使用 **SwiftUI** 與 **Swift Charts** 打造的基金淨值追蹤 App。本專案嚴格遵循 **Clean Architecture** 與 **MVVM** 模式，並透過單元測試確保核心邏輯的穩定性。



---

## 專案架構與優勢 (Architecture & Benefits)

本專案採用四層解耦架構，其核心價值在於：

* **易於維護 (Maintainability)**: 
    * **邏輯分離**：UI (SwiftUI)、商業邏輯 (UseCase) 與資料來源 (Repository) 互不干擾。若未來更換 API 來源或資料庫，只需修改 Data 層，不需動到介面與業務邏輯。
    * **單一職責**：每個 UseCase 只處理一件事（如：獲取淨值），這讓代碼結構清晰，易於定位問題。
* **高度可測試性 (Testability)**: 
    * 透過 **依賴注入 (Dependency Injection)**，我們可以在測試時輕鬆注入 Mock 資料，不需要啟動模擬器或連動網路即可驗證邏輯，大幅提升測試效率。

---

## UI/UX 優化細節 (UI Adaptability)

### 響應式 Tooltip 設計調整
在實作圖表選取功能（Tooltip）時，我針對手機螢幕寬度進行了優化調整：

* **原設計 (Figma)**: 淨值標籤與金額顯示於同一行（例如：`淨值：NT$ 15.50`）。
* **優化後實作**: 將格式調整為 **換行顯示**：
    ```text
    淨值：
    NT$ 15.50
    ```
* **決策原因**: 考量到行動裝置螢幕寬度有限，若淨值位元較長（或在 iPhone SE 等小螢幕裝置上），同一行顯示會導致 Tooltip 寬度過大，容易超出螢幕邊界或遮擋過多圖表資訊。透過換行處理，確保了在各種螢幕尺寸下皆能保持資訊的**可讀性**與**介面美感**。

---

## 執行方式 (Execution)

1.  **環境需求**: Xcode 15.0+ / iOS 17.0+。
2.  **開啟專案**: 複製專案後開啟 `.xcodeproj` 檔案。
3.  **運行**: 按下 `Cmd + R` 執行。
4.  **測試**: 按下 `Cmd + U` 執行所有單元測試。

---

## 測試描述 (Testing Strategy)

本專案透過 **XCTest** 針對 `FundPurchaseViewModel` 進行完整單元測試，涵蓋以下關鍵情境：

### 1. 申購邏輯測試 (Purchase Logic)
* **金額計算**: 驗證 `totalAmount` 是否精確執行 `最新淨值 * 申購單位` 的數學計算。
* **異常輸入處理**: 測試當使用者輸入非數字字元（如 "abc"）時，系統能正確將金額歸零，確保程式強健性。

### 2. UI 狀態與互動測試 (UI State & Interaction)
* **按鈕啟用狀態**: 驗證金額為 0 時禁用按鈕，大於 0 時啟用。這能有效引導使用者正確操作，避免無效點擊。
* **圖表選取邏輯**: 模擬使用者在圖表上滑動選取日期，驗證 ViewModel 是否能精確找回對應日期的 `NavPoint` 並同步更新 UI。

### 3. 資料載入與狀態管理
* **自動選取機制**: 測試 `loadData()` 成功後，系統是否正確自動選取列表中的第一筆基金作為初始顯示。
* **MockRepository**: 透過虛擬資料隔離網路不確定性，確保測試結果 100% 可預測且能快速執行。



---

## 技術棧 (Tech Stack)

* **UI 框架**: SwiftUI, Swift Charts
* **設計模式**: Clean Architecture + MVVM
* **非同步處理**: Swift Concurrency (Async/Await)
* **測試框架**: XCTest (Unit Testing)
