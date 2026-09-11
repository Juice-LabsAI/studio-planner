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

Your quotes and edits are saved in the **browser you're using**, in its localStorage for this site. There's no database or server behind the app. That means data doesn't sync between computers or people, and clearing your browser's site data deletes it.

When the app changes how it stores data, it updates your saved data the next time it loads. It keeps your rates, team and quotes.

- **Reference rates → Download backup** saves everything (rate card, rates, team, quotes) as a JSON file. **Restore from backup** loads one back.
- **Reference rates → Download seed.js** exports the current rate card, rates and team without quotes. Commit it as `data/seed.js` to change the defaults for everyone who opens the repo.
- **Reset to repo defaults** reloads `data/seed.js` and replaces all local data.

The first time the app opens in a browser, it loads `data/seed.js`.
