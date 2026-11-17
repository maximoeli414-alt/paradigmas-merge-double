"
Clase abstracta. Un bonus es un poder que el jugador gana al completar una racha. Cada subclase define su efecto sobre el tablero, cuantas posiciones necesita y su nombre.
"
Class {
	#name : 'Bonus',
	#superclass : 'Object',
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'instance creation' }
Bonus class >> todos [
	"Los bonus disponibles, en el orden en que se muestran en el menu."

	^ { BonusRomper new. BonusIntercambiar new. BonusMezclar new. BonusDuplicar new. BonusEliminarMenor new }
]

{ #category : 'operations' }
Bonus >> aplicarEn: unTablero con: posiciones [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
Bonus >> cantidadDePosiciones [
	"Cuantas posiciones del tablero necesita elegir el jugador."

	^ 0
]

{ #category : 'accessing' }
Bonus >> nombre [

	^ self subclassResponsibility
]

{ #category : 'testing' }
Bonus >> puedeAplicarseEn: unTablero con: posiciones [
	"Valida cantidad, que no se repitan, que esten dentro del tablero y que tengan ficha."

	posiciones size = self cantidadDePosiciones ifFalse: [ ^ false ].
	posiciones asSet size = posiciones size ifFalse: [ ^ false ].
	^ posiciones allSatisfy: [ :p |
		(unTablero esPosicionValidaFila: p y columna: p x)
			and: [ (unTablero fichaEn: p) notNil ] ]
]
