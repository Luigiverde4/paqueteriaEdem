# Digitalización y trazabilidad de la gestión de paquetería

**EDEM · Marina de Empresas**

## Contexto

La recepción de Marina de Empresas es el punto central de entrada de paquetes para todo el ecosistema EDEM. Los destinatarios son:

- Personal interno
- Alumnos
- Emprendedores (generan el mayor volumen: mercancía, muestras, material promocional, equipamiento tecnológico y documentación)

La gestión actual es mayoritariamente manual, lo que supone carga operativa, riesgo de errores y trazabilidad incompleta.

## Situación actual

**Recepción del paquete**

1. Recepción recibe el paquete del repartidor.
2. Se pega una etiqueta física manual con un código.
3. Registro manual en Excel.
4. Almacenaje en estantería o almacén.
5. Aviso al destinatario por WhatsApp u otros canales.

**Recogida del paquete**

1. Búsqueda del paquete en el Excel.
2. Localización en el almacén.
3. Firma digital del destinatario en pantalla.
4. Registro manual posterior de la firma y la recogida en el Excel.

## Problemas identificados

| #   | Problema                  | Descripción                                                                                                |
| --- | ------------------------- | ---------------------------------------------------------------------------------------------------------- |
| 1   | Procesos manuales         | Introducción manual que consume tiempo y genera errores.                                                   |
| 2   | Sin trazabilidad completa | No hay un sistema único que registre todo el ciclo del envío.                                              |
| 3   | Etiquetas ineficientes    | Duplicidades, errores de identificación y dificultad para localizar.                                       |
| 4   | Riesgo de extravío        | Difícil saber dónde está, quién es responsable y si fue entregado.                                         |
| 5   | Comunicación manual       | Hay que buscar los datos de contacto y avisar uno a uno.                                                   |
| 6   | Información dispersa      | Datos repartidos en varios canales (Excel, etiquetas, WhatsApp, firmas), difíciles de consultar y auditar. |

## Objetivo

Sustituir el flujo manual por una aplicación única que registre automáticamente todo el ciclo de vida del paquete. Hoy **no queda registrado**:

- Fecha y hora de recepción
- Persona que recibió el paquete
- Ubicación física en el almacén
- Notificaciones realizadas
- Fecha y hora de recogida
- Evidencia de la recogida (firma)

Cada uno de estos puntos debe quedar guardado de forma automática y consultable en un único sistema.

## Stack tecnológico

| Capa            | Tecnología                                                       |
| --------------- | ---------------------------------------------------------------- |
| Frontend        | HTML, CSS y JS nativo (siguiendo la marca de Marina de Empresas) |
| Backend         | Express                                                          |
| ORM             | Prisma                                                           |
| Base de datos   | PostgreSQL                                                       |
| Infraestructura | Docker                                                           |

## Puesta en marcha

Requisitos: Node 24+, Docker y `make`.

```bash
git clone https://github.com/Luigiverde4/paqueteriaEdem.git
cd paqueteriaEdem
make install   # instala las dependencias (incluida la versión fija de Prettier)
```

<!-- TODO: completar cuando exista el código (variables de entorno, `make up`, migraciones de Prisma, puertos) -->

### Comandos (`make`)

| Comando             | Qué hace                                          |
| ------------------- | ------------------------------------------------- |
| `make install`      | Instala las dependencias                          |
| `make format`       | Formatea todo el repo con Prettier                |
| `make format-check` | Comprueba el formato sin modificar (igual que CI) |
| `make up` / `down`  | Levanta / para los contenedores                   |
| `make logs`         | Sigue los logs de los contenedores                |
| `make dev`          | Arranca el backend en modo desarrollo             |
| `make db-migrate`   | Aplica las migraciones de Prisma                  |
| `make db-studio`    | Abre Prisma Studio                                |

> Aún no funcionan: `up`, `down` y `logs` necesitan el `compose.yml`, y `dev`, `db-migrate` y `db-studio` ejecutan los scripts `dev`, `db:migrate` y `db:studio` de `server/package.json`, que todavía no existe. Cuando se cree, hay que añadir `npm ci --prefix server` a `make install`.

Si en Windows no tienes `make`, instálalo con `winget install ezwinports.make`. Los comandos del `Makefile` no usan herramientas de Unix (`grep`, `awk`...), así que funcionan también en PowerShell y `cmd`. Al añadir comandos nuevos, mantén esa regla.

## Formato del código (Prettier)

Para no pisarnos unos a otros con configuraciones distintas, **la configuración vive en el repo** y es la misma para todos:

| Fichero                              | Para qué sirve                                               |
| ------------------------------------ | ------------------------------------------------------------ |
| `.prettierrc.json`                   | Reglas de Prettier (comillas simples, `;`, `arrowParens`...) |
| `.prettierignore`                    | Qué no se formatea (`node_modules`, migraciones, lockfile)   |
| `.editorconfig`                      | Indentación, saltos de línea y codificación en cualquier IDE |
| `.gitattributes`                     | Fuerza saltos de línea `LF` aunque trabajes en Windows       |
| `.vscode/settings.json`              | Formatear al guardar con Prettier en VS Code                 |
| `package.json` + `package-lock.json` | Fijan la versión exacta de Prettier para todo el equipo      |

Reglas:

- Instala las extensiones recomendadas de VS Code cuando te lo proponga (Prettier y EditorConfig).
- Usa **la versión del repo** (`make format`), no un Prettier global ni otra configuración tuya.
- Antes de abrir una PR, ejecuta `make format-check`. El CI hace lo mismo y bloquea la PR si falla.
- No cambies `.prettierrc.json` ni `.editorconfig` dentro de una PR de funcionalidad: si queréis cambiar una regla, PR aparte y avisando al equipo.
- Si formateas ficheros que no has tocado, mételo en un commit aparte (`style: ...`) para que el diff de la PR siga siendo legible.

## Estructura del proyecto

```text
paqueteriaEdem/
├── client/              # Frontend: HTML, CSS y JS nativo (lo sirve Express)
│   ├── assets/
│   ├── css/
│   ├── js/
│   └── index.html
├── server/              # Backend: API con Express y Prisma
│   ├── prisma/
│   ├── src/
│   │   ├── controllers/
│   │   ├── middlewares/
│   │   └── routes/
│   └── tests/
├── docs/                # Enunciado y documentación
├── Makefile
└── .env.example
```

## Metodología de trabajo

**Al empezar a trabajar:**

```bash
git pull
```

**Flujo de ramas**

- Trabajar siempre en ramas propias, nunca directamente sobre `main`.
- **Excepción temporal:** mientras montamos la infraestructura base (estructura de carpetas, Docker, esqueleto del servidor) se trabaja directamente en `main`. Al terminar esa fase, todo pasa por PR.
- Nombre de rama: `tipo/descripcion-corta`, por ejemplo `feat/registro-recepcion` o `fix/etiqueta-duplicada`.
- Mergear a `main` mediante Pull Request.
- Cada PR se pide a revisión a un compañero como mínimo y se espera su aprobación antes de mergear. Nadie aprueba su propia PR (GitHub no lo permite).
- Las conversaciones abiertas de la revisión se resuelven antes de mergear.
- Se mergea con **Create a merge commit**: en `main` queda un commit de merge con el título de la PR y, dentro, los commits de la rama. Por eso **tanto el título de la PR como cada commit de la rama deben seguir el formato de commits**. Antes de abrir la PR, limpia los commits tipo `wip` o `arreglos` (por ejemplo, con `git rebase -i`).
- _Squash and merge_ queda disponible para las ramas cuyos commits no merezca la pena conservar.
- Abre la PR como _Draft_ mientras trabajas y pásala a _Ready for review_ cuando esté lista.
- Borra la rama después de mergear.

**Pull Requests**

Al crear una PR se rellena automáticamente la plantilla de [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md): qué cambia, por qué, cómo probarlo y un checklist. No la borres: rellénala, que es lo que permite a tu compañero revisar sin tener que preguntarte. Mantén las PRs pequeñas (una idea por PR) para que se puedan revisar de verdad.

**Regla de equipo sobre las revisiones**

El ruleset de `main` permite a los tres miembros del equipo saltarse la aprobación obligatoria (_bypass_) para que nadie se quede bloqueado. Es un **acuerdo entre nosotros, no una forma habitual de trabajar**:

