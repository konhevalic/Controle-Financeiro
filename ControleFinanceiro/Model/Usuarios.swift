//
//  Usuarios.swift
//  ControleFinanceiro
//
//  Created by Aluno on 31/10/22.
//

import Foundation

class UsuariosCadastrados {
    
    var usuarios = [Usuario]()
    var usuarioLogado: Usuario?
    var gastos = [Gasto]()
    
    static let shared = UsuariosCadastrados()
    
}
