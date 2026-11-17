# Merge & Double (Paradigmas de Programacion - 5ta Instancia de Evaluacion)

Implementacion en Smalltalk (Pharo 13) del escenario 10: Merge & Double.

## Estructura
- `src/MergeDouble-Modelo`: reglas del juego (Ficha, FichaComun, FichaComodin, GeneradorDeFichas, Tablero, Partida).
- `src/MergeDouble-Vista`: interaccion con el usuario (VistaConsola).
- `src/MergeDouble-Tests`: pruebas unitarias (FichaTest, TableroTest).

## Como cargarlo
1. Abrir Pharo 13 e Iceberg (Tools > Iceberg).
2. Add > Import from existing clone y elegir esta carpeta (debe ser un repositorio Git).
3. Cargar los tres paquetes (clic derecho sobre el repositorio > Load packages).

## Como ejecutarlo
Abrir el Transcript (Tools > Transcript) y ejecutar en el Playground:

    (VistaConsola partida: Partida estandar) jugar

Ingresar fila y columna separadas por un espacio (ej: `3 4`).

## Como correr las pruebas
Abrir el Test Runner y ejecutar los paquetes `MergeDouble-Tests`.

## Convenciones
- Posiciones: `columna @ fila` (x = columna, y = fila). La fila 1 es la de arriba.
- Adyacencia en 4 direcciones (sin diagonales). Grupo valido: minimo 3 fichas.

## Variaciones propias
- Vidas: 3. Si el tablero queda sin movimientos se pierde una vida y se mezcla. Con 0 vidas termina la partida.
- Racha: 4 fusiones consecutivas de valor creciente desbloquean una carga de bonus.
- Bonus (tecla B en la consola): romper una ficha, intercambiar dos, mezclar el tablero, duplicar una ficha y eliminar las fichas de menor valor.
- Bloques con bonus: algunas fichas aparecen marcadas con + y otorgan una carga de bonus al fusionarse.
