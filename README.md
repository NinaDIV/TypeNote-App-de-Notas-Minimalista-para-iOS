# TypeNote-App-de-Notas-Minimalista-para-iOS

✨ **TypeNote: Sistema de Gestión de Notas Minimalista para iOS con Sincronización en la Nube** ✨

TypeNote es una aplicación móvil nativa desarrollada en Swift y SwiftUI, diseñada para ofrecer una experiencia de notas personal, moderna y elegante. Inspirada en herramientas de productividad, se enfoca en la velocidad, la simplicidad y la seguridad de la información mediante la integración con AWS Amplify.

## 🚀 Tecnologías Clave

| Categoría | Tecnología/Framework | Versión |
| :--- | :--- | :--- |
| **Lenguaje** | Swift | 5.9 |
| **UI Framework** | SwiftUI | 4.0+ |
| **Arquitectura** | MVVM (Model-View-ViewModel) | N/A |
| **Backend** | AWS Amplify (BaaS) | Latest |
| **Dependencias** | Swift Package Manager (SPM) | N/A |

## ☁️ Integración con AWS Amplify

La aplicación utiliza AWS Amplify para establecer una infraestructura *serverless* robusta y escalable.

- **AWS Cognito:** Gestión de la autenticación de usuarios (Registro, Login, Sesiones).
- **AWS DynamoDB:** Base de datos NoSQL para el almacenamiento persistente de las notas.
- **AWS API Gateway & Lambda:** Proporcionan la capa de la API REST para las operaciones CRUD de las notas.

## 🔑 Características Principales

1.  **Autenticación Segura:** Flujo completo de Login y Registro basado en AWS Cognito.
2.  **Gestión Completa de Notas (CRUD):**
    * **C**rear nuevas notas de forma intuitiva.
    * **R**ecuperar y listar todas las notas de forma eficiente.
    * **U**pdate (Editar) el contenido, categoría y color de las notas existentes.
    * **D**elete (Eliminar) notas de forma permanente.
3.  **Organización Visual:** Categorización de notas con la asignación de colores para una identificación rápida.
4.  **Diseño Minimalista:** Interfaz de usuario elegante y centrada en la escritura, siguiendo los principios de diseño de iOS.
5.  **Persistencia en la Nube:** Sincronización automática de las notas para mantener la información actualizada en todos los dispositivos.

## 📐 Estructura del Proyecto (MVVM)

El proyecto sigue el patrón **MVVM** para una mejor modularidad:

-   `NotesApp/Model/`: Contiene las estructuras de datos (`Note`, `Category`).
-   `NotesApp/View/`: Contiene las vistas declarativas de SwiftUI (`AuthView`, `MainView`, `NoteDetailView`, etc.).
-   `NotesApp/ViewModel/`: Contiene la lógica de negocio, la gestión del estado y la comunicación con AWS (e.g., `AuthViewModel`, `NotesViewModel`).

## 🛠️ Cómo Configurar y Ejecutar

Para clonar y ejecutar la aplicación localmente, necesitarás tener instalado Xcode y el CLI de AWS Amplify.

### Prerrequisitos

* Xcode 15.0+
* Swift 5.9+
* Node.js y npm (para el CLI de Amplify)
* AWS CLI configurado en tu máquina.

### Pasos para la Configuración

1.  **Clonar el Repositorio:**
    ```bash
    git clone [https://github.com/NinaDIV/TypeNote-App-de-Notas-Minimalista-para-iOS.git](https://github.com/NinaDIV/TypeNote-App-de-Notas-Minimalista-para-iOS.git)
    cd TypeNote-App-de-Notas-Minimalista-para-iOS
    ```

2.  **Instalar y Configurar Amplify:**
    > **Nota:** Se asume que el backend ya está aprovisionado. Si no lo está, debes usar `amplify init` y seguir las instrucciones.

    Asegúrate de tener el archivo de configuración de Amplify en la raíz del proyecto:
    ```bash
    # Verifica que el archivo de configuración esté presente
    ls amplifyconfiguration.json
    ```

3.  **Abrir en Xcode:**
    ```bash
    open NotesApp.xcodeproj
    ```
    Xcode automáticamente resolverá las dependencias del **Swift Package Manager**.

4.  **Compilar y Ejecutar:**
    * Selecciona un simulador de iOS (e.g., iPhone 15 Pro).
    * Haz clic en el botón de "Run" (▶) o usa `Cmd + R` para compilar y ejecutar la aplicación.

## 📷 Galería y Demostración

El contenido visual del proyecto (capturas de pantalla y un video de demostración) se encuentra en la carpeta `Galeri01/`.

### 1. Pantalla de Inicio / Login (AWS Cognito)
Muestra la interfaz de autenticación para un acceso seguro.

![Captura de la pantalla de Login y Registro de TypeNote](Galeri01/Pantalla%20de%20Inicio.png)

### 2. Formulario de Creación de Nota
Vista que permite registrar una nueva nota, incluyendo la selección de categoría y color.

![Captura del formulario de creación de una nueva nota](Galeri01/Formulario%20de%20Creación.png)

### 3. Listado Principal de Notas
Muestra la `MainView` con el listado de notas optimizado, destacando la organización visual por color.
![Captura del listado de notas con tarjetas categorizadas](Galeri01/Listado%20de%20notas.png)

### 4. Vista de Detalle y Edición
Interfaz para visualizar el contenido completo y modificar la nota existente.
![Captura de la vista para ver y editar una nota](Galeri01/Vista%20de%20detalle.edición%20de%20nota.png)

### 5. Video de Funcionamiento (Demostración Completa)
El video demuestra el flujo completo de la aplicación: autenticación, CRUD de notas y la sincronización en la nube.

**[▶ Ver Video Completo de Funcionamiento (MP4)](Galeri01/FUNCIONAMIENTO.mp4)**

## 🧩 Contribuciones

- **Backend completo (AWS Amplify)** — Implementado por **Alarcón Paricanaza Anderson Aaron**  
  Incluye:
  - Configuración de AWS Amplify (Inicialización del proyecto)
  - Implementación de **AWS Cognito** para autenticación
  - Implementación de **AWS DynamoDB** como base de datos NoSQL
  - Creación de **Lambdas** y configuración de **API Gateway** para el CRUD
  - Integración total del backend con la app iOS

