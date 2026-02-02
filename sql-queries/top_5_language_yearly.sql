# Create a table to analyse the top 5 languages every year
CREATE OR REPLACE TABLE github-analysis-486123.github_data.top_5_language_yearly AS

  # Create a CTE to contain yearly language information
  WITH yearly_stats AS (
    SELECT 
      EXTRACT(YEAR FROM commit_month) AS commit_year
      , language_name
      , SUM(commit_count) AS annual_commits
    FROM github-analysis-486123.github_data.summary_stats
    WHERE commit_month BETWEEN '2017-11-01' AND '2022-11-30'
    GROUP BY 1, 2
  )

  # Select only the top 5 languages for every year based on annual_commits
  SELECT *
  FROM yearly_stats
  QUALIFY ROW_NUMBER() OVER(PARTITION BY commit_year ORDER BY annual_commits DESC) <= 5;