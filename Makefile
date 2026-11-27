.PHONY: install format format-check up down logs dev db-migrate db-studio

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

dev: ## Arranca el servidor en modo desarrollo
	npm --prefix server run dev

db-migrate: ## Aplica las migraciones de Prisma
	npm --prefix server run db:migrate

db-studio: ## Abre Prisma Studio
	npm --prefix server run db:studio
