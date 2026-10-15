# Thiên Đồ V11.152 — Method verification foundation (NOT RELEASED)

**Status: NO-GO.** The source is a candidate for reviewing rule provenance, not a release that completes the astrological, divination, calendar or fortune-telling algorithms.

## Proven work
- 21 discipline inventory entries, covering V11.152 (3), V11.153 (3) and V11.154 (15). File/test presence is not expert acceptance.
- V11.152 additions: method inventory JSON, deterministic SHA-256 evidence envelope, recursive first-party source dependency fingerprint, frozen method metadata and unit tests for invariant drift detection.
- Local: inventory audit PASS, 10/10 new unit checks PASS; other regression sample 31/31 PASS with local workspace symlinks.
- [First GitHub CI run #38686089276](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38686089276) **SUCCESS**, including npm ci, typecheck, build, full regression, migrations and live PostgreSQL HTTP E2E. This proves the initial V11.152 code at commit c7f66e1811271cdefa1c8db1cfe7c79308a77bcf only.

## Subsequent security fix and open blocker
- The method metadata objects were additionally frozen and the unit test checks immutability. Updated source/tests PASS 10/10 **locally**.
- [GitHub CI #38686280603](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38686280603) **FAIL**, because its source-overlay SHA-256 validation expects the previous revisions. New source/test hashes must be pinned in the workflow, then full CI rerun on the latest branch head; **do not count the earlier successful run as validation of the current HEAD**.
- No product algorithm replacement; provenance recording remains opt-in and not connected to persisted API records. Historical results are unchanged.

## Expert/production acceptance blockers
- Tử Vi inventory contains 104 names and 14 principal stars, but zero independently validated 12-palace-specific editorial readings.
- Historical DST independent witnesses and Jie minute boundaries should remain distinct; unresolved cases must not be replaced with confident AI text.
- V11.153 and V11.154 require independent source-led golden cases before any production algorithm expansion.
- V11.150 browser and V11.151 real provider/OAuth, real owner MFA and Admin integration gates are still open.
- No merge to main, no changes to original `adolfcsix/thiendo_demo`, no website deployment.

The standalone V11.152 candidate ZIP and full evidence matrix are provided in ChatGPT as separate artifacts.
