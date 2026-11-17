"
Administra la grilla de fichas: busca grupos, fusiona, aplica gravedad, rellena y mezcla. Ofrece las operaciones que usan los bonus. Posiciones: columna @ fila (x = columna, y = fila). La fila 1 es la de arriba.
"
Class {
	#name : 'Tablero',
	#superclass : 'Object',
	#instVars : [
		'celdas',
		'generador'
	],
	#category : 'MergeDouble-Modelo',
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

{ #category : 'operations' }
Tablero >> aplicarGravedad [

	1 to: self columnas do: [ :c | self aplicarGravedadEnColumna: c ]
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

{ #category : 'accessing' }
Tablero >> columnas [

	^ celdas first size
]

{ #category : 'testing' }
Tablero >> contieneFichaDeValorAlMenos: unValor [

	^ self fichas anySatisfy: [ :ficha | ficha valor >= unValor ]
]

{ #category : 'operations' }
Tablero >> duplicarFichaEn: pos [

	| ficha |
	ficha := self fichaEn: pos.
	(ficha isNil or: [ ficha esComodin ])
		ifTrue: [ ^ self error: 'No se puede duplicar esa ficha' ].
	ficha duplicar
]

{ #category : 'operations' }
Tablero >> eliminarValorMinimo [
	"Elimina todas las fichas comunes de menor valor. Devuelve cuantas elimino."

	| minimo eliminadas |
	minimo := self valorMinimo.
	eliminadas := 0.
	1 to: self filas do: [ :f |
		1 to: self columnas do: [ :c |
			| ficha |
			ficha := self fichaEnFila: f columna: c.
			(ficha notNil and: [ ficha esComodin not and: [ ficha valor = minimo ] ])
				ifTrue: [
					self vaciar: c @ f.
					eliminadas := eliminadas + 1 ] ] ].
	^ eliminadas
]

{ #category : 'testing' }
Tablero >> esPosicionValidaFila: f columna: c [

	^ (f between: 1 and: self filas) and: [ c between: 1 and: self columnas ]
]

{ #category : 'accessing' }
Tablero >> fichaEn: pos [

	^ self fichaEnFila: pos y columna: pos x
]

{ #category : 'accessing' }
Tablero >> fichaEnFila: f columna: c [

	^ (celdas at: f) at: c
]

{ #category : 'accessing' }
Tablero >> fichas [

	| resultado |
	resultado := OrderedCollection new.
	celdas do: [ :fila |
		fila do: [ :ficha | ficha ifNotNil: [ resultado add: ficha ] ] ].
	^ resultado
]

{ #category : 'accessing' }
Tablero >> filas [

	^ celdas size
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

{ #category : 'testing' }
Tablero >> hayMovimientosPosibles [

	1 to: self filas do: [ :f |
		1 to: self columnas do: [ :c |
			(self puedeFusionar: c @ f) ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : 'initialization' }
Tablero >> initializeFilas: unasFilas columnas: unasColumnas generador: unGenerador [

	celdas := (1 to: unasFilas) collect: [ :i | Array new: unasColumnas ].
	generador := unGenerador
]

{ #category : 'operations' }
Tablero >> intercambiar: pos1 con: pos2 [

	| ficha1 ficha2 |
	ficha1 := self fichaEn: pos1.
	ficha2 := self fichaEn: pos2.
	self ponerFicha: ficha2 enFila: pos1 y columna: pos1 x.
	self ponerFicha: ficha1 enFila: pos2 y columna: pos2 x
]

{ #category : 'operations' }
Tablero >> mezclar [
	"Redistribuye al azar las fichas que ya estan en el tablero. Las celdas vacias siguen vacias."

	| posiciones barajadas |
	posiciones := OrderedCollection new.
	1 to: self filas do: [ :f |
		1 to: self columnas do: [ :c |
			(self fichaEnFila: f columna: c) ifNotNil: [ posiciones add: c @ f ] ] ].
	barajadas := self fichas shuffled.
	posiciones with: barajadas do: [ :pos :ficha |
		self ponerFicha: ficha enFila: pos y columna: pos x ]
]

{ #category : 'operations' }
Tablero >> ponerFicha: unaFicha enFila: f columna: c [

	(celdas at: f) at: c put: unaFicha
]

{ #category : 'testing' }
Tablero >> puedeFusionar: pos [

	| ficha |
	ficha := self fichaEn: pos.
	(ficha isNil or: [ ficha esComodin ]) ifTrue: [ ^ false ].
	^ (self grupoConectadoDesde: pos) size >= self class tamanioMinimoGrupo
]

{ #category : 'operations' }
Tablero >> reiniciar [

	1 to: self filas do: [ :f |
		1 to: self columnas do: [ :c | self vaciar: c @ f ] ].
	self rellenar
]

{ #category : 'operations' }
Tablero >> rellenar [

	1 to: self filas do: [ :i |
		1 to: self columnas do: [ :j |
			(self fichaEnFila: i columna: j) ifNil: [
				self ponerFicha: generador nuevaFicha enFila: i columna: j ] ] ]
]

{ #category : 'operations' }
Tablero >> romperFichaEn: pos [

	(self fichaEn: pos) ifNil: [ ^ self error: 'No hay ficha en esa posicion' ].
	self vaciar: pos
]

{ #category : 'private' }
Tablero >> vaciar: pos [

	self ponerFicha: nil enFila: pos y columna: pos x
]

{ #category : 'operations' }
Tablero >> valorMinimo [
	"Menor valor entre las fichas comunes. Los comodines no cuentan. Devuelve 0 si no hay ninguna."

	| valores |
	valores := (self fichas reject: [ :f | f esComodin ]) collect: [ :f | f valor ].
	^ valores isEmpty ifTrue: [ 0 ] ifFalse: [ valores min ]
]

{ #category : 'queries' }
Tablero >> vecinosDe: pos [

	^ { pos + (-1 @ 0). pos + (1 @ 0). pos + (0 @ -1). pos + (0 @ 1) }
		select: [ :p | self esPosicionValidaFila: p y columna: p x ]
]
