"
Cuadrado clickeable de la interfaz grafica. Dibuja un color de fondo y un texto centrado; se usa tanto para las fichas del tablero como para los botones. No conoce las reglas del juego: avisa de los clics y del paso del mouse mediante bloques.
"
Class {
	#name : 'CasilleroMorph',
	#superclass : 'Morph',
	#instVars : [
		'colorFondo',
		'texto',
		'colorTexto',
		'conBonus',
		'resaltado',
		'fuente',
		'accion',
		'alEntrar',
		'alSalir'
	],
	#category : 'MergeDouble-Vista',
	#package : 'MergeDouble-Vista'
}

{ #category : 'instance creation' }
CasilleroMorph class >> fuenteDeTamanio: puntos [

	"Fuente de la interfaz. Si la familia no esta disponible se usa la fuente estandar del sistema."

	^ [ LogicalFont familyName: 'Source Sans Pro' pointSize: puntos ]
		on: Error
		do: [ :error | StandardFonts defaultFont ]
]

{ #category : 'configuring' }
CasilleroMorph >> accion: unBloque [

	"Bloque que se evalua al hacer clic."

	accion := unBloque
]

{ #category : 'configuring' }
CasilleroMorph >> alEntrar: unBloque [

	"Bloque que se evalua cuando el mouse entra al casillero."

	alEntrar := unBloque
]

{ #category : 'configuring' }
CasilleroMorph >> alSalir: unBloque [

	"Bloque que se evalua cuando el mouse sale del casillero."

	alSalir := unBloque
]

{ #category : 'private' }
CasilleroMorph >> dibujarMarcaDeBonus: aCanvas [


	aCanvas frameRectangle: (self bounds insetBy: 4) width: 2 color: Color white.
	aCanvas drawString: '+' at: self topLeft + (7 @ 3) font: fuente color: Color white
]

{ #category : 'private' }
CasilleroMorph >> dibujarTexto: aCanvas [


	| ancho alto origen |
	ancho := fuente widthOfString: texto.
	alto := fuente height.
	origen := self center - ((ancho // 2) @ (alto // 2)).
	aCanvas drawString: texto at: origen font: fuente color: colorTexto
]

{ #category : 'drawing' }
CasilleroMorph >> drawOn: aCanvas [


	aCanvas
		frameAndFillRectangle: self bounds
		fillColor: colorFondo
		borderWidth: 2
		borderColor: colorFondo muchDarker.
	conBonus ifTrue: [ self dibujarMarcaDeBonus: aCanvas ].
	texto isEmpty ifFalse: [ self dibujarTexto: aCanvas ].
	resaltado ifTrue: [ aCanvas frameRectangle: self bounds width: 4 color: Color white ]
]

{ #category : 'configuring' }
CasilleroMorph >> fondo: unColor texto: unTexto colorTexto: otroColor conBonus: unBoolean [


	colorFondo := unColor.
	texto := unTexto.
	colorTexto := otroColor.
	conBonus := unBoolean.
	self changed
]

{ #category : 'configuring' }
CasilleroMorph >> fuente: unaFuente [


	fuente := unaFuente
]

{ #category : 'event handling' }
CasilleroMorph >> handlesMouseDown: evento [


	^ accion notNil
]

{ #category : 'event handling' }
CasilleroMorph >> handlesMouseOver: evento [


	^ alEntrar notNil or: [ alSalir notNil ]
]

{ #category : 'initialization' }
CasilleroMorph >> initialize [


	super initialize.
	colorFondo := Color gray.
	texto := ''.
	colorTexto := Color white.
	conBonus := false.
	resaltado := false.
	fuente := self class fuenteDeTamanio: 16
]

{ #category : 'event handling' }
CasilleroMorph >> mouseDown: evento [


	accion ifNotNil: [ :bloque | bloque value ]
]

{ #category : 'event handling' }
CasilleroMorph >> mouseEnter: evento [


	alEntrar ifNotNil: [ :bloque | bloque value ]
]

{ #category : 'event handling' }
CasilleroMorph >> mouseLeave: evento [


	alSalir ifNotNil: [ :bloque | bloque value ]
]

{ #category : 'configuring' }
CasilleroMorph >> resaltado: unBoolean [


	resaltado = unBoolean ifTrue: [ ^ self ].
	resaltado := unBoolean.
	self changed
]
