# V11.150 — source already transferred by ChatGPT (no phone upload needed)

**Status:** completed. This document supersedes the old manual upload instructions.

The vetted 1,855-file source archive was transferred automatically as seven GitHub text blobs at `ci-source-b64/part-00.b64` through `part-06.b64`, with a Git commit on `audit/v11.150`.

The CI workflow reconstructs the exact `THIEN_DO_V11_150_PUBLIC_CI_SOURCE_REVIEW.zip` and verifies:

- Archive SHA-256: `dab5b902d5557d08d5eaab7d5853778505f05248c22a26c723b31fbe954dc0a2`
- Every included source file against `PUBLIC_CI_SOURCE_MANIFEST.json`
- Seven frozen regression fixtures plus the V11.150 immutable migration baseline
- A pinned, reviewed SSR home-route smoke contract update in `ci-overrides/`

The checks run from: [.github/workflows/v11150-source-zip-ci.yml](.github/workflows/v11150-source-zip-ci.yml)

See the repository **Actions** tab for actual status. Green steps only certify what they ran. V11.150 remains **NO-GO** for production until browser, provider, deployment, data recovery and operational gates have evidence.

**Do not upload the ZIP again.** Do not merge to main or deploy the site without separate approval.
