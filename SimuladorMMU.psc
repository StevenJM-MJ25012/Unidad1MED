// ============================================================
//  SIMULADOR DE GESTION DE MEMORIA (MMU)
//  Proyecto Integrador - Unidad 1
//  Alumno: Steven Alexis Martinez Jimenez
// ============================================================

//  Pone todos los marcos fisicos en estado libre
SubProceso InicializarRAM(MarcoOcupado, MarcoPagina)
	Definir i Como Entero
	Para i <- 1 Hasta 4 Con Paso 1
		MarcoOcupado[i] <- 0
		MarcoPagina[i]  <- -1
	FinPara
FinSubProceso

//  Imprime el mapa de bits 0/1 de los 4 marcos fisicos
SubProceso MostrarMapaBits(MarcoOcupado, MarcoPagina)
	Definir i Como Entero
	Escribir "Mapa de bits RAM fisica (M1..M4):"
	Escribir "Marco | Bit | Estado"
	Para i <- 1 Hasta 4 Con Paso 1
		Si MarcoOcupado[i] = 0 Entonces
			Escribir "  M", i, "  |  0  | LIBRE"
		SiNo
			Escribir "  M", i, "  |  1  | OCUPADO - Pagina ", MarcoPagina[i]
		FinSi
	FinPara
FinSubProceso

//  Convierte direccion logica (pagina + offset) a fisica
//  Devuelve -1 si hay fallo de pagina
Funcion dirFisica <- TraducirDireccion(Presente, MarcoDePagina, paginaLogica, offset)
	Definir marco     Como Entero
	Definir TAM_MARCO Como Entero
	TAM_MARCO <- 4096
	Si Presente[paginaLogica] = 0 Entonces
		dirFisica <- -1
	SiNo
		marco     <- MarcoDePagina[paginaLogica]
		dirFisica <- (marco * TAM_MARCO) + offset
	FinSi
FinFuncion

//  Prepara los marcos de usuario para la simulacion
SubProceso InicializarMarcosUsuario(Marcos, Ocupado)
	Definir i Como Entero
	Para i <- 1 Hasta 3 Con Paso 1
		Ocupado[i] <- 0
		Marcos[i]  <- -1
	FinPara
FinSubProceso

//  Devuelve el indice del marco que contiene la pagina
//  o -1 si no esta cargada
Funcion idx <- BuscarPaginaEnMarcos(Marcos, Ocupado, pag)
	Definir i Como Entero
	idx <- -1
	Para i <- 1 Hasta 3 Con Paso 1
		Si Ocupado[i] = 1 Y Marcos[i] = pag Entonces
			idx <- i
		FinSi
	FinPara
FinFuncion

//  Algoritmo First In First Out
//  Devuelve el total de fallos de pagina
Funcion fallos <- SimularFIFO(Referencias, Marcos, Ocupado)
	Definir i           Como Entero
	Definir t           Como Entero
	Definir pag         Como Entero
	Definir libre       Como Entero
	Definir punteroFIFO Como Entero
	Definir esFallo     Como Entero
	Definir idx         Como Entero
	
	InicializarMarcosUsuario(Marcos, Ocupado)
	fallos      <- 0
	punteroFIFO <- 1
	
	Para t <- 1 Hasta 12 Con Paso 1
		pag     <- Referencias[t]
		esFallo <- 0
		idx     <- BuscarPaginaEnMarcos(Marcos, Ocupado, pag)
		
		Si idx = -1 Entonces
			// Fallo de pagina
			fallos  <- fallos + 1
			esFallo <- 1
			
			// Buscar marco libre
			libre <- -1
			Para i <- 1 Hasta 3 Con Paso 1
				Si Ocupado[i] = 0 Y libre = -1 Entonces
					libre <- i
				FinSi
			FinPara
			
			Si libre <> -1 Entonces
				// Hay espacio disponible
				Ocupado[libre] <- 1
				Marcos[libre]  <- pag
			SiNo
				// RAM llena: reemplazar segun FIFO
				Marcos[punteroFIFO] <- pag
				punteroFIFO <- punteroFIFO + 1
				Si punteroFIFO > 3 Entonces
					punteroFIFO <- 1
				FinSi
			FinSi
		FinSi
		
		// Mostrar estado del paso actual
		Si esFallo = 1 Entonces
			Escribir "  t=", t, " | Pag=", pag, " | [", Marcos[1], ",", Marcos[2], ",", Marcos[3], "] <- FALLO"
		SiNo
			Escribir "  t=", t, " | Pag=", pag, " | [", Marcos[1], ",", Marcos[2], ",", Marcos[3], "]  (hit)"
		FinSi
	FinPara
