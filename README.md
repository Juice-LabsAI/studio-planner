# Juice Studio Planner

A cost and bandwidth planner for Juice AI Studio. Use it to price a project from the rate card, check the markup, and see how many workdays each role (Creative Director, Video Editor, Graphic Designer) will need against team capacity.

It's a single static page with no build step and no server.

```
index.html      the app
data/seed.js    default rate card, reference rates, team, example quotes
.nojekyll       lets GitHub Pages serve the files as-is
```

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
- **"Quote per brief"** jobs (e.g. Complex CGI) suggest a price of internal cost × target markup.
- **Complimentary** jobs are quoted at ₹0, but their effort and cost still count.
- **Who does the work:** each job type's effort is production time only and goes 100% to one role: Video Editor for video, GIF and AI voiceover jobs, Graphic Designer for static and carousel jobs, and PM for artist dubbing and PDP copy.
- **Leadership & coordination (CD, PM):** every quote also books, for whoever holds each role on it, that role's *hours per project* plus a *% of the quote's production days*. Set these in Reference rates → Roles. This time is already covered by the workday rate, so it shows up in capacity but isn't added to internal cost.
- **People:** the team is a list of named people (Reference rates → Team), each with one or more roles and a utilisation %. A person's capacity is working days (Mon–Fri) × their utilisation, and all their roles share it.
- **Assigning work:** on each quote, pick one person per role under "Who's on it", or click **Assign least booked**. To give a single line to someone else, use its "Done by" menu. For example, split 20 statics into two lines of 10 with different designers. Work with no one picked shows as **Unassigned** until you assign it.
- **Capacity view:** booked days per person, switchable between **weekly** (8 weeks) and **monthly** (6 months), with a quote's days spread evenly between its start and delivery dates. Unassigned work gets its own section, and pitches are optional.

## Where your data lives

The planner saves to a shared **Supabase** database (Postgres), set in `data/config.js`. There's no sign-in: anyone who opens the page sees and edits the same rate card, rates, team and quotes, and open planners update live. **Share the address only with admins.** Anyone who has it, or who reads the key in the page source, can change the data.

It uses three tables, all prefixed `sp_` so other apps can share the same Supabase project:

| Table | Holds |
|---|---|
| `sp_settings` | Reference rates, team and markup guardrails (one row, `main`) |
| `sp_jobs` | Rate card job types |
| `sp_quotes` | Quotes |

Each row stores one JSON document (`data`), plus `updated_at` and `updated_by`.

### One-time setup

1. In Supabase, open **SQL Editor** and run `supabase/schema.sql`, which creates the tables. Then run `supabase/open-access.sql`, which allows access without signing in.
2. Open the planner **in the browser that has your existing data**. The database is empty the first time, so choose **Import from this browser**.

To lock it down later, set `requireLogin: true` in `data/config.js` and re-run `schema.sql`. Only @juicelabs.ai emails will then get in, by emailed sign-in link. You'll also need to set the Site URL under Authentication → URL Configuration.

### Backups and defaults

- **Reference rates → Download backup** saves everything as a JSON file. **Restore from backup** loads one back, for everyone.
- **Download seed.js** exports the current rate card, rates and team. Commit it as `data/seed.js` to change the repo defaults.
- To run the planner without the database, in this browser only, delete `data/config.js`.
