"
Muestra el estado de la partida y pide la seleccion al usuario. No contiene reglas del juego.
"
Class {
	#name : 'VistaConsola',
	#superclass : 'Object',
	#instVars : [
		'partida'
	],
	#package : 'MergeDouble-Vista'
}

{ #category : 'instance creation' }
VistaConsola class >> partida: unaPartida [

	^ self new setPartida: unaPartida
]

{ #category : 'initialization' }
VistaConsola >> setPartida: unaPartida [

	partida := unaPartida
]

{ #category : 'operations' }
VistaConsola >> mostrarTablero [

	| tablero |
	tablero := partida tablero.
	Transcript
		show: 'Puntaje: ', partida puntaje printString, '   Mejor: ', partida mejorPuntaje printString;
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

{ #category : 'operations' }
VistaConsola >> mostrarResultado [

	Transcript
		show: (partida estaGanada ifTrue: [ 'Ganaste!' ] ifFalse: [ 'Sin movimientos posibles' ]);
		cr
]

{ #category : 'operations' }
VistaConsola >> jugar [

	[ partida estaGanada or: [ partida estaPerdida ] ] whileFalse: [
		| pos |
		self mostrarTablero.
		pos := self pedirSeleccion.
		pos ifNil: [ ^ self ].
		(partida seleccionar: pos)
			ifFalse: [ Transcript show: 'Seleccion invalida'; cr ] ].
	self mostrarTablero.
	self mostrarResultado
]

{ #category : 'private' }
VistaConsola >> formatear: unaFicha [

	| texto |
	texto := unaFicha printString.
	^ (String new: ((5 - texto size) max: 0) withAll: Character space), texto
]