FinFuncion

//  Elige el marco cuya pagina tardara mas en volver a usarse
Funcion victima <- ElegirVictimaOPT(Referencias, Marcos, tActual)
	Definir i          Como Entero
	Definir k          Como Entero
	Definir dist       Como Entero
	Definir mayorDist  Como Entero
	Definir encontrado Como Entero
	
	victima   <- 1
	mayorDist <- -1
	
	Para i <- 1 Hasta 3 Con Paso 1
		dist       <- 9999
		encontrado <- 0
		Para k <- tActual + 1 Hasta 12 Con Paso 1
			Si Referencias[k] = Marcos[i] Y encontrado = 0 Entonces
				dist       <- k - tActual
				encontrado <- 1
			FinSi
		FinPara
		Si dist > mayorDist Entonces
			mayorDist <- dist
			victima   <- i
		FinSi
	FinPara
FinFuncion

//  Algoritmo Optimo (Belady)
//  Devuelve el total de fallos de pagina
Funcion fallos <- SimularOPT(Referencias, Marcos, Ocupado)
	Definir i       Como Entero
	Definir t       Como Entero
	Definir pag     Como Entero
	Definir libre   Como Entero
	Definir v       Como Entero
	Definir esFallo Como Entero
	Definir idx     Como Entero
	
	InicializarMarcosUsuario(Marcos, Ocupado)
	fallos <- 0
	
	Para t <- 1 Hasta 12 Con Paso 1
		pag     <- Referencias[t]
		esFallo <- 0
		idx     <- BuscarPaginaEnMarcos(Marcos, Ocupado, pag)
		
		Si idx = -1 Entonces
			// Fallo de pagina
			fallos  <- fallos + 1
			esFallo <- 1
			
			// Buscar marco libre
			libre <- -1
			Para i <- 1 Hasta 3 Con Paso 1
				Si Ocupado[i] = 0 Y libre = -1 Entonces
					libre <- i
				FinSi
			FinPara
			
			Si libre <> -1 Entonces
				// Hay espacio disponible
				Ocupado[libre] <- 1
				Marcos[libre]  <- pag
			SiNo
				// RAM llena: reemplazar segun OPT
				v             <- ElegirVictimaOPT(Referencias, Marcos, t)
				Marcos[v]     <- pag
			FinSi
		FinSi
		
		// Mostrar estado del paso actual
		Si esFallo = 1 Entonces
			Escribir "  t=", t, " | Pag=", pag, " | [", Marcos[1], ",", Marcos[2], ",", Marcos[3], "] <- FALLO"
		SiNo
			Escribir "  t=", t, " | Pag=", pag, " | [", Marcos[1], ",", Marcos[2], ",", Marcos[3], "]  (hit)"
		FinSi
	FinPara
FinFuncion

