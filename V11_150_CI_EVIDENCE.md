# Thiên Đồ V11.150 — GitHub Actions evidence (2026-10-15)

## Verified CI run
- Source branch: `audit/v11.150` of `adolfcsix/thiendo_demoo` (PUBLIC TEST repo)
- Tested commit: `fe5486ca2af289072bf6cba0b87bc7feba6e4f1e`
- [Run #38676478252](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38676478252): **SUCCESS**
- CI environment: GitHub Actions Ubuntu + Node.js 22 + ephemeral PostgreSQL 16
- Original vetted source ZIP SHA-256: `dab5b902d5557d08d5eaab7d5853778505f05248c22a26c723b31fbe954dc0a2`
- 1,855 vetted source files reconstructed from seven base64 blobs; each source SHA-256 validated against ZIP manifest. Pinned supplementary immutable baselines, historical fixtures, and three SHA-verified contract source overlays were applied exclusively in the CI working directory.

## PASS: evidence
- npm registry / `yoctocolors-cjs@2.1.3` probe, lockfile integrity, strict `npm ci`, installed CLI dependencies
- V11.150 stability audit, source import checks, architecture checks
- Frontend and backend TypeScript typecheck
- API/web production builds
- Full Node.js regression suite: **2474/2474 tests across 250 files** in the successful run
- Disposable PostgreSQL 16 guard, verified empty test DB, migrations run twice, verified target
- Live HTTP smoke of 24 Next routes (including anonymous auth gates and Academy lessons)
- Next -> Nest -> exact PostgreSQL test instance fingerprint; health and auth proxy
- Live dedicated PostgreSQL API HTTP E2E

## Actual fixes in the test branch
- Restore an immutable migrations baseline inadvertently omitted by the filtered source archive.
- Restore seven SHA-256 validated frozen regression fixtures omitted by the filtered source archive.
- Match SSR checks to the actual anonymous **ToolAccessGate** for /chart, /calendar, /good-days and /bazi (these require login); the homepage marker reflects current UI copy.
- Start both first-party Next.js and NestJS services safely for HTTP E2E, enforce DB identity before mutations, clean processes afterward.
- Do **not** bypass login gates or disable HTTP assertions to pass CI.

## Caveats — V11.150 **NO-GO** remains
This is an isolated, passing **CI baseline**, **NOT** confirmation that production may launch:
- Headless Chromium responsive/browser acceptance and authenticated UI workflows have not yet been verified by this run.
- OAuth/Google, payment provider webhooks and real QR/PayOS transactions were not run with production integrations.
- Production-like backup/restore, rollback, long-duration soak/load testing and observability/security review are outstanding.
- Avoid public deployment, production secrets, main branch merge, or V11.151 promotion without distinct approval.

The GitHub test repository is **public by the owner's choice**, but no website was deployed and original `adolfcsix/thiendo_demo` was untouched. The audit branch contains the source archive in seven transfer blobs, not a flattened Git tree. Developers should use the vetted ZIP and pinned CI patches as the tested input when recreating the checkout.
