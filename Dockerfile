# Estágio 1: Construção
FROM node:18.17 AS builder

# Definir diretório de trabalho
WORKDIR /app

# Copiar package.json e package-lock.json para o diretório de trabalho
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar todo o código fonte para o diretório de trabalho
COPY . .

# Construir o projeto
RUN npm run build

# Estágio 2: Produção
FROM node:18.17-alpine AS runner

# Definir diretório de trabalho
WORKDIR /app

# Copiar os arquivos necessários do estágio de construção para o estágio de produção
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Instalar apenas as dependências de produção
RUN npm install --only=production

# Expor a porta em que o Next.js será executado
EXPOSE 3000

# Comando para iniciar o aplicativo
CMD ["npm", "start"]
