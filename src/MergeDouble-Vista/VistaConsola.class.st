"
Muestra el estado de la partida y pide la seleccion al usuario. No contiene reglas del juego.
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
VistaConsola >> formatear: unaFicha [

	| texto |
	texto := unaFicha printString.
	^ (String new: ((5 - texto size) max: 0) withAll: Character space), texto
]

{ #category : 'operations' }
VistaConsola >> jugar [

	[ partida estaGanada or: [ partida estaPerdida ] ] whileFalse: [
		| pos vidasAntes |
		self mostrarTablero.
		pos := self pedirSeleccion.
		pos ifNil: [ ^ self ].
		vidasAntes := partida vidas.
		(partida seleccionar: pos)
			ifFalse: [ Transcript show: 'Seleccion invalida'; cr ]
			ifTrue: [
				partida vidas < vidasAntes ifTrue: [
					Transcript show: 'Sin movimientos: perdiste una vida'; cr ] ] ].
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
		show: ('Puntaje: {1}   Mejor: {2}   Vidas: {3}   Racha: {4}/{5}' format: {
				partida puntaje printString.
				partida mejorPuntaje printString.
				partida vidas printString.
				partida racha contador printString.
				Racha umbral printString });
		cr.
	1 to: tablero filas do: [ :f |
		1 to: tablero columnas do: [ :c |
			Transcript show: (self formatear: (tablero fichaEnFila: f columna: c)) ].
		Transcript cr ]
]

{ #category : 'operations' }
VistaConsola >> pedirSeleccion [

	| texto partes |
	texto := UIManager default request: 'Fila y columna (ej: 3 4)'.
	texto ifNil: [ ^ nil ].
	partes := (texto substrings: ' ') collect: [ :s | s asInteger ].
	(partes size = 2 and: [ partes noneSatisfy: [ :n | n isNil ] ])
		ifFalse: [ ^ nil ].
	^ partes second @ partes first
]

{ #category : 'initialization' }
VistaConsola >> setPartida: unaPartida [

	partida := unaPartida
]
