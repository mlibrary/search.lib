# Statically load all explicitly rendered icons

## Context

 Icons from a a CDN can take a while to load when you load the whole family. Ideally each page would only load the icons it needs, but this is challenging because you need to put the list of icons to load at the top of the html document and you can't know implicitly what icons you need.

We tried having an array where icon names are added as they are called, but by the time the array is fully populated the link in the header has already been rendered with an empty list of icons. Ruby doesn't wait to render the page, it renders as it's being read.

We considered declaring what icons are needed for each route, but that would be hard to maintain long term because to add a partial template with an icon, you'd need to list it for every route that uses it.

We timed the loading of the ~40 icons that we need for Search and it took around 50ms. This duration is OK.

## Decision

We will load all of the partial specific icons we could need for every page of the application.

Format icons (which are about half of the needed icons) can be loaded dynamically because they are coupled with the record data anyway.

## Status

Approved

| Date       | Summary              |
|------------|----------------------|
| 2025-02-07 | Drafted and Approved |

## Consequences

It is straightforward to maintain icons for the site. If it is explicitly render in a template, it is added to the appropriate configuration file. Otherwise it is added dynamically to the list of icons for the page.

More icons will be loaded than are strictly necessary for the page, so it will take longer than strictly necessary to load.
