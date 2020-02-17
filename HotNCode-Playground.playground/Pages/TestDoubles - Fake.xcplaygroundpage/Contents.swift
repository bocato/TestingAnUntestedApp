import XCTest

struct User {
    let name: String
    let password: String
}

protocol UserServiceProtocol {
    func login(_ user: User, then: (Result<Void, Error>) -> Void)
}

final class LoginViewModel {
    
    private let userService: UserServiceProtocol
    private(set) var loggedUser: User?
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func performLoginForUser(_ user: User, then: @escaping () -> Void) {
        userService.login(user) { [weak self] result in
            let loginDidSucceed = (try? result.get()) != nil
            self?.loggedUser = loginDidSucceed ? user : nil
            then()
        }
    }
    
}

// Usage
final class LoginViewModelTests: XCTestCase {
    
    func test_loginShouldSucceed() {
        
        // Given
        let sut = LoginViewModel(userService: UserServiceFake())
        let userMock = User(name: "Mock", password: "Mock")
        
        // When
        let performLoginExpectation = expectation(description: "performLoginExpectation")
        sut.performLoginForUser(userMock) {
            performLoginExpectation.fulfill()
        }
        wait(for: [performLoginExpectation], timeout: 1.0)
        
        // Then
        XCTAssertNotNil(sut.loggedUser)
    }
    
}



