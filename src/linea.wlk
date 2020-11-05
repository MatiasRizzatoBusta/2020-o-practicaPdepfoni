import packs.*

class Linea {
	var numero
	var costoTotal = 0
	var registroDeDeuda = 0
	var packsQueTiene = []
	var fechaActual = new Date() //fecha del dia de hoy
	var consumosTotales = []
	var tipoLinea = lineaComun
	
	method agregarPack(nuevoPack) = packsQueTiene.add(nuevoPack)
	
	method sacarPack(pack) = packsQueTiene.remove(pack)
	
	method packsQueTiene() = packsQueTiene
		
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
		
	method consumir(consumo) = tipoLinea.hacerUnConsumo(consumo,self)
	
	method puedeHacerConsumo(unConsumo) = packsQueTiene.all({pack => pack.satisfaceConsumo(unConsumo)})
	
	method agarrarElUltimoQueCumple(consumo) = packsQueTiene.find({pack => pack.satisfaceConsumo(consumo)})
	
	method gastarUltimoPackUtil(consumo){
		const packAGastar = self.agarrarElUltimoQueCumple(consumo)
		packAGastar.gastarse(consumo.costo())
		if(packAGastar.seAcabo()){
			packsQueTiene.remove(packAGastar)
		}
	}
	
	method limpiarPacks(){
		const packsASacar = packsQueTiene.filter({pack =>pack.noSirve()})
		packsASacar.forEach({pack => self.sacarPack(pack)})
	}
	
	method agregarDeuda(costo){
		registroDeDeuda += costo
	}
	
	method mostrarDeuda() = registroDeDeuda
	
}

object lineaComun {
	
	method hacerUnConsumo(consumo,linea){
		if(linea.puedeHacerConsumo(consumo)){
		consumo.aplicarse(linea)	
		}else{
			self.error("No alcanzan los packs para realizar el consumo")
		}
		
	}
}

object lineaBlack{
	
	 method hacerUnConsumo(consumo,linea){
		if(linea.puedeHacerConsumo(consumo)){
		consumo.aplicarse(linea)	
		}else{
			consumo.aplicarse(linea)
			self.agregarADeudaDeLinea(consumo,linea)
		}
	}
	
	method agregarADeudaDeLinea(consumo,linea){
		linea.agregarDeuda(consumo.costo())
	}
}

object lineaPlatinum {
	
	method hacerUnConsumo(consumo,linea){
		consumo.aplicarse(linea)
		}
}

class Consumo{
	var fecha
	var costo = 0
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