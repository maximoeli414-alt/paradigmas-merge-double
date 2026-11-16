"
Pruebas de la jerarquia de fichas: compatibilidad y duplicacion.
"
Class {
	#name : 'FichaTest',
	#superclass : 'TestCase',
	#package : 'MergeDouble-Tests'
}

{ #category : 'tests' }
FichaTest >> testFichaComunEsCompatibleConMismoValor [

	self assert: ((FichaComun valor: 4) esCompatibleCon: (FichaComun valor: 4)).
	self deny: ((FichaComun valor: 4) esCompatibleCon: (FichaComun valor: 8))
]

{ #category : 'tests' }
FichaTest >> testFichaComunEsCompatibleConComodin [

	self assert: ((FichaComun valor: 4) esCompatibleCon: (FichaComodin valor: 0))
]

{ #category : 'tests' }
FichaTest >> testComodinEsCompatibleConCualquierFicha [

	self assert: ((FichaComodin valor: 0) esCompatibleCon: (FichaComun valor: 16))
]

{ #category : 'tests' }
FichaTest >> testDuplicarDuplicaElValor [

	| ficha |
	ficha := FichaComun valor: 4.
	ficha duplicar.
	self assert: ficha valor equals: 8
]
