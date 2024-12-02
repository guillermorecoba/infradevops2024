# 1. Presentación del problema

Una empresa líder en retail se encuentra en la transición digital, los desafíos que se le presentaron evidenciaron la brecha cultural entre los equipos de desarrollo y operaciones. Durante el lanzamiento de una aplicación innovadora destinada a revolucionar la experiencia de compra de los usuarios, los despliegues frecuentes generaron errores y caídas, afectando la experiencia del usuario. Esto reflejó una desconexión en la comunicación y en la responsabilidad compartida, donde desarrollo priorizaba la velocidad mientras operaciones se centraba en la estabilidad. Reconociendo que el problema no era técnico sino organizativo, se identificó la necesidad de fomentar una cultura colaborativa. Este cambio busca alinear objetivos y mejorar procesos, sentando las bases para una operación ágil y resiliente. Por lo tanto, se le solicita al equipo de proyecto un plan de acción detallado que no solo aborde las ineficiencias operativas evidentes sino que también fomente un ambiente de colaboración, transparencia y aprendizaje continuo. Se espera que mediante la solución planteada la empresa no sólo supere los obstáculos actuales sino que también sentará las bases para una agilidad y resiliencia operativa a largo plazo, asegurando así su posición competitiva en el mercado.

# 2. Solución planteada

Mediante la implementación de un modelo DevOps, buscamos aprovechar al máximo los beneficios que nos provee esta metodología para así solucionar o disminuir considerablemente los problemas de comunicación entre los equipos, además de reducir los costos gracias a que al usar los servicios de Cloud solo se nos computa los gastos de lo que utilizamos, tener a disposición una infraestructura escalable y flexible para estar prevenidos ante cualquier acontecimiento, disminuir el time-to-market, etc. Todo esto es además configurado como Infraestructura como código (IaC) para normalizar el tiempo en que lleven los procesos quitando el factor del error humano y así facilitando los procesos de CI/CD.

# 3. Herramientas utilizadas

- **Azure DevOps** - Tablero Kanban
- **Terraform** - Manejo de la IaC
- **GitHub** - Manejo de Git/Versionado de código
- **GitHub Actions** - Manejo del CI/CD
- **DockerHub** - Almacenamiento y distribución de imágenes Docker
- **Amazon Web Services** - Plataforma de servicios Cloud
- **Amazon Elastic Container Service** - Orquestador de contenedores
- **SonarQube** - Análisis de código estático
- **Lambda** - Servicio serverless (por decidir/puede cambiar)

## 3.1 Azure DevOps

Utilizamos el tablero de Kanban de Azure DevOps para organizarnos de una manera estructurada. Con 3 columnas en donde íbamos agrupando las tareas en "To Do", "In progress" y "Completed". Los tableros Kanban no tienen mucha complicación, ya que son fáciles de entender a simple vista. La elección de utilizar Azure DevOps fue simplemente por practicidad, ya que teníamos las cuentas creadas y habíamos tenido un acercamiento en el práctico de Scrum.

![Tablero de Kanban](./imagenes/kanban.png)

## 3.2 Terraform

Elegimos Terraform como herramienta de despliegue de Infraestructura como Código (IaC) debido a su flexibilidad y compatibilidad con múltiples proveedores de nube. Terraform nos permite describir la infraestructura deseada en archivos de configuración que son fáciles de leer, versionar y mantener, asegurando consistencia y replicabilidad en los entornos de desarrollo, pruebas y producción.

Tiene la capacidad de gestionar el ciclo de vida completo de los recursos, desde la creación hasta la eliminación, facilita la automatización y minimiza errores humanos. Además, su soporte para múltiples proveedores, como AWS, Azure y Google Cloud, y que haya sido la única herramienta de IaC con una guía en los prácticos, facilitaron nuestra decisión.

## 3.3 GitHub

GitHub fue nuestra elección para compartir y versionar el código. La elección se basó en experiencia previa de ambos en la utilización de dicha herramienta, además de la compatibilidad con infinidad de herramientas del mundo de DevOps. Además, nos permite la utilización directa de GitHub Actions para la implementación del CI/CD.

## 3.4 GitHub Actions

Como mencionamos en el punto anterior, elegimos GitHub Actions como nuestra herramienta de CI/CD por su integración nativa con GitHub, lo que facilita la automatización de flujos de trabajo directamente en los repositorios de código. Al estar diseñado específicamente para GitHub, no requiere configuraciones adicionales para conectar el código fuente con las pipelines, simplificando y agilizando el proceso de despliegue. Su modelo de precios basado en uso (minutos de ejecución) y la disponibilidad de minutos gratuitos en planes iniciales lo convierten en una solución eficiente y económica, especialmente adecuada para proyectos pequeños y medianos.

## 3.5 DockerHub

Utilizamos DockerHub para publicar las imágenes de Docker. Si bien posiblemente Amazon Elastic Container Registry (ECR) hubiese sido una opción válida para simplificar un poco más el trabajo, decidimos utilizar DockerHub por un tema de costos y practicidad. Si bien la versión gratuita de DockerHub tiene sus limitaciones, nos era más que necesario para realizar la tarea asignada.

## 3.6 Amazon Web Services

Elegimos AWS como plataforma de la nube, en parte porque se nos brindaron cuentas con saldo para la realización de las tareas, pero además debido a su robustez, escalabilidad y amplia gama de servicios, que ofrecen soluciones completas para cumplir con las necesidades de nuestro proyecto. Al ser una empresa líder en el mercado de la nube, posee una infraestructura global confiable que asegura alta disponibilidad y prácticamente un nulo tiempo de inactividad, elementos clave para garantizar la continuidad de nuestras operaciones.

## 3.7 Amazon Elastic Container Service

*(Detalles a agregar más adelante)*

## 3.8 SonarQube

Elegimos SonarQube como herramienta de análisis de código estático para realizar los análisis tanto de las 4 aplicaciones Backend como de la aplicación Frontend de React. En el CI/CD dejamos automatizado el realizar un análisis cada vez que detecta un cambio. En caso de que el análisis sea exitoso, se procederá con la build.

![Analisis de SonarQube](./imagenes/sonarqube.png)
