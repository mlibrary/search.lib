# Use YAML for config files

## Context

There are many potential formats for config files. We only considered `YAML` and
`JSON`, both of which have traedoffs.

`YAML` is easy for humans to work with, but gets complicated and hard to work with easily.

`JSON` is easy for programming languages to work with and is not too bad to work
with when the data strucutre is complicated.

The big advantage of `YAML` over `JSON` is that `YAML` can have comments. 

For this project we do not intend to have complex configuration files and these
configuration files will be generated manually. 

## Decision

We will use `YAML` for config files. We will use the `.yaml` extension for these files.

## Status

Proposed

| Date       | Summary  |
|------------|----------|
| 2025-02-07 | Proposed |

## Consequences

We will be able to have configuration files with comments to provide added context.

If the configuration files get to have a complicated structure they will be more
difficult to maintain.