Algoritmo Principal
	
	// Declaracion de arreglos 
	Definir MarcoOcupado  Como Entero
	Definir MarcoPagina   Como Entero
	Dimension MarcoOcupado[4]
	Dimension MarcoPagina[4]
	
	Definir Presente      Como Entero
	Definir MarcoDePagina Como Entero
	Dimension Presente[5]
	Dimension MarcoDePagina[5]
	
	Definir Marcos  Como Entero
	Definir Ocupado Como Entero
	Dimension Marcos[3]
	Dimension Ocupado[3]
	
	Definir Referencias Como Entero
	Dimension Referencias[12]
	
	// Variables simples 
	Definir i          Como Entero
	Definir pag        Como Entero
	Definir offset     Como Entero
	Definir marco      Como Entero
	Definir dirFisica  Como Entero
	Definir fallosFIFO Como Entero
	Definir fallosOPT  Como Entero
	
	// cadena de referencia
	Referencias[1]  <- 1
	Referencias[2]  <- 2
	Referencias[3]  <- 3
	Referencias[4]  <- 4
	Referencias[5]  <- 1
	Referencias[6]  <- 2
	Referencias[7]  <- 5
	Referencias[8]  <- 1
	Referencias[9]  <- 2
	Referencias[10] <- 3
	Referencias[11] <- 4
	Referencias[12] <- 5
	
	//  FASE 1: INICIALIZACION Y MAPA DE BITS
	Escribir "==================================================="
	Escribir "  FASE 1: INICIALIZACION DE RAM FISICA"
	Escribir "==================================================="
	InicializarRAM(MarcoOcupado, MarcoPagina)
	MostrarMapaBits(MarcoOcupado, MarcoPagina)
	
	//  FASE 2: TRADUCCION DE DIRECCIONES
	Escribir ""
	Escribir "==================================================="
	Escribir "  FASE 2: TRADUCCION DE DIRECCIONES (MMU)"
	Escribir "==================================================="
	
	// Inicializar tabla de paginas
	Para i <- 1 Hasta 5 Con Paso 1
		Presente[i]      <- 0
		MarcoDePagina[i] <- -1
	FinPara
	
	// Cargar paginas 1, 2 y 3 en marcos 1, 2 y 3
	Presente[1]      <- 1
	MarcoDePagina[1] <- 1
	MarcoOcupado[1]  <- 1
	MarcoPagina[1]   <- 1
	
	Presente[2]      <- 1
	MarcoDePagina[2] <- 2
	MarcoOcupado[2]  <- 1
	MarcoPagina[2]   <- 2
	
	Presente[3]      <- 1
	MarcoDePagina[3] <- 3
	MarcoOcupado[3]  <- 1
	MarcoPagina[3]   <- 3
	
	Escribir "Mapa de bits tras cargar paginas 1, 2 y 3:"
	MostrarMapaBits(MarcoOcupado, MarcoPagina)
	
	Escribir ""
	Escribir "Traduccion de direcciones logicas a fisicas:"
	
	// Traduccion 1: pagina 1, offset 100 -> 0*4096+100 = 100
	pag       <- 1
	offset    <- 100
	dirFisica <- TraducirDireccion(Presente, MarcoDePagina, pag, offset)
	Si dirFisica = -1 Entonces
		Escribir "  Pag ", pag, " offset ", offset, " -> FALLO DE PAGINA"
	SiNo
		Escribir "  Pag ", pag, " offset ", offset, " -> Dir. fisica: ", dirFisica
	FinSi
	
	// Traduccion 2: pagina 2, offset 2048 -> 1*4096+2048 = 6144
	pag       <- 2
	offset    <- 2048
	dirFisica <- TraducirDireccion(Presente, MarcoDePagina, pag, offset)
	Si dirFisica = -1 Entonces
		Escribir "  Pag ", pag, " offset ", offset, " -> FALLO DE PAGINA"
	SiNo
		Escribir "  Pag ", pag, " offset ", offset, " -> Dir. fisica: ", dirFisica
	FinSi
	
	// Traduccion 3: pagina 5 (no cargada) -> fallo
	pag       <- 5
	offset    <- 0
	dirFisica <- TraducirDireccion(Presente, MarcoDePagina, pag, offset)
	Si dirFisica = -1 Entonces
		Escribir "  Pag ", pag, " offset ", offset, " -> FALLO DE PAGINA (pagina no esta en RAM)"
	SiNo
		Escribir "  Pag ", pag, " offset ", offset, " -> Dir. fisica: ", dirFisica
	FinSi
	
	//  FASE 3: SIMULACION FIFO
	Escribir ""
	Escribir "==================================================="
	Escribir "  FASE 3: SIMULACION FIFO"
	Escribir "  Cadena: [1,2,3,4,1,2,5,1,2,3,4,5]  Marcos: 3"
	Escribir "==================================================="
	fallosFIFO <- SimularFIFO(Referencias, Marcos, Ocupado)

	//  FASE 3: SIMULACION OPT
	Escribir ""
	Escribir "==================================================="
	Escribir "  FASE 3: SIMULACION OPT (OPTIMO - Belady)"
	Escribir "  Cadena: [1,2,3,4,1,2,5,1,2,3,4,5]  Marcos: 3"
	Escribir "==================================================="
	fallosOPT <- SimularOPT(Referencias, Marcos, Ocupado)
	
	//  RESUMEN FINAL
	Escribir ""
	Escribir "==================================================="
	Escribir "  RESUMEN DE FALLOS DE PAGINA"
	Escribir "==================================================="
	Escribir "  Algoritmo FIFO : ", fallosFIFO, " fallos"
	Escribir "  Algoritmo OPT  : ", fallosOPT,  " fallos"
	Escribir "  Mejora OPT     : ", fallosFIFO - fallosOPT, " fallo(s) menos que FIFO"
	Escribir "==================================================="
	
FinAlgoritmo