-- Question: How do average total costs differ by hospital facility type?
-- Data: CMS Hospital Provider Cost Report, 2024
-- Facility type codes come from the CCN (e.g., STH = short-term hospital, CAH = critical access hospital).
-- Each hospital counts once, even if it filed more than one 2024 cost report.
-- Facility types with fewer than 5 hospitals are excluded.

WITH provider_costs AS (
    SELECT "CCN Facility Type" AS facility_type,
           "Provider CCN" AS provider_id,
           AVG(CAST("Total Costs" AS REAL)) AS provider_cost
    FROM CostReport_2024_final
    WHERE "CCN Facility Type" IS NOT NULL
      AND "Total Costs" IS NOT NULL
      AND "Total Costs" <> ''
    GROUP BY "CCN Facility Type", "Provider CCN"
)
SELECT facility_type,
       COUNT(*) AS hospital_count,
       ROUND(AVG(provider_cost), 2) AS average_total_cost
FROM provider_costs
GROUP BY facility_type
HAVING COUNT(*) >= 5
ORDER BY average_total_cost DESC;
