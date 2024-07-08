output aws_iam_role_1_name {
  value = module.appcd_b71fd16c-797e-5a95-8e1b-ab22f1e34f43.name
}

output aws_iam_role_1_arn {
  value = module.appcd_b71fd16c-797e-5a95-8e1b-ab22f1e34f43.arn
}

output aws_lambda_hello_kitty_function_function_arn {
  value = module.appcd_00a20b0a-2ec0-5bdc-a08d-65a85dc81d5b.function_arn
}

output aws_lambda_hello_kitty_function_function_url {
  value = module.appcd_00a20b0a-2ec0-5bdc-a08d-65a85dc81d5b.function_url
}

output aws_lambda_hello_kitty_function_function_name {
  value = module.appcd_00a20b0a-2ec0-5bdc-a08d-65a85dc81d5b.function_name
}

output aws_lambda_hello_kitty_function_invoke_arn {
  value = module.appcd_00a20b0a-2ec0-5bdc-a08d-65a85dc81d5b.invoke_arn
}

output aws_cloudwatch_log_group_aws_lambda_hello_kitty_function_arn {
  value = module.appcd_86ec452a-770a-59bf-87dd-67ed883e25e5.arn
}

output aws_cloudwatch_log_group_aws_lambda_hello_kitty_function_name {
  value = module.appcd_86ec452a-770a-59bf-87dd-67ed883e25e5.name
}

output aws_s3_test_bucket_name {
  value = module.appcd_06a3bedf-011d-54aa-94f4-9993e8bdf8fb.bucket_name
}

output aws_s3_test_arn {
  value = module.appcd_06a3bedf-011d-54aa-94f4-9993e8bdf8fb.arn
}

output aws_s3_test_kms_arn {
  value = module.appcd_06a3bedf-011d-54aa-94f4-9993e8bdf8fb.kms_arn
}

output aws_s3_test_bucket_website_endpoint {
  value = module.appcd_06a3bedf-011d-54aa-94f4-9993e8bdf8fb.bucket_website_endpoint
}
