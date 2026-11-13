Class {
	#name : 'GeneradorDeFichas',
	#superclass : 'Object',
	#instVars : [
		'valoresPosibles'
	],
	#category : 'TPI2026',
	#package : 'TPI2026'
}

{ #category : 'initialization' }
GeneradorDeFichas >> initialize [ 
	super initialize.
	valoresPosibles:= #(2 4 8 16)
]

{ #category : 'operatin' }
GeneradorDeFichas >> nuevaFicha [
	|nueva|
	nueva:= Ficha new.
	nueva valor: (valoresPosibles atRandom).
	^nueva
]
