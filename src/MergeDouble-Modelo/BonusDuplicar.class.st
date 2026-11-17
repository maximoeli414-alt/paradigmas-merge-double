"
Duplica el valor de una ficha comun elegida por el jugador.
"
Class {
	#name : 'BonusDuplicar',
	#superclass : 'Bonus',
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'operations' }
BonusDuplicar >> aplicarEn: unTablero con: posiciones [

	unTablero duplicarFichaEn: posiciones first
]

{ #category : 'accessing' }
BonusDuplicar >> cantidadDePosiciones [

	^ 1
]

{ #category : 'accessing' }
BonusDuplicar >> nombre [

	^ 'Duplicar una ficha'
]

{ #category : 'testing' }
BonusDuplicar >> puedeAplicarseEn: unTablero con: posiciones [
	"Ademas de lo comun, no se puede duplicar un comodin."

	^ (super puedeAplicarseEn: unTablero con: posiciones)
		and: [ (unTablero fichaEn: posiciones first) esComodin not ]
]
