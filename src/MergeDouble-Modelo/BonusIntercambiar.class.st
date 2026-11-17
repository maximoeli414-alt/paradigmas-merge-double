Class {
	#name : 'BonusIntercambiar',
	#superclass : 'Bonus',
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'operations' }
BonusIntercambiar >> aplicarEn: unTablero con: posiciones [

	unTablero intercambiar: posiciones first con: posiciones last
]

{ #category : 'accessing' }
BonusIntercambiar >> cantidadDePosiciones [

	^ 2
]

{ #category : 'accessing' }
BonusIntercambiar >> nombre [

	^ 'Intercambiar dos fichas'
]
