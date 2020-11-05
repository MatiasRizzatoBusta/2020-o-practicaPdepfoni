import linea.*
import packs.*

class Consumo{
	var fecha
	var costo = 0
	
	method costo() = costo
	method fecha() = fecha
	
	method agregarCosto(nuevoCosto){
		costo = nuevoCosto
	}
	
	method cubiertoPorLlamadas(pack) = false

	method cubiertoPorInternet(pack) = false
	
	method estaEntreEstasFechas(fechaInicial,fechaFinal) = fecha.between(fechaInicial,fechaFinal)
	
	method aplicarse(linea)
}


class ConsumoInternet inherits Consumo{
	var precioFijoInternet = 0.1
	var mbUsados
	
	override method aplicarse(linea){
		self.agregarCosto(precioFijoInternet * mbUsados)
		linea.agregarConsumo(self)
		linea.gastarUltimoPackUtil(self)
	}
	
	override method cubiertoPorInternet(pack) = pack.puedeGastarMB(mbUsados)
}

class ConsumoLlamada inherits Consumo{
	var precioFijoLlamadas = 1
	var precioSegundoLlamadas = 0.05
	var segundosLlamada
	
	override method aplicarse(linea){
		if(segundosLlamada <= 30){
				self.agregarCosto(precioFijoLlamadas)
				linea.agregarConsumo(self)
				linea.gastarUltimoPackUtil(self)
			}else{
				self.agregarCosto(precioFijoLlamadas + (segundosLlamada - 30) * precioSegundoLlamadas)
				linea.agregarConsumo(self)
				linea.gastarUltimoPackUtil(self)
			}
	}
	
	override method cubiertoPorLlamadas(pack) = pack.puedeGastarLlamada(segundosLlamada)

}