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
- **Role split:** each job type splits its workdays across roles by percentage.
- **Capacity:** headcount × working days (Mon–Fri) × utilisation. A quote's days are spread evenly between its start and delivery dates. Pitches are optional in the view.

## Where your data lives

Your edits are saved in the **browser you're using** (localStorage). They don't sync between computers or people.

- **Reference rates → Download backup** saves everything (rate card, rates, team, quotes) as a JSON file. **Restore from backup** loads one back.
- **Reference rates → Download seed.js** exports the current rate card, rates and team without quotes. Commit it as `data/seed.js` to change the defaults for everyone who opens the repo.
- **Reset to repo defaults** reloads `data/seed.js` and replaces all local data.

The first time the app opens in a browser, it loads `data/seed.js`.
