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
}

object pandemia {
    var property fase=1
}		
		
