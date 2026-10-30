# Medicare Hospital Cost Analysis (CMS 2024)

SQL analysis of the CMS Hospital Provider Cost Report (2024) to compare total hospital costs across states and facility types.

## Data source

- **Dataset:** Hospital Provider Cost Report, 2024 (public use file) from CMS, available on data.cms.gov
- **Level of detail:** one row per submitted hospital cost report (6,109 reports from 6,026 distinct hospitals)
- **Key fields used:** `State Code`, `Provider CCN` (hospital ID), `CCN Facility Type`, `Total Costs` (total hospital costs, Worksheet C)
- The raw data is not included in this repo because of its size. Download it from CMS to reproduce the results.

## Tools

SQL (SQLite) in DB Browser for SQLite

## Data quality check

The file contains 6,109 reports but only 6,026 distinct hospitals, so 83 reports were duplicate filings. A simple average over all rows would have counted those hospitals twice. Both queries average costs per hospital first, so each hospital counts once. This changed several state rankings (for example, DC moved from about $413M to about $433M, and California moved ahead of Connecticut).

## Query 1: Which states have the highest average total hospital costs?

File: `01_avg_cost_by_state.sql`

States and territories with fewer than 5 hospitals are excluded (none were excluded here; all 52 entries qualified).

**Top 10 states by average total cost per hospital**

| Rank | State | Hospitals | Avg total cost |
|---|---|---|---|
| 1 | NY | 181 | $536.0M |
| 2 | DC | 12 | $432.6M |
| 3 | CA | 395 | $381.8M |
| 4 | CT | 39 | $379.8M |
| 5 | MA | 99 | $352.6M |
| 6 | NJ | 93 | $335.6M |
| 7 | DE | 15 | $323.7M |
| 8 | NC | 125 | $289.2M |
| 9 | MD | 56 | $285.3M |
| 10 | FL | 267 | $279.9M |

**Findings**
- New York has the highest average cost per hospital (about $536M across 181 hospitals), followed by DC ($433M) and California ($382M).
- The lowest averages are in Wyoming (about $61M) and Puerto Rico (about $55M), so New York's average is nearly 10 times Puerto Rico's.
- Texas has the most hospitals of any state (566) but ranks 30th at about $167M per hospital.

## Query 2: How do average total costs differ by facility type?

File: `02_avg_cost_by_facility_type.sql`

Facility types come from the last four digits of each hospital's CMS Certification Number (CCN). Types with fewer than 5 hospitals are excluded.

| Facility type | Hospitals | Avg total cost |
|---|---|---|
| CH (children's hospitals) | 71 | $661.1M |
| STH (short-term hospitals) | 3,159 | $345.5M |
| ORD (demonstration project hospitals) | 8 | $93.1M |
| PH (psychiatric hospitals) | 609 | $38.0M |
| CAH (critical access hospitals) | 1,377 | $36.0M |
| LTCH (long-term care hospitals) | 328 | $29.7M |
| RH (rehabilitation hospitals) | 390 | $29.0M |
| RNMHC (religious non-medical health care institutions) | 7 | $3.9M |

**Findings**
- Children's hospitals have the highest average cost ($661M), about twice that of short-term hospitals ($346M).
- Short-term hospitals are the largest group (3,159 hospitals, just over half of the facilities in the table).
- Critical access hospitals average about $36M, roughly one-tenth of short-term hospitals, even though there are 1,377 of them.

## Limitations

- These are averages per hospital, not cost per patient. Costs depend heavily on hospital size and type.
- Facility type varies this much in cost, so state rankings likely reflect each state's mix of large short-term and children's hospitals as well as price levels. I did not test that directly; a next step would be to compare states within a single facility type.
- Several facility groups are small (ORD with 8 hospitals, RNMHC with 7), so their averages are less reliable.

## Files

- `01_avg_cost_by_state.sql` and `01_query.png`, `01_results.png`
- `02_avg_cost_by_facility_type.sql` and `02_query_and_results.png`
