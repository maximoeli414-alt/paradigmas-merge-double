"
Clase abstracta. Representa una ficha con un valor y define con qué otras fichas puede agruparse.
"
Class {
	#name : 'Ficha',
	#superclass : 'Object',
	#instVars : [
		'valor'
	],
	#package : 'MergeDouble-Modelo'
}

{ #category : 'instance creation' }
Ficha class >> valor: unValor [

	^ self new setValor: unValor
]

{ #category : 'initialization' }
Ficha >> setValor: unValor [

	valor := unValor
]

{ #category : 'accessing' }
Ficha >> valor [

	^ valor
]

{ #category : 'testing' }
Ficha >> esComodin [

	^ false
]

{ #category : 'testing' }
Ficha >> esCompatibleCon: otraFicha [

	^ self subclassResponsibility
]

{ #category : 'operations' }
Ficha >> duplicar [

	valor := valor * 2
]

{ #category : 'printing' }
Ficha >> printOn: aStream [

	aStream print: valor
]
