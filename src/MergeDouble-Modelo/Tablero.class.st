"
Administra la grilla de fichas: busca grupos, fusiona, aplica gravedad y rellena. Posiciones: columna @ fila (x = columna, y = fila). La fila 1 es la de arriba.
"
Class {
	#name : 'Tablero',
	#superclass : 'Object',
	#instVars : [
		'celdas',
		'generador'
	],
	#package : 'MergeDouble-Modelo'
}

{ #category : 'instance creation' }
Tablero class >> filas: unasFilas columnas: unasColumnas [

	^ self filas: unasFilas columnas: unasColumnas generador: GeneradorDeFichas new
]

{ #category : 'instance creation' }
Tablero class >> filas: unasFilas columnas: unasColumnas generador: unGenerador [

	^ self new initializeFilas: unasFilas columnas: unasColumnas generador: unGenerador
]

{ #category : 'constants' }
Tablero class >> tamanioMinimoGrupo [

	^ 3
]

{ #category : 'initialization' }
Tablero >> initializeFilas: unasFilas columnas: unasColumnas generador: unGenerador [

	celdas := (1 to: unasFilas) collect: [ :i | Array new: unasColumnas ].
	generador := unGenerador
]

{ #category : 'accessing' }
Tablero >> filas [

	^ celdas size
]

{ #category : 'accessing' }
Tablero >> columnas [

	^ celdas first size
]

{ #category : 'accessing' }
Tablero >> fichaEnFila: f columna: c [

	^ (celdas at: f) at: c
]

{ #category : 'accessing' }
Tablero >> fichaEn: pos [

	^ self fichaEnFila: pos y columna: pos x
]

{ #category : 'accessing' }
Tablero >> fichas [

	| resultado |
	resultado := OrderedCollection new.
	celdas do: [ :fila |
		fila do: [ :ficha | ficha ifNotNil: [ resultado add: ficha ] ] ].
	^ resultado
]

{ #category : 'operations' }
Tablero >> ponerFicha: unaFicha enFila: f columna: c [

	(celdas at: f) at: c put: unaFicha
]

{ #category : 'testing' }
Tablero >> esPosicionValidaFila: f columna: c [

	^ (f between: 1 and: self filas) and: [ c between: 1 and: self columnas ]
]

{ #category : 'testing' }
Tablero >> puedeFusionar: pos [

	| ficha |
	ficha := self fichaEn: pos.
	(ficha isNil or: [ ficha esComodin ]) ifTrue: [ ^ false ].
	^ (self grupoConectadoDesde: pos) size >= self class tamanioMinimoGrupo
]

{ #category : 'testing' }
Tablero >> hayMovimientosPosibles [

	1 to: self filas do: [ :f |
		1 to: self columnas do: [ :c |
			(self puedeFusionar: c @ f) ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : 'testing' }
Tablero >> contieneFichaDeValorAlMenos: unValor [

	^ self fichas anySatisfy: [ :ficha | ficha valor >= unValor ]
]

{ #category : 'queries' }
Tablero >> vecinosDe: pos [

	^ { pos + (-1 @ 0). pos + (1 @ 0). pos + (0 @ -1). pos + (0 @ 1) }
		select: [ :p | self esPosicionValidaFila: p y columna: p x ]
]

{ #category : 'queries' }
Tablero >> grupoConectadoDesde: pos [

	| seleccionada grupo pendientes actual |
	seleccionada := self fichaEn: pos.
	seleccionada ifNil: [ ^ OrderedCollection new ].
	grupo := Set with: pos.
	pendientes := OrderedCollection with: pos.
	[ pendientes isEmpty ] whileFalse: [
		actual := pendientes removeFirst.
		(self vecinosDe: actual) do: [ :vecino |
			| ficha |
			ficha := self fichaEn: vecino.
			(ficha notNil
				and: [ (grupo includes: vecino) not
					and: [ ficha esCompatibleCon: seleccionada ] ])
				ifTrue: [ grupo add: vecino. pendientes add: vecino ] ] ].
	^ grupo asOrderedCollection
]

{ #category : 'operations' }
Tablero >> fusionar: pos [

	| grupo |
	(self puedeFusionar: pos)
		ifFalse: [ ^ self error: 'No hay un grupo fusionable en esa posicion' ].
	grupo := self grupoConectadoDesde: pos.
	(self fichaEn: pos) duplicar.
	(grupo reject: [ :p | p = pos ]) do: [ :p | self vaciar: p ].
	^ grupo size - 1
]

{ #category : 'operations' }
Tablero >> aplicarGravedad [

	1 to: self columnas do: [ :c | self aplicarGravedadEnColumna: c ]
]

{ #category : 'operations' }
Tablero >> rellenar [

	1 to: self filas do: [ :i |
		1 to: self columnas do: [ :j |
			(self fichaEnFila: i columna: j) ifNil: [
				self ponerFicha: generador nuevaFicha enFila: i columna: j ] ] ]
]

{ #category : 'operations' }
Tablero >> reiniciar [

	1 to: self filas do: [ :f |
		1 to: self columnas do: [ :c | self vaciar: c @ f ] ].
	self rellenar
]

{ #category : 'private' }
Tablero >> vaciar: pos [

	self ponerFicha: nil enFila: pos y columna: pos x
]

{ #category : 'private' }
Tablero >> aplicarGravedadEnColumna: c [

	| fichas huecos |
	fichas := ((1 to: self filas) collect: [ :f | self fichaEnFila: f columna: c ])
		reject: [ :ficha | ficha isNil ].
	huecos := self filas - fichas size.
	1 to: self filas do: [ :f |
		self
			ponerFicha: (f <= huecos ifTrue: [ nil ] ifFalse: [ fichas at: f - huecos ])
			enFila: f
			columna: c ]
]
