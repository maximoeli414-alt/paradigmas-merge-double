"
Aplica las reglas del juego: puntaje, victoria y derrota. Coordina al tablero.
"
Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'puntaje',
		'mejorPuntaje',
		'metaValor',
		'vidas'
	],
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'instance creation' }
Partida class >> estandar [

	^ self filas: 9 columnas: 11 meta: 2048
]

{ #category : 'instance creation' }
Partida class >> filas: f columnas: c meta: unValor [

	| partida |
	partida := self tablero: (Tablero filas: f columnas: c) meta: unValor.
	partida reiniciar.
	^ partida
]

{ #category : 'constants' }
Partida class >> maximoMezclas [
	"Tope de mezclas seguidas antes de regenerar el tablero, para evitar un bucle infinito."

	^ 50
]

{ #category : 'instance creation' }
Partida class >> tablero: unTablero meta: unValor [

	^ self tablero: unTablero meta: unValor vidas: self vidasIniciales
]

{ #category : 'instance creation' }
Partida class >> tablero: unTablero meta: unValor vidas: cantidadDeVidas [
	"Crea una partida sobre un tablero ya armado, sin reiniciarlo. Util para pruebas."

	^ self new initializeTablero: unTablero meta: unValor vidas: cantidadDeVidas
]

{ #category : 'constants' }
Partida class >> vidasIniciales [

	^ 3
]

{ #category : 'testing' }
Partida >> estaGanada [

	^ tablero contieneFichaDeValorAlMenos: metaValor
]

{ #category : 'testing' }
Partida >> estaPerdida [

	^ self estaGanada not and: [ vidas <= 0 ]
]

{ #category : 'initialization' }
Partida >> initializeTablero: unTablero meta: unValor vidas: cantidadDeVidas [

	tablero := unTablero.
	metaValor := unValor.
	vidas := cantidadDeVidas.
	puntaje := 0.
	mejorPuntaje := 0
]

{ #category : 'accessing' }
Partida >> mejorPuntaje [

	^ mejorPuntaje
]

{ #category : 'private' }
Partida >> mezclarHastaHaberMovimientos [
	"Mezcla hasta que el tablero tenga al menos un movimiento. No cuesta vidas.
	Si tras muchas mezclas sigue bloqueado, regenera el tablero entero."

	| intentos |
	intentos := 0.
	[ tablero hayMovimientosPosibles ] whileFalse: [
		intentos := intentos + 1.
		intentos > self class maximoMezclas
			ifTrue: [ tablero reiniciar. intentos := 0 ]
			ifFalse: [ tablero mezclar ] ]
]

{ #category : 'operations' }
Partida >> perderVida [
	"Resta una sola vida. Si quedan, mezcla el tablero hasta que haya movimientos."

	vidas := vidas - 1.
	vidas > 0 ifTrue: [ self mezclarHastaHaberMovimientos ]
]

{ #category : 'accessing' }
Partida >> puntaje [

	^ puntaje
]

{ #category : 'private' }
Partida >> puntosPorAbsorber: cantidad [

	^ cantidad * 10
]

{ #category : 'operations' }
Partida >> reiniciar [

	mejorPuntaje := mejorPuntaje max: puntaje.
	puntaje := 0.
	vidas := self class vidasIniciales.
	tablero reiniciar.
	self mezclarHastaHaberMovimientos
]

{ #category : 'operations' }
Partida >> seleccionar: pos [

	| absorbidas |
	(tablero puedeFusionar: pos) ifFalse: [ ^ false ].
	absorbidas := tablero fusionar: pos.
	puntaje := puntaje + (self puntosPorAbsorber: absorbidas).
	tablero aplicarGravedad.
	tablero rellenar.
	mejorPuntaje := mejorPuntaje max: puntaje.
	self verificarBloqueo.
	^ true
]

{ #category : 'accessing' }
Partida >> tablero [

	^ tablero
]

{ #category : 'operations' }
Partida >> verificarBloqueo [
	"Si el tablero quedo sin movimientos y la partida sigue en juego, cuesta una vida."

	self estaGanada ifTrue: [ ^ self ].
	tablero hayMovimientosPosibles ifTrue: [ ^ self ].
	self perderVida
]

{ #category : 'accessing' }
Partida >> vidas [

	^ vidas
]
