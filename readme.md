# KTX app

## Application and data

- `tuff.html` is the standalone app, deployed to GitHub Pages as `index.html`.
- Supabase is the shared source of truth for user-added shops, menu-photo metadata, and user ratings.
- The built-in food/building catalog remains bundled in the app as read-only starter content; it is not user-editable data.
- Ratings are publicly readable. Signed-in users can create, update, and delete only their own rating for each spot.
- Existing local ratings are migrated for the signed-in user on their first visit after this update. Demo ratings are not imported. Legacy data is retained on the device if migration fails.
- Legacy user-added shops are migrated after sign-in; local data is removed only after successful migration.
- Menu images are JPG, PNG, or WebP, up to 5 MB each and 5 images per shop, stored in the public `ktx-menu-photos` bucket.

## Authentication redirect

Magic-link emails always return to the production app, even when sign-in is started from a local development URL:

- Redirect URL: `https://tr-ki.github.io/KTX/`
- In Supabase **Authentication → URL Configuration**, set the Site URL to the URL above and add it to the allowed Redirect URLs.
- The app uses Supabase email OTP/magic-link authentication; no password is stored by the app.

## Supabase and deployment

- Supabase project ref: `fbwvypwbrpgpgcgryjbs`
- Project URL: `https://fbwvypwbrpgpgcgryjbs.supabase.co`
- The publishable key is used by the browser app. Never put a Supabase secret/service-role key, database password, or access token in browser code or commit them.
- GitHub Actions deploys database migrations and the static app to Pages on pushes to `main`.
- Required repository Actions secrets: `SUPABASE_ACCESS_TOKEN`, `SUPABASE_DB_PASSWORD`, and `SUPABASE_PROJECT_REF` (the project ref above).
- Enable GitHub Pages with **GitHub Actions** as its source.

## Security note

A Supabase secret key and database password were shared in chat previously. Revoke/rotate those credentials in Supabase if that has not already been done. Do not copy secret values into this repository or send them in chat.
