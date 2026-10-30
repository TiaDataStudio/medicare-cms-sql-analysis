SELECT count(*) FROM CostReport_2024_Final;
-- Question: Which states have the highest average total hospital costs?
-- Data: CMS Hospital Provider Cost Report, 2024
-- Each hospital counts once, even if it filed more than one 2024 cost report.
-- States with fewer than 5 hospitals are excluded so small samples don't skew results.

WITH provider_costs AS (
    SELECT "State Code" AS state_code,
           "Provider CCN" AS provider_id,
           AVG(CAST("Total Costs" AS REAL)) AS provider_cost
    FROM CostReport_2024_final
    WHERE "State Code" IS NOT NULL
      AND "Total Costs" IS NOT NULL
      AND "Total Costs" <> ''
    GROUP BY "State Code", "Provider CCN"
)
SELECT state_code,
       COUNT(*) AS hospital_count,
       ROUND(AVG(provider_cost), 2) AS average_total_cost
FROM provider_costs
GROUP BY state_code
HAVING COUNT(*) >= 5
ORDER BY average_total_cost DESC;