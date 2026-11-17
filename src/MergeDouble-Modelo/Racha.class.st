"
Lleva la cuenta de fusiones consecutivas en las que el valor resultante supera al de la fusion anterior. Al llegar al umbral se desbloquea un bonus.
"
Class {
	#name : 'Racha',
	#superclass : 'Object',
	#instVars : [
		'cota',
		'contador'
	],
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'constants' }
Racha class >> umbral [
	"Fusiones consecutivas necesarias para desbloquear un bonus."

	^ 4
]

{ #category : 'accessing' }
Racha >> contador [

	^ contador
]

{ #category : 'accessing' }
Racha >> cota [

	^ cota
]

{ #category : 'initialization' }
Racha >> initialize [

	super initialize.
	self reiniciar
]

{ #category : 'operations' }
Racha >> registrar: valorResultante [
	"Si el valor supera a la cota la racha sube; si no, se corta."

	valorResultante > cota
		ifTrue: [
			cota := valorResultante.
			contador := contador + 1 ]
		ifFalse: [ self reiniciar ]
]

{ #category : 'operations' }
Racha >> reiniciar [

	cota := 0.
	contador := 0
]

{ #category : 'testing' }
Racha >> umbralAlcanzado [

	^ contador >= self class umbral
]
