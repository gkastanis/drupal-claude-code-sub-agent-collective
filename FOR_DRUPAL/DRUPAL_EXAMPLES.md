# Drupal Example Tasks - For Testing Your Sub-Agent Collective

## Level 1 Examples (Direct Execution - 1-2 minutes)

### Example 1.1: Add Field to Content Type
```
Add a text field called "Subtitle" to the Article content type with a maximum length of 255 characters
```

**Expected Outcome:**
- Field added via Drush command
- Cache cleared
- Field visible in content type configuration

**Verification:**
```bash
drush field:list article
```

---

### Example 1.2: Enable Module
```
Enable the Pathauto module and its dependencies
```

**Expected Outcome:**
- Module enabled via Drush
- Dependencies resolved
- Configuration available

**Verification:**
```bash
drush pm:list --status=enabled | grep pathauto
```

---

### Example 1.3: Block Configuration
```
Place the "Who's online" block in the sidebar first region and make it visible only on the front page
```

**Expected Outcome:**
- Block placed and configured via Drush config
- Visibility settings applied

---

### Example 1.4: Menu Item
```
Add a menu link to "/contact" in the main navigation menu with the title "Get in Touch"
```

**Expected Outcome:**
- Menu link created
- Appears in main navigation
- Links to correct path

---

## Level 2 Examples (Feature Development - 15-20 minutes)

### Example 2.1: Custom Block Plugin
```
Create a custom block plugin called "Site Stats" that displays:
- Total number of published articles
- Total number of registered users
- Total number of comments
- Make the counts update when content changes (use proper cache tags)
```

**Expected Agents:** @architect → @module-dev → @security → @functional-test

**Expected Outcome:**
- Custom module: `site_stats_block`
- Block plugin with entity queries
- Proper dependency injection
- Cache tags implemented
- Drupal coding standards compliant
- Security reviewed
- Browser tested

**Files Created:**
- `web/modules/custom/site_stats_block/site_stats_block.info.yml`
- `web/modules/custom/site_stats_block/src/Plugin/Block/SiteStatsBlock.php`

**Verification:**
```bash
drush pm:list --type=module | grep site_stats
drush cr
# Visit /admin/structure/block and place the block
```

---

### Example 2.2: Custom Field Formatter
```
Create a custom field formatter for phone number fields that:
- Formats phone numbers as (XXX) XXX-XXXX
- Makes them clickable with tel: links
- Works with plain text fields
- Include settings to toggle the click-to-call feature
```

**Expected Agents:** @architect → @module-dev → @security → @functional-test

**Expected Outcome:**
- Custom module: `phone_formatter`
- Field formatter plugin
- Configuration form
- JavaScript behavior if needed
- Standards compliant

---

### Example 2.3: Custom Form Validation
```
Add custom validation to the contact form that:
- Checks if the phone number field contains only digits and dashes
- Ensures the message is at least 50 characters
- Blocks submissions containing spam keywords: "viagra", "casino", "lottery"
- Shows user-friendly error messages
```

**Expected Agents:** @architect → @module-dev → @security → @functional-test

**Expected Outcome:**
- Custom module: `contact_validation`
- Form alter hook
- Validation functions
- Proper sanitization
- Security reviewed

---

### Example 2.4: Custom View Mode
```
Create a custom "Card" view mode for Article content that displays:
- Featured image (thumbnail style)
- Title (linked)
- Trimmed body (150 characters)
- Author name
- Created date
- Make it responsive and accessible
```

**Expected Agents:** @architect → @theme-dev → @config-mgmt → @functional-test

**Expected Outcome:**
- View mode configuration
- Template override
- CSS styling
- WCAG compliant
- Responsive

---

## Level 3 Examples (Multi-Component System - 60-90 minutes)

### Example 3.1: FAQ System
```
Build a comprehensive FAQ system with:

1. FAQ content type with:
   - Question (title)
   - Answer (rich text body)
   - Category (taxonomy term reference)
   - Helpful votes (integer field - upvotes/downvotes)

2. FAQ Category taxonomy with description field

3. Custom module for voting functionality:
   - Ajax voting buttons (thumbs up/down)
   - Vote tracking per user (no double voting)
   - Vote count display

4. Views:
   - FAQ listing page with category filtering
   - Most helpful FAQs block (top 5)
   - Category-specific FAQ pages

5. Theme:
   - Accordion-style FAQ display
   - Responsive design
   - Accessible keyboard navigation

6. Admin features:
   - View showing all FAQs by category
   - Bulk operations for publishing/unpublishing
```

**Expected Agents:** PM → @architect → @module-dev → @theme-dev → @config-mgmt → @security → @performance → @functional-test → @integration

**Expected Outcome:**
- Custom module: `faq_system`
- Content type and taxonomy configured
- Voting system with Ajax
- Multiple views
- Custom theme templates
- Admin interface
- All quality gates passed

**Verification Flow:**
1. Create FAQ categories
2. Create FAQ entries
3. Test voting functionality
4. Test category filtering
5. Verify admin views
6. Check accessibility
7. Test responsive design

---

