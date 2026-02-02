# Create a table to analyse top 5 growing languages
CREATE OR REPLACE TABLE github-analysis-486123.github_data.top_5_growth AS

  # Create a CTE to identify the start date  to calculate growth rate
  WITH start_point AS (
    SELECT 
      language_name
      , SUM(commit_count) AS start_vol
    FROM github-analysis-486123.github_data.summary_stats
    WHERE commit_month = '2017-11-01'
    GROUP BY 1
  )

  # Create a CTE to identify the end date to calculate growth rate
  , end_point AS (
    SELECT
      language_name
      , SUM(commit_count) AS end_vol
    FROM github-analysis-486123.github_data.summary_stats
    WHERE commit_month = '2022-11-01'
    GROUP BY 1
  )

  # Select languages and calculate its growth rate
  SELECT 
    e.language_name
    , ((e.end_vol - s.start_vol) / NULLIF(s.start_vol, 0)) AS growth_rate
  FROM end_point AS e
  JOIN start_point s
    ON e.language_name = s.language_name
  ORDER BY growth_rate DESC
  LIMIT 5;