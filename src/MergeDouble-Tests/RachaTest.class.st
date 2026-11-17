Class {
	#name : 'RachaTest',
	#superclass : 'TestCase',
	#instVars : [
		'racha'
	],
	#category : 'MergeDouble-Tests',
	#package : 'MergeDouble-Tests'
}

{ #category : 'running' }
RachaTest >> setUp [

	super setUp.
	racha := Racha new
]

{ #category : 'tests' }
RachaTest >> testCuatroFusionesCrecientesAlcanzanElUmbral [

	#(2 4 8 16) do: [ :v | racha registrar: v ].
	self assert: racha umbralAlcanzado
]

{ #category : 'tests' }
RachaTest >> testRachaNuevaEmpiezaEnCero [

	self assert: racha contador equals: 0
]

{ #category : 'tests' }
RachaTest >> testReiniciarVuelveACero [

	racha registrar: 8.
	racha reiniciar.
	self assert: racha contador equals: 0.
	self assert: racha cota equals: 0
]

{ #category : 'tests' }
RachaTest >> testTresFusionesNoAlcanzanElUmbral [

	#(2 4 8) do: [ :v | racha registrar: v ].
	self deny: racha umbralAlcanzado
]

{ #category : 'tests' }
RachaTest >> testValorIgualRompeLaRacha [

	racha registrar: 4.
	racha registrar: 8.
	racha registrar: 8.
	self assert: racha contador equals: 0
]

{ #category : 'tests' }
RachaTest >> testValorMayorSumaALaRacha [

	racha registrar: 4.
	racha registrar: 8.
	self assert: racha contador equals: 2.
	self assert: racha cota equals: 8
]

{ #category : 'tests' }
RachaTest >> testValorMenorRompeLaRacha [

	racha registrar: 16.
	racha registrar: 4.
	self assert: racha contador equals: 0
]
