# Create a table of aggregated data of repositories
CREATE OR REPLACE TABLE github-analysis-486123.github_data.summary_stats AS

  # Create a CTE of repository information, unnesting repo_name
  WITH base_commits AS (
    SELECT
      r AS repo_name
      , DATE_TRUNC(DATE(TIMESTAMP_SECONDS(c.committer.date.seconds)), MONTH) AS commit_month
      , c.committer.name AS committer_name
    FROM
      # Cross join to flatten the repo_name array in the commits table
      bigquery-public-data.github_repos.commits AS c
      , UNNEST(repo_name) AS r
    WHERE
      # Grab 5 years of data up to 2022-11-30 (date found from initial investigation)
      TIMESTAMP_SECONDS(c.committer.date.seconds) BETWEEN '2017-11-01' AND '2022-11-30'
      # Exclude records of commits by bots
      AND NOT REGEXP_CONTAINS(LOWER(c.committer.name), r'bot|automation|service-account')
  )

  # Create a CTE of repository information, unnesting/flattening language
  , repo_langs AS (
    SELECT 
      repo_name 
      , l.name AS language_name
      , l.bytes
    FROM
      # Cross join to flatten the language array in the languages table
      bigquery-public-data.github_repos.languages
      , UNNEST(language) AS l
  )

  # Select aggregated data of repository information to language information
  SELECT 
    bc.commit_month
    , bc.repo_name
    , rl.language_name
    , rl.bytes
    , COUNT(*) AS commit_count
    , COUNT(DISTINCT bc.committer_name) AS unique_contributors
  FROM base_commits bc
  JOIN repo_langs rl 
    ON bc.repo_name = rl.repo_name
  GROUP BY 1, 2, 3, 4;
