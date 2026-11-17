"
Decide que ficha nueva aparece al rellenar el tablero.
"
Class {
	#name : 'GeneradorDeFichas',
	#superclass : 'Object',
	#instVars : [
		'valoresPosibles',
		'probabilidadComodin',
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
	azar := Random new
]

{ #category : 'operations' }
GeneradorDeFichas >> nuevaFicha [

	^ azar next < probabilidadComodin
		ifTrue: [ FichaComodin valor: 0 ]
		ifFalse: [ FichaComun valor: (valoresPosibles atRandom: azar) ]
]
