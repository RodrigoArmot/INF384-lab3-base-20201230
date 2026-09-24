# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.

# defecto 1
FROM node:20.11-alpine AS build

# defecto 2
COPY package.json package-lock.json ./

# defecto 3
RUN npm ci

# defecto 4
FROM node:20.11-alpine AS runtime
ENV DB_PASSWORD= bucket
WORKDIR /app

COPY --from=build /app/dist ./dist # 5
COPY --from=build /app/node_modules ./node_modules

USER node 
# defecto 5
#RUN dnf install -y procps-ng vim && dnf clean all

CMD ["src/handler.handler"]
