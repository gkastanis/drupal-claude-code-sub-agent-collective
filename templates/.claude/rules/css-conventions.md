# CSS Conventions

## Selector Specificity

Target specific elements within context (`.parent .child`), not parent containers. This prevents unintended style bleeding across components.

## BEM Methodology

Follow `block__element--modifier` pattern strictly for custom CSS classes.

## Drupal Asset Management

- Use `{{ attach_library('my_theme/component') }}` for all component assets.
- Every asset bundle needs a matching `*.libraries.yml` entry.
- No inline JS or CSS - always use the library system.

## Responsive Design

- Mobile-first responsive design approach.
- Use Drupal breakpoints system for responsive images.
