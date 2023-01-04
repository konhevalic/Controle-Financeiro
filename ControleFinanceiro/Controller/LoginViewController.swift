//
//  LoginViewController.swift
//  ControleFinanceiro
//
//  Created by Alan on 29/10/22.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var senhaLogin: UITextField!
    
    var usuarios = UsuariosCadastrados.shared.usuarios
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    @IBAction func fazerLogin(_ sender: Any) {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        
        request.predicate = NSPredicate(format: "email = %@", argumentArray: [emailLogin.text!])
        
        
        do {
            usuarios = try contexto.fetch(request)
        } catch {
            fatalError()
        }
        var index = 0

        
        if(senhaLogin.text! == usuarios[0].senha) {
            UsuariosCadastrados.shared.usuarioLogado = usuarios[0]

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let informacoesGerais = storyBoard.instantiateViewController(withIdentifier: "InformacoesGerais")
            self.navigationController?.pushViewController(informacoesGerais, animated: true)
        } else {
            print("email ou senha invalidos")
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

}
