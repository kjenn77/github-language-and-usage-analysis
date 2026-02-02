# Calculate the percentiles of user commits to determine category cutoffs
SELECT 
  PERCENTILE_CONT(total_commits, 0.25) OVER() AS p25
  , PERCENTILE_CONT(total_commits, 0.50) OVER() AS p50
  , PERCENTILE_CONT(total_commits, 0.75) OVER() AS p75
FROM (
  SELECT
    committer.name
    , COUNT(*) AS total_commits
  FROM
    bigquery-public-data.github_repos.commits
  WHERE
    TIMESTAMP_SECONDS(committer.date.seconds) BETWEEN '2017-11-01' AND '2022-11-30'
  GROUP BY 1
)
LIMIT 1;
