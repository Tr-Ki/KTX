# KTX app — handoff context

## Current app

- Main app file: `tuff.html`
- It is a standalone HTML app with an inline JavaScript module and Three.js loaded from a CDN. There is no app backend or build system in the local folder.
- The app currently stores user-added shops in `localStorage` under `ktx_khub_shops_v1`. Shop ownership is based on a client-generated ID, so it is not suitable for secure public editing/deletion.
- Existing ratings are stored locally under `ktx_khub_ratings_v1`.
- The current shop UI lets a user add shops/foods, choose one or more buildings, and delete shops they own in that browser. It displays a “not verified” notice.

## Requested next work

1. Add menu-photo upload to each shop. The requested formats are JPG, PNG, and WebP; PDF was not selected.
2. Make shops and their menus public across users/devices using Supabase. This requires moving shop records out of local-only storage as well as storing menu metadata and image objects.
3. Add Supabase schema/storage policies and GitHub Actions CI/CD to deploy the backend.

Important design work still needed:

- Choose how shop owners authenticate. The existing browser-generated owner ID is not a trusted identity; public write/delete policies must use Supabase Auth and `auth.uid()`.
- Agree on upload limits (maximum image size and number of photos per shop), deletion behavior, and whether images are public URLs or served through signed URLs.
- Preserve or migrate existing local shops, if needed.
- Decide whether GitHub Actions deploys only Supabase migrations/functions or also the static HTML app.

## Supabase project details

- Project URL: `https://fbwvypwbrpgpgcgryjbs.supabase.co`
- Project ref: `fbwvypwbrpgpgcgryjbs`
- Publishable browser key provided by the user: `sb_publishable_UUaPSefP6uWuvevBz_xcGw_HcOVN9rS`
- The publishable key is intended for client use, but database/storage access must still be protected with correct RLS and Storage policies.
- **The database password was pasted into chat and is intentionally not recorded here. Rotate it in Supabase before using the project.** Do not put the database password, service-role key, or access token in source code or commit them. Store the rotated database password and Supabase access token as GitHub Actions secrets when needed.

## GitHub and workspace status

- GitHub repository supplied: `https://github.com/Tr-Ki/KTX`
- The user said Git SCM was installed, but Git was not available on the agent's PATH during this session.
- No local clone of `Tr-Ki/KTX` was found in the inspected Desktop folders. The app file is at the Desktop root, along with unrelated personal files; do not initialize the Desktop root as a Git repository.
- Before editing the backend/repository, get the exact local clone path and confirmation to use it directly or create a worktree. The user has not yet provided that local path/isolation choice.
- No Supabase migrations, Storage bucket/policies, Edge Functions, or GitHub Actions workflow have been created yet. The only new file for this handoff is this README.

## Suggested implementation direction

- Store shop records and menu-photo metadata in Supabase tables; store image files in a dedicated Storage bucket.
- Use Supabase Auth for owner identity. Permit public reads only if intended; restrict uploads and deletes to the authenticated owner with both row-level security and Storage object policies.
- Use the Supabase publishable key in the browser only. Use GitHub Actions secrets for `SUPABASE_ACCESS_TOKEN`, the rotated `SUPABASE_DB_PASSWORD`, and `SUPABASE_PROJECT_REF`.
- Deploy migrations and any Edge Functions with the Supabase CLI from GitHub Actions after pushes to the chosen deployment branch. Never expose a service-role key in the browser.

## Implemented defaults

- Owner authentication: Supabase Auth magic-link email.
- Public shop and menu reads.
- Authenticated owners may create, update and delete only their own shops and menu photos.
- Menu formats: JPG, PNG and WebP.
- Maximum size: 5 MB per image.
- Maximum count: 5 images per shop.
- Images use public URLs from the public `ktx-menu-photos` Storage bucket.
- Existing `ktx_khub_shops_v1` records are migrated once a user signs in; the local key is removed after migration.
- Existing local ratings remain browser-local and were not moved by this implementation.
- GitHub Pages is deployed from `tuff.html` as `index.html`; Supabase migrations are deployed in the same workflow.

## GitHub Actions secrets

Add these repository secrets before running the workflow:

- `SUPABASE_ACCESS_TOKEN`
- `SUPABASE_DB_PASSWORD` using the rotated database password
- `SUPABASE_PROJECT_REF` with value `fbwvypwbrpgpgcgryjbs`

Enable GitHub Pages with **GitHub Actions** as its source in repository settings. Add the published Pages URL to Supabase Auth's allowed redirect URLs so magic-link sign-in can return to the app.

Never put the Supabase secret key, database password, or access token in the browser app, repository files, or chat. If a secret key has been shared, revoke it and create a replacement in Supabase; it is not a substitute for the Supabase CLI access token and database password required by the deployment workflow.
