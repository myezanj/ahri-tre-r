# TRE Interface vs R Wrapper Gap Analysis

This compares function names from TRE Public Interfaces.csv with currently implemented R functions in this repository.

## Coverage Summary

- Total exported R wrapper functions: 139 (from `NAMESPACE`)
- Backlog read/search functions listed in this document: fully implemented
- Direct CSV name-parity is no longer a useful metric for this repository because
	wrappers are intentionally namespaced and normalized for R conventions.

## Category Coverage Snapshot

| Category | Wrapper Surface (exported) |
|---|---|
| Study, Governance | `study_*` family present, including access/custodian/duo helpers |
| Datastore, Semantic Catalog | `datastore_*`, `domain_*`, `variable_*`, `vocabulary_*`, `schema_*` families present |
| Assets, Datafiles, Datasets | `asset_*`, `datafile_*`, `dataset_*` families present |
| Authentication, Daemon, Sessions | `auth_*`, `daemon_*`, `session_*` families present |
| Entities, Relations, Transformations, Ingest | `entity_*`, relation-instance helpers, `transformation_list`, `ingest_*` helpers present |
| Runtime | `runtime_*` lifecycle helpers present |
| Local/Utility | `doctor`, `version`, `completion`, smoke helpers present |

## Completed Backlog Check

The previously prioritized wrapper backlog items are now implemented:

- `study_list`, `study_get`, `datastore_info`, `datastore_ping`
- `asset_list`, `asset_get`, `dataset_list`, `dataset_metadata`, `dataset_preview`
- `auth_status`, `session_status`, `session_list`
- `study_search`, `dataset_search`, `datafile_search`, `variable_search`

## Interpretation

- The package now exposes broad command-wrapper coverage in addition to C-ABI
	runtime/client bridging and contract smoke testing.
- Remaining work should focus on wrapper ergonomics, response normalization,
	and long-term parity maintenance as protocol commands evolve.

## Remaining Opportunities

1. Improve typed response normalizers and table-friendly return structures.
2. Expand snapshot/contract tests for less-common command paths.
3. Keep wrappers synchronized with command/reference schema updates.

See docs/tre_r_wrapper_semantic_gap_analysis.md for capability-level status.

