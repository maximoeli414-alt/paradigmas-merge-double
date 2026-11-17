"
Redistribuye al azar todas las fichas del tablero.
"
Class {
	#name : 'BonusMezclar',
	#superclass : 'Bonus',
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'operations' }
BonusMezclar >> aplicarEn: unTablero con: posiciones [

	unTablero mezclar
]

{ #category : 'accessing' }
BonusMezclar >> nombre [

	^ 'Mezclar el tablero'
]
