"
Aplica las reglas del juego: puntaje, vidas, racha, bonus, victoria y derrota. Coordina al tablero y decide cuando se pierde una vida.
"
Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'puntaje',
		'mejorPuntaje',
		'metaValor',
		'vidas',
		'racha',
		'cargasDeBonus'
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

{ #category : 'accessing' }
Partida >> cargasDeBonus [

	^ cargasDeBonus
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
	mejorPuntaje := 0.
	racha := Racha new.
	cargasDeBonus := 0
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
Partida >> otorgarBonus [

	cargasDeBonus := cargasDeBonus + 1
]

{ #category : 'private' }
Partida >> otorgarBonusSiCorresponde [
	"Al completar la racha se gana una carga de bonus y la racha vuelve a cero."

	racha umbralAlcanzado ifFalse: [ ^ self ].
	self otorgarBonus.
	racha reiniciar
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

{ #category : 'accessing' }
Partida >> racha [

	^ racha
]

{ #category : 'operations' }
Partida >> reiniciar [

	mejorPuntaje := mejorPuntaje max: puntaje.
	puntaje := 0.
	vidas := self class vidasIniciales.
	cargasDeBonus := 0.
	racha reiniciar.
	tablero reiniciar.
	self mezclarHastaHaberMovimientos
]

{ #category : 'operations' }
Partida >> seleccionar: pos [

	| absorbidas |
	(tablero puedeFusionar: pos) ifFalse: [ ^ false ].
	absorbidas := tablero fusionar: pos.
	racha registrar: (tablero fichaEn: pos) valor.
	self otorgarBonusSiCorresponde.
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
Partida >> usarBonus: unBonus en: posiciones [
	"Gasta una carga y aplica el efecto. Devuelve false si no se pudo usar.
	No cuesta vida ni rompe la racha. Si deja el tablero bloqueado, lo mezcla sin costo."

	cargasDeBonus > 0 ifFalse: [ ^ false ].
	(unBonus puedeAplicarseEn: tablero con: posiciones) ifFalse: [ ^ false ].
	unBonus aplicarEn: tablero con: posiciones.
	cargasDeBonus := cargasDeBonus - 1.
	tablero aplicarGravedad.
	tablero rellenar.
	mejorPuntaje := mejorPuntaje max: puntaje.
	self estaGanada ifFalse: [ self mezclarHastaHaberMovimientos ].
	^ true
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
