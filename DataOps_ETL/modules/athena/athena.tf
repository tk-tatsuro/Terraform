# ----------------------------------
# Athena database
# ----------------------------------
resource "aws_athena_database" "athena_glue_test" {
  name   = var.athena_database_name
  bucket = var.log_bucket_name
}


# ----------------------------------
# Athena workgroup
# ----------------------------------
resource "aws_athena_workgroup" "glue_test_athena_workgroup" {
  name = "glue_test_athena_workgroup"
  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = false
    result_configuration {
      output_location = "s3://terraform-development-private-bucket-102/athena_result/cleansing_proc/"
    }
  }
}


# ----------------------------------
# Athena query
# ----------------------------------
data "template_file" "create_table_sql" {
  template = file("./src/queries/create_table.sql")
  vars = {
    athena_database_name = aws_athena_database.athena_glue_test.name
    athena_table_name    = var.athena_table_name
    log_bucket_name      = var.athena_log_bucket_name
  }
}
resource "aws_athena_named_query" "create_table" {
  name        = "Create table"
  workgroup   = aws_athena_workgroup.glue_test_athena_workgroup.id
  database    = aws_athena_database.athena_glue_test.name
  query       = data.template_file.create_table_sql.rendered
}
