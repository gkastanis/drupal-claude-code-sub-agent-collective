---
name: prd
description: "Generate a Product Requirements Document (PRD) for a Drupal feature. Use when planning a feature, starting a new project, or when asked to create a PRD. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out."
---

# PRD Generator

Create detailed Product Requirements Documents that are clear, actionable, and suitable for Drupal implementation.

---

## The Job

1. Receive a feature description from the user
2. Ask 3-5 essential clarifying questions (with lettered options)
3. Generate a structured PRD based on answers
4. Save to `.taskmaster/docs/prd-[feature-name].md`

**Important:** Do NOT start implementing. Just create the PRD.

---

## Step 1: Clarifying Questions

Ask only critical questions where the initial prompt is ambiguous. Focus on:

- **Problem/Goal:** What problem does this solve?
- **Core Functionality:** What are the key actions?
- **Scope/Boundaries:** What should it NOT do?
- **Success Criteria:** How do we know it's done?

### Format Questions Like This:

```
1. What is the primary goal of this feature?
   A. Improve user onboarding experience
   B. Increase user retention
   C. Reduce support burden
   D. Other: [please specify]

2. Who is the target user?
   A. Anonymous visitors only
   B. Authenticated users only
   C. All users
   D. Admin users only

3. What is the scope?
   A. Minimal viable version (single module)
   B. Full-featured implementation (multiple modules)
   C. Just the backend/API
   D. Just the theme/frontend
```

This lets users respond with "1A, 2C, 3B" for quick iteration.

---

## Step 2: PRD Structure

Generate the PRD with these sections:

### 1. Introduction/Overview
Brief description of the feature and the problem it solves.

### 2. Goals
Specific, measurable objectives (bullet list).

### 3. User Stories
Each story needs:
- **Title:** Short descriptive name
- **Description:** "As a [role], I want [feature] so that [benefit]"
- **Acceptance Criteria:** Verifiable checklist of what "done" means

Each story should be small enough to implement in one focused session.

**Format:**
```markdown
### US-001: [Title]
**Description:** As a [role], I want [feature] so that [benefit].

**Acceptance Criteria:**
- [ ] Specific verifiable criterion
- [ ] Another criterion
- [ ] ddev exec phpunit passes for new code
- [ ] **[UI stories only]** Verify in browser using agent-browser skill
```

**Important:**
- Acceptance criteria must be verifiable, not vague. "Works correctly" is bad. "Form displays validation error when email field is empty" is good.
- **For any story with UI changes:** Always include "Verify in browser using agent-browser skill" as acceptance criteria.

### 4. Functional Requirements
Numbered list of specific functionalities:
- "FR-1: The module must provide a custom entity type for..."
- "FR-2: When a user submits the form, the system must..."

Be explicit and unambiguous.

### 5. Non-Goals (Out of Scope)
What this feature will NOT include. Critical for managing scope.

### 6. Drupal Architecture
- **Content model:** Entity types, bundles, fields
- **Modules:** Custom modules needed, contrib dependencies
- **Configuration:** Config entities, settings forms
- **Routes/Permissions:** New routes and access control
- **Services:** Custom services and dependency injection

### 7. Technical Considerations (Optional)
- Known constraints or dependencies
- Integration points with existing modules
- Performance requirements (caching strategy, query optimization)

### 8. Success Metrics
How will success be measured?
- "Content editors can create X in under 2 minutes"
- "Page load time under 1 second with caching enabled"

### 9. Open Questions
Remaining questions or areas needing clarification.

---

## Writing for Junior Developers

The PRD reader may be a junior developer or AI agent. Therefore:

- Be explicit and unambiguous
- Avoid jargon or explain it
- Provide enough detail to understand purpose and core logic
- Number requirements for easy reference
- Use concrete examples where helpful

---

## Output

- **Format:** Markdown (`.md`)
- **Location:** `.taskmaster/docs/`
- **Filename:** `prd-[feature-name].md` (kebab-case)

---

## Example PRD

```markdown
# PRD: Event Registration System

## Introduction

Add event registration to the Drupal site so that authenticated users can register for events, view their registrations, and receive confirmation emails.

## Goals

- Allow users to register for published events
- Provide admin tools to manage registrations and capacity
- Send automated email confirmations
- Track registration counts per event

## User Stories

### US-001: Create event registration entity
**Description:** As a developer, I need a custom entity to store registrations so they persist and are queryable.

**Acceptance Criteria:**
- [ ] Custom `event_registration` entity type with bundle support
- [ ] Fields: event reference, user reference, status, timestamp
- [ ] Entity has proper access control handler
- [ ] ddev exec phpunit passes for entity CRUD tests

### US-002: Registration form on event pages
**Description:** As a user, I want a registration button on event pages so I can sign up.

**Acceptance Criteria:**
- [ ] "Register" button appears on event node pages for authenticated users
- [ ] Button hidden when event is full or user already registered
- [ ] Registration creates entity and shows confirmation message
- [ ] ddev exec phpunit passes
- [ ] Verify in browser using agent-browser skill

### US-003: Admin registration management
**Description:** As an admin, I want to view and manage registrations via Views.

**Acceptance Criteria:**
- [ ] Admin view at /admin/content/registrations
- [ ] Filters: event, status, date range
- [ ] Bulk operations: approve, cancel, delete
- [ ] ddev exec phpunit passes
- [ ] Verify in browser using agent-browser skill

## Functional Requirements

- FR-1: Create `event_registration` custom entity with bundle support
- FR-2: Add registration form as extra field on event content type
- FR-3: Enforce capacity limits per event
- FR-4: Send email notification on registration via Symfony Mailer
- FR-5: Provide Views integration for admin listing
- FR-6: Add `administer event registrations` permission

## Non-Goals

- No payment processing or ticketing
- No waitlist functionality
- No calendar integration
- No public registration listing

## Drupal Architecture

- **Entity:** `event_registration` (custom content entity)
- **Module:** `custom_event_registration`
- **Config:** Default view, email templates, capacity settings
- **Routes:** /admin/content/registrations, /event/{node}/register
- **Services:** RegistrationManager, CapacityChecker, NotificationService
- **Dependencies:** node, user, views, symfony_mailer

## Success Metrics

- Users can register for an event in under 3 clicks
- Admin can view all registrations for an event in one screen
- No registration accepted beyond capacity limit

## Open Questions

- Should cancelled registrations free up capacity immediately?
- Should there be a registration deadline separate from event date?
```

---

## Checklist

Before saving the PRD:

- [ ] Asked clarifying questions with lettered options
- [ ] Incorporated user's answers
- [ ] User stories are small and specific
- [ ] Functional requirements are numbered and unambiguous
- [ ] Non-goals section defines clear boundaries
- [ ] Drupal Architecture section covers entities, modules, config, routes
- [ ] Saved to `.taskmaster/docs/prd-[feature-name].md`
