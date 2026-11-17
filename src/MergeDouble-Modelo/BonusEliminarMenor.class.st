"
Elimina del tablero todas las fichas comunes de menor valor, para despejar espacio.
"
Class {
	#name : 'BonusEliminarMenor',
	#superclass : 'Bonus',
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'operations' }
BonusEliminarMenor >> aplicarEn: unTablero con: posiciones [

	unTablero eliminarValorMinimo
]

{ #category : 'accessing' }
BonusEliminarMenor >> nombre [

	^ 'Eliminar las fichas de menor valor'
]
