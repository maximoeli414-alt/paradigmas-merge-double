"
Decide que ficha nueva aparece al rellenar el tablero.
"
Class {
	#name : 'GeneradorDeFichas',
	#superclass : 'Object',
	#instVars : [
		'valoresPosibles',
		'probabilidadComodin',
		'probabilidadBonus',
		'azar'
	],
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'initialization' }
GeneradorDeFichas >> initialize [

	super initialize.
	valoresPosibles := #(2 4 8 16).
	probabilidadComodin := 0.05.
	probabilidadBonus := 0.008.
	azar := Random new
]

{ #category : 'operations' }
GeneradorDeFichas >> nuevaFicha [

	| ficha |
	azar next < probabilidadComodin ifTrue: [ ^ FichaComodin valor: 0 ].
	ficha := FichaComun valor: (valoresPosibles atRandom: azar).
	azar next < probabilidadBonus ifTrue: [ ficha marcarConBonus ].
	^ ficha
]
