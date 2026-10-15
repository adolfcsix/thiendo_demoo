# Thiên Đồ V11.151 — Account and Admin Security Foundation (NO-GO)

**Branch:** `audit/v11.151` in `adolfcsix/thiendo_demoo`. **Do not merge main, deploy or use production credentials.**

## Scope implemented (pre-acceptance)
- Schema migration `019_account_admin_mfa.sql`: email-verified timestamp, unique owner usernames, opaque per-device sessions, one-time verification challenges, encrypted admin TOTP credentials, session MFA assurance and per-user security events.
- Email OTP verify with HMAC, five-minute expiry, throttling, single-use; actual Resend delivery **not yet tested**.
- Sessions: list, per-session revoke and logout from other devices. No session verifiers sent to UI.
- Two offline-provisioned equal Owners with exact usernames `quynhngan297` / `mcuong484`. Existing separately registered/verified emails required; **no users or passwords are seeded**.
- MFA TOTP per owner, AES-256-GCM encrypted key, replay defense, per-account lockout and step-up per authenticated session; all admin APIs checked server-side; state-changing admin calls recheck permissions/MFA inside transaction.
- Existing Admin dashboard and account-profile screens extended; no astrological algorithm modifications.
- Unit tests (11 targeted, locally PASS) and new disposable PostgreSQL HTTP dual-owner integration; CI is configured to run full regression and this new test.

## Evidence and gate
- `npm ci`, frontend/backend typecheck and build PASS on [CI 38681990305](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38681990305).
- Earlier 8 legacy regression assertions were aligned with additive migration and security events; reruns passed locally.
- [CI 38682557002](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38682557002): full test failures narrowed to legacy migration count, corrected in V11.151.2.
- [CI 38682822945](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38682822945): full unit/regression suite passed; HTTP E2E initially failed because servers were not started; workflow now uses existing `run-ci-http.sh` safe startup/stop harness.
- Latest CI workflow: [V11.151 Actions](https://github.com/adolfcsix/thiendo_demoo/actions/workflows/v11151-auth-ci.yml). Mark GO only after the latest run **finishes** and all prerequisites are met.

## Outstanding before acceptance
- Actual Resend email code delivery, Google OAuth redirect/nonce, password reset with provider, real MFA enrollment using two separate owner accounts, admin recovery, authenticated browser workflows.
- Admin coverage currently includes dashboard, users/roles, Pro, orders, articles, audit, consultation; books, documents, forum, points/ranks, Gemini AI, CMS, notifications, policy and configuration panels are not implemented as full management modules.
- Distributed/edge login abuse controls, MFA recovery/rotation, authorization attack testing, CSRF/XSS audit, nonfunctional security and browser regression, backup/restore rollout gates.
- Previous V11.150 browser acceptance still has unmet scenarios, so this branch is not a production candidate.
