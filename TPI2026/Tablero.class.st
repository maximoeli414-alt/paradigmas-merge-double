Class {
	#name : 'Tablero',
	#superclass : 'Object',
	#instVars : [
		'celdas',
		'generador'
	],
	#category : 'TPI2026',
	#package : 'TPI2026'
}

{ #category : 'testing' }
Tablero >> esPosicionValidaFila: f columna: c [ 
	^ (f between: 1 and: 9) and: [ c between: 1 and: 11 ]
]

{ #category : 'accessing' }
Tablero >> fichaEnFila: f columna: c [
	^ (celdas at: f) at: c
]

{ #category : 'initialization' }
Tablero >> initialize [ 
	super initialize. 
	celdas:= (1 to: 9) collect: [ :fila | (1 to: 11) collect: [ :columna | nil ] ]. "hice con coleccion de colecciones digamos porque era mas intuitivo con el collect que ya vimos en el lab"
	generador:= GeneradorDeFichas new.
	self rellenar 
]

{ #category : 'accessing' }
Tablero >> ponerFicha: unaFicha enFila: f columna: c [
	(celdas at: f) at: c put: unaFicha.
]

{ #category : 'operating' }
Tablero >> rellenar [
	1 to: 9 do: [ :i|
		1 to: 11 do: [ :j | 
			(self fichaEnFila: i columna: j) ifNil: [ self ponerFicha: (generador nuevaFicha) enFila: i columna: j]
		]
	]
]
