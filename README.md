# GitHub Analysis of Programming Languages and User Engagement
## Project Overview
Analyse popular and trending programming languages and user engagement on GitHub.

## Key Questions Answered
* What are the top 5 languages used each year?
* Which languages have the highest growth rate?
* What languages do the top repositories use?
* Which languages are most frequently used together?
* What is the user engagement demographic?

## Data Set
* GitHub Activity Data (github_repos) from Google Cloud.
* Used data from 01-Nov-2017 to 31-Nov-2022 (refer to the Notes section below).

## Tools
* Data cleaning, manipulation, and simple analysis: **Google BigQuery** (SQL)
* Creating visualisations: **Google Looker Studio**
* Documentation and displaying results: **Microsoft Word**

## Notes
* Data from 01-Nov-2017 until 31-Nov-2017 (5 years) was extracted from github_repos due to the following findings:
  * Initial investigation showed that November 2022 was the last month with valid and significant data.
  * github_repos has over 3TB of data and BigQuery on the free trial only allows processing usage up to 1TB.
