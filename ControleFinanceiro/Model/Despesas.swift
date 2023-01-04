//
//  Despesas.swift
//  ControleFinanceiro
//
//  Created by alan on 17/11/22.
//

import Foundation

class DespesaMensal {
    var mes: String?
    var despesas = [Double]()
    var nomeDespesas = [String]()
    var categorias = [String]()
    var dataGasto = [Date]()
    var receita: Double?
    static let shared = DespesaMensal()
}

class DespesaMensalTotal {
    
    var despesaMensalTotal = [DespesaMensal]()
    
    let meses = ["janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro" ]
    
    var dadosCarregados = false
    
    
    
    init() {
        for mes in meses {
            var despesaMensal = DespesaMensal()
            despesaMensal.mes = mes
            despesaMensalTotal.append(despesaMensal)
        }
    }
    
    static let shared = DespesaMensalTotal()
    
}
