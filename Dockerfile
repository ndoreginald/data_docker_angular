# --- STAGE 1: Build ---
FROM node:12.7-alpine AS build

# Définir le répertoire de travail
WORKDIR /usr/src/app

# Copier les fichiers nécessaires pour installer les dépendances
COPY package.json package-lock.json ./

# Installer les dépendances
RUN npm install

# Copier tout le contenu du projet dans l'image
COPY . .

# Construire le projet
RUN npm run build

# --- STAGE 2: Run ---
FROM nginx:1.17.1-alpine

# Copier le fichier de configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copier les fichiers construits à partir de l'étape de build
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html

# Exposer le port utilisé par nginx
EXPOSE 80

# Démarrer nginx
CMD ["nginx", "-g", "daemon off;"]

