import packs.*

class Linea {
	var numero
	var costoTotal = 0
	var packsQueTiene = []
	var fechaActual = new Date() //fecha del dia de hoy
	var consumosTotales = []
	
	method agregarPack(nuevoPack) = packsQueTiene.add(nuevoPack)
	
	method sacarPack(pack) = packsQueTiene.remove(pack)
		
	method agregarConsumo(consumo){
		consumosTotales.add(consumo)
	}
	
	method costoConsumo(packUsado,segundosUsado){
		packUsado.agregarConsumo(segundosUsado)
	}
	
	method costoPromedio(fechaInicial,fechaFinal){
		const listaConsumosQueCumplen = consumosTotales.filter({consumo => consumo.estaEntreEstasFechas(fechaInicial,fechaFinal)})
		const tamanio = listaConsumosQueCumplen.size()
		const costoPeriodo = listaConsumosQueCumplen.sum({consumo => consumo.costo()})
		return costoPeriodo / tamanio
	}
	
	method costoTotal(){
		const listaConsumosQueCumplen = consumosTotales.filter({consumo => consumo.estaEntreEstasFechas(fechaActual.minusDays(30),fechaActual)})
		return listaConsumosQueCumplen.sum({consumo => consumo.costo()})
	} 
	
	
	method puedeHacerConsumo(unConsumo) = packsQueTiene.all({pack => pack.satisfaceConsumo(unConsumo)})
	
	
	method hacerUnConsumo(consumo){
		if(self.puedeHacerConsumo(consumo)){
		consumo.aplicarse(self)	
		}else{
			self.error("No alcanzan los packs para realizar el consumo")
		}
		
	}
	
	method agarrarElUltimoQueCumple(consumo) = packsQueTiene.find({pack => pack.satisfaceConsumo(consumo)})
	
	method gastarUltimoPackUtil(consumo){
		const packAGastar = self.agarrarElUltimoQueCumple(consumo)
		packAGastar.gastarse(consumo.costo())
		if(packAGastar.seAcabo()){
			packsQueTiene.remove(packAGastar)
		}
	}
	
	method limpiarPacks(){
		const packsASacar = packsQueTiene.filter({pack => pack.sirve()})
		packsASacar.forEach({pack => self.sacarPack(pack)})
	}
	
}

class LineaBlack inherits Linea{
	var registroDeDeuda = 0
	
	
	override method hacerUnConsumo(consumo){
		if(self.puedeHacerConsumo(consumo)){
		consumo.aplicarse(self)	
		}else{
			consumo.aplicarse(self)
			self.agregarADeuda(consumo)
		}
	}
	
	method agregarADeuda(consumo){
		registroDeDeuda += consumo.costo()
	}
}

class Consumo{
	var fecha
	var costo
	var cuantoUso
	var tipo = "" //llamada o internet
	var precioFijoInternet = 0.1
	var precioFijoLlamadas = 1
	var precioSegundoLlamadas = 0.05
	
	method costo() = costo
	method tipo() = tipo
	method fecha() = fecha
	method cuantoUso() = cuantoUso
	
	method agregarCosto(nuevoCosto){
		costo = nuevoCosto
	}
	
	method estaEntreEstasFechas(fechaInicial,fechaFinal) = fecha.between(fechaInicial,fechaFinal)
	
	method aplicarse(linea){
		if(tipo == "internet"){
		self.agregarCosto(precioFijoInternet * cuantoUso)
		linea.agregarConsumo(self)
		linea.gastarUltimoPackUtil(self)
		
		}else{
			
			if(cuantoUso <= 30){
				self.agregarCosto(precioFijoLlamadas)
				linea.agregarConsumo(self)
				linea.gastarUltimoPackUtil(self)
			}else{
				self.agregarCosto(precioFijoLlamadas + (cuantoUso - 30) * precioSegundoLlamadas)
				linea.agregarConsumo(self)
				linea.gastarUltimoPackUtil(self)
			}
		}
	}

}



