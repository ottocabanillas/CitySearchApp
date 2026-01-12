# Ualá Mobile Challenge (iOS · SwiftUI)

Una app en **SwiftUI** que descarga ~200k ciudades desde un JSON remoto, permite **filtrar por prefijo**, marcar **favoritos**, ver detalles y **navegar en mapa**. Optimizada para búsquedas rápidas con **preprocesamiento** e indexación. Soporta UI combinada en **landscape** y pantallas separadas en **portrait**.

> ⚠️ Requisitos del challenge:
>
> - Swift + SwiftUI (sin librerías de terceros).
> - Compatibilidad con la última versión estable de iOS y Xcode.
> - Búsqueda por prefijo (case-insensitive), lista ordenada alfabéticamente por _ciudad_ y luego _país_.
> - Favoritos persistentes, UI responsiva, detalle por ciudad y mapa integrado.
> - Tests unitarios y de UI.
> - README explicando decisiones, supuestos y enfoque de búsqueda.

---

## Índice

1. Arquitectura
2. Fuentes de datos
3. Estrategia de búsqueda y rendimiento
4. Decisiones importantes
5. Supuestos
6. UX y UI dinámica
7. Persistencia de favoritos
8. Ordenamiento y normalización
9. Mapa y pantalla de información
10. Errores, estados y accesibilidad
11. Configuración y ejecución
12. Estructura del proyecto
13. Testing
14. Mejoras futuras

---

## 1. Arquitectura
**Patrón:** MVVM + Clean Architecture Adaptada

- **Data Layer:**  
  - Descarga y decodificación de JSON de ciudades.
  - Persistencia local (favoritos) mediante `LocalCityStorage`.
  - Manejo de errores y modelos de red (`NetworkLayer`, `NetworkError`, `RequestModel`).

- **Domain Layer:**  
  - Modelos de dominio: `CityModel`, `CityInfoModel`.
  - Protocolos para abstracción de servicios (`NetworkService`, `CityStorage`, `SearchStrategy`).
  - Lógica de búsqueda y ordenamiento (`CityBinarySearch`).

- **Presentation Layer:**  
  - ViewModels reactivos con estado observable (`CityListViewModel`, `CityDetailViewModel`, `MapViewModel`).
  - Vistas SwiftUI desacopladas de la lógica de negocio (`CityListView`, `CityCellView`, `CityDetailView`, `MapView`).
  - Navegación y manejo de estados de UI (carga, error, sin resultados).

- **Services:**  
  - Abstracciones y servicios reutilizables:  
    - `NetworkLayer` (peticiones de red).
    - `LocalCityStorage` (almacenamiento local).
    - `SearchStrategy` (algoritmos de búsqueda).

**Ventajas:**
- Separación clara de responsabilidades entre datos, lógica y presentación.
- Alta testabilidad: mocks y protocolos permiten pruebas unitarias y de UI robustas.
- UI declarativa y reactiva, fácil de mantener y escalar.
- Inyección de dependencias para facilitar pruebas y modularidad.

---

## 2. Fuentes de datos

### Endpoints de ciudades

- **Producción:**  
  [`cities.json` (PROD)](https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json)

