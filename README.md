# Juice Studio Planner

A cost and bandwidth planner for Juice AI Studio. Use it to price a project from the rate card, check the markup, and see how many workdays each role (Creative Director, Video Editor, Graphic Designer) will need against team capacity.

It's a single static page with no build step and no server.

```
index.html      the app
data/config.js  Supabase address and public (anon) key
data/seed.js    default rate card, reference rates, team, example quotes
k/<key>.js      admin sign-in for the admin link (see "Two links" below)
supabase/       database setup scripts
.nojekyll       lets GitHub Pages serve the files as-is
```

## Two links: admin and team

There's no sign-in screen. Which planner you get depends on the address:

| Link | Who | What they get |
|---|---|---|
| **Site address** (e.g. studio-planner-chi.vercel.app) | Video editors, designers, the rest of the team | **Team view**: Job status, Daily updates, Projects, Schedule and Credits. They can keep the job status, post daily updates and log credits; they can't see or change prices, and lost quotes are hidden. Refreshes every minute. |
| **Site address + `#<key>`** | Admins only | The full planner: Dashboard, Quote builder, Job status, Daily updates, Projects, Schedule, Credits, Pipeline & capacity, Rate card, Reference rates. |

How it works: the `#<key>` part names a file in `k/`. That file holds the admin user's email and password, and the page signs in with it silently. Without the key, the page only has the public anon key, and the database lets that key read three stripped-down views (`sp_team_settings`, `sp_team_jobs`, `sp_team_quotes`) and call a handful of narrow functions: `sp_log_credits` / `sp_undo_credit` (credit entries), `sp_set_line` (the tracking fields on one deliverable, and nothing else — prices, quantities and job types are refused), `sp_log_update` / `sp_undo_update` (daily updates) and `sp_add_brief` / `sp_patch_brief` / `sp_del_brief` (incoming briefs; the team can't link a brief to a quote). So the team view can't change prices or create work because the **database** refuses it, not just because the buttons are hidden.

Keep the admin link to admins. Anyone who has it has full edit access. To change it, rename the file in `k/` (the new file name is the new key) and push. The repo should stay private, because the key file is in it.

## Run it

- **On your computer:** open `index.html` in a browser.
- **On Vercel:** the project is linked to this repo, so pushing to `main` redeploys it (studio-planner-chi.vercel.app).
- **On GitHub Pages:** push the repo, then go to Settings → Pages → Deploy from branch → `main` / root. The app will be at `https://<user>.github.io/<repo>/`.

## How the numbers work

```
Internal cost = effort (workdays) × workday cost
              + (credits + buffer) × credit rate
              + external cost                     (e.g. voice artists)

Adapts:  price = % × base film price              (50% same orientation, 75% vertical↔landscape)
         cost  = adapt effort × workday cost
               + share × base film (credits + buffer) × base film credit rate   (20% / 40%)

Markup   = price ÷ internal cost
Margin % = (price − internal cost) ÷ price
```

- **Price ranges** (e.g. ₹2L–5L) use the midpoint. You can override the price on any quote line.
- **Discounts:** each line has its own **Disc %**, applied to that line only; the quote-level discount then applies to the total. Both show in the quote summary and the CSV export.
- **Line notes:** every line has a Note box for scope, language or SKU details. Notes are included in the CSV export.
- **"Quote per brief"** jobs (e.g. Complex CGI) suggest a price of internal cost × target markup.
- **Complimentary** jobs are quoted at ₹0, but their effort and cost still count.
- **Who does the work:** each job type's effort is production time only and goes 100% to one role: Video Editor for video, GIF and AI voiceover jobs, Graphic Designer for static and carousel jobs, and PM for artist dubbing and PDP copy.
- **Leadership & coordination (CD, PM):** every quote also books, for whoever holds each role on it, that role's *hours per project* plus a *% of the quote's production days*. Set these in Reference rates → Roles. This time is already covered by the workday rate, so it shows up in capacity but isn't added to internal cost.
- **People:** the team is a list of named people (Reference rates → Team), each with one or more roles and a utilisation %. A person's capacity is working days (Mon–Fri) × their utilisation, and all their roles share it.
- **Assigning work:** on each quote, pick one person per role under "Who's on it", or click **Assign least booked**. To give a single line to someone else, use its "Done by" menu. For example, split 20 statics into two lines of 10 with different designers. Work with no one picked shows as **Unassigned** until you assign it.
- **Capacity view:** booked days per person, switchable between **weekly** (8 weeks) and **monthly** (6 months), with a quote's days spread evenly between its start and delivery dates. Unassigned work gets its own section, and pitches are optional.

## Dashboard

The first tab, and the one to open if you only have a minute.

- **Five numbers:** confirmed value delivering this month (with margin %, and next month underneath), value out on pitches, average markup across priced projects (and how many sit under the markup floor), team load for the next four weeks (and who is over 100%), and how many things need attention.
- **Needs attention:** one list, worst first — overdue deliveries, work with no free capacity, deliverables overflowing past a delivery date, projects with no dates, work nobody is assigned to, quotes under the markup floor, and credit overspends. Each row has an **Open** button that jumps to the right tab with that project selected.
- **Team load:** each person's booked days against their capacity for the next four weeks.
- **Money & spend:** pipeline value by status with the win rate, client concentration, credits to buy this month in rupees, estimate-vs-actual on both credits and days, and delivered value against cost by month.

Everything on it is derived from the quotes, so there's nothing extra to maintain.

## Credits

A tab in both the admin and the team view.

- **Log credits** (team and admins): **who's logging** (required, remembered in that browser), project, date used, provider, credits, who used them (defaults to the person logging) and an optional note. Picking a project shows its estimate — credits + buffer — with how much is used and left. **+ Log** on any project row in the table picks that project. Each entry is stored on its project (`usage`), and the Projects tab's "used" figures are the running total of these entries, so the two always match.
- **Undo:** the team can undo their own entry for 15 minutes (Entries view). After that, an admin can delete it from the admin link.
- **Estimate for reference:** each project row shows `Est. 2,000 + 500 buffer = 2,500 Higgsfield · used 1,850 · 650 left`.
- **Tables:** by project or by person, weekly (8 weeks) or monthly (6 months), with ← Today → to move. Each cell shows credits **used** (bold, red when over) and the **estimate** (grey). The estimate is each deliverable's credits + buffer from the quote, spread evenly across its working days and attributed to whoever is doing it. **Entries** lists every log entry in the selected period.
- **Stats bar:** for the selected period, **credits used**, **cost of credits used** (₹), **more estimated** (estimate for the rest of the period, from today) and **used vs plan**. Click a column heading to select that week or month, or Total for the whole range.
- **Provider:** pick Higgsfield or ElevenLabs to see credits, or **All providers (₹)** to add them up in rupees. Credits from different providers aren't comparable, so they're never added together as credits.
- Filter to one project with the project menu, or use **Log credits →** / **Credit log →** on any row of the Projects tab.
- Totals entered before the credit log existed were carried over as one entry per provider, dated on the project's delivery date (or the day of the upgrade if that date is still ahead).

## Job status

The deliverable-by-deliverable tracker, and the team's home tab.

### Incoming briefs

At the top of the tab: jobs the client has asked for that nobody has quoted yet — the rows that used to sit half-empty in the sheet. Anyone adds one with brand, project, what's been asked for, received and target dates, who added it and notes. The team can edit a waiting brief or mark it **Dropped**; only an admin can clear it, either with **Create quote** (starts a pitch with the brand, name and target date filled in, the brief kept as the first comment, and jumps to the Quote builder) or **or add to…** an existing quote. Briefs then show as **Quoted** with a link, and are hidden unless you tick "Show quoted and dropped". Waiting briefs appear in the dashboard's Needs attention list. They're stored in the settings row, so they're in the backup.

### Deliverables

One row per quote line, grouped by brand and project:

- **Client brief** — Not received / Received / Clarification required.
- **Client assets** — Not received / Received / Some pending.
- **Assigned to** — people who can do that job first, then everyone else.
- **Start** and **Due** — these are the deliverable's own dates, so they move its bar on the Schedule timeline.
- **Stage** — Scripting / Storyboard / Production / Editing / Post production, with a free-text **Stage progress** note.
- **Status** — Not started / In progress / Under review / Complete.
- **Blocker** — pick a type (client feedback, client assets, internal approval, creative issue, technical issue, other) and the row opens a red strip for what the blocker is and the action to clear it.
- **Delivered** — a tick. Delivered rows are hidden unless you ask for them.
- **Rename for the client**: each row can carry its own name ("10s product forward") on top of the rate-card job name.

Filter by brand, person, blocked-only, and whether to include pitches. Blockers and deliverables waiting on a brief or assets near a delivery date show up in the dashboard's Needs attention list. Project rows (here and on the Projects tab) show **3/7 delivered** and the blocked count.

New deliverables are added by an admin in the Quote builder, so everything stays priced and in capacity — start from a brief above, and nothing gets lost in between.

## Daily updates

The end-of-day note, replacing the per-editor tabs in the sheet. Pick your name (remembered on that computer), the project and optionally the task, then fill in stage, **work done today**, pending work, blocker and an EOD files link. Updates are listed newest first, grouped by day, filtered by person and period. A banner says who hasn't posted today (production people only). You can undo your own update for 15 minutes; admins can delete any.

## Projects and schedule

- **Projects tab:** every quote appears here automatically. Set status, priority (Critical / High / Medium / Low), start and delivery dates inline, see who's on each project, and keep a running comment thread per project. Your name for comments is remembered in your browser.
- **Statuses:** Pitch, Confirmed, In production, Delivered and **Lost**. A lost quote stays on record — it feeds the win rate on the dashboard — but is left out of capacity, the schedule and all pipeline totals.
- **Actuals, estimated vs used:** the Projects table has an **Actuals · est → used** column. The first row is **days** (quoted production days → what it really took, typed in by an admin); the rest are credits per provider (credits + buffer → the total of the credit log). Each shows the variance as a percentage, and the line underneath totals the rupee difference ("₹12,863 over cost") using the workday rate and credit rates. Stored per project as `actualDays` and `usage`.
- **Timeline key:** click ⓘ in the Schedule toolbar. A thick solid bar is the project; a thin tinted bar is one deliverable with its own dates; a dashed tinted bar is a deliverable that hasn't been given dates yet, so it can happen anywhere inside the project's dates. Bar colour is the project's priority.
- **auto-plan:** on an expanded project row, gives every deliverable real dates. It re-runs the scheduler for that project from scratch (ignoring any dates already pinned on its own lines), so the result follows priority: a Critical project takes the early days and a Low one gets what's left. Re-run it after changing a priority.
- **Work that won't fit:** when a person hasn't enough free capacity inside the dates, the row says "0.5 d won't fit" and a red hatched block appears just past the bar, sized to roughly that much time, with the exact figure in its tooltip. The bar also gets a red right edge.
- **Overflow:** if a deliverable ends after the project's delivery date, the project row shows **Overflow +3 d** and an **extend** button that moves the delivery date to cover it. The deliverable's own row shows the same figure, and a line starting before the project shows "starts 2 d early".
- **Schedule tab → Timeline:** an editable Gantt. Drag a project bar to move it, or its edges to change start and delivery. Expand a project to plan each deliverable on its own: a dashed bar follows the project dates until you drag it, and "reset" puts it back. Switch between day and week zoom, and use arrow keys (Shift for length) on a focused bar. Team load lanes at the bottom show each person's booked days per day or week and recolour as you drag.
- **Schedule tab → By person:** a per-person view of what they're working on, week by week (or month by month). Each person's days are filled from each project's start date, highest priority first, up to their daily capacity (utilisation). Anything that can't fit before the delivery date is flagged as "x d won't fit by <date>" rather than silently moving the date. Delivered projects are excluded; pitches are optional.

## Where your data lives

The planner saves to a shared **Supabase** database (Postgres), set in `data/config.js`. Admins see each other's changes live. The team view reloads every minute and whenever its tab comes back into focus.

It uses three tables, all prefixed `sp_` so other apps can share the same Supabase project:

| Table | Holds |
|---|---|
| `sp_settings` | Reference rates, team and markup guardrails (one row, `main`) |
| `sp_jobs` | Rate card job types |
| `sp_quotes` | Quotes |

Each row stores one JSON document (`data`), plus `updated_at` and `updated_by`. The team view reads `sp_team_*` views of the same tables instead.

### One-time setup

1. In Supabase, open **SQL Editor** and run `supabase/schema.sql`, which creates the tables.
2. Under **Authentication → Users → Add user → Create new user**, add the admin user with the email and password from the file in `k/`, and tick **Auto Confirm User**.
3. Run `supabase/team-access.sql`. It makes the tables admin-only and creates the read-only team views. Then run `supabase/team-credit-log.sql` (team credit logging), `supabase/team-job-status.sql` (team job status and daily updates) and `supabase/team-briefs.sql` (incoming briefs). (`open-access.sql` is the older no-sign-in setup and is no longer used.)
4. Open the admin link. If the database is empty, choose **Import from this browser** or **Start from the repo defaults**.

To use per-person email sign-in instead, set `requireLogin: true` in `data/config.js` and remove the file in `k/`. Only @juicelabs.ai emails will then get in, by emailed sign-in link, and you'll need to set the Site URL under Authentication → URL Configuration.

### Backups and defaults

- **Reference rates → Download backup** saves everything as a JSON file. **Restore from backup** loads one back, for everyone.
- **Download seed.js** exports the current rate card, rates and team. Commit it as `data/seed.js` to change the repo defaults.
- To run the planner without the database, in this browser only, delete `data/config.js`.
- Opening `index.html` from your computer works the same way: add `#<key>` to the address for the admin planner.
