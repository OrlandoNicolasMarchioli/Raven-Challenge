Raven-Challenge
Documentación del Proyecto: ChallengeRaven

Introducción
Este documento describe la arquitectura, los componentes y el flujo de datos de la aplicación ChallengeRaven, desarrollada utilizando la arquitectura MVVM (Model-View-ViewModel). La aplicación consume la API de New York Times para mostrar noticias basados en una búsqueda proporcionada por el usuario. A continuación, se detallan los puntos clave del proyecto.
Documento utilizado para el challenge: 
[Prueba-tecnica-raven-ios (1) (1).pdf](https://github.com/user-attachments/files/16163927/Prueba-tecnica-raven-ios.1.1.pdf)


Arquitectura MVVM
La arquitectura MVVM se implementa para separar las responsabilidades de la aplicación en tres componentes principales:

Model: Representa los datos y la lógica de negocio de la aplicación.
View: Define la interfaz de usuario y presenta los datos del ViewModel.
ViewModel: Actúa como un intermediario entre el Model y la View, gestionando la lógica de presentación.
Esta separación permite un código más limpio y mantenible, facilitando las pruebas y la escalabilidad.

Componentes del Proyecto
Model

SelectedArticleData: Estructura que representa un articulo seleccionado con todos sus atributos relevantes.
AllArticlesState: Estructura que representa el estado de la vista, incluyendo la lista de articulos, mensajes de error y otros indicadores de estado.
View

Implementada utilizando SwiftUI, proporcionando una interfaz de usuario declarativa y reactiva.
Ejemplos de vistas: AllArticlesView, ArticleDetailView.
ViewModel

AllArticlesViewModel: Gestiona la lógica de presentación de la vista de articulos. Se comunica con el caso de uso DefaultArticlesFetchUseCase para obtener los articulos desde la API.
Utiliza Combine para gestionar la reactividad y la asincronía en la obtención de datos.
Repository

ArticlesApiFetch: Implementa el protocolo ArticlessRepository para obtener articulos desde la API de New York Times.
ArticleApi: Clase que realiza la petición HTTP a la API de New York Times.

API de New York Times 
URL de Petición: https://api.nytimes.com/svc/mostpopular/v2/emailed/1.json?api-key=
La aplicación realiza una petición GET a esta URL, anexando el término de búsqueda proporcionado por el usuario.

Colección de Postman
Se utilizó una colección de Postman para probar y documentar las peticiones a la API de Mercado Libre. Esta colección incluye ejemplos de peticiones con diferentes términos de búsqueda y verifica las respuestas esperadas.

[Raven-Challenge.postman_collection.json](https://github.com/user-attachments/files/16164006/Raven-Challenge.postman_collection.json)


Frameworks Utilizados
SwiftUI: Framework de interfaz de usuario declarativa de Apple, utilizado para construir la UI de la aplicación.
Combine: Framework de reactividad de Apple, utilizado para gestionar la asincronía y la programación reactiva en la aplicación.
