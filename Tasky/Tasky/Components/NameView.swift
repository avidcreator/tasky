//
//  NameView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

struct NameView: View {
    var placeholder: String
    @Binding var name: String
    @FocusState private var focusedTextField: FormTextField?
    
    enum FormTextField {
        case symbol
        case name
    }
    
    var body: some View {
        TextField(placeholder, text: $name, axis: .vertical)
            .frame(maxWidth: .infinity)
            .focused($focusedTextField, equals: .name)
            .onSubmit { focusedTextField = .name }
            .submitLabel(.next)
            .font(.title)
            .fontWeight(.regular)
            .padding(.vertical, 6)
            .multilineTextAlignment(.center)
            .lineLimit(3)
    }
}

#Preview {
    NameView(placeholder: "name your task", name: .constant("Get groceries"))
}
