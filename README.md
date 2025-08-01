# SecretHub - GitHub Secrets CLI

SecretHub lets you easily manage your GitHub secrets from the command line
with support for bulk operations and organization secrets.

---

## Installation

With Ruby:

```shell
$ gem install secret_hub
```

Or with Docker:

```shell
$ alias secrethub='docker run --rm -it -e GITHUB_ACCESS_TOKEN -v "$PWD:/app" dannyben/secrethub'
```

## Prerequisites

SecretHub is a wrapper around the [GitHub Secrets API][secrets-api]. To use
it, you need to set up your environment with a
[GitHub Access Token][access-key]:


```shell
$ export GITHUB_ACCESS_TOKEN=<your access token>
```

Give your token the `repo` scope, and for organization secrets, the `admin:org` scope.

## Usage

SecretHub has three families of commands:

1. `secrethub repo` - manage repository secrets.
2. `secrethub org` - manage organization secrets.
3. `secrethub bulk` - manage multiple secrets in multiple repositories using a config file.

```shell
$ secrethub
GitHub Secret Manager

Commands:
  repo  Manage repository secrets
  org   Manage organization secrets
  bulk  Manage multiple secrets in multiple repositories

Run secrethub COMMAND --help for command specific help


$ secrethub repo
Usage:
  secrethub repo list REPO
  secrethub repo save REPO KEY [VALUE]
  secrethub repo delete REPO KEY
  secrethub repo (-h|--help)


$ secrethub org
Usage:
  secrethub org list ORG
  secrethub org save ORG KEY [VALUE]
  secrethub org delete ORG KEY
  secrethub org (-h|--help)


$ secrethub bulk
Usage:
  secrethub bulk init [CONFIG]
  secrethub bulk show [CONFIG --visible]
  secrethub bulk list [CONFIG]
  secrethub bulk save [CONFIG --clean --dry --only REPO]
  secrethub bulk clean [CONFIG --dry]
  secrethub bulk (-h|--help)
```

## Bulk operations

All the bulk operations use a simple YAML configuration file.
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


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].

---

[secrets-api]: https://developer.github.com/v3/actions/secrets/
[access-key]: https://github.com/settings/tokens
[issues]: https://github.com/DannyBen/secret_hub/issues