- Pide siempre la revisión y espera a tu compañero. El bypass sirve para desbloquear, no para evitar revisiones.
- Úsalo solo si nadie puede revisar a tiempo y el cambio es pequeño o urgente (una errata, documentación, un ajuste de formato).
- Los cambios grandes, o que toquen el esquema de la BBDD, la autenticación o los secretos, se revisan siempre.
- El bypass también se salta el check `Formato (Prettier)`: no mergees hasta que esté en verde.
- Si lo usas, deja un comentario en la PR explicando por qué.

**Commits**

Se usa el formato `tipo(ámbito): descripción`.

| Tipo       | Cuándo se usa                                        | Ejemplo                                                |
| ---------- | ---------------------------------------------------- | ------------------------------------------------------ |
| `feat`     | Nueva funcionalidad                                  | `feat(recepcion): registrar fecha y hora de recepción` |
| `fix`      | Corrección de un error                               | `fix(etiquetas): evitar códigos duplicados`            |
| `docs`     | Solo documentación                                   | `docs(readme): añadir guía de commits`                 |
| `refactor` | Cambia el código sin cambiar el comportamiento       | `refactor(api): extraer validación a un middleware`    |
| `style`    | Formato, espacios, comas (sin cambios de lógica)     | `style: aplicar prettier a todo el repo`               |
| `chore`    | Tareas de mantenimiento, dependencias, configuración | `chore(deps): fijar versión de prettier`               |
| `build`    | Docker, Makefile, scripts de arranque                | `build(docker): añadir healthcheck a postgres`         |
| `ci`       | GitHub Actions                                       | `ci: comprobar formato en las PRs`                     |
| `test`     | Añadir o corregir tests                              | `test(api): cubrir la recogida con firma`              |

Ámbitos habituales: `front`, `api`, `db`, `docker`, `auth`, `recepcion`, `recogida`, `etiquetas`, `notificaciones`. El ámbito es opcional, pero si lo usas, que sea uno de estos (o añádelo aquí).

Reglas:

- Solo se usan los tipos de la tabla (nada de `feature`, `fixes`, `refactoring`...). Así el historial se puede leer y filtrar.
- Descripción en español, en minúscula, en imperativo (`añadir`, `corregir`) y sin punto final.
- Máximo ~72 caracteres en la primera línea. Si hace falta explicar el porqué, se deja una línea en blanco y se añade un cuerpo.
- Un commit = un cambio con sentido. No mezcles formato y lógica en el mismo commit.

Ejemplo con cuerpo:

```text
fix(recogida): guardar la firma antes de marcar el paquete como entregado

Si la firma fallaba, el paquete quedaba como entregado sin evidencia.
Ahora se guarda en una transacción.
```

**Configuración del repo en GitHub** (solo la hace quien administre el repo)

En _Settings → Rules → Rulesets_ (o _Branches → Branch protection rules_) sobre `main`:

- Require a pull request before merging
- Required approvals: **1**
- Dismiss stale pull request approvals when new commits are pushed
- Require conversation resolution before merging
- Require status checks to pass: `Formato (Prettier)`
- Block force pushes y restringir el borrado de la rama
- Allowed merge methods: **Merge** y **Squash**
- Bypass list: el rol **Write**.
  - **Ahora**, en modo _Always_, porque durante la fase de infraestructura base trabajamos directamente en `main`.
  - **Al terminar esa fase**, en modo _For pull requests only_. Así cualquiera del equipo puede desbloquear una PR (ver la regla de equipo de arriba), pero nadie puede hacer push directo a `main`, forzarlo ni borrarlo.

En _Settings → General → Pull Requests_:

- Permitir **merge commits**, con _Default commit message_ en **Pull request title**.
- Permitir **squash merging**.
- Desactivar **rebase merging**.
- Activar _Automatically delete head branches_.

## Organización del proyecto

- **Grupos:** 3 grupos de 3 personas.
- **Defensa:** 10 minutos (5-7 min de presentación y 3-5 min de feedback y preguntas).
- **UPC (única persona de contacto):** se encarga de comunicarse con el tutor y con coordinación, y de subir el material a Campus.

### Equipo (Grupo 2)

- Raúl
- Ricardo
- Nacho

### Calendario

| Fecha  | Hito             | Notas             |
| ------ | ---------------- | ----------------- |
| 1 dic  | Punto de control |                   |
| 11 dic | Punto de control | Online            |
| 14 dic | Defensa          | 15:00 h a 15:30 h |
