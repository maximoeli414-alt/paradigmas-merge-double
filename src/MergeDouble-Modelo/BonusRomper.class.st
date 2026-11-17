"
Elimina una ficha elegida por el jugador.
"
Class {
	#name : 'BonusRomper',
	#superclass : 'Bonus',
	#category : 'MergeDouble-Modelo',
	#package : 'MergeDouble-Modelo'
}

{ #category : 'operations' }
BonusRomper >> aplicarEn: unTablero con: posiciones [

	unTablero romperFichaEn: posiciones first
]

{ #category : 'accessing' }
BonusRomper >> cantidadDePosiciones [

	^ 1
]

{ #category : 'accessing' }
BonusRomper >> nombre [

	^ 'Romper una ficha'
]
