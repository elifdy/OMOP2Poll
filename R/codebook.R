
library(bigrquery)
library(dplyr)
library(readr)

project_id <- Sys.getenv("WORKSPACE_CDR")

codebook_sql <- paste0(
  "SELECT DISTINCT
      answer.survey,
      answer.question_concept_id,
      answer.question,
      answer.answer_concept_id,
      answer.answer
  FROM
      `", project_id, ".ds_survey` answer"
)

codebook_df <- bq_project_query(project_id, codebook_sql) %>%
  bq_table_download()

head(codebook_df)



codebookdf_data <- codebook_df %>%
  arrange(survey, question_concept_id, answer_concept_id) %>%
  rownames_to_column() %>%
  select(-rowname)

print(codebookdf_data)

write_csv(codebookdf_data, "codebookdf.csv")
