.DEFAULT_GOAL := help

install: ## Instala las dependencias (incluida la versión fija de Prettier)
	npm ci

format: ## Formatea todo el repo con Prettier
	npm run format

format-check: ## Comprueba el formato sin modificar nada (lo mismo que hace el CI)
	npm run format:check

up: ## Levanta los contenedores (Postgres, API...)
	docker compose up -d

down: ## Para y elimina los contenedores
	docker compose down

logs: ## Sigue los logs de los contenedores
	docker compose logs -f

dev: ## Arranca el backend en modo desarrollo
	npm run dev

db-migrate: ## Aplica las migraciones de Prisma
	npx prisma migrate dev

db-studio: ## Abre Prisma Studio
	npx prisma studio
