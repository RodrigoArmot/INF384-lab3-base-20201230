# defecto 1 corregido: version fija en vez de "latest", y nombre de etapa
FROM public.ecr.aws/lambda/nodejs:20 AS build

WORKDIR /build

# defecto 2 corregido: manifiestos primero, para aprovechar la cache de capas
COPY package.json package-lock.json ./

# defecto 3 corregido: instalacion reproducible desde el lockfile
RUN npm ci

COPY . .

# defecto 4: eliminado, la credencial no debe hornearse en ninguna capa de la imagen
# defecto 5: eliminado, esbuild no necesita vim ni procps-ng en la etapa de build

### NO TOCAR DE ACA EN ADELANTE, CONSIDEREN QUE EL WORKDIR DEBE SER /build
RUN npx esbuild src/handler.js \
      --bundle --platform=node --target=node20 \
      --outfile=dist/handler.js

# Etapa final: recibe unicamente el artefacto empaquetado.
# El arbol de node_modules se queda en la etapa anterior.
FROM public.ecr.aws/lambda/nodejs:20 AS runtime
COPY --from=build /build/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["handler.handler"]
#Test Funcional
