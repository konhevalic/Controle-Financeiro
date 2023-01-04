//
//  EditarUsuarioViewController.swift
//  ControleFinanceiro
//
//  Created by Alan on 29/10/22.
//  Created by Alan on 29/10/22.
//

import UIKit
import CoreData

class EditarUsuarioViewController: UIViewController {
    
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var sobrenome: UITextField!
    @IBOutlet weak var receitaMensal: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmarSenha: UITextField!
    
    var usuarios = UsuariosCadastrados.shared.usuarios
    
    @IBAction func cadastrarUsuario(_ sender: Any) {
        let novoUsuario = Usuario(context: self.contexto)
        
        novoUsuario.nome = self.nome.text!
        novoUsuario.sobrenome = self.sobrenome.text!
        novoUsuario.receita = Float(self.receitaMensal.text!) ?? 3000.00
        novoUsuario.email = self.email.text!
        novoUsuario.senha = self.senha.text!
        novoUsuario.confirmarSenha = self.confirmarSenha.text!
        
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        
        do {
            usuarios = try contexto.fetch(request)
        } catch {
            fatalError()
        }
        
        do {
            if(novoUsuario.nome != "" &&
               novoUsuario.sobrenome != "" &&
               novoUsuario.email != "" &&
               novoUsuario.senha != "" &&
               novoUsuario.confirmarSenha != "" &&
               novoUsuario.senha == novoUsuario.confirmarSenha
            ){

                usuarios.append(novoUsuario)
                try self.contexto.save()
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let login = storyBoard.instantiateViewController(withIdentifier: "Login")
                self.navigationController?.pushViewController(login, animated: true)
                
            } else {
                print(fatalError())

            }
        } catch {
            fatalError()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
