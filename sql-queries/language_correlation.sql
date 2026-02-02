# Create a cross-table of programming languages
CREATE OR REPLACE TABLE github-analysis-486123.github_data.language_correlation AS
SELECT 
  a.language_name AS lang_a
  , b.language_name AS lang_b
  , COUNT(DISTINCT a.repo_name) AS shared_repo_count
FROM github-analysis-486123.github_data.summary_stats AS a
JOIN github-analysis-486123.github_data.summary_stats AS b
  ON a.repo_name = b.repo_name
# Prevent duplicates of language combinations (e.g. A-B and B-A)
WHERE a.language_name < b.language_name
GROUP BY 1, 2;