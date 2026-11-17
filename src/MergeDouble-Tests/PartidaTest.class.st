Class {
	#name : 'PartidaTest',
	#superclass : 'TestCase',
	#instVars : [
		'partida'
	],
	#category : 'MergeDouble-Tests',
	#package : 'MergeDouble-Tests'
}

{ #category : 'private' }
PartidaTest >> partidaConMatriz: matriz meta: unValor vidas: cantidadDeVidas [

	| tablero |
	tablero := Tablero filas: matriz size columnas: matriz first size.
	matriz doWithIndex: [ :fila :i |
		fila doWithIndex: [ :valor :j |
			tablero ponerFicha: (FichaComun valor: valor) enFila: i columna: j ] ].
	^ Partida tablero: tablero meta: unValor vidas: cantidadDeVidas
]

{ #category : 'tests' }
PartidaTest >> testBloqueoEnLaVictoriaNoRestaVida [

	partida := self partidaConMatriz: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} } meta: 16 vidas: 3.
	partida verificarBloqueo.
	self assert: partida vidas equals: 3
]

{ #category : 'tests' }
PartidaTest >> testBloqueoRestaUnaVida [

	partida := self partidaConMatriz: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} } meta: 2048 vidas: 3.
	partida verificarBloqueo.
	self assert: partida vidas equals: 2
]

{ #category : 'tests' }
PartidaTest >> testConMovimientosNoSeRestaVida [

	partida := self partidaConMatriz: { {4. 4. 4}. {2. 8. 16}. {16. 2. 8} } meta: 2048 vidas: 3.
	partida verificarBloqueo.
	self assert: partida vidas equals: 3
]

{ #category : 'tests' }
PartidaTest >> testFusionSumaALaRacha [

	partida := self partidaConMatriz: { {4. 4. 4}. {2. 8. 16}. {16. 2. 8} } meta: 2048 vidas: 3.
	partida seleccionar: 1 @ 1.
	self assert: partida racha contador equals: 1
]

{ #category : 'tests' }
PartidaTest >> testPartidaNuevaEmpiezaConTresVidas [

	self assert: Partida estandar vidas equals: 3
]

{ #category : 'tests' }
PartidaTest >> testPerderLaUltimaVidaTerminaLaPartida [

	partida := self partidaConMatriz: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} } meta: 2048 vidas: 1.
	partida verificarBloqueo.
	self assert: partida vidas equals: 0.
	self assert: partida estaPerdida
]

{ #category : 'tests' }
PartidaTest >> testPerderUnaVidaNoRompeLaRacha [

	partida := self partidaConMatriz: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} } meta: 2048 vidas: 3.
	partida racha registrar: 4.
	partida verificarBloqueo.
	self assert: partida racha contador equals: 1
]

{ #category : 'tests' }
PartidaTest >> testReiniciarRestauraLasVidas [

	partida := Partida estandar.
	partida perderVida.
	partida reiniciar.
	self assert: partida vidas equals: 3
]

{ #category : 'tests' }
PartidaTest >> testSeleccionInvalidaNoTocaLaRacha [

	partida := self partidaConMatriz: { {4. 4. 4}. {2. 8. 16}. {16. 2. 8} } meta: 2048 vidas: 3.
	partida racha registrar: 4.
	partida seleccionar: 2 @ 2.
	self assert: partida racha contador equals: 1
]

{ #category : 'tests' }
PartidaTest >> testTrasPerderUnaVidaElTableroTieneMovimientos [

	partida := self partidaConMatriz: { {4. 2. 8}. {2. 16. 4}. {8. 4. 2} } meta: 2048 vidas: 3.
	partida verificarBloqueo.
	self assert: partida tablero hayMovimientosPosibles
]
