"
Pruebas de la jerarquia de fichas: compatibilidad y duplicacion.
"
Class {
	#name : 'FichaTest',
	#superclass : 'TestCase',
	#category : 'MergeDouble-Tests',
	#package : 'MergeDouble-Tests'
}

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

{ #category : 'tests' }
FichaTest >> testFichaComunEsCompatibleConComodin [

	self assert: ((FichaComun valor: 4) esCompatibleCon: (FichaComodin valor: 0))
]

{ #category : 'tests' }
FichaTest >> testFichaComunEsCompatibleConMismoValor [

	self assert: ((FichaComun valor: 4) esCompatibleCon: (FichaComun valor: 4)).
	self deny: ((FichaComun valor: 4) esCompatibleCon: (FichaComun valor: 8))
]

{ #category : 'tests' }
FichaTest >> testFichaNuevaNoTieneBonus [

	self deny: (FichaComun valor: 4) tieneBonus
]

{ #category : 'tests' }
FichaTest >> testMarcarYQuitarBonus [

	| ficha |
	ficha := FichaComun valor: 4.
	ficha marcarConBonus.
	self assert: ficha tieneBonus.
	ficha quitarBonus.
	self deny: ficha tieneBonus
]
