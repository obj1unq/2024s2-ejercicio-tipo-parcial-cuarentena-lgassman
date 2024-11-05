/** completar las clases y objetos */



class Trabajo {
    const base
    const bono

    method salario() { 
        return base + self.extra()
    }

    method extra()
    method presencial()
}

class TrabajoNoEsencial inherits Trabajo{
    const fasePermitida

    override method extra() {
        return if (self.presencial()) bono else 0
    } 

    override method presencial() {
        return pandemia.fase() >= fasePermitida
    }
}

class TrabajoEsencial inherits Trabajo {
    override method extra() {
        return bono * ((5 - pandemia.fase()) / 4 )
    } 

    override method presencial() {
        return true
    }

}

class TrabajoSanitario inherits TrabajoEsencial{ 
    override method extra() {
        return super() + 5000
    } 
}


class Persona {
    const edad
    const enfermedadesPreexistentes
    const trabajos
    const property salidas = []

    method ganancias() {
        return trabajos.sum({trabajo => trabajo.salario()})
    }

    method enRiesgo() {
        //Un miembro está en riesgo si tiene 65 o más años o si posee una enfermedad preexistente.
        return self.adultoMayor() or enfermedadesPreexistentes
    }

    method adultoMayor() {
        return edad >= 65
    }

    method trabajoPrincipal() {
        return trabajos.max({trabajo => trabajo.salario()})
    }

    method activo() {
        return trabajos.any({trabajo => trabajo.presencial()})
    }

    method inactivo() {
        return not self.activo()         
    }

    method salir(salida) {
        self.validarSalida(salida)
        salidas.add(salida)
    }
    method validarSalida(salida) {
        if (not salida.puedeHacer(self)){
            self.error(self.toString() + "No se puede hacer " + salida)
        }
    }

}

class Familia {
    const integrantes

    method ganancias() {
        return integrantes.sum({persona => persona.ganancias()})
    }

    method aislada() {
        return integrantes.all({persona => persona.enRiesgo() })
    }

    method trabajosPrincipales() {
        return integrantes.map({integrante => integrante.trabajoPrincipal() }).asSet()
    }

    method inactivos() {
        //son aquellos que no puedan realizar ninguno de sus trabajos de manera presencial.
        return integrantes.filter({integrante => integrante.inactivo()})
    }
    method salir(salida) {
        self.validarSalir(salida)
        self.integrantesPara(salida).forEach({persona => persona.salir(salida)})
    }

    method validarSalir(salida) {
        if (not self.puedeHacer(salida)) {
            self.error("No se puede realizar esta salida" + salida)
        }
    }
    method puedeHacer(salida) {
        return not self.integrantesPara(salida).isEmpty()
        //return integrantes.any({integrante => salida.puedeHacer(integrante)}) //así es con el any, pero como ya necesitaba el método con el filter lo reutilicé
    }

    method integrantesPara(salida) {
        return integrantes.filter({integrante => salida.puedeHacer(integrante)})
    }
}

object pandemia {
    var property fase=1
}

class Salida {

    method puedeHacer(persona) {
        return not persona.enRiesgo()
    }
}
class SalidaEjercicio inherits Salida {
    override method puedeHacer(persona) {
        return super(persona) and pandemia.fase() > 3
    }
}

object salidaComprar inherits  Salida {

}

object salidaEjercicio inherits SalidaEjercicio{

}

object salidaTrabajar inherits Salida {
    override method puedeHacer(persona) {
        return super(persona) and persona.activo()
    }
}

object salidaCaminar inherits SalidaEjercicio {
    override method puedeHacer(persona) {
        return super(persona) or pandemia.fase() == 5
    }
}

		
