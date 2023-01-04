//
//  HistoricoViewController.swift
//  ControleFinanceiro
//
//  Created by Alan on 16/11/22.
//

import UIKit
import Charts
import CoreData


class HistoricoViewController: UIViewController {
    
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let request: NSFetchRequest<Gasto> = Gasto.fetchRequest()
    var gastos = UsuariosCadastrados.shared.gastos
    
    let usuarioLogado = UsuariosCadastrados.shared.usuarioLogado
    
    var despesaMensalTotal = DespesaMensalTotal.shared.despesaMensalTotal
    var meses = DespesaMensalTotal.shared.meses
    var despesaMensal = DespesaMensal()

    var index = 0
    
    var total = Float()
    

    var valorGastosArray = [Float]()
    var mes = [String]()
    
    
    @IBOutlet weak var barView: LineChartView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        
      loadData()
    }
    
    private func loadData() {
        var ageGroupEntries = [BarChartDataEntry]()
        var ageGroupEntries1 = [BarChartDataEntry]()

        var i = 0.0
        var j = 0.0

        for _ in DespesaMensalTotal.shared.despesaMensalTotal {
            ageGroupEntries1.append(BarChartDataEntry(x: i, y: DespesaMensalTotal.shared.despesaMensalTotal[Int(i)].despesas.reduce(0, +)))
                i += 1
        }
        
        for _ in DespesaMensalTotal.shared.despesaMensalTotal {
            ageGroupEntries.append(BarChartDataEntry(x: j, y: DespesaMensalTotal.shared.despesaMensalTotal[Int(j)].receita ?? 0.0))
                j += 1
        }
        
        let chartDataSet = LineChartDataSet(entries: ageGroupEntries)
        let chartDataSet1 = LineChartDataSet(entries: ageGroupEntries1)
        
        chartDataSet1.label = "Gastos"
        chartDataSet1.setColor(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
        chartDataSet1.circleRadius = 4.0
        chartDataSet1.setCircleColor(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
        
        chartDataSet.label = "Receita"
        chartDataSet.setColor(UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0))
        chartDataSet.circleRadius = 4.0
        chartDataSet.setCircleColor(UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0))
        
        
        let mesesAbreviado = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"]
        barView.data = LineChartData(dataSets: [chartDataSet, chartDataSet1])
        barView.xAxis.valueFormatter = IndexAxisValueFormatter(values: mesesAbreviado)
        barView.xAxis.setLabelCount(12, force: true)
        barView.xAxis.drawGridLinesEnabled = false
        barView.rightAxis.enabled = false
        barView.rightAxis.drawAxisLineEnabled = true
        barView.legend.enabled = false
        
    }

}
