"
Pruebas del tablero: busqueda de grupos, fusion, gravedad y comodines. Posiciones: columna @ fila.
"
Class {
	#name : 'TableroTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero'
	],
	#category : 'MergeDouble-Tests',
	#package : 'MergeDouble-Tests'
}

{ #category : 'private' }
TableroTest >> cargar: matriz [

	tablero := Tablero filas: matriz size columnas: matriz first size.
	matriz doWithIndex: [ :fila :i |
		fila doWithIndex: [ :valor :j |
			tablero ponerFicha: (FichaComun valor: valor) enFila: i columna: j ] ]
]

{ #category : 'tests' }
TableroTest >> testComodinNoPuedeSerLaFichaSeleccionada [

	self cargar: { {4. 4. 4}. {2. 8. 16}. {16. 2. 8} }.
	tablero ponerFicha: (FichaComodin valor: 0) enFila: 1 columna: 2.
	self deny: (tablero puedeFusionar: 2 @ 1)
]

{ #category : 'tests' }
TableroTest >> testComodinSeUneAlGrupo [

	self cargar: { {4. 4. 4}. {2. 8. 16}. {16. 2. 8} }.
	tablero ponerFicha: (FichaComodin valor: 0) enFila: 1 columna: 2.
	self assert: (tablero puedeFusionar: 1 @ 1)
]

{ #category : 'tests' }
TableroTest >> testDiagonalNoCuentaComoAdyacente [

	self cargar: { {4. 2. 8}. {2. 4. 16}. {8. 16. 4} }.
	self deny: (tablero puedeFusionar: 1 @ 1)
]

{ #category : 'tests' }
TableroTest >> testDuplicarFichaEn [

	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	tablero duplicarFichaEn: 1 @ 1.
	self assert: (tablero fichaEn: 1 @ 1) valor equals: 8
]

{ #category : 'tests' }
TableroTest >> testDuplicarUnComodinLanzaError [

	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	tablero ponerFicha: (FichaComodin valor: 0) enFila: 1 columna: 1.
	self should: [ tablero duplicarFichaEn: 1 @ 1 ] raise: Error
]

{ #category : 'tests' }
TableroTest >> testEliminarValorMinimoQuitaTodasLasFichasDeEseValor [

	| eliminadas |
	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	eliminadas := tablero eliminarValorMinimo.
	self assert: eliminadas equals: 3.
	self assert: tablero fichas size equals: 6.
	self assert: tablero valorMinimo equals: 4
]

{ #category : 'tests' }
TableroTest >> testFichaAisladaNoPuedeFusionarse [

	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	self deny: (tablero puedeFusionar: 2 @ 2)
]

{ #category : 'tests' }
TableroTest >> testFusionarDejaFichaDuplicadaYVaciaElResto [

	self cargar: { {4. 4. 4}. {2. 8. 16}. {16. 2. 8} }.
	tablero fusionar: 1 @ 1.
	self assert: (tablero fichaEnFila: 1 columna: 1) valor equals: 8.
	self assert: (tablero fichaEnFila: 1 columna: 2) isNil.
	self assert: (tablero fichaEnFila: 1 columna: 3) isNil
]

{ #category : 'tests' }
TableroTest >> testFusionarEnPosicionInvalidaLanzaError [

	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	self should: [ tablero fusionar: 2 @ 2 ] raise: Error
]

{ #category : 'tests' }
TableroTest >> testGravedadHaceCaerLasFichas [

	self cargar: { {2. 8. 16}. {4. 4. 4}. {16. 2. 8} }.
	tablero fusionar: 1 @ 2.
	tablero aplicarGravedad.
	self assert: (tablero fichaEnFila: 1 columna: 2) isNil.
	self assert: (tablero fichaEnFila: 2 columna: 2) valor equals: 8.
	self assert: (tablero fichaEnFila: 2 columna: 3) valor equals: 16
]

{ #category : 'tests' }
TableroTest >> testGrupoDeTresPuedeFusionarse [

	self cargar: { {4. 4. 4}. {2. 8. 16}. {16. 2. 8} }.
	self assert: (tablero grupoConectadoDesde: 1 @ 1) size equals: 3.
	self assert: (tablero puedeFusionar: 1 @ 1)
]

{ #category : 'tests' }
TableroTest >> testIntercambiarFichas [

	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	tablero intercambiar: 1 @ 1 con: 3 @ 3.
	self assert: (tablero fichaEn: 1 @ 1) valor equals: 2.
	self assert: (tablero fichaEn: 3 @ 3) valor equals: 4
]

{ #category : 'tests' }
TableroTest >> testMezclarConservaLaCantidadDeFichas [

	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	tablero mezclar.
	self assert: tablero fichas size equals: 9
]

{ #category : 'tests' }
TableroTest >> testMezclarConservaLosValores [

	| antes |
	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	antes := (tablero fichas collect: [ :f | f valor ]) asSortedCollection asArray.
	tablero mezclar.
	self
		assert: ((tablero fichas collect: [ :f | f valor ]) asSortedCollection asArray)
		equals: antes
]

{ #category : 'tests' }
TableroTest >> testParNoPuedeFusionarse [

	self cargar: { {4. 4. 2}. {2. 8. 16}. {16. 2. 8} }.
	self deny: (tablero puedeFusionar: 1 @ 1)
]

{ #category : 'tests' }
TableroTest >> testRomperFichaVaciaLaCelda [

	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	tablero romperFichaEn: 2 @ 2.
	self assert: (tablero fichaEn: 2 @ 2) isNil
]

{ #category : 'tests' }
TableroTest >> testSinMovimientosPosibles [

	self cargar: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} }.
	self deny: tablero hayMovimientosPosibles
]

{ #category : 'tests' }
TableroTest >> testValorMinimoIgnoraLosComodines [

	self cargar: { {8. 8}. {8. 8} }.
	tablero ponerFicha: (FichaComodin valor: 0) enFila: 1 columna: 1.
	self assert: tablero valorMinimo equals: 8
]
