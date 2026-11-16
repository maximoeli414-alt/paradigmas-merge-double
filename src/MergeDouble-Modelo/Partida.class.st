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
		'metaValor'
	],
	#package : 'MergeDouble-Modelo'
}

{ #category : 'instance creation' }
Partida class >> filas: f columnas: c meta: unValor [

	^ self new initializeFilas: f columnas: c meta: unValor
]

{ #category : 'instance creation' }
Partida class >> estandar [

	^ self filas: 9 columnas: 11 meta: 2048
]

{ #category : 'initialization' }
Partida >> initializeFilas: f columnas: c meta: unValor [

	tablero := Tablero filas: f columnas: c.
	metaValor := unValor.
	puntaje := 0.
	mejorPuntaje := 0.
	self reiniciar
]

{ #category : 'accessing' }
Partida >> tablero [

	^ tablero
]

{ #category : 'accessing' }
Partida >> puntaje [

	^ puntaje
]

{ #category : 'accessing' }
Partida >> mejorPuntaje [

	^ mejorPuntaje
]

{ #category : 'testing' }
Partida >> estaGanada [

	^ tablero contieneFichaDeValorAlMenos: metaValor
]

{ #category : 'testing' }
Partida >> estaPerdida [

	^ self estaGanada not and: [ tablero hayMovimientosPosibles not ]
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
	^ true
]

{ #category : 'operations' }
Partida >> reiniciar [

	mejorPuntaje := mejorPuntaje max: puntaje.
	puntaje := 0.
	tablero reiniciar
]

{ #category : 'private' }
Partida >> puntosPorAbsorber: cantidad [

	^ cantidad * 10
]
