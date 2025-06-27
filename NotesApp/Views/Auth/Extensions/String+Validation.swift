//
//  String+Validation.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import Foundation

extension String {
    /// Valida si el string es un email válido
    var isValidEmail: Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    /// Valida si el string es una contraseña válida (mínimo 8 caracteres)
    var isValidPassword: Bool {
        return self.count >= 8
    }
    
    /// Valida si el string es un código de confirmación válido (6 dígitos)
    var isValidConfirmationCode: Bool {
        let codeRegex = "^[0-9]{6}$"
        return NSPredicate(format: "SELF MATCHES %@", codeRegex).evaluate(with: self)
    }
}
