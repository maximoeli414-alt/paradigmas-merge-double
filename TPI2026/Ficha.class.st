Class {
	#name : 'Ficha',
	#superclass : 'Object',
	#instVars : [
		'valor'
	],
	#category : 'TPI2026',
	#package : 'TPI2026'
}

{ #category : 'accessing' }
Ficha >> duplicar [
	valor:= valor * 2
]

{ #category : 'testing' }
Ficha >> esCompatibleCon: otraFicha [
	^(valor = (otraFicha valor))
]

{ #category : 'accessing' }
Ficha >> valor [
	^ valor
]

{ #category : 'accessing' }
Ficha >> valor: unNumero [
	valor:= unNumero.
]
