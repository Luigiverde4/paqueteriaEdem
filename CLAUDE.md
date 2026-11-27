# CLAUDE.md

Guía para Claude Code en este repositorio. Para el contexto completo del proyecto, lee primero el [README](README.md).

## Proyecto

Aplicación para digitalizar y dar trazabilidad a la gestión de paquetería de la recepción de Marina de Empresas (EDEM): registrar recepción, ubicación, avisos al destinatario y recogida con firma, sustituyendo el Excel y el WhatsApp actuales.

**Stack:** frontend en HTML, CSS y JS nativo (sin frameworks, siguiendo la marca de Marina de Empresas) · backend en Express · Prisma · PostgreSQL · Docker.

## Cómo trabajar

- **Lee el código antes de responder.** Ante cualquier pregunta sobre el proyecto, revisa los ficheros relevantes en vez de contestar de memoria o suponer cómo está hecho. Si algo no existe todavía, dilo.
- **No inventes comandos, rutas ni scripts.** Comprueba el `Makefile`, el `package.json` y el `compose.yml` antes de recomendarlos. Algunos comandos del `Makefile` dependen de ficheros que aún no existen (se indica en el propio fichero).
- **Si hay varias opciones, da una recomendación**, no un listado de alternativas.
- **Cambios pequeños y enfocados.** No refactorices ni cambies el formato de código que no tiene relación con la tarea.

## Idioma

- **Código en inglés:** variables, funciones, clases, nombres de ficheros de código, modelos y campos de Prisma, endpoints y nombres de ramas técnicas.
- **Español:** comunicación con el equipo, README y documentación, textos visibles para el usuario, comentarios y mensajes de commit.
- Los comentarios explican **por qué** se hace algo, no qué hace la línea.

## Convenciones de código

- Variables y funciones en `camelCase` (`packageId`, `getPendingPackages`).
- Clases y modelos de Prisma en `PascalCase`; sus campos, en `camelCase`.
- Constantes globales en `UPPER_SNAKE_CASE`.
- Clases CSS en `kebab-case`.
- Nombres descriptivos y completos: `receivedAt`, no `ra`; `recipient`, no `r`.
- Booleanos con prefijo `is`, `has` o `can` (`isDelivered`, `hasSignature`).
- Funciones pequeñas con una sola responsabilidad; evita el código duplicado y los números o textos "mágicos".
- El formato lo decide Prettier, no tú: ejecuta `make format` y no discutas la configuración. No toques `.prettierrc.json` ni `.editorconfig` salvo que se pida.

## Prácticas modernas (evita lo antiguo)

Se trabaja con Node 24 y navegadores actuales, así que no hace falta nada heredado:

- JavaScript moderno: `const` y `let` (nunca `var`), `async`/`await` en lugar de callbacks o cadenas de `.then()`, `?.` y `??`, desestructuración, módulos ES (`import`/`export`, no `require`).
- Comparaciones con `===`. Nada de `==`.
- `fetch` en vez de `XMLHttpRequest`; `URL` y `URLSearchParams` en vez de concatenar cadenas.
- Node nativo antes que dependencias: `fetch` global, `--env-file` para el `.env`, `--watch` para desarrollo, `node:test` si hace falta. No añadas `dotenv` ni `nodemon`.
- Express 5: los errores de los handlers `async` ya llegan al manejador de errores, no hace falta envolverlos en `try/catch` para eso.
- CSS moderno: Grid, Flexbox, variables CSS, `clamp()`, `:has()`, nesting. Nada de floats para maquetar.
- HTML semántico (`<main>`, `<nav>`, `<button>`, `<label>`) y accesible desde el principio.

## Antes de añadir una librería, mira qué puede hacer el navegador

El frontend es nativo a propósito. Comprueba primero si la plataforma ya lo resuelve:

| Necesidad                         | Usa la plataforma                                                          |
| --------------------------------- | -------------------------------------------------------------------------- |
| Peticiones HTTP                   | `fetch`                                                                    |
| Modales                           | `<dialog>`                                                                 |
| Validación de formularios         | Atributos HTML (`required`, `pattern`, `type`) y Constraint Validation API |
| Fechas y números                  | `Intl.DateTimeFormat`, `Intl.NumberFormat`                                 |
| Plantillas de HTML                | `<template>` y `cloneNode`                                                 |
| Desplegables, tooltips y menús    | `popover` y `<details>`                                                    |
| Escanear códigos o leer la cámara | `navigator.mediaDevices`, `BarcodeDetector` (comprobar soporte)            |
| Firma manuscrita                  | `<canvas>` con Pointer Events                                              |
| Guardar datos en el cliente       | `localStorage` / `IndexedDB` (nunca datos sensibles)                       |
| Notificaciones                    | Notification API (con permiso del usuario)                                 |
| Identificadores                   | `crypto.randomUUID()`                                                      |

Si una API no tiene soporte amplio, **comprueba su compatibilidad** (MDN / caniuse) y define una alternativa antes de usarla. Si aun así una librería aporta mucho, propónla y justifica por qué la plataforma no basta, en vez de añadirla sin más.

## Backend y base de datos

- Accede a la BBDD solo con Prisma: nada de SQL construido concatenando cadenas.
- Valida y sanea siempre los datos de entrada en el servidor, aunque el frontend ya los valide.
- Cada cambio en el esquema lleva su migración (`make db-migrate`).
- Los secretos van en `.env` (ignorado por git); documenta las variables nuevas en `.env.example`.
- Las respuestas de error devuelven códigos HTTP correctos y mensajes que no filtran detalles internos.
- Pensando en la trazabilidad: toda acción relevante sobre un paquete (recepción, ubicación, aviso, recogida) debe guardar **quién, cuándo y qué**.

## Git y Pull Requests

- Nunca trabajes en `main`: crea una rama `tipo/descripcion-corta` (`feat/registro-recepcion`).
- Commits con el formato `tipo(ámbito): descripción`, usando solo estos tipos: `feat`, `fix`, `docs`, `refactor`, `style`, `chore`, `build`, `ci`, `test`. Descripción en español, en minúscula, en imperativo y sin punto final. La tabla completa y los ámbitos están en el README.
- Antes de proponer una PR, ejecuta `make format-check`.
- Las PRs usan la plantilla de `.github/PULL_REQUEST_TEMPLATE.md` y necesitan al menos una revisión de un compañero.
- **No hagas commit, push ni abras PRs sin que te lo pidan expresamente.**
- No subas secretos ni ficheros `.env`.
