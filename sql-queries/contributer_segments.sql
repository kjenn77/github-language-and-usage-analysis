# Group committers into categories based on total commits within 5 years
CREATE OR REPLACE TABLE github-analysis-486123.github_data.contributor_segments AS
SELECT
  committer_name
  , total_commits
  , CASE
      # total_commit value for each category based on previous percentile calculation
      WHEN total_commits <= 2 THEN 'Occasional'
      WHEN total_commits <= 5 THEN 'Light'
      WHEN total_commits <= 25 THEN 'Medium'
      ELSE 'Heavy'
    END AS engagement_level
FROM (
  SELECT
    committer.name AS committer_name
    , COUNT(*) AS total_commits
  FROM bigquery-public-data.github_repos.commits
  WHERE TIMESTAMP_SECONDS(committer.date.seconds) BETWEEN '2017-11-01' AND '2022-11-30'
  GROUP BY 1
);
