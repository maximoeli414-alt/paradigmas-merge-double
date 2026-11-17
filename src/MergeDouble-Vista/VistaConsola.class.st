"
Muestra el estado de la partida (puntaje, vidas, racha y bonus), pide la jugada y permite usar bonus con la tecla B. No contiene reglas del juego.
"
Class {
	#name : 'VistaConsola',
	#superclass : 'Object',
	#instVars : [
		'partida'
	],
	#category : 'MergeDouble-Vista',
	#package : 'MergeDouble-Vista'
}

{ #category : 'instance creation' }
VistaConsola class >> partida: unaPartida [

	^ self new setPartida: unaPartida
]

{ #category : 'private' }
VistaConsola >> avisandoCambiosDe: unBloque [
	"Ejecuta el bloque e informa si se perdio una vida o se gano un bonus. Devuelve lo que devuelve el bloque."

	| vidasAntes cargasAntes resultado |
	vidasAntes := partida vidas.
	cargasAntes := partida cargasDeBonus.
	resultado := unBloque value.
	partida vidas < vidasAntes ifTrue: [
		Transcript show: 'Sin movimientos: perdiste una vida y se mezclo el tablero'; cr ].
	partida cargasDeBonus > cargasAntes ifTrue: [
		Transcript show: 'Racha completa! Ganaste un bonus. Escribi B para usarlo'; cr ].
	^ resultado
]

{ #category : 'operations' }
VistaConsola >> elegirBonus [
	"Devuelve el bonus elegido en el menu, o nil si se cancela."

	| bonus indice |
	bonus := Bonus todos.
	indice := UIManager default
		chooseFrom: (bonus collect: [ :b | b nombre ])
		title: 'Elegi un bonus'.
	^ (indice isNil or: [ indice = 0 ]) ifTrue: [ nil ] ifFalse: [ bonus at: indice ]
]

{ #category : 'private' }
VistaConsola >> formatear: unaFicha [

	| texto |
	texto := unaFicha printString.
	^ (String new: ((5 - texto size) max: 0) withAll: Character space), texto
]

{ #category : 'operations' }
VistaConsola >> jugar [

	[ partida estaGanada or: [ partida estaPerdida ] ] whileFalse: [
		| entrada |
		self mostrarTablero.
		entrada := self pedirSeleccion.
		entrada ifNil: [ ^ self ].
		entrada = #bonus
			ifTrue: [ self usarBonus ]
			ifFalse: [
				(self avisandoCambiosDe: [ partida seleccionar: entrada ])
					ifFalse: [ Transcript show: 'Seleccion invalida'; cr ] ] ].
	self mostrarTablero.
	self mostrarResultado
]

{ #category : 'operations' }
VistaConsola >> mostrarResultado [

	Transcript
		show: (partida estaGanada ifTrue: [ 'Ganaste!' ] ifFalse: [ 'Te quedaste sin vidas. Fin del juego' ]);
		cr
]

{ #category : 'operations' }
VistaConsola >> mostrarTablero [

	| tablero |
	tablero := partida tablero.
	Transcript
		show: ('Puntaje: {1}   Mejor: {2}   Vidas: {3}   Racha: {4}/{5}   Bonus: {6}' format: {
				partida puntaje printString.
				partida mejorPuntaje printString.
				partida vidas printString.
				partida racha contador printString.
				Racha umbral printString.
				partida cargasDeBonus printString });
		cr.
	1 to: tablero filas do: [ :f |
		1 to: tablero columnas do: [ :c |
			Transcript show: (self formatear: (tablero fichaEnFila: f columna: c)) ].
		Transcript cr ]
]

{ #category : 'operations' }
VistaConsola >> pedirPosicion [

	| texto |
	texto := UIManager default request: 'Fila y columna (ej: 3 4)'.
	texto ifNil: [ ^ nil ].
	^ self posicionDesde: texto
]

{ #category : 'operations' }
VistaConsola >> pedirSeleccion [

	| texto |
	texto := UIManager default request: 'Fila y columna (ej: 3 4), o B para usar un bonus'.
	texto ifNil: [ ^ nil ].
	texto trimBoth asLowercase = 'b' ifTrue: [ ^ #bonus ].
	^ self posicionDesde: texto
]

{ #category : 'private' }
VistaConsola >> posicionDesde: texto [

	| partes |
	partes := (texto substrings: ' ') collect: [ :s | s asInteger ].
	(partes size = 2 and: [ partes noneSatisfy: [ :n | n isNil ] ])
		ifFalse: [ ^ nil ].
	^ partes second @ partes first
]

{ #category : 'initialization' }
VistaConsola >> setPartida: unaPartida [

	partida := unaPartida
]

{ #category : 'operations' }
VistaConsola >> usarBonus [

	| bonus posiciones |
	partida cargasDeBonus = 0 ifTrue: [
		Transcript show: 'No tenes bonus disponibles'; cr.
		^ self ].
	bonus := self elegirBonus.
	bonus ifNil: [ ^ self ].
	posiciones := OrderedCollection new.
	bonus cantidadDePosiciones timesRepeat: [
		| pos |
		pos := self pedirPosicion.
		pos ifNil: [ ^ self ].
		posiciones add: pos ].
	(self avisandoCambiosDe: [ partida usarBonus: bonus en: posiciones ])
		ifFalse: [ Transcript show: 'No se puede usar ese bonus ahi'; cr ]
]
