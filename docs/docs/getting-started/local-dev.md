---
sidebar_position: 1
---

# Setup a local development environment

## Prerequisites

Create a service account key with sufficient permissions, rename it to `service-account.json`, and put it in the `.secrets/` directory.

**Example:**

```
.secrets/service-account.json
```

Create an `.env` file with these environment variables (for missing values, ask a team member):

```sh
# Access token used to set AuthApp cookie
ACCESS_TOKEN=

# Where the web application is hosted
BASE_URL=http://localhost:3000

# API endpoints
API_GATEWAY_URL=https://rpim-fe-gw-staging-2lzjriym.ew.gateway.dev
TAGS_API_URL=http://localhost:8081
SERVICES_API_URL=http://localhost:8082
SEARCH_API_URL=http://localhost:8083

# Sentry configuration
SENTRY_DSN=
SENTRY_CSP_URL=
SENTRY_ENVIRONMENT=development

# Service account credentials
AUTH_PASSWORD=

# Google Cloud Platform configuration
GOOGLE_APPLICATION_CREDENTIALS=.secrets/service-account.json

# Google Analytics configuration
GOOGLE_ANALYTICS_TRACKING_CODE=UA-121396927-16

# The number of items a user is allowed to edit simultaneously
MAX_ITEM_NUMBERS=1000
```

The `ACCESS_TOKEN` value can be taken from the [staging environment](https://staging.admin.retail-pim.ingkadt.com/), from the `AkaOauth_rpim` cookie.

Export a valid Artifactory npm token to be picked up in `.npmrc`:

```sh
export NPM_TOKEN=<ARTIFACTORY_NPM_TOKEN>
```

## Install

```sh
# Install dependencies
$ yarn install

# Serve with hot reload at localhost:3000
$ yarn dev

# Build for production and launch server
$ yarn build
$ yarn start
```

For detailed explanation on how things work, check out the [Nuxt.js docs](https://nuxtjs.org).

## Translations

Translations are handled in [PhraseApp](https://help.phrase.com/en/articles/2185220-installation).

After changing a translation, pull the latest translation files:

```sh
phraseapp pull
```

And then commit your changes.

## Error reporting

All client-side errors are reported to Sentry.

More information about Sentry can be found [here](https://sentry.io).

## Feature flags

Feature flags can be added in the self-hosted [Unleash](https://www.getunleash.io/) frontend application. To access it, you need a Google JWT `Authorization` header.

- [Staging](https://staging-rpim-feature-flag-admin-iilfswprfq-lz.a.run.app)
- [Production](https://rpim-feature-flag-admin-6roq3gfuya-lz.a.run.app)

## Commitlint

We utilise [commitlint](https://github.com/conventional-changelog/commitlint) using the [convential](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#rules) config for sanitising commit messages against those that would be compatible with the use of Semantic-Release.

When creating or updating a pull request, a CI job will run commitlint against all commits in your source branch. If this fails you can check the output of the job to see which commit messages do not adhere to the standard.

To avoid issues in this job it is recommended that you make local commits using the available helper `yarn commit` which will take you through a simple wizard to formulate your commit message correctly.

## Release

There is a manual job available at the end of the [main branch CI/CD pipelines](https://github.com/ingka-group-digital/retail-pim-admin/actions/workflows/release.yml) that will start deployment to production.

Click the button and Semantic Release will automatically determine the version, tag the repository, create the release and trigger deployment.

You can [follow deployment](https://github.com/ingka-group-digital/retail-pim-admin/actions) to ensure it completes correctly, or check the [#rrm-rpim-github](https://ingka.slack.com/archives/C01GSJWACBC) channel on Slack.
