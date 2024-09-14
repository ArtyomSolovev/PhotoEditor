import Foundation

enum AlertError: String {
    case accountNotCreated = "Не получилось создать аккаунт"
    case authenticationNotCompleted = "Не получилось войти в аккаунт"
    case emailCheckingNotCompleted = "Не получилось проверить уникальность электронной почты"
    case incorrectLogin = "Введен некорректный адресс электронной почты"
    case incorrectPassword = "Длинна пароля менее 8 символов"
    case userAlreadyCreated = "Пользователь уже создан"
    case userNotFound = "Пользователь не найден"
    case passwordNotRecovery = "Не получилось восстоновить пароль"
    case none
}
