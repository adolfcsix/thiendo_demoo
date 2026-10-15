# Thiên Đồ V11.150 — one ZIP upload to run actual CI

Repository: `adolfcsix/thiendo_demoo` (PUBLIC test repository).
Branch: **`audit/v11.150` only**. Never commit this archive to `main` or to `thiendo_demo`.

## What to upload (one file)
Exact filename:
`THIEN_DO_V11_150_PUBLIC_CI_SOURCE_REVIEW.zip`

SHA-256:
`dab5b902d5557d08d5eaab7d5853778505f05248c22a26c723b31fbe954dc0a2`

Size: 4,973,605 bytes. Contents: 1,855 reviewed source files plus manifest.

## Phone/browser upload
1. Download the exact ZIP file from the ChatGPT response. Do not unzip.
2. Open this repository in the GitHub web browser, switch the branch selector from `main` to `audit/v11.150` first.
3. Select **Add file → Upload files**, choose the single ZIP file.
4. Commit changes **directly to `audit/v11.150`**. Do not create a pull request or merge.
5. Open the repository Actions tab and look for **Thiên Đồ V11.150 — Full source archive CI**.

The uploaded ZIP is public because this repository is public. Never upload `.env`, keys, credentials, raw database dumps, or the unreviewed 7,000+ file archive.

## Expected automated checks
- Exact ZIP checksum and internal file manifest, unsafe path and symlink rejection.
- npm registry, committed lockfile, strict `npm ci` on Node.js 22.
- Source stability, architecture, typecheck, lint if a script exists, API/web build, tests.
- Fresh disposable PostgreSQL 16 schema migration and E2E tests.

This workflow does **not** deploy the website. Browser/mobile UX checks, payment webhooks, external OAuth, full production restore and performance remain separate NO-GO gates.

## Important limitation
The GitHub app's text-only file-write API could create the workflow but not upload this binary ZIP from ChatGPT's working container. The single browser upload above bridges that limitation.
