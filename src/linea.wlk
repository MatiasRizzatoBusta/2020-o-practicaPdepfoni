import packs.*

class Linea {
	var numero
	var registroDeDeuda = 0
	var packsQueTiene = []
	var fechaActual 
	var consumosTotales = []
	var tipoLinea = lineaComun
	
	method agregarPack(nuevoPack) = packsQueTiene.add(nuevoPack)
	
	method sacarPack(pack) = packsQueTiene.remove(pack)
	
	method packsQueTiene() = packsQueTiene
		
	method agregarConsumo(consumo){
		consumosTotales.add(consumo)
	}

	method listaConsumosEntreFechas(fechaInicial,fechaFinal) = consumosTotales.filter({consumo => consumo.estaEntreEstasFechas(fechaInicial,fechaFinal)})
	
	method costoPromedio(fechaInicial,fechaFinal){
		const tamanio = self.listaConsumosEntreFechas(fechaInicial,fechaFinal).size()
		const costoPeriodo = self.listaConsumosEntreFechas(fechaInicial,fechaFinal).sum({consumo => consumo.costo()})
		return costoPeriodo / tamanio
	}
	
	method costoTotal(){
		const listaConsumosQueCumplen = self.listaConsumosEntreFechas(fechaActual.minusDays(30),fechaActual)
		return listaConsumosQueCumplen.sum({consumo => consumo.costo()})
	} 
		
	method consumir(consumo) = tipoLinea.hacerUnConsumo(consumo,self)
	
	method puedeHacerConsumo(unConsumo) = packsQueTiene.all({pack => pack.satisfaceConsumo(unConsumo)})
	
	method agarrarElUltimoQueCumple(consumo) = packsQueTiene.reverse().find({pack => pack.satisfaceConsumo(consumo)})
	
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
			self.error("No alcanzan los packs")
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