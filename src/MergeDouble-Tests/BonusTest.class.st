Class {
	#name : 'BonusTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero'
	],
	#category : 'MergeDouble-Tests',
	#package : 'MergeDouble-Tests'
}

{ #category : 'running' }
BonusTest >> setUp [

	super setUp.
	tablero := Tablero filas: 3 columnas: 3.
	tablero rellenar
]

{ #category : 'tests' }
BonusTest >> testDuplicarNoAceptaComodin [

	tablero ponerFicha: (FichaComodin valor: 0) enFila: 1 columna: 1.
	self deny: (BonusDuplicar new puedeAplicarseEn: tablero con: { 1 @ 1 })
]

{ #category : 'tests' }
BonusTest >> testHayCincoBonusDisponibles [

	self assert: Bonus todos size equals: 5
]

{ #category : 'tests' }
BonusTest >> testIntercambiarExigeDosPosicionesDistintas [

	self assert: (BonusIntercambiar new puedeAplicarseEn: tablero con: { 1 @ 1. 2 @ 2 }).
	self deny: (BonusIntercambiar new puedeAplicarseEn: tablero con: { 1 @ 1. 1 @ 1 })
]

{ #category : 'tests' }
BonusTest >> testRomperExigeUnaPosicionValida [

	self assert: (BonusRomper new puedeAplicarseEn: tablero con: { 1 @ 1 }).
	self deny: (BonusRomper new puedeAplicarseEn: tablero con: { 9 @ 9 }).
	self deny: (BonusRomper new puedeAplicarseEn: tablero con: #())
]
