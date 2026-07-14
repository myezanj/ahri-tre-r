# TRE Interface vs R Wrapper Semantic Gap Analysis

This report maps TRE command capabilities to current R wrapper capabilities by behavior rather than strict function-name parity.

## Current R Capability Surface

- Runtime artifact discovery and ABI loading helpers.
- Runtime lifecycle actions (`runtime_*`) and daemon helpers (`daemon_*`).
- Protocol execution transport (`AhriTreClient`, `execute_json`).
- Command wrappers across governance, datastore, datasets/assets/datafiles,
  entities/relations, session/auth, schema/tag, and ingest surfaces.
- Payload extraction/Arrow conversion plus contract smoke and diagnostic redaction.

## Category-Level Semantic Coverage

| Category | Semantic Coverage |
|---|---|
| Assets, Datafiles, Datasets | Wrapper families present (`asset_*`, `datafile_*`, `dataset_*`). |
| Study, Governance | Wrapper family present (`study_*`, including access/custodian/duo operations). |
| Datastore, Semantic Catalog | Wrapper families present (`datastore_*`, `domain_*`, `variable_*`, `vocabulary_*`, `schema_*`). |
| Authentication, Daemon, Sessions | Wrapper families present (`auth_*`, `daemon_*`, `session_*`). |
| Entities, Relations, Transformations, Ingest | Wrapper families present (`entity_*`, relation-instance helpers, `transformation_list`, `ingest_*`). |
| Local Commands | Utility wrappers present (`doctor`, `version`, `completion`, smoke helpers). |
| Runtime | Full lifecycle wrapper surface present (`runtime_*`). |

## Prioritized Maintenance Phases

1. Strengthen typed response normalizers for high-volume list/search endpoints.
2. Expand test coverage on mutation and relation-instance flows.
3. Keep wrapper signatures and docs synchronized with command/schema updates.
4. Preserve safety semantics for destructive operations (confirmation and dry-run where supported).

## Design Notes for Wrapper Expansion

- Keep transport (`execute_json`) separate from typed command wrappers.
- Continue expanding typed request builders and response normalizers per category.
- Preserve dry-run/force/yes semantics for destructive operations.
- Standardize error mapping to `ahri_tre_error` subclasses by command family.

