# ictools <img src="https://img.shields.io/badge/R-package-blue?logo=r" align="right" height="28"/>

> **Herramientas para el cálculo de intervalos de confianza en R**  
> Métodos clásicos y bootstrap sobre data frames y matrices.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-%3E%3D4.0-276DC3?logo=r)](https://www.r-project.org/)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)

---

## 📋 Tabla de contenidos

- [Descripción](#-descripción)
- [Instalación](#-instalación)
- [Funciones disponibles](#-funciones-disponibles)
- [Uso rápido](#-uso-rápido)
- [Ejemplos detallados](#-ejemplos-detallados)
- [Estructura del paquete](#-estructura-del-paquete)
- [Licencia](#-licencia)

---

## 📖 Descripción

`ictools` es un paquete de R diseñado para calcular **intervalos de confianza** de forma sencilla y reproducible a partir de data frames y matrices. Ofrece una interfaz unificada para los métodos estadísticos más utilizados en inferencia clásica, incluyendo:

- Intervalos de confianza para **medias** poblacionales
- Intervalos de confianza para **proporciones**
- Intervalos de confianza para **varianzas**
- Intervalos de confianza para la **razón de varianzas**
- Intervalos de confianza en **regresión lineal**

El paquete está orientado a estudiantes, docentes e investigadores que necesiten calcular intervalos de confianza de manera sistemática sin tener que reescribir la misma lógica repetidamente.

---

## 📦 Instalación

Puedes instalar la versión de desarrollo directamente desde GitHub usando el paquete `devtools` o `remotes`:

```r
# Usando devtools
install.packages("devtools")
devtools::install_github("RayanSiffeO/ictools")

# O usando remotes
install.packages("remotes")
remotes::install_github("RayanSiffeO/ictools")
```

Una vez instalado, carga el paquete con:

```r
library(ictools)
```

---

## 🔧 Funciones disponibles

| Función | Descripción | Distribución usada |
|---|---|---|
| `ic_pmean()` | IC para la media poblacional | t de Student / Normal |
| `ic_prop()` | IC para una proporción | Normal (aproximación) |
| `ic_var()` | IC para la varianza | Chi-cuadrado |
| `ic_razon_var()` | IC para la razón de dos varianzas | F de Snedecor |
| `ic_reg()` | IC para coeficientes de regresión lineal | t de Student |

Todas las funciones devuelven objetos con métodos `print()` y `as.data.frame()` implementados, lo que facilita la visualización y exportación de resultados.

---

## ⚡ Uso rápido

```r
library(ictools)

# Intervalo de confianza para la media (varianza desconocida)
ic_pmean(x = c(23, 25, 28, 22, 30, 27), conf = 0.95)

# Intervalo de confianza para una proporción
ic_prop(x = 42, n = 100, conf = 0.95)

# Intervalo de confianza para la varianza
ic_var(x = rnorm(30, mean = 5, sd = 2), conf = 0.95)

# Intervalo de confianza para la razón de varianzas
ic_razon_var(x = rnorm(20, sd = 2), y = rnorm(25, sd = 3), conf = 0.95)

# Intervalo de confianza para coeficientes de regresión
modelo <- ic_reg(y ~ x1 + x2, data = mi_datos, conf = 0.95)
print(modelo)
```

---

## 📚 Ejemplos detallados

### `ic_pmean()` — Media poblacional

Calcula el intervalo de confianza para la media de una población cuando la varianza es desconocida (usa distribución t de Student) o conocida (usa distribución Normal).

```r
# Con un vector numérico
datos <- c(4.5, 5.1, 4.8, 5.3, 4.9, 5.0, 4.7)
resultado <- ic_pmean(x = datos, conf = 0.95)
print(resultado)
#> Intervalo de confianza para la media (95%)
#> Estimación puntual: 4.9
#> IC: [4.62, 5.18]

# Exportar como data frame
as.data.frame(resultado)
```

---

### `ic_prop()` — Proporción

Calcula el intervalo de confianza para una proporción poblacional usando la aproximación normal.

```r
# 42 éxitos en 100 ensayos
resultado <- ic_prop(x = 42, n = 100, conf = 0.95)
print(resultado)
#> Intervalo de confianza para la proporción (95%)
#> Proporción muestral: 0.42
#> IC: [0.323, 0.517]
```

---

### `ic_var()` — Varianza

Calcula el intervalo de confianza para la varianza poblacional basado en la distribución chi-cuadrado.

```r
set.seed(42)
muestra <- rnorm(50, mean = 10, sd = 3)
resultado <- ic_var(x = muestra, conf = 0.95)
print(resultado)
#> Intervalo de confianza para la varianza (95%)
#> Varianza muestral: 8.73
#> IC: [6.02, 13.54]
```

---

### `ic_razon_var()` — Razón de varianzas

Calcula el intervalo de confianza para el cociente de dos varianzas poblacionales usando la distribución F.

```r
grupo_A <- c(12, 14, 13, 15, 11, 14)
grupo_B <- c(20, 18, 22, 19, 21, 23)

resultado <- ic_razon_var(x = grupo_A, y = grupo_B, conf = 0.95)
print(resultado)
#> Intervalo de confianza para la razón de varianzas (95%)
#> Razón muestral: 0.43
#> IC: [0.07, 2.86]
```

---

### `ic_reg()` — Regresión lineal

Calcula los intervalos de confianza para los coeficientes de un modelo de regresión lineal.

```r
# Usando el dataset mtcars
resultado <- ic_reg(mpg ~ wt + hp, data = mtcars, conf = 0.95)
print(resultado)
#> Intervalos de confianza para coeficientes de regresión (95%)
#>              Estimación     LI       LS
#> (Intercept)   37.23      33.16    41.29
#> wt            -3.88      -5.17    -2.58
#> hp            -0.03      -0.05    -0.02

as.data.frame(resultado)
```

---

## 🗂 Estructura del paquete

```
ictools/
├── R/                    # Código fuente de las funciones
├── man/                  # Documentación generada por roxygen2
├── tests/                # Pruebas unitarias (testthat)
├── DESCRIPTION           # Metadatos del paquete
├── NAMESPACE             # Exports e imports generados automáticamente
├── LICENSE               # Licencia del paquete
└── README.md             # Este archivo
```

---

## 📄 Licencia

Este proyecto está bajo la licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## 👤 Autor

**Rayan Siffeo**  
GitHub: [@RayanSiffeO](https://github.com/RayanSiffeO)

---

*Si encuentras algún error o quieres proponer mejoras, no dudes en abrir un [issue](https://github.com/RayanSiffeO/ictools/issues) o un pull request.*
