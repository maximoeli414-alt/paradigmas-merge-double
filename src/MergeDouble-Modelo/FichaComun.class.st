"
Ficha que solo se agrupa con fichas de su mismo valor o con comodines.
"
Class {
	#name : 'FichaComun',
	#superclass : 'Ficha',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'testing' }
FichaComun >> esCompatibleCon: otraFicha [

	^ otraFicha esComodin or: [ valor = otraFicha valor ]
]