- **Desarrollo:**  
  [`cities.json` (DEV)](https://gist.githubusercontent.com/ottocabanillas/6f299e1053fd0d0cfd622f2932188c55/raw/4d28af829a1f5f23598f291486353b4c30d4ecf1/cities.json)

#### Formato de ciudad
```json
{
  "country": "UA",
  "name": "Hurzuf",
  "_id": 707860,
  "coord": { "lon": 34.283333, "lat": 44.549999 }
}
```

### Endpoint de descripción de ciudad (Wikipedia)

- **Wiki API:**  
  `https://en.wikipedia.org/w/api.php?format=json&prop=extracts&exintro=true&explaintext=true&action=query&ggslimit=1&generator=geosearch&ggscoord=<lat>|<lon>&ggsradius=10000n`

#### Formato de respuesta
```json
{
  "batchcomplete": "",
  "query": {
    "pages": {
      "1620956": {
        "pageid": 1620956,
        "ns": 0,
        "title": "Gurzuf",
        "index": -1,
        "extract": "Gurzuf or Hurzuf (Ukrainian: Гурзуф, Russian: Гурзуф, ...."
      }
    }
  }
}
```

---

## 3. Estrategia de búsqueda y rendimiento

**Algoritmo de búsqueda:**  
Búsqueda binaria (Binary Search) sobre una lista de ciudades ordenada alfabéticamente.

**Implementación:**  
La búsqueda por prefijo se realiza utilizando un algoritmo de búsqueda binaria personalizado (`CityBinarySearch`).
- Primero, la lista de ciudades se ordena por nombre y país.
- Cuando el usuario ingresa texto en la barra de búsqueda, se utiliza la búsqueda binaria para encontrar el rango de ciudades cuyo nombre comienza con ese prefijo, lo que permite obtener resultados de forma eficiente incluso con grandes volúmenes de datos.

**¿Por qué es eficiente este enfoque?**
- La búsqueda binaria reduce la complejidad de la búsqueda de O(n) a O(log n), ya que no es necesario recorrer toda la lista, sino solo dividir y acotar el rango de búsqueda.
- Permite filtrar resultados en tiempo real sin afectar el rendimiento de la interfaz, incluso con miles de ciudades.

**Manejo de case-insensitive y diacríticos:**  
Se implementó una extensión de `String` que normaliza el texto ingresado en la barra de búsqueda:
- Elimina diacríticos (acentos y caracteres especiales) usando `folding(options: .diacriticInsensitive, locale: .current)`.
- Convierte el texto a minúsculas (`lowercased()`).
- Esto asegura que la búsqueda sea insensible a mayúsculas/minúsculas y a acentos, mejorando la experiencia del usuario y la precisión de los resultados.

---

## 4. Decisiones importantes

**Abstracción:**
Se definieron interfaces/protocolos para los siguientes componentes clave:

- **Binary Search:**  
  Permite intercambiar fácilmente la estrategia de búsqueda (por ejemplo, reemplazar búsqueda binaria por otra más eficiente en el futuro).
  
- **Network (uso de async/await):**  
  Protocolo para servicios de red, facilitando el reemplazo de la implementación y el uso de mocks en tests.
  
- **Repository/Store:**  
  Abstracción para la persistencia y acceso a datos, permitiendo cambiar la fuente de datos (local, remota, cache) sin afectar la lógica de negocio.

Esto facilita la escalabilidad y el mantenimiento, ya que si surge una mejor solución o una nueva necesidad, solo se reemplaza la implementación concreta sin modificar el resto del sistema. Además, el uso de protocolos simplifica la creación de mocks y stubs para pruebas unitarias y de UI.

**Justificación de las decisiones:**

- **Binary Search:**  
  - Excelente balance entre consumo de recursos y rendimiento.
  - Capaz de manejar grandes volúmenes de datos (hasta 200k elementos) de forma eficiente.
  - Menor complejidad en la implementación, lo que reduce la probabilidad de bugs.
  - Fácil de mantener y extender si se requiere una estrategia diferente en el futuro.

- **Network:**  
  - Decodificación genérica para soportar múltiples modelos de datos.
  - Uso de un `RequestModel` para construir URLs seguras y flexibles.
  - Facilidad para agregar `queryItems` y otros parámetros dinámicamente.
  - Operaciones asíncronas (`async/await`) para no bloquear la UI y mejorar la experiencia de usuario.

- **Repository/Store:**  
  - Abstracción que permite desacoplar la lógica de acceso a datos de la lógica de presentación y dominio.
  - Facilita el cambio de fuente de datos (por ejemplo, de local a remoto) sin afectar el resto de la app.
  - Permite implementar estrategias de sincronización y persistencia de manera modular.
  - Mejora la testabilidad al poder inyectar implementaciones mock o fake en los tests.

---

## 5. Supuestos

**Interpretación de búsqueda por prefijo:**  
Se considera coincidencia cuando el texto ingresado por el usuario coincide con el inicio de la cadena formada por “Nombre de ciudad, Código de país” (por ejemplo, “Al” coincide con “Alabama, US”).

**Responsividad y experiencia de usuario:**  
- La búsqueda es dinámica y se actualiza en tiempo real tanto en la lista principal como en la de favoritos.
- El diseño y la disposición de los elementos pueden variar entre orientación portrait y landscape para mejorar la experiencia en cada caso.
- Se contemplan diferentes escenarios de error (sin conexión, sin resultados, error de red) y se muestra feedback claro al usuario mediante vistas dedicadas.

**Limitaciones y decisiones tomadas:**  
- La búsqueda solo se realiza por el inicio de la cadena, no por palabras intermedias.
- La app está optimizada para iPhone; el soporte para iPad u otros dispositivos no está garantizado.
- Se asume que los datos recibidos del endpoint son válidos y completos.
- El feedback de error se muestra en pantalla, evitando el uso de alertas modales para no interrumpir la experiencia de usuario.

---

## 6. UX y UI dinámica

**Vistas principales:**

### CityListView
- **Barra de búsqueda:** Permite filtrar ciudades por nombre o país en tiempo real.
- **Botón de favoritos:** Permite alternar entre mostrar todas las ciudades o solo las favoritas.
- **Lista de ciudades:**  
  - **CityCell:**  
    - **Título:** Muestra el nombre de la ciudad y el país.
    - **Coordenadas:** Muestra latitud y longitud.
    - **Botón de información:** Al tocarlo, navega a la pantalla de detalles de la ciudad.
    - **Botón de favoritos:** Permite agregar o quitar la ciudad de favoritos.
    - **Tap en la celda:** Navega al mapa de la ciudad (solo en modo portrait).
- **Vista de error:** Se muestra cuando ocurre un error al obtener la información.
- **Vista de sin resultados:** Se muestra cuando la búsqueda no devuelve coincidencias.

### MapView
- **Vista de mapa:** Muestra la ubicación de la ciudad seleccionada.
- **Marcador:** Indica la ciudad en el mapa con su nombre.

**Comportamiento adaptativo (portrait vs. landscape):**

- **Modo portrait:**
  - Al tocar el botón de información, se navega a la pantalla de detalles de la ciudad.
  - Al tocar la celda, se navega al mapa de la ciudad seleccionada.

- **Modo landscape:**
  - La pantalla se divide (split view): la lista de ciudades se muestra a la izquierda y el mapa a la derecha.
  - La navegación a detalles se mantiene igual (botón de información).
  - La navegación al mapa por tap en la celda está deshabilitada; en su lugar, al seleccionar una ciudad, el mapa se actualiza dinámicamente para mostrar la ciudad seleccionada.

**Notas de experiencia de usuario:**
- La interfaz es responsiva y se adapta automáticamente a la orientación del dispositivo.
- Se proporciona feedback visual claro en caso de errores o búsquedas sin resultados.
- La navegación y las acciones principales están optimizadas para usabilidad tanto en portrait como en landscape.

---

## 7. Persistencia de favoritos

**Estrategia utilizada:**
- Se utiliza almacenamiento local basado en archivos, implementado a través de la clase `LocalCityStorage`.
- Los identificadores de las ciudades marcadas como favoritas se guardan como un conjunto (`Set<Int>`) en un archivo JSON en el sistema de archivos de la app.

**Guardado y recuperación del estado:**
- Cuando el usuario marca o desmarca una ciudad como favorita, el "ID" de la ciudad se agrega o elimina del conjunto y se actualiza el archivo local.
- Al iniciar la aplicación, el ViewModel recupera el conjunto de favoritos desde el archivo usando `LocalCityStorage`, asegurando que el estado de favoritos persista entre sesiones.

**Filtrado de favoritos en la lista:**
- El ViewModel mantiene una lista reactiva de ciudades favoritas basada en los "IDs" almacenados.
- Al activar el filtro de favoritos en la UI, la lista principal muestra únicamente las ciudades cuyos identificadores están presentes en el conjunto de favoritos.
- El filtrado se actualiza en tiempo real cuando el usuario agrega o elimina favoritos.

**Ventajas:**
- Persistencia simple y eficiente sin necesidad de bases de datos complejas.
- Sincronización automática del estado de favoritos entre la UI y el almacenamiento local.
- Fácil de testear y mantener gracias a la abstracción mediante protocolos y mocks.

---

## 8. Ordenamiento y normalización

**Normalización de cadenas para búsqueda:**
- Se implementó una extensión de `String` con la función `normalizedForSearch()`, que transforma los textos de la siguiente manera:
  - Elimina signos de puntuación y diacríticos (acentos y caracteres especiales).
  - Convierte todos los caracteres a minúsculas.
- Esto asegura que las búsquedas sean insensibles a mayúsculas/minúsculas, acentos y puntuación, mejorando la precisión y experiencia del usuario.

**Criterio de ordenamiento:**
- Las ciudades se ordenan alfabéticamente primero por nombre de ciudad y luego por código de país.
- Este ordenamiento se aplica tanto al mostrar la lista principal como al realizar búsquedas, garantizando resultados consistentes y fáciles de navegar.

**Ventajas:**
- Permite búsquedas más flexibles y tolerantes a errores de tipeo o diferencias de formato.
- Mejora la usabilidad al presentar los resultados de manera predecible y ordenada.

---

## 9. Mapa y pantalla de información

**Mapa interactivo:**
- El mapa se integra en la interfaz principal y responde dinámicamente a la selección de ciudades.
- En modo landscape, el mapa se actualiza en tiempo real mostrando la ubicación de la ciudad seleccionada sin necesidad de navegación adicional.
- Se utiliza un marcador (“mark”) que indica el nombre de la ciudad seleccionada, proporcionando información contextual directamente en el mapa.
- El usuario puede visualizar rápidamente la ubicación y el nombre de cualquier ciudad seleccionada desde la lista.

**Pantalla de información detallada:**
- Al pulsar el botón de información en una ciudad, se navega a una pantalla de detalles.
- Esta pantalla muestra información relevante sobre la ciudad, obtenida en tiempo real mediante la API de WikiGeoSearch.
- Se presenta un extracto descriptivo del lugar, enriqueciendo la experiencia del usuario con datos históricos, culturales o geográficos.
- El diseño prioriza la claridad y la legibilidad, mostrando la información de manera concisa y accesible.

**Ventajas:**
- Experiencia de usuario fluida y enriquecida, con acceso inmediato tanto a la ubicación geográfica como a información relevante de cada ciudad.
- Integración eficiente de datos externos (Wikipedia) para ofrecer contexto adicional sin salir de la app.
- Adaptabilidad de la interfaz según la orientación del dispositivo, optimizando la visualización y la interacción.

---

## 10. Errores, estados y accesibilidad

**Manejo de errores de red:**
- Si ocurre un error al obtener la información (por ejemplo, sin conexión, error de servidor, datos corruptos), se muestra una pantalla dedicada de error.
- Esta pantalla informa al usuario del problema y ofrece un botón para reintentar la operación.
- Los mensajes de error son claros y están localizados para facilitar la comprensión.

**Estados de la UI:**
- **Cargando:** Se muestra un indicador de progreso mientras se obtienen los datos.
- **Éxito:** Se presenta la lista de ciudades o la información solicitada.
- **Vacío:** Si la búsqueda no arroja resultados, se muestra una pantalla específica informando al usuario que no hay coincidencias.
- **Error:** Ante cualquier fallo, se muestra una vista de error con opción de reintento.

**Ventajas:**
- El usuario siempre recibe feedback claro sobre el estado de la app.
- La accesibilidad está integrada desde el diseño, permitiendo que la app sea usable por la mayor cantidad de personas posible.
- El manejo explícito de estados y errores facilita el testing y la mantenibilidad del código.

---

## 11. Configuración y ejecución
**Requisitos:**
- Xcode 14.0 o superior
- Swift 5.0 o superior
- iOS Deployment Target 15.0 o superior
- Compatible con Mac con Apple Silicon o Intel

---

## 12. Estructura del proyecto

---

## 13. Testing
**UnitTes:**
- Busqueda por prefijo
- Conexcion a red
- Carga y guardado de elementos
- Toggle de un elemento
- Orientacion dl dispositivo

**UITest:**
- Si la celda posee todos sus elementos
- Navegacion al mapa y vista de detalles
- Elementos filtrados por favoritos
- Actualizacion diamica en las busqueda
- Si el dispositivo esta en modo portrait o landscape
- Adicion de un nuevo elemento a la lista de favoritos

---

## 14. Mejoras futuras

**Propuestas:**
- Mejorar la accesibilidad: soporte completo para VoiceOver, tamaños de fuente dinámicos y refinamiento de identificadores para tests automatizados.
- Añadir nuevos filtros: permitir filtrado por país/código de país u otros criterios relevantes.
- Enriquecer la UI de la vista de detalles: mostrar información adicional, imágenes y enlaces relevantes sobre la ciudad.
- Implementar modo offline: uso de la app y la consulta de favoritos.
- Ampliar y robustecer la cobertura de tests unitarios y de UI: agregar más casos de prueba, pruebas de integración y validaciones de accesibilidad.

---
