//
//  InformacoesGeraisViewController.swift
//  ControleFinanceiro
//
//  Created by Alan on 31/10/22.
//

import UIKit
import CoreData
import DropDown

class InformacoesGeraisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let usuarioLogado = UsuariosCadastrados.shared.usuarioLogado
    var gastos = UsuariosCadastrados.shared.gastos
    
    var despesaMensalTotal = DespesaMensalTotal.shared.despesaMensalTotal
    var meses = DespesaMensalTotal.shared.meses
    var changed = false
    
    let now = Date()
    let dateFormatter = DateFormatter()

    var arrayData = [Date]()

    var nameOfMonth = ""

    var total = Float(0)
    var index = 0
    
    @IBOutlet weak var saudacaoUsuario: UILabel!
    @IBOutlet weak var saldoAtual: UILabel!
    @IBOutlet weak var ganhoMensal: UILabel!
    @IBOutlet weak var gastosMensais: UILabel!
    
    let dropDown = DropDown()

    @IBOutlet weak var mesAtual: UIButton!
    
    @IBAction func logout(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyBoard.instantiateViewController(withIdentifier: "Login")
        self.navigationController?.pushViewController(login, animated: true)
        
        for itens in DespesaMensalTotal.shared.despesaMensalTotal {
            itens.despesas.removeAll()
            itens.nomeDespesas.removeAll()
            itens.categorias.removeAll()
            itens.dataGasto.removeAll()
            itens.receita = 0
            
        }
        
        DespesaMensalTotal.shared.dadosCarregados = false
    }
    
    @IBAction func dropTeste(_ sender: UIButton) {
        
        dropDown.dataSource = meses
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [self] (index: Int, item: String) in
          sender.setTitle(item, for: .normal)
            nameOfMonth = item
            let indexMesAtual = meses.firstIndex(of: nameOfMonth)
            changed = true
            mesAtual.setTitle(nameOfMonth, for: .normal)
            
            total = Float(despesaMensalTotal[indexMesAtual!].despesas.reduce(0, +))
            
            self.saldoAtual.text = "Saldo atual: R$ \(total == 0 ? 0 : usuarioLogado!.receita - total)"
            
            self.ganhoMensal.text = String(total == 0 ? 0 : usuarioLogado!.receita)
            
            self.gastosMensais.text = String(total)
            
            let cell = IndexPath(row: despesaMensalTotal[indexMesAtual!].nomeDespesas.count - 1, section: 0)

            listaGastos.reloadData()
        }

    }
    
    @IBOutlet weak var listaGastos: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let index = meses.firstIndex(of: nameOfMonth)
        return despesaMensalTotal[index!].nomeDespesas.count
    }
    
    private func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return UITableView.automaticDimension
    }


    private func tableView(tableView: UITableView!, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaGastosCelula", for: indexPath)
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 21))
        label.textAlignment = .left
        
        let label2 = UILabel(frame: CGRect(x: 10, y: 21, width: 200, height: 21))
        label2.textAlignment = .left
        
        let label1 = UILabel(frame: CGRect(x: 10, y: 42, width: 200, height: 21))
        label1.textAlignment = .left

        let label3 = UILabel(frame: CGRect(x: 150, y: 0, width: 200, height: 21))
        label3.textAlignment = .right
        
        if let index = meses.firstIndex(of: nameOfMonth) {
            label1.text = "R$ \(despesaMensalTotal[index].despesas[indexPath.row])"
            label.text = despesaMensalTotal[index].nomeDespesas[indexPath.row]
            label2.text = "Categoria: \(despesaMensalTotal[index].categorias[indexPath.row])"


            let teste = despesaMensalTotal[index].dataGasto[indexPath.row]
            
            dateFormatter.dateFormat = "LLLL"
            let mes = dateFormatter.string(from: teste)
            
            dateFormatter.dateFormat = "dd"
            let dia = dateFormatter.string(from: teste)
            label3.text = "\(dia)/\(mes)"
        }
        
        cell.addSubview(label)
        cell.addSubview(label1)
        cell.addSubview(label2)
        cell.addSubview(label3)
        
        return cell

    }
    
    @IBAction func adicionarGasto(_ sender: Any) {
        
        let adicionarGastos = UIAlertController(title: "Novo gasto", message: "Qual o seu novo gasto?", preferredStyle: .alert)
        
        var nomeGasto = UITextField()
        var valorGasto = UITextField()
        var categoria = UITextField()
        
        adicionarGastos.addTextField { txt in
            txt.placeholder = "Padaria"
            nomeGasto = txt
        }
        
        adicionarGastos.addTextField { txt in
            txt.placeholder = "8.75"
            valorGasto = txt
        }
        
        adicionarGastos.addTextField { txt in
            txt.placeholder = "Alimentacao"
            categoria = txt
        }
        
        let acao = UIAlertAction(title: "Adicionar", style: .default) { [self] botao in
            let gasto = Gasto(context: self.contexto)
            gasto.nomeGasto = nomeGasto.text!
            gasto.valorGasto = Float(valorGasto.text!)!
            gasto.categoria = categoria.text!
            let data = now
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let now1 = df.string(from: Date())
            
            self.dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = self.dateFormatter.date(from: now1)
            
            self.dateFormatter.dateFormat = "LLLL"
            let nameOfMonth = self.dateFormatter.string(from: date!)
            gasto.mes = nameOfMonth
            
            let index1 = self.meses.firstIndex(of: ((gasto as AnyObject).mes!)!)

            self.index += 1

            let request: NSFetchRequest<Gasto> = Gasto.fetchRequest()
            
            do {
                self.gastos = try self.contexto.fetch(request)
            } catch {
                fatalError()
            }
            
            self.usuarioLogado?.addToGastos(gasto)
            
            despesaMensalTotal[index1!].nomeDespesas.append(((gasto as AnyObject).nomeGasto!)!)
            despesaMensalTotal[index1!].despesas.append(Double(((gasto as AnyObject).valorGasto!)))
            despesaMensalTotal[index1!].categorias.append(((gasto as AnyObject).categoria!))
            despesaMensalTotal[index1!].dataGasto.append(((gasto as AnyObject).data ?? self.now))
            
            if(despesaMensalTotal[index1!].receita == 0) {
                despesaMensalTotal[index1!].receita = Double(usuarioLogado!.receita)
                despesaMensalTotal[index1!].receita = Double(usuarioLogado!.receita)
            }
            
            total = Float(despesaMensalTotal[index1!].despesas.reduce(0, +))
            
            self.saldoAtual.text = "Saldo atual: R$ \(usuarioLogado!.receita - total)"
            
            self.gastosMensais.text = String(total)
            
            do {
                try self.contexto.save()
                let cell = IndexPath(row: despesaMensalTotal[index1!].nomeDespesas.count - 1, section: 0)
                self.listaGastos.beginUpdates()
                self.listaGastos.insertRows(at: [cell], with: .bottom)
                self.listaGastos.endUpdates()
            } catch {
                fatalError()
            }
                    
            
        }
        
        let fechar = UIAlertAction(title: "Cancelar", style: .cancel) { botao in
            self.dismiss(animated: true)
        }
        
        adicionarGastos.addAction(acao)
        adicionarGastos.addAction(fechar)
        
        present(adicionarGastos, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.navigationItem.hidesBackButton = true
        listaGastos.register(UITableViewCell.self, forCellReuseIdentifier: "ListaGastosCelula")
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let now1 = df.string(from: Date())
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = self.dateFormatter.date(from: now1)
        
        dateFormatter.dateFormat = "LLLL"
        nameOfMonth = dateFormatter.string(from: date!)
       
        
        let indexMesAtual = meses.firstIndex(of: nameOfMonth)
        
        mesAtual.setTitle(meses[indexMesAtual!], for: .normal)

        listaGastos.delegate = self

        listaGastos.dataSource = self
        
        listaGastos.rowHeight = 75
        
       self.navigationItem.setHidesBackButton(true, animated: true)
        
        saudacaoUsuario.text! = "Olá, \((usuarioLogado?.nome)!)!"
        
        var teste = [String]()

        if(!DespesaMensalTotal.shared.dadosCarregados){
            
            for gasto in usuarioLogado!.gastos! {
                
                if let index = meses.firstIndex(of: ((gasto as AnyObject).mes!)!) {
                   
                    despesaMensalTotal[index].nomeDespesas.append(((gasto as AnyObject).nomeGasto!)!)
                    despesaMensalTotal[index].despesas.append(Double(((gasto as AnyObject).valorGasto!)))
                    despesaMensalTotal[index].categorias.append(((gasto as AnyObject).categoria!))
                    despesaMensalTotal[index].dataGasto.append(((gasto as AnyObject).data ?? self.now))
                    DespesaMensalTotal.shared.despesaMensalTotal[index].receita = Double(usuarioLogado!.receita)
                    
                }
                
            }
            
        }
        
        total = Float(despesaMensalTotal[indexMesAtual!].despesas.reduce(0, +))
        
        self.gastosMensais.text = String(total)
        self.ganhoMensal.text = String(usuarioLogado!.receita)
        self.saldoAtual.text = "Saldo atual: R$ \(usuarioLogado!.receita - total)"
        
        DespesaMensalTotal.shared.dadosCarregados = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.navigationItem.hidesBackButton = true

        if(changed) {
            listaGastos.reloadData()

        }
        
        changed = false
        
    }
    

}
