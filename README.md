# Pizza App
This is the code behind the Pizza App orders management system.

### Dependencies and Versions
- **Rails 7.0.5**
- **Ruby 3.2.2**
- **Rspec 5.0**
- **PostgreSQL 14.7**

### Project Setup
Install [Docker](https://docs.docker.com/) for [Mac](https://docs.docker.com/desktop/install/mac-install/) or [Windows](https://docs.docker.com/desktop/install/windows-install/), then run:

```shell
scripts/setup.sh
```

After running the command, please note that the server will not start immediately. It may take some time for the server to set up, and you will see log messages indicating the progress. Once the images are successfully created, you will start seeing the Puma server logs. At that point, you can open another terminal tab and run the following commands:

```shell
scripts/db-create.sh
scripts/db-migrate.sh
scripts/db-seed.sh
```

If you encounter any issues during the setup process, I recommend referring to a helpful resource that provides guidance on Docker setup for various environments. You can find detailed instructions and a set of useful scripts listed in the [Custom Scripts Guide](DOCKER.md) documentation.

Incase of success you'll have the server up and running at [localhost:3000](https:/localhost:3000)


### Rubocop Rules
[Rubocop](https://rubocop.org) linter rules configured in [.rubocop.yml](.rubocop.yml).

Run Rubocop
```shell
bundle exec rubocop
```

Run Rubocop Single Rule
```shell
bundle exec rubocop --only "Layout/EmptyLines"
```

Auto Correct Warnings
```shell
bundle exec rubocop --auto-correct
```

Auto Correct All Warnings
```shell
bundle exec rubocop --autocorrect-all
```

### Ruby Gems
Ruby gems defined in [Gemfile](Gemfile).

### Git Aliases

Create New Branch
```shell
git config --global alias.add-commit-push '!git add -A && git commit -m "$1" && git push && git status'

```

Add, Commit, Push
```shell
git config --global alias.new-branch '!git checkout -b "$1" && git add -A && git commit -m "$2" && git push -u origin "$1" && git status'
```

### Git Commands

Checkout Main
```shell
git checkout main
```

Create Branch
```shell
git new-branch "PA-123" "PA-123 Title From Jira Issue"
```

Commit Changes
```shell
git add-commit-push "Description of changes"
```

### Git Workflows

Local Development
- create new branch from `main` 
- use Jira issue number as branch name
- commit changes to your branch
- ensure all tests are passing
- create pull request with Jira issue number as prefix
- add appropriate labels to the pull request
- assign pull request for review
- make necessary changes from the review
- review and close all comments
- use `Squash and merge` to merge back into `main`

### Run Tests
Run Backend Tests
```shell
scripts/tests.sh
```