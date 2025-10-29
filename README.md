# SecretHub - GitHub Secrets and Variables CLI

SecretHub lets you easily manage your GitHub Actions secrets and variables from the command line
with support for bulk operations and organization secrets/variables.

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

1. `secrethub repo` - manage repository secrets and variables.
2. `secrethub org` - manage organization secrets and variables.
3. `secrethub bulk` - manage multiple secrets and variables in multiple repositories using a config file.

```shell
$ secrethub
GitHub Secrets and Variables Manager

Commands:
  repo  Manage repository secrets and variables
  org   Manage organization secrets and variables
  bulk  Manage multiple secrets and variables in multiple repositories

Run secrethub COMMAND --help for command specific help


$ secrethub repo
Usage:
  secrethub repo list secrets|variables REPO
  secrethub repo save secrets|variables REPO KEY [VALUE]
  secrethub repo delete secrets|variables REPO KEY
  secrethub repo (-h|--help)


$ secrethub org
Usage:
  secrethub org list secrets|variables ORG
  secrethub org save secrets|variables ORG KEY [VALUE]
  secrethub org delete secrets|variables ORG KEY
  secrethub org (-h|--help)


$ secrethub bulk
Usage:
  secrethub bulk init [CONFIG]
  secrethub bulk show [CONFIG --visible]
  secrethub bulk list secrets|variables [CONFIG]
  secrethub bulk save secrets|variables [CONFIG --clean --dry --only REPO]
  secrethub bulk clean secrets|variables [CONFIG --dry]
  secrethub bulk (-h|--help)
```

## Bulk operations

All the bulk operations use a simple YAML configuration file.
The configuration file includes a list of GitHub repositories, each with separate
sections for secrets and variables.

For example:

```yaml
# secrethub.yml
user/repo:
  secrets:
    - SECRET
    - PASSWORD
    - SECRET_KEY
  variables:
    - API_URL
    - ENVIRONMENT

user/another-repo:
  secrets:
    - SECRET
    - SECRET_KEY
  variables:
    - API_URL
    - ENVIRONMENT
```

Both secrets and variables lists can use either array or hash syntax.

### Using array syntax

All values must be defined as environment variables.

```yaml
user/repo:
  secrets:
    - SECRET
    - PASSWORD
  variables:
    - API_URL
    - ENVIRONMENT
```

### Using hash syntax

Each value may be specified directly or left blank. When blank, 
the value will be loaded from the environment.

```yaml
user/another-repo:
  secrets:
    SECRET:
    PASSWORD: p4ssw0rd
  variables:
    API_URL: https://api.example.com
    ENVIRONMENT: production
```

### Using YAML anchors

SecretHub ignores any key that does not look like a repository (does not
include a slash `/`). Using this feature, you can define reusable YAML
anchors:

```yaml
docker: &docker
  # Secrets (must be encrypted)
  DOCKER_USER:
  DOCKER_PASSWORD:

  # Variables (stored as plain text)
  DOCKER_REGISTRY: ghcr.io
  DOCKER_TAG: latest

user/repo:
  secrets:
    <<: *docker
    SECRET:
    PASSWORD: p4ssw0rd
  variables:
    <<: *docker
    API_URL: https://api.example.com
    ENVIRONMENT: production
```

Note that YAML anchors only work with the hash syntax.


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].

---

[secrets-api]: https://developer.github.com/v3/actions/secrets/
[access-key]: https://github.com/settings/tokens
[issues]: https://github.com/DannyBen/secret_hub/issues
