# Simulador de Gestión de Memoria (MMU) – Proyecto Integrador Unidad 1

## Descripción

Este proyecto implementa un simulador básico de la Unidad de Gestión de Memoria (MMU) utilizando pseudocódigo en PSeInt. El programa representa el funcionamiento de la memoria paginada mediante el uso de marcos físicos, tabla de páginas, mapa de bits y simulación de algoritmos de reemplazo de páginas.

El objetivo es comprender el proceso de traducción de direcciones lógicas a físicas y analizar el comportamiento de los algoritmos de reemplazo FIFO y OPT.

---

## Funcionalidades implementadas

El simulador incluye las siguientes etapas:

### 1. Inicialización de memoria física

Se inicializan 4 marcos físicos utilizando un mapa de bits donde:

* 0 representa marco libre
* 1 representa marco ocupado

Se muestra el estado inicial de la RAM simulada.

---

### 2. Traducción de direcciones lógicas a físicas

Se implementa una tabla de páginas con bit de presencia.

El sistema:

* verifica si la página está cargada en memoria
* calcula la dirección física usando marco + desplazamiento
* detecta fallos de página cuando la página no está presente

---

### 3. Simulación del algoritmo FIFO

Se simula el algoritmo First-In First-Out utilizando:

* 3 marcos de memoria
* cadena de referencias de 12 páginas

El sistema muestra paso a paso:

* página referenciada
* contenido actual de los marcos
* detección de fallos de página

---

### 4. Simulación del algoritmo OPT (Óptimo)

Se implementa el algoritmo óptimo de reemplazo de páginas (Belady).

Este algoritmo selecciona como víctima la página cuyo próximo uso está más lejano en el futuro.

Se muestra el comportamiento paso a paso durante la simulación.

---

### 5. Comparación de resultados

Al final del programa se muestra:

* número total de fallos FIFO
* número total de fallos OPT
* diferencia entre ambos algoritmos

Esto permite observar la eficiencia del algoritmo óptimo frente a FIFO.

---

## Estructura del programa

El programa está organizado modularmente mediante:

* Subprocesos
* Funciones
* Algoritmo principal

Principales módulos:

* InicializarRAM
* MostrarMapaBits
* TraducirDireccion
* InicializarMarcosUsuario
* BuscarPaginaEnMarcos
* SimularFIFO
* ElegirVictimaOPT
* SimularOPT

---

## Requisitos

Para ejecutar el programa se necesita:

PSeInt

Abrir el archivo:

SimuladorMMU.psc

y ejecutar normalmente.

---

## Autor

Proyecto realizado como parte del Proyecto Integrador – Unidad 1
Simulación de gestión de memoria con paginación
