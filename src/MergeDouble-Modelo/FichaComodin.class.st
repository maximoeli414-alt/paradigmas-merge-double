"
Ficha especial compatible con cualquier otra. Tiene valor 0 y no puede ser la ficha seleccionada.
"
Class {
	#name : 'FichaComodin',
	#superclass : 'Ficha',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'testing' }
FichaComodin >> esComodin [

	^ true
]

{ #category : 'testing' }
FichaComodin >> esCompatibleCon: otraFicha [

	^ true
]

{ #category : 'printing' }
FichaComodin >> printOn: aStream [

	aStream nextPut: $*
]
