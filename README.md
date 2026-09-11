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
- **Leadership & coordination (CD, PM):** every quote also books each role's *hours per project* plus a *% of the quote's production days*. Set these in Reference rates → Team. This time is already covered by the workday rate, so it shows up in capacity but isn't added to internal cost.
- **Capacity:** headcount × working days (Mon–Fri) × utilisation. A quote's days are spread evenly between its start and delivery dates. Pitches are optional in the view.

## Where your data lives

The planner saves to a shared **Supabase** database (Postgres), set in `data/config.js`. Anyone signed in with a @juicelabs.ai email sees and edits the same rate card, rates, team and quotes, and open planners update live.

It uses three tables, all prefixed `sp_` so other apps can share the same Supabase project:

| Table | Holds |
|---|---|
| `sp_settings` | Reference rates, team and markup guardrails (one row, `main`) |
| `sp_jobs` | Rate card job types |
| `sp_quotes` | Quotes |

Each row stores one JSON document (`data`), plus `updated_at` and `updated_by`.

### One-time setup

1. In Supabase, open **SQL Editor**, paste `supabase/schema.sql`, and click **Run**. This creates the tables and the rule that only @juicelabs.ai accounts can read or write.
2. Go to **Authentication → URL Configuration**. Set **Site URL** to `https://juice-labsai.github.io/studio-planner/` and add the same URL under **Redirect URLs**.
3. Optional: under **Authentication → Emails → Magic Link**, add `{{ .Token }}` to the template. People can then type the 6-digit code instead of clicking the link, which helps when email opens on a different device.
4. Open the planner **in the browser that has your existing data** and sign in. The database is empty the first time, so choose **Import from this browser**.

Sign-in uses an emailed link, so there are no passwords. Supabase's built-in email service only sends a few emails per hour. That's fine for a small team because sessions last, but add your own SMTP server under **Authentication → Emails** if it becomes a problem.

### Backups and defaults

- **Reference rates → Download backup** saves everything as a JSON file. **Restore from backup** loads one back, for everyone.
- **Download seed.js** exports the current rate card, rates and team. Commit it as `data/seed.js` to change the repo defaults.
- To run the planner without the database, in this browser only, delete `data/config.js`.
