SecretHub - GitHub Secrets CLI
==================================================

[![Gem Version](https://badge.fury.io/rb/secret_hub.svg)](https://badge.fury.io/rb/secret_hub)
[![Build Status](https://github.com/DannyBen/secret_hub/workflows/Test/badge.svg)](https://github.com/DannyBen/secret_hub/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/9ac95755c33e105ed998/maintainability)](https://codeclimate.com/github/DannyBen/secret_hub/maintainability)

---

SecretHub lets you easily manage your GitHub secrets from the command line
with support for bulk operations.

---

Installation
--------------------------------------------------

```shell
$ gem install secret_hub
```


Prerequisites
--------------------------------------------------

SecretHub is a wrapper around the [GitHub Secrets API][secrets-api]. To use
it, you need to set up your environment with a
[GitHub Access Token][access-key]:


```shell
$ export GITHUB_ACCESS_TOKEN=<your access token>
```


Usage
--------------------------------------------------

SecretHub has two families of commands:

1. Commands that operate on a single repository
2. Commands that operate on multiple repositories, and multiple secrets.

### Single repository operations

#### Show the secret keys in a repository

```shell
# secrethub list REPO
$ secrethub list you/your-repo
```

#### Create or update a secret in a repository

```shell
# secrethub save REPO KEY VALUE
$ secrethub list you/your-repo SECRET "there is no spoon"
```

#### Delete a secret from a repository

```shell
# secrethub delete REPO KEY
$ secrethub list you/your-repo SECRET
```

### Bulk operations

All the bulk operations function by:

1. Having a config file specifying the list of repositories, and their
   expected secret keys.
2. Having all the secrets set up as environment variables.

A typical config file looks like this:

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

#### Create a sample configuration file

```shell
# secrethub bulk init [CONFIG]
$ secrethub bulk init mysecrets.yml
```

#### Show all secrets in all repositories

```shell
# secrethub bulk list [CONFIG]
$ secrethub bulk list mysecrets.yml
```

#### Save multiple secrets to multiple repositories

```shell
# secrethub bulk save [CONFIG --clean]
$ secrethub bulk save mysecrets.yml --clean
```

Using the `--clean` flag, you can ensure that the repositories do not have
any secrets that you are unaware of. This flag will delete any secret that is
not specified in your config file.

#### Delete secrets from multiple repositories unless they are specified in the config file

```shell
# secrethub bulk clean [CONFIG]
$ secrethub bulk clean mysecrets.yml
```


Contributing / Support
--------------------------------------------------

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].

---

[secrets-api]: https://developer.github.com/v3/actions/secrets/
[access-key]: https://github.com/settings/tokens
[issues]: https://github.com/DannyBen/secret_hub/issues
