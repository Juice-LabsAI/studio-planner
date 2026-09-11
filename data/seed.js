/* Juice Studio Planner — default rate card, reference rates, team and example quotes.
   Edit here (or use Reference rates → Download seed.js in the app) and commit. */
window.STUDIO_SEED = {
  "version": 1,
  "exportedAt": "2026-09-11T00:00:00.000Z",
  "settings": {
    "credits": [
      {
        "id": "hf",
        "name": "Higgsfield",
        "rate": 6.5
      },
      {
        "id": "el",
        "name": "ElevenLabs",
        "rate": 0.015
      }
    ],
    "dayRate": 4000,
    "hoursPerDay": 8,
    "markupFloor": 1.5,
    "targetMarkup": 2.5,
    "roles": [
      {
        "id": "cd",
        "name": "Creative Director",
        "headcount": 1,
        "utilisation": 70
      },
      {
        "id": "ve",
        "name": "Video Editor",
        "headcount": 3,
        "utilisation": 80
      },
      {
        "id": "gd",
        "name": "Graphic Designer",
        "headcount": 2,
        "utilisation": 80
      }
    ],
    "categoryBlurbs": {
      "Brand Films": "Hero content: cinematic, AI-produced brand storytelling with custom direction, voiceover, and post.",
      "Product Promo": "Hub & hygiene content: character-led or product-only promos for quick teasers, launches, and performance creative.",
      "Language": "Localization for film and promo assets across markets.",
      "Adapts": "Reformatting an approved film master into additional aspect ratios.",
      "Static Ads": "CPAS / performance / social: high-velocity AI-generated creative built for paid media testing and scaling.",
      "PDP Content": "Amazon, Q-Com & marketplaces: conversion-focused listing assets generated and optimized for marketplace placements."
    },
    "history": []
  },
  "jobs": {
    "brand-film-15": {
      "order": 110,
      "category": "Brand Films",
      "name": "Brand Films (Master)",
      "variant": "Up to 15 seconds",
      "description": "Short-form hooks, bumpers, and bridge moments, standard production quality.",
      "pricing": {
        "type": "fixed",
        "sp": 40000
      },
      "effortDays": 2,
      "creditType": "hf",
      "credits": 1500,
      "buffer": 500,
      "externalCost": 0,
      "split": {
        "cd": 25,
        "ve": 65,
        "gd": 10
      }
    },
    "brand-film-30": {
      "order": 120,
      "category": "Brand Films",
      "name": "Brand Films (Master)",
      "variant": "Up to 30 seconds",
      "description": "Standard spot for social, CTV, and broadcast, standard production quality.",
      "pricing": {
        "type": "fixed",
        "sp": 100000
      },
      "effortDays": 3,
      "creditType": "hf",
      "credits": 2000,
      "buffer": 500,
      "externalCost": 0,
      "split": {
        "cd": 25,
        "ve": 65,
        "gd": 10
      }
    },
    "brand-film-60": {
      "order": 130,
      "category": "Brand Films",
      "name": "Brand Films (Master)",
      "variant": "60 seconds and above",
      "description": "Long-form brand film, higher complexity, extended narrative.",
      "pricing": {
        "type": "range",
        "min": 200000,
        "max": 500000
      },
      "effortDays": 5,
      "creditType": "hf",
      "credits": 3500,
      "buffer": 500,
      "externalCost": 0,
      "split": {
        "cd": 25,
        "ve": 65,
        "gd": 10
      }
    },
    "promo-char-15": {
      "order": 210,
      "category": "Product Promo",
      "name": "Product Promo (With Characters)",
      "variant": "Up to 15 sec",
      "description": "Single character/actor, high production quality, mid complexity.",
      "pricing": {
        "type": "fixed",
        "sp": 26000
      },
      "effortDays": 1,
      "creditType": "hf",
      "credits": 600,
      "buffer": 300,
      "externalCost": 0,
      "split": {
        "cd": 20,
        "ve": 70,
        "gd": 10
      }
    },
    "promo-char-30": {
      "order": 220,
      "category": "Product Promo",
      "name": "Product Promo (With Characters)",
      "variant": "Up to 30 sec",
      "description": "Single character/actor, high production quality, mid complexity.",
      "pricing": {
        "type": "fixed",
        "sp": 32000
      },
      "effortDays": 2,
      "creditType": "hf",
      "credits": 800,
      "buffer": 200,
      "externalCost": 0,
      "split": {
        "cd": 20,
        "ve": 70,
        "gd": 10
      }
    },
    "promo-char-60": {
      "order": 230,
      "category": "Product Promo",
      "name": "Product Promo (With Characters)",
      "variant": "Up to 60 sec",
      "description": "Single character/actor, high production quality, mid complexity.",
      "pricing": {
        "type": "fixed",
        "sp": 64000
      },
      "effortDays": 2,
      "creditType": "hf",
      "credits": 1500,
      "buffer": 200,
      "externalCost": 0,
      "split": {
        "cd": 20,
        "ve": 70,
        "gd": 10
      }
    },
    "promo-prod-15": {
      "order": 240,
      "category": "Product Promo",
      "name": "Product Promo (Without Characters)",
      "variant": "Up to 15 sec",
      "description": "No human characters, product-only, essentials-tier quality and lowest complexity.",
      "pricing": {
        "type": "fixed",
        "sp": 13000
      },
      "effortDays": 1,
      "creditType": "hf",
      "credits": 300,
      "buffer": 150,
      "externalCost": 0,
      "split": {
        "cd": 15,
        "ve": 70,
        "gd": 15
      }
    },
    "promo-prod-30": {
      "order": 250,
      "category": "Product Promo",
      "name": "Product Promo (Without Characters)",
      "variant": "Up to 30 sec",
      "description": "No human characters, product-only, essentials-tier quality and lowest complexity.",
      "pricing": {
        "type": "fixed",
        "sp": 17500
      },
      "effortDays": 1,
      "creditType": "hf",
      "credits": 700,
      "buffer": 150,
      "externalCost": 0,
      "split": {
        "cd": 15,
        "ve": 70,
        "gd": 15
      }
    },
    "promo-prod-60": {
      "order": 260,
      "category": "Product Promo",
      "name": "Product Promo (Without Characters)",
      "variant": "Up to 60 sec",
      "description": "No human characters, product-only, essentials-tier quality and lowest complexity.",
      "pricing": {
        "type": "fixed",
        "sp": 21000
      },
      "effortDays": 1,
      "creditType": "hf",
      "credits": 1000,
      "buffer": 300,
      "externalCost": 0,
      "split": {
        "cd": 15,
        "ve": 70,
        "gd": 15
      }
    },
    "cgi-15": {
      "order": 270,
      "category": "Product Promo",
      "name": "Complex CGI (No character)",
      "variant": "Up to 15 sec",
      "description": "Complex CGI output, depending on the brief.",
      "pricing": {
        "type": "tbd"
      },
      "effortDays": 5,
      "creditType": "hf",
      "credits": 1500,
      "buffer": 500,
      "externalCost": 0,
      "split": {
        "cd": 20,
        "ve": 50,
        "gd": 30
      }
    },
    "dub-artist": {
      "order": 310,
      "category": "Language",
      "name": "Language Dubbing (Artist Voice)",
      "variant": "Per script, per language",
      "description": "Human voice artist, premium quality, natural delivery, higher complexity/turnaround than AI.",
      "pricing": {
        "type": "fixed",
        "sp": 25000
      },
      "effortDays": 0,
      "creditType": "",
      "credits": 0,
      "buffer": 0,
      "externalCost": 14000,
      "split": {
        "cd": 0,
        "ve": 0,
        "gd": 0
      }
    },
    "ai-vo": {
      "order": 320,
      "category": "Language",
      "name": "Language AI Voiceover (1 min script)",
      "variant": "Per script, per language",
      "description": "AI voice cloning using a reference voice, standard quality, low complexity, fast turnaround.",
      "pricing": {
        "type": "fixed",
        "sp": 1500
      },
      "effortDays": 0.125,
      "creditType": "el",
      "credits": 1500,
      "buffer": 500,
      "externalCost": 0,
      "split": {
        "cd": 10,
        "ve": 90,
        "gd": 0
      }
    },
    "adapt-same": {
      "order": 410,
      "category": "Adapts",
      "name": "Adapts (same orientation)",
      "variant": "Same length as master film",
      "description": "Reframe to 1:1, 4:5, or 9:16 from the approved master, lower complexity, no rebuild.",
      "pricing": {
        "type": "adapt",
        "pct": 0.5
      },
      "effortDays": 0.125,
      "creditType": "",
      "credits": 0,
      "buffer": 0,
      "externalCost": 0,
      "split": {
        "cd": 0,
        "ve": 100,
        "gd": 0
      },
      "adaptShare": 0.2
    },
    "adapt-cross": {
      "order": 420,
      "category": "Adapts",
      "name": "Adapts (vertical ↔ landscape)",
      "variant": "Same length as master film",
      "description": "Landscape build, cannot be cropped from vertical, built separately. Higher complexity than standard adapts.",
      "pricing": {
        "type": "adapt",
        "pct": 0.75
      },
      "effortDays": 0.375,
      "creditType": "",
      "credits": 0,
      "buffer": 0,
      "externalCost": 0,
      "split": {
        "cd": 10,
        "ve": 90,
        "gd": 0
      },
      "adaptShare": 0.4
    },
    "static": {
      "order": 510,
      "category": "Static Ads",
      "name": "Static",
      "variant": "Single frame",
      "description": "Single-frame ad creative, ready for paid social and CPAS, standard quality.",
      "pricing": {
        "type": "fixed",
        "sp": 6000
      },
      "effortDays": 0.05,
      "creditType": "hf",
      "credits": 5,
      "buffer": 2.5,
      "externalCost": 0,
      "split": {
        "cd": 10,
        "ve": 0,
        "gd": 90
      }
    },
    "static-var": {
      "order": 520,
      "category": "Static Ads",
      "name": "Static Variation",
      "variant": "Single frame",
      "description": "SKU- or message-level variant of an approved static format, lower complexity, reuses approved format.",
      "pricing": {
        "type": "fixed",
        "sp": 3000
      },
      "effortDays": 0.05,
      "creditType": "hf",
      "credits": 5,
      "buffer": 2.5,
      "externalCost": 0,
      "split": {
        "cd": 5,
        "ve": 0,
        "gd": 95
      }
    },
    "carousel": {
      "order": 530,
      "category": "Static Ads",
      "name": "Carousel (Set of 4)",
      "variant": "4 frames",
      "description": "Four-frame swipeable narrative for Meta, TikTok, and LinkedIn, standard quality.",
      "pricing": {
        "type": "fixed",
        "sp": 8000
      },
      "effortDays": 0.2,
      "creditType": "hf",
      "credits": 20,
      "buffer": 10,
      "externalCost": 0,
      "split": {
        "cd": 15,
        "ve": 0,
        "gd": 85
      }
    },
    "gif": {
      "order": 540,
      "category": "Static Ads",
      "name": "GIF",
      "variant": "Up to 5 sec",
      "description": "Short looping motion creative for feed and display, standard quality.",
      "pricing": {
        "type": "fixed",
        "sp": 7500
      },
      "effortDays": 0.25,
      "creditType": "hf",
      "credits": 135,
      "buffer": 45,
      "externalCost": 0,
      "split": {
        "cd": 10,
        "ve": 50,
        "gd": 40
      }
    },
    "ratio": {
      "order": 550,
      "category": "Static Ads",
      "name": "Ratio Adaptation",
      "variant": "Single frame",
      "description": "Reframe an existing asset to 9:16, 4:5, 1:1, or any custom placement, low complexity.",
      "pricing": {
        "type": "fixed",
        "sp": 1000
      },
      "effortDays": 0.05,
      "creditType": "hf",
      "credits": 5,
      "buffer": 2.5,
      "externalCost": 0,
      "split": {
        "cd": 0,
        "ve": 0,
        "gd": 100
      }
    },
    "pdp-gallery": {
      "order": 610,
      "category": "PDP Content",
      "name": "PDP Image Gallery and A+ Content",
      "variant": "Static image set",
      "description": "6 product images + 5 brand-story images, with mobile-adapted versions of every asset, standard quality.",
      "pricing": {
        "type": "fixed",
        "sp": 35000
      },
      "effortDays": 0.5,
      "creditType": "hf",
      "credits": 5,
      "buffer": 2.5,
      "externalCost": 0,
      "split": {
        "cd": 15,
        "ve": 0,
        "gd": 85
      }
    },
    "pdp-explainer": {
      "order": 620,
      "category": "PDP Content",
      "name": "AI Explainer Video",
      "variant": "1 minute",
      "description": "Narrated explainer optimized for PDPs and A+ modules, standard quality.",
      "pricing": {
        "type": "fixed",
        "sp": 35000
      },
      "effortDays": 0.5,
      "creditType": "hf",
      "credits": 800,
      "buffer": 300,
      "externalCost": 0,
      "split": {
        "cd": 10,
        "ve": 80,
        "gd": 10
      }
    },
    "pdp-copy": {
      "order": 630,
      "category": "PDP Content",
      "name": "PDP Copy",
      "variant": "N/A",
      "description": "Titles, bullets, A+ content, and listing text, complimentary add-on, no separate complexity tier.",
      "pricing": {
        "type": "free"
      },
      "effortDays": 0.25,
      "creditType": "",
      "credits": 0,
      "buffer": 0,
      "externalCost": 0,
      "split": {
        "cd": 100,
        "ve": 0,
        "gd": 0
      }
    }
  },
  "projects": {
    "example-festive": {
      "name": "Example · Festive launch campaign",
      "client": "Example brand",
      "status": "confirmed",
      "start": "2026-09-21",
      "end": "2026-10-16",
      "discountPct": 0,
      "notes": "Example quote to show how the planner works — edit or delete it.",
      "lines": [
        {
          "id": "l1",
          "jobId": "brand-film-30",
          "qty": 1,
          "spOverride": "",
          "baseJobId": ""
        },
        {
          "id": "l2",
          "jobId": "adapt-same",
          "qty": 2,
          "spOverride": "",
          "baseJobId": "brand-film-30"
        },
        {
          "id": "l3",
          "jobId": "adapt-cross",
          "qty": 1,
          "spOverride": "",
          "baseJobId": "brand-film-30"
        },
        {
          "id": "l4",
          "jobId": "promo-char-15",
          "qty": 3,
          "spOverride": "",
          "baseJobId": ""
        },
        {
          "id": "l5",
          "jobId": "ai-vo",
          "qty": 4,
          "spOverride": "",
          "baseJobId": ""
        },
        {
          "id": "l6",
          "jobId": "static",
          "qty": 12,
          "spOverride": "",
          "baseJobId": ""
        },
        {
          "id": "l7",
          "jobId": "static-var",
          "qty": 20,
          "spOverride": "",
          "baseJobId": ""
        }
      ],
      "createdAt": "2026-09-11T10:00:00.000Z",
      "updatedAt": "2026-09-11T10:00:00.000Z"
    },
    "example-marketplace": {
      "name": "Example · Marketplace refresh",
      "client": "Example brand",
      "status": "pitch",
      "start": "2026-10-05",
      "end": "2026-10-23",
      "discountPct": 5,
      "notes": "Example pitch — edit or delete it.",
      "lines": [
        {
          "id": "m1",
          "jobId": "pdp-gallery",
          "qty": 4,
          "spOverride": "",
          "baseJobId": ""
        },
        {
          "id": "m2",
          "jobId": "pdp-explainer",
          "qty": 2,
          "spOverride": "",
          "baseJobId": ""
        },
        {
          "id": "m3",
          "jobId": "pdp-copy",
          "qty": 4,
          "spOverride": "",
          "baseJobId": ""
        },
        {
          "id": "m4",
          "jobId": "static",
          "qty": 10,
          "spOverride": "",
          "baseJobId": ""
        },
        {
          "id": "m5",
          "jobId": "carousel",
          "qty": 3,
          "spOverride": "",
          "baseJobId": ""
        }
      ],
      "createdAt": "2026-09-11T10:00:00.000Z",
      "updatedAt": "2026-09-11T09:00:00.000Z"
    }
  }
};
