class Packs {
	const fechaDeVencimiento 
	var fechaActual = new Date()
	
	method satisfaceConsumo(consumo) = not(self.estaVencido())
	
	method gastarse(gasto)
	method seAcabo() = false
	
	method sirve() = true
	
	method estaVencido() = fechaActual < fechaDeVencimiento

}

class CreditoDisponible inherits Packs{
	var credito	
	
	override method satisfaceConsumo(consumo){
		super(consumo)
		if(consumo.tipo() == "internet"){
			return consumo.cuantoUso() <= credito
		}else if(consumo.tipo() == "llamada"){
			return consumo.costo() <= credito
		}else{
			return false
		}
	}
	
	override method gastarse(gasto){
		credito = 0.max(credito - gasto)
	}
	
	override method seAcabo() = credito == 0
	
	override method sirve() = not(self.seAcabo()) or not(self.estaVencido())
	
}

class MbLibres inherits Packs{
	var mbLibres
	
	override method satisfaceConsumo(consumo){
		super(consumo)
		if(consumo.tipo() == "internet"){
			return consumo.cuantoUso() <= mbLibres
		}else{
			return false
		}
	}
	
	override method gastarse(gasto){
		mbLibres = 0.max(mbLibres - gasto)
	}
	
	override method seAcabo() = mbLibres == 0
}

class MbLibresPlus inherits MbLibres{
	override method satisfaceConsumo(consumo){
		super(consumo)
		if(consumo.cuantoUso() >= mbLibres and consumo.tipo() == "internet"){
			return consumo.cuantoUso() <= 0.1
		}else{
			return false
		}
	}
}

class LlamadasGratis inherits Packs{
	
	override method satisfaceConsumo(consumo){
		if(consumo.tipo() == "llamada"){
			return super(consumo)
		}else{
			return false
		}
	}
}

class InternetIlimitadoLosFindes inherits Packs{
	
	method esFinde(consumo)= true //nose como hacerlo pero no es importante
	
	override method satisfaceConsumo(consumo){
		super(consumo)
		if(consumo.tipo() == "internet"){
			return self.esFinde(consumo)
		}else{
			return false
		}
	}
	
}