### Example 3.2: Event Management System
```
Build an event management system with:

1. Event content type:
   - Title, description, featured image
   - Event date/time (datetime_range field)
   - Location (address field or text)
   - Registration limit (integer)
   - Registration deadline (datetime)
   - Event status (list: upcoming, in-progress, completed, cancelled)

2. Custom entity: EventRegistration
   - Link to event
   - Registrant name, email, phone
   - Registration date
   - Status (registered, waitlist, cancelled)
   - Optional message field

3. Registration system:
   - Block plugin for registration form on event pages
   - Check for capacity before registering
   - Check deadline before allowing registration
   - Email notifications (registrant confirmation, admin notification)
   - Waitlist functionality when event is full

4. Views:
   - Upcoming events calendar (use Calendar module)
   - Admin view: all registrations by event
   - Admin view: registrations by status
   - User's registered events (My Events page)

5. Permissions:
   - Anonymous users can register
   - Authenticated users see their registrations
   - Event managers can view all registrations
   - Admins can edit/delete registrations

6. Email templates:
   - Registration confirmation
   - Waitlist notification
   - Event reminder (1 day before)
   - Cancellation notification
```

**Expected Agents:** PM → @architect → @content-migration → @module-dev → @theme-dev → @config-mgmt → @security → @performance → @functional-test → @integration

**Expected Outcome:**
- Custom module: `event_management`
- Content type configured
- Custom entity for registrations
- Registration form with validation
- Email notification system
- Multiple views
- Proper permissions
- Theme templates
- Queue system for emails
- All tests passing

---

### Example 3.3: Member Directory
```
Build a member directory system with:

1. Member Profile content type:
   - Full name, bio, photo
   - Job title, company
   - Email, phone, website
   - Location (city, state)
   - Expertise areas (taxonomy - multi-select)
   - Social media links (multiple link fields)
   - Member since date
   - Featured member (boolean)

2. Filtering and Search:
   - Exposed filters for: expertise, location, company
   - Search by name or keyword
   - Ajax-powered for instant results
   - Sort by: name, company, date joined

3. Display options:
   - Grid view (cards with photos)
   - List view (compact)
   - Map view (if location data available)

4. Member detail page:
   - Custom layout with sidebar
   - Contact form
   - Related members (same expertise)
   - Activity feed if available

5. Admin features:
   - Bulk import from CSV
   - Featured member selection
   - Approval workflow for new members
```

**Expected Agents:** PM → @architect → @module-dev → @theme-dev → @config-mgmt → @security → @performance → @functional-test

**Expected Outcome:**
- Content type fully configured
- Advanced Views with exposed filters
- Ajax functionality
- Multiple display modes
- CSV import functionality
- Admin workflow
- Responsive theme
- All quality gates passed

---

## Level 4 Examples (Full Project - 3-6 hours)

### Example 4.1: University Department Website
```
Build a complete university department website based on this PRD:

[PRD CONTENT]

**Site Structure:**
1. Homepage with hero, news highlights, events, quick links
2. About section (history, mission, contact)
3. Faculty & Staff directory with individual profiles
4. Course catalog with filtering
5. Research areas and publications
6. News & announcements
7. Events calendar
8. Student resources
9. Alumni section
10. Contact forms

**Content Types:**
- Person (faculty/staff)
- Course
- Research Project
- Publication
- News Article
- Event
- Student Resource

**Features:**
- User authentication for students
- Document library with permissions
- Faculty can edit their own profiles
- Course registration interest form
- Newsletter signup
- Site search
- Responsive design
- WCAG AA compliance

**Integrations:**
- Campus authentication (SAML/LDAP)
- Campus calendar feed
- Social media feeds
- Google Analytics

**Admin Requirements:**
- Editorial workflow (draft → review → published)
- Content scheduling
- Media library
- Menu management
- User management
```

**Expected Agents:** All agents in phased approach

**Expected Phases:**
1. Architecture & Content Model (PM, Architect)
2. Core Implementation (Module Dev, Theme Dev, Config Mgmt)
3. Features & Integrations (All core agents)
4. Testing & Validation (All testing agents)
5. Deployment Prep (Performance, DevOps)

**Expected Outcome:**
- Complete Drupal site
- 7+ content types
- 20+ views
- Custom modules as needed
- Custom theme
- All configurations exported
- Full test coverage
- Security reviewed
- Performance optimized
- Documentation complete
- Ready for production deployment

---

## Testing Your Sub-Agent Collective

### Recommended Testing Sequence

**Day 1: Validate Setup**
1. Run Example 1.1 (Add Field) - verify basic operation
2. Run Example 1.2 (Enable Module) - verify Drush integration
3. Run Example 1.3 (Block Config) - verify configuration management

**Day 2: Test Feature Development**
4. Run Example 2.1 (Custom Block) - verify agent coordination
5. Review generated code for quality
6. Verify security and standards gates

**Week 1: Complex Systems**
7. Run Example 3.1 (FAQ System) - verify multi-agent coordination
8. Test all features thoroughly
9. Review all quality gates

**Week 2+: Full Projects**
10. Attempt Example 4.1 or your own full project
11. Evaluate time savings
12. Document learnings

### Success Metrics

✅ Level 1 tasks complete in < 2 minutes
✅ Level 2 features are production-ready
✅ Code passes phpcs standards check
✅ Security reviews pass
✅ Functional tests validate behavior
✅ Configuration is exportable
✅ Development time reduced by 40-60%

---

## Creating Your Own Examples

Template for adding agency-specific examples:

```markdown
### Example X.X: [Feature Name]
```
[Description of what to build]

[Detailed requirements]
```

**Expected Agents:** [List agents]

**Expected Outcome:**
- [Deliverables]
- [Quality standards]

**Verification:**
```bash
[Commands to verify]
```
```

Save your examples in `examples/drupal/` for team reference.
