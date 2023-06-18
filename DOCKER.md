# Pizza App on Docker

## Docker for Development

This short guide will take you from nothing to having a fully-working environment of the Pizza App for development purposes. It will describe the setup process as well as the available scripts that can be used to assist you when developing.

All you need to use this development setup is a recent Docker installation that is properly configured for your OS. At the time of writing, it was extensively tested against `Docker 20.10.17` and `docker-compose 2.10.2` on MacOS m1 machine. If you are encountering issues, please make sure your versions are recent enough before asking for help.

## Getting Started

### Clone the Project Repository

We will assume that Git is already installed and configured, simply clone [pizza-app](https://github.com/im-oswald/pizza-app) to a local directory.

This is your new home! Everything that you usually invoke from the root of your Rails application you will do here through scripts instead from now on.

### Scripts

Before getting started, a quick note on scripts: All of the provided scripts are Shell scripts (.sh) so you will need to be able to execute them on your local machine to proceed. 

If you are on Windows (where execution of Shell scripts is typically a problem), you should already have a complete working WSL2 setup as a prerequisite to running Docker. Simply prefix all commands below with `wsl` like this:

```
wsl scripts/my-script.sh
```

This will execute the command in the context of your Linux subsystem.

If you are on Linux / macOS and are having permission issues when trying to execute a script, you might need to manually grant execute permissions to the scripts:

```shell
sudo chmod +x scripts/*.sh
```

#### Docker Setup Script

You can prepare *absolutely* everything in a single command with the following script:

```shell
scripts/setup.sh
```

*Warning:* This script will take a long time to finish and will include multiple file downloads. When it is fully done executing however, you will have a functional application running on [localhost:3000](http://localhost:3000) along with all its dependencies!

Here is a non-exhaustive list of what the script will do for you:

* Copy `.env.example` to `.env`
* Build our custom application Docker image: `pizza-app` according to `Dockerfile`
* Assemble the following containers:
  * `db` (Docker Port: 5432, Host Port: 5433)
  * `web` (Docker Port: 3000, Host Port: 3000)
* Start all containers

You will see *a lot* streaming output from all the containers. Long-running operations are to be expected the first time you start containers, including but not limited to: Docker image downloads, Linux package downloads, gem downloads / compiles, database creation / migrations / seeding.

You will know when it is completely done when you see `web` mention that the Puma server is booting. The application will then be accessible at the usual [localhost:3000](http://localhost:3000). Feel free to close the terminal tab / window; The Docker services will keep running in the background.

**Recommended:** After a successful setup, install the Git hooks for the project using `scripts/install-git-hooks.sh`.

#### Docker Clean Script

Although rare, it will happen that the `Dockerfile` or `docker-compose.yml` files are changed in a way that requires a rebuild of some images and containers. If you are asked to do that, a script is provided to perform this process correctly:

```shell
scripts/clean.sh
```

*Warning:* This is a destructive process. You will need to provide confirmation you really want to do this to proceed!

The script will completely wipe clean the following items:

* All containers that were assembled during setup
* All volumes that are defined and used in `docker-compose.yml`
* The `web` Docker image

Other images are preserved to prevent you from having to download them again.

It sounds scary, but all you have to do to get going again is run the setup script! If you feel something is off with your Docker setup, it's always a good idea to clean+setup before asking for help.

#### Utility Scripts

A small collection of extra scripts is provided for the most common operations you will want to perform.

##### Stopping the Docker Services

```shell
scripts/stop.sh
```

##### Starting the Docker Services (in detached mode)

```shell
scripts/start.sh
```

This script will start the containers in detached mode, meaning that the logs of the containers will not be outputed to your shell. Once the containers are started you get access back to your shell while the containers run in the background.

Note: [localhost:3000](http://localhost:3000) will NOT be available immediately after `web` is marked as started. There is a bootstrap process involved before launching the server (i.e. check if database exists, check if migrations are needed, check if all gems are installed and up-to-date).

##### Bringing Up the Docker Services (starting in attached mode)
```shell
scripts/up.sh
```

The `up` command will build, (re)create, start, and attach to containers for services. Running this script will output the combined logs of all containers until you kill them using `Ctrl+c`.

##### Rails Generate

```shell
scripts/rails-generate.sh [Rails generate arguments...]
```

This script can be used as a typical rails generator to create models, controllers, migrations etc.

*Example:* `scripts/rails-generate.sh model Article title description` 

##### Creating Databases

```shell
scripts/db-create.sh
```

This script will create the `gsquad_development` & `gsquad_test` databases.

##### Dropping Databases

```shell
scripts/db-drop.sh
```

This script will drop the `gsquad_development` & `gsquad_test` databases.

##### Running Migrations

```shell
scripts/db-migrate.sh
```

This script will run all pending migrations in the development environment.

*Typical Use Case:* Rolling back last two migrations to make changes. Example: `scripts/db-rollback.sh STEP=2`

##### Resetting Databases

```shell
scripts/db-reset.sh
```

This script will first drop and recreate the development and test databases. It will then run the migrations and insert the seed data in the development database.

#### Synchronizing Environment Variables

```shell
scripts/env-sync.sh
```

This script will reassemble the `web` container to have the latest environment variables from `.env`.

*Typical Use Case:* When the content of `.env` changes.

Note: Just like when starting the Docker services, [localhost:3000](http://localhost:3000) will not be available immediately because of the application bootstrap process.


##### Running the Rails Console

```shell
scripts/console.sh
```

##### Enumerating the Rails Routes

```shell
scripts/routes.sh [optional pattern-matching string...]
```
Note: Passing an argument to this script will filter out the routes that don't match on prefix, verb, URI or controller.

##### Running the Test Suite

```shell
scripts/tests.sh [optional RSpec arguments...]
```

This script will ensure the test database is on the correct schema version, perform migrations if needed and will then run RSpec with the provided arguments, if any.

##### Installing Git Hooks 

```shell
scripts/install-git-hooks.sh
```

This will notably install a pre-commit hook to run the auto-formatting with Prettier on changed files.

##### Running Rubocop Linter

Run rubocop

```shell
scripts/rubocop.sh
```

Run rubocop with autocorrect enabled

```shell
scripts/rubocop-autocorrect.sh
```

Formatting Ruby code with Prettier is part of our acceptance criteria for PRs so this script will be used frequently (or at least your IDE will be configure to do so)

##### Generating the RubyCritic Code Quality Report

```shell
scripts/rubycritic.sh [optional RubyCritic arguments...]
```

##### Running a One-off Command in the Development Environment

```shell
scripts/run.sh my-command arg1 arg2
```

The `run` command starts a new container to run the command. If you want to run a command on your already running containers, use the `exec` script instead.

#### Executing a Command Inside of the Running `gsp-rails-app` Container

```shell
scripts/exec.sh my-command arg1 arg2
```

*Typical Use Cases:* Running npm scripts

#### Environment Variables

This Docker development setup is configured with all the required environment variables for the application to operate. If you need to add / change a variable in your local environment, you can do so by editing `.env`. This file is in the `.gitignore` so your personal changes won't be committed. 

If you want to introduce a new environment variable that will be needed by the application, edit `.env.example` and commit your changes.

## Getting Help

While you are always encouraged to be resourceful and try to investigate issues that may come up on your own, do not hesitate to ask for help on work.ertiza@gmail.com if you can't resolve them in a reasonable amount of time!

