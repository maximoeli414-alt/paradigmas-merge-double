"
Interfaz grafica Morphic de la partida: dibuja el tablero como cuadrados de colores, traduce los clics en selecciones y muestra puntaje, vidas, racha y bonus. No contiene reglas del juego: todo se delega en Partida. Posiciones: columna @ fila.
"
Class {
	#name : 'VistaGrafica',
	#superclass : 'Object',
	#instVars : [
		'partida',
		'raiz',
		'casilleros',
		'etiquetaPuntaje',
		'etiquetaEstado',
		'etiquetaMensaje',
		'bonusPendiente',
		'posicionesBonus'
	],
	#category : 'MergeDouble-Vista',
	#package : 'MergeDouble-Vista'
}

{ #category : 'instance creation' }
VistaGrafica class >> abrir [

	"Abre una ventana con una partida estandar."

	^ (self partida: Partida estandar) abrir
]

{ #category : 'constants' }
VistaGrafica class >> colorComodin [


	^ Color r: 70 g: 70 b: 85 range: 255
]

{ #category : 'constants' }
VistaGrafica class >> colorDeTextoSobre: unColor [

	"Texto oscuro sobre fondos claros y blanco sobre fondos oscuros."

	^ unColor luminance > 0.55
		ifTrue: [ Color r: 30 g: 40 b: 60 range: 255 ]
		ifFalse: [ Color white ]
]

{ #category : 'constants' }
VistaGrafica class >> colorParaValor: unValor [

	"Un color por potencia de dos: 2 azul, 4 celeste, 8 verde, 16 amarillo, y asi sucesivamente."

	| colores indice |
	colores := self paleta.
	indice := ((unValor highBit - 1) max: 1) min: colores size.
	^ colores at: indice
]

{ #category : 'constants' }
VistaGrafica class >> margen [


	^ 12
]

{ #category : 'constants' }
VistaGrafica class >> paleta [


	^ {
		#(46 94 170).
		#(44 196 232).
		#(91 181 32).
		#(247 195 46).
		#(242 138 48).
		#(228 65 58).
		#(194 53 143).
		#(123 63 184).
		#(63 81 181).
		#(0 150 136).
		#(255 193 7) }
		collect: [ :rgb | Color r: rgb first g: rgb second b: rgb third range: 255 ]
]

{ #category : 'instance creation' }
VistaGrafica class >> partida: unaPartida [


	^ self new setPartida: unaPartida
]

{ #category : 'constants' }
VistaGrafica class >> separacion [


	^ 4
]

{ #category : 'constants' }
VistaGrafica class >> tamanioCasillero [


	^ 48
]

{ #category : 'operations' }
VistaGrafica >> abrir [

	"Construye la ventana, la dibuja y la muestra en el mundo de Morphic."

	self construirRaiz.
	self refrescar.
	raiz openInWorld
]

{ #category : 'private' }
VistaGrafica >> actualizarCasillero: casillero con: unaFicha [


	| fondo |
	unaFicha ifNil: [
		^ casillero fondo: (Color r: 30 g: 40 b: 60 range: 255) texto: '' colorTexto: Color white conBonus: false ].
	unaFicha esComodin ifTrue: [
		^ casillero fondo: self class colorComodin texto: '*' colorTexto: Color white conBonus: false ].
	fondo := self class colorParaValor: unaFicha valor.
	casillero
		fondo: fondo
		texto: unaFicha valor printString
		colorTexto: (self class colorDeTextoSobre: fondo)
		conBonus: unaFicha tieneBonus
]

{ #category : 'operations' }
VistaGrafica >> alPresionarBonus [

	"Elige un bonus. Si necesita posiciones, queda esperando los clics sobre el tablero. Si ya habia uno pendiente, lo cancela."

	| bonus |
	self juegoTerminado ifTrue: [ ^ self ].
	bonusPendiente ifNotNil: [
		self cancelarBonus.
		^ self mostrarMensaje: 'Bonus cancelado' ].
	partida cargasDeBonus = 0 ifTrue: [ ^ self mostrarMensaje: 'No tenes bonus disponibles' ].
	bonus := self elegirBonus.
	bonus ifNil: [ ^ self ].
	bonus cantidadDePosiciones = 0 ifTrue: [ ^ self aplicarBonus: bonus en: #() ].
	bonusPendiente := bonus.
	self mostrarMensaje: bonus nombre , ': elegi ' , bonus cantidadDePosiciones printString
		, (bonus cantidadDePosiciones = 1 ifTrue: [ ' ficha' ] ifFalse: [ ' fichas' ])
]

{ #category : 'operations' }
VistaGrafica >> alPresionarReiniciar [


	self cancelarBonus.
	partida reiniciar.
	self mostrarMensaje: ''.
	self refrescar
]

{ #category : 'operations' }
VistaGrafica >> aplicarBonus: unBonus en: posiciones [


	| usado |
	self cancelarBonus.
	usado := self avisandoCambiosDe: [ partida usarBonus: unBonus en: posiciones ].
	usado ifFalse: [ self mostrarMensaje: 'No se puede usar ese bonus ahi' ].
	self refrescar.
	self verificarFin
]

{ #category : 'private' }
VistaGrafica >> avisandoCambiosDe: unBloque [

	"Ejecuta el bloque y muestra si se perdio una vida o se gano un bonus. Devuelve lo que devuelve el bloque."

	| vidasAntes cargasAntes resultado avisos |
	vidasAntes := partida vidas.
	cargasAntes := partida cargasDeBonus.
	resultado := unBloque value.
	avisos := OrderedCollection new.
	partida vidas < vidasAntes ifTrue: [
		avisos add: (partida vidas > 0
			ifTrue: [ 'Sin movimientos: perdiste una vida y se mezclo el tablero' ]
			ifFalse: [ 'Sin movimientos: perdiste la ultima vida' ]) ].
	partida cargasDeBonus > cargasAntes ifTrue: [ avisos add: 'Ganaste un bonus!' ].
	self mostrarMensaje: (' - ' join: avisos).
	^ resultado
]

{ #category : 'operations' }
VistaGrafica >> cancelarBonus [


	bonusPendiente := nil.
	posicionesBonus := OrderedCollection new.
	self quitarResaltado
]

{ #category : 'accessing' }
VistaGrafica >> casilleroEn: pos [

	"El casillero de la posicion columna @ fila."

	^ (casilleros at: pos y) at: pos x
]

{ #category : 'operations' }
VistaGrafica >> clicEn: pos [


	self juegoTerminado ifTrue: [ ^ self ].
	bonusPendiente ifNotNil: [ ^ self elegirParaBonus: pos ].
	(self avisandoCambiosDe: [ partida seleccionar: pos ])
		ifFalse: [ self mostrarMensaje: 'Seleccion invalida: se necesitan 3 fichas iguales conectadas' ].
	self refrescar.
	self verificarFin
]

{ #category : 'construction' }
VistaGrafica >> construirRaiz [

	"Arma el morph principal con la cabecera, el tablero de casilleros y el pie con mensajes y botones."

	| tablero paso anchoTablero altoTablero cabecera yPie margen |
	tablero := partida tablero.
	margen := self class margen.
	paso := self class tamanioCasillero + self class separacion.
	anchoTablero := tablero columnas * paso - self class separacion.
	altoTablero := tablero filas * paso - self class separacion.
	cabecera := 60.
	yPie := cabecera + altoTablero + 12.
	raiz := Morph new.
	raiz color: (Color r: 24 g: 32 b: 52 range: 255).
	raiz position: 60 @ 40.
	raiz extent: ((anchoTablero + (2 * margen)) max: 420) @ (yPie + 80 + margen).
	etiquetaPuntaje := self crearEtiquetaEn: margen @ 8 tamanio: 18.
	etiquetaEstado := self crearEtiquetaEn: margen @ 32 tamanio: 15.
	casilleros := (1 to: tablero filas) collect: [ :f |
		(1 to: tablero columnas) collect: [ :c | self crearCasilleroFila: f columna: c ] ].
	etiquetaMensaje := self crearEtiquetaEn: margen @ yPie tamanio: 14.
	self crearBotonEn: margen @ (yPie + 34) texto: 'Bonus' accion: [ self alPresionarBonus ].
	self crearBotonEn: (margen + 130) @ (yPie + 34) texto: 'Reiniciar' accion: [ self alPresionarReiniciar ].
	self crearBotonEn: (margen + 260) @ (yPie + 34) texto: 'Salir' accion: [ raiz delete ]
]

{ #category : 'construction' }
VistaGrafica >> crearBotonEn: relativa texto: unTexto accion: unBloque [


	| boton |
	boton := CasilleroMorph new.
	boton extent: 120 @ 30.
	boton position: raiz position + relativa.
	boton fuente: (CasilleroMorph fuenteDeTamanio: 14).
	boton fondo: (Color r: 70 g: 90 b: 140 range: 255) texto: unTexto colorTexto: Color white conBonus: false.
	boton accion: unBloque.
	raiz addMorph: boton.
	^ boton
]

{ #category : 'construction' }
VistaGrafica >> crearCasilleroFila: f columna: c [


	| casillero paso |
	paso := self class tamanioCasillero + self class separacion.
	casillero := CasilleroMorph new.
	casillero extent: self class tamanioCasillero @ self class tamanioCasillero.
	casillero position: raiz position
		+ ((self class margen + ((c - 1) * paso)) @ (60 + ((f - 1) * paso))).
	casillero fuente: (CasilleroMorph fuenteDeTamanio: 18).
	casillero accion: [ self clicEn: c @ f ].
	casillero alEntrar: [ self resaltarGrupoDesde: c @ f ].
	casillero alSalir: [ self quitarResaltado ].
	raiz addMorph: casillero.
	^ casillero
]

{ #category : 'construction' }
VistaGrafica >> crearEtiquetaEn: relativa tamanio: puntos [


	| etiqueta |
	etiqueta := StringMorph new.
	etiqueta font: (CasilleroMorph fuenteDeTamanio: puntos).
	etiqueta color: Color white.
	etiqueta contents: ' '.
	etiqueta position: raiz position + relativa.
	raiz addMorph: etiqueta.
	^ etiqueta
]

{ #category : 'private' }
VistaGrafica >> elegirBonus [

	"Devuelve el bonus elegido en el menu, o nil si se cancela."

	| bonus indice |
	bonus := Bonus todos.
	indice := UIManager default
		chooseFrom: (bonus collect: [ :b | b nombre ])
		title: 'Elegi un bonus'.
	^ (indice isNil or: [ indice = 0 ]) ifTrue: [ nil ] ifFalse: [ bonus at: indice ]
]

{ #category : 'operations' }
VistaGrafica >> elegirParaBonus: pos [

	"Registra una posicion para el bonus pendiente y lo aplica cuando ya estan todas."

	(posicionesBonus includes: pos) ifTrue: [
		^ self mostrarMensaje: 'Esa ficha ya esta elegida' ].
	posicionesBonus add: pos.
	(self casilleroEn: pos) resaltado: true.
	posicionesBonus size < bonusPendiente cantidadDePosiciones
		ifTrue: [ ^ self mostrarMensaje: 'Elegi otra ficha' ].
	self aplicarBonus: bonusPendiente en: posicionesBonus
]

{ #category : 'testing' }
VistaGrafica >> juegoTerminado [


	^ partida estaGanada or: [ partida estaPerdida ]
]

{ #category : 'private' }
VistaGrafica >> mostrarMensaje: unTexto [


	etiquetaMensaje contents: (unTexto isEmpty ifTrue: [ ' ' ] ifFalse: [ unTexto ])
]

{ #category : 'private' }
VistaGrafica >> quitarResaltado [

	"Apaga todos los resaltados y vuelve a marcar las fichas ya elegidas para un bonus."

	casilleros do: [ :fila | fila do: [ :casillero | casillero resaltado: false ] ].
	posicionesBonus do: [ :pos | (self casilleroEn: pos) resaltado: true ]
]

{ #category : 'operations' }
VistaGrafica >> refrescar [

	"Vuelve a leer el estado de la partida y redibuja cabecera y tablero."

	| tablero |
	tablero := partida tablero.
	self quitarResaltado.
	1 to: tablero filas do: [ :f |
		1 to: tablero columnas do: [ :c |
			self
				actualizarCasillero: ((casilleros at: f) at: c)
				con: (tablero fichaEnFila: f columna: c) ] ].
	etiquetaPuntaje contents: 'Puntaje: ' , partida puntaje printString
		, '     Mejor: ' , partida mejorPuntaje printString.
	etiquetaEstado contents: 'Vidas: ' , partida vidas printString
		, '     Racha: ' , partida racha contador printString , '/' , Racha umbral printString
		, '     Bonus: ' , partida cargasDeBonus printString
]

{ #category : 'private' }
VistaGrafica >> resaltarGrupoDesde: pos [

	"Al pasar el mouse, marca el grupo que se fusionaria si se eligiera esa ficha."

	self quitarResaltado.
	(self juegoTerminado or: [ bonusPendiente notNil ]) ifTrue: [ ^ self ].
	(partida tablero puedeFusionar: pos) ifFalse: [ ^ self ].
	(partida tablero grupoConectadoDesde: pos) do: [ :p |
		(self casilleroEn: p) resaltado: true ]
]

{ #category : 'initialization' }
VistaGrafica >> setPartida: unaPartida [


	partida := unaPartida.
	bonusPendiente := nil.
	posicionesBonus := OrderedCollection new
]

{ #category : 'private' }
VistaGrafica >> verificarFin [

	"Muestra el resultado cuando la partida termino."

	partida estaGanada ifTrue: [
		^ self mostrarMensaje: 'Ganaste! Usa Reiniciar para jugar de nuevo' ].
	partida estaPerdida ifTrue: [
		self mostrarMensaje: 'Sin vidas. Fin del juego. Usa Reiniciar' ]
]
