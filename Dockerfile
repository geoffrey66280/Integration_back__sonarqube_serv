# Utiliser une image Maven pour construire l'application
FROM maven:latest as builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier pom.xml dans le conteneur
COPY pom.xml .

# Installer les dépendances du projet
RUN mvn dependency:go-offline -B

# Copier le reste des fichiers du projet dans le conteneur
COPY src ./src

# Construire l'application Spring Boot
RUN mvn package -DskipTests

# Utiliser une image Java comme base pour exécuter l'application
FROM openjdk:latest

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier JAR de l'application Spring Boot depuis le premier étage
COPY --from=builder /app/target/spring-boot-jpa-h2-0.0.1-SNAPSHOT.jar ./app.jar

# Exposer le port sur lequel votre application Spring Boot écoute (par défaut : 8080)
EXPOSE 8081

# Commande pour démarrer votre application Spring Boot lorsque le conteneur démarre
CMD ["java", "-jar", "app.jar"]
