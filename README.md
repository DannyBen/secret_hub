# SecretHub - GitHub Secrets CLI

[![Gem Version](https://badge.fury.io/rb/secret_hub.svg)](https://badge.fury.io/rb/secret_hub)
[![Build Status](https://github.com/DannyBen/secret_hub/workflows/Test/badge.svg)](https://github.com/DannyBen/secret_hub/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/9ac95755c33e105ed998/maintainability)](https://codeclimate.com/github/DannyBen/secret_hub/maintainability)

---

SecretHub lets you easily manage your GitHub secrets from the command line
with support for bulk operations.

---

## Installation

With Ruby:

```shell
$ gem install secret_hub
```

Or with Docker:

```shell
$ alias secrethub='docker run --rm -it -e GITHUB_ACCESS_TOKEN -v $PWD:/app dannyben/secrethub'
```

## Prerequisites

SecretHub is a wrapper around the [GitHub Secrets API][secrets-api]. To use
it, you need to set up your environment with a
[GitHub Access Token][access-key]:


```shell
$ export GITHUB_ACCESS_TOKEN=<your access token>
```


## Usage

SecretHub has two families of commands:

1. Commands that operate on a single repository.
2. Commands that operate on multiple repositories, and multiple secrets.

Most commands are self explanatory, and described by the CLI.

```shell
$ secrethub --help
```

## Single repository operations

### Show the secret keys in a repository

```shell
# secrethub list REPO
$ secrethub list you/your-repo
```

### Create or update a secret in a repository

```shell
# secrethub save REPO KEY VALUE
$ secrethub list you/your-repo SECRET "there is no spoon"
```

### Delete a secret from a repository

```shell
# secrethub delete REPO KEY
$ secrethub delete you/your-repo SECRET
```

## Bulk operations

All the bulk operations function by using a simple YAML configuration file.
The configuration file includes a list of GitHub repositories, each with a
list of its secrets.

For example:

```yaml
# secrethub.yml
user/repo:
- SECRET
- PASSWORD
- SECRET_KEY

user/another-repo:
- SECRET
- SECRET_KEY
```

Each list of secrets can either be an array, or a hash.

### Using array syntax

All secrets must be defined as environment variables.

```yaml
user/repo:
- SECRET
- PASSWORD
```

### Using hash syntax

Each secret may define its value, or leave it blank. When a secret value is
blank, it will be loaded from the environment.

```yaml
user/another-repo:
  SECRET:
  PASSWORD: p4ssw0rd
```

### Using YAML anchors

SecretHub ignores any key that does not look like a repository (does not
include a slash `/`). Using this feature, you can define reusable YAML
anchors:

```yaml
docker: &docker
  DOCKER_USER:
  DOCKER_PASSWORD:

user/repo:
  <<: *docker
  SECRET:
  PASSWORD: p4ssw0rd
```

Note that YAML anchors only work with the hash syntax.


### Create a sample configuration file

```shell
# secrethub bulk init [CONFIG]
$ secrethub bulk init mysecrets.yml
```

### Show the configuration file and its secrets

```shell
# secrethub bulk show [CONFIG --visible]
$ secrethub bulk show mysecrets.yml
```

### Show all secrets stored on GitHub in all repositories

```shell
# secrethub bulk list [CONFIG]
$ secrethub bulk list mysecrets.yml
```

### Save multiple secrets to multiple repositories

```shell
# secrethub bulk save [CONFIG --clean --dry --only REPO]
$ secrethub bulk save mysecrets.yml --clean
```

Using the `--clean` flag, you can ensure that the repositories do not have
any secrets that you are unaware of. This flag will delete any secret that is
not specified in your config file.

### Delete secrets from multiple repositories unless they are specified in the config file

```shell
# secrethub bulk clean [CONFIG]
$ secrethub bulk clean mysecrets.yml
```


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].

---

[secrets-api]: https://developer.github.com/v3/actions/secrets/
[access-key]: https://github.com/settings/tokens
[issues]: https://github.com/DannyBen/secret_hub/issues
