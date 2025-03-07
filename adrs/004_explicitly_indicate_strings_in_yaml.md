
# In YAML files use double quotes and HEREDOCs for all string values

## Context

When YAML can't infer what kind of entity a value is, it defaults to String.
This means one does not have to explicitly put quotes around strings. This can
be convenient because you don't have to worry about escaping single or double
quotes.

Leaving bare strings is risky because the YAML parser may assume that the value
is something other than a string or the value contains a ": " character
combination and will interpret the colon-space as indicating a new key.

## Decision

We will use double quotes or HEREDOCs for all string values.

We will use double quotes by default.

We will use HEREDOCs when:

* The value uses an ERB tag
* The value contains a ": "
* The value contains double quotes
* The value is long and it will be easier to read/maintain if it is in a HEREDOC
* Whenever else double quotes would be more cumbersome

## Status

Proposed

| Date       | Summary  |
|------------|----------|
| 2025-03-06 | Proposed |

## Consequences

* Editing YAML files will be more likely to work when edited
* Complex string values will be easier to read
* Values with ERB tags can be expressed without quote escaping
* String values will have consistent quoting within YAML files
* Small string values may have to escape internal double quotes
* There will be many not-strictly-necessary double quotes in YAML files
