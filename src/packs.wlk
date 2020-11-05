class Packs {
	const fechaDeVencimiento 
	var fechaActual
	var cuantoPuedeConsumir
	
	method satisfaceConsumo(consumo) = not(self.estaVencido())
		
	method gastarse(gasto){
		cuantoPuedeConsumir = 0.max(cuantoPuedeConsumir - gasto)
	}
	method seAcabo() = cuantoPuedeConsumir == 0
	
	method noSirve() = self.seAcabo() or self.estaVencido()
	
	method estaVencido() = fechaActual > fechaDeVencimiento

}

class CreditoDisponible inherits Packs{
	
	override method satisfaceConsumo(consumo) {
		super(consumo)
		return consumo.costo() < cuantoPuedeConsumir
		
		}
	
}

class MbLibres inherits Packs{
	
	override method satisfaceConsumo(consumo){
		super(consumo)
		return consumo.cubiertoPorInternet(self)
		
		}
	
	method puedeGastarMB(cantidad) = cantidad <= cuantoPuedeConsumir
	
}

class MbLibresPlus inherits MbLibres{ //hago que herede porque tiene que hacer lo mismo y algo mas y asi no repito logica
	override method puedeGastarMB(cantidad) = super(cantidad) || cantidad <= 0.1
}

class LlamadasGratis inherits Packs{
	
	override method satisfaceConsumo(consumo){
		super(consumo)
		return consumo.cubiertoPorLlamadas(self)
	} 
	
	method puedeGastarLlamada(segundosLlamada) = true
	
}

class InternetIlimitadoLosFindes inherits Packs{
	
	method esFinde(consumo)= true //nose como hacerlo pero no es importante
	
	override method satisfaceConsumo(consumo) = true
		//if(consumo.tipo() == "internet"){ ESTO ES UN TYPECHEK Y NO VA. PONER UN METHOD EN EL CONSUMO QUE SE ENCARGUE DE VER SI LO CUBRE O NO
		
	
}
