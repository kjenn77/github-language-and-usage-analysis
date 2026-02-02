CREATE OR REPLACE TABLE github-analysis-486123.github_data.top_5_repos_2022 AS

  # Determine the top 5 repositories in 2022 based on total commits and unique contributers
  WITH repo_engagement_2022 AS (
      SELECT 
          repo_name
          , SUM(commit_count) + SUM(unique_contributors) AS engagement
      FROM github-analysis-486123.github_data.summary_stats
      WHERE EXTRACT(YEAR FROM commit_month) = 2022
      GROUP BY 1
      ORDER BY engagement DESC
      LIMIT 5
  )
  
  # Extract the languages used in the top 5 repositotries
  , repo_language_dna AS (
      SELECT 
          s.repo_name
          , s.language_name
          , AVG(s.bytes) AS avg_lang_size
          , r.engagement
      FROM github-analysis-486123.github_data.summary_stats AS s
      JOIN repo_engagement_2022 r
        ON s.repo_name = r.repo_name
      GROUP BY 1, 2, 4
  )

  # Determine the language rank for each repository based on language size
  , ranked_stack AS (
      SELECT 
          repo_name
          , language_name
          , engagement
          # Calculate % of languages in the repository
          , avg_lang_size / SUM(avg_lang_size) OVER(PARTITION BY repo_name) AS pct_lang
          , ROW_NUMBER() OVER(PARTITION BY repo_name ORDER BY avg_lang_size DESC) AS lang_rank
      FROM repo_language_dna
  )

  SELECT 
      repo_name
      , language_name
      , engagement
      , pct_lang
  FROM ranked_stack
  WHERE lang_rank <= 3
  ORDER BY engagement DESC, pct_lang DESC;