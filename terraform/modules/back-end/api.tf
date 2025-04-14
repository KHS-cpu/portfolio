#Create REST api
resource "aws_api_gateway_rest_api" "count_api" {
  name = var.count_api

}

#Create resource path for api
resource "aws_api_gateway_resource" "visitor_count" {
  rest_api_id = aws_api_gateway_rest_api.count_api.id
  parent_id   = aws_api_gateway_rest_api.count_api.root_resource_id
  path_part   = "visitor_count"
}

#Create method for GET request
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.count_api.id
  resource_id   = aws_api_gateway_resource.visitor_count.id
  http_method   = "GET"
  authorization = "NONE"
}

#Integrate with Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id          = aws_api_gateway_rest_api.count_api.id
  resource_id          = aws_api_gateway_resource.visitor_count.id
  http_method          = aws_api_gateway_method.get_method.http_method
  type                 = "AWS_PROXY"
  integration_http_method = "POST"
  uri                  = aws_lambda_function.viewer_count_lambda_function.invoke_arn

}

#OPTIONS method for CORS
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.count_api.id
  resource_id   = aws_api_gateway_resource.visitor_count.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

#Integration for OPTIONS
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.count_api.id
  resource_id          = aws_api_gateway_resource.visitor_count.id
  http_method          = aws_api_gateway_method.options_method.http_method
  type                 = "MOCK"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

}

#Method response for OPTIONS
resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id          = aws_api_gateway_rest_api.count_api.id
  resource_id          = aws_api_gateway_resource.visitor_count.id
  http_method          = aws_api_gateway_method.options_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

#Integration response for OPTIONS
resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id          = aws_api_gateway_rest_api.count_api.id
  resource_id          = aws_api_gateway_resource.visitor_count.id
  http_method          = aws_api_gateway_method.options_method.http_method
  status_code          = aws_api_gateway_method_response.options_response.status_code

  depends_on = [ aws_api_gateway_integration.options_integration,
                 aws_api_gateway_method_response.options_response   
                ]    

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

}

#Permission for API gateway to execute lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "visitor_count_ID"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.viewer_count_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.count_api.execution_arn}/*/*"
}

#Deploying the API to prod stage
resource "aws_api_gateway_deployment" "visitor_count_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.count_api.id
  depends_on = [ aws_api_gateway_integration.lambda_integration,
                 aws_api_gateway_method.get_method, aws_api_gateway_integration.options_integration,
                 aws_api_gateway_method.options_method,
                 aws_api_gateway_method_response.options_response,
                 aws_api_gateway_integration_response.options_integration_response 
                ]
}

#Stage API to prod
resource "aws_api_gateway_stage" "prod_stage" {
  deployment_id = aws_api_gateway_deployment.visitor_count_api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.count_api.id
  stage_name    = "prod"
}

#API gateway stage throttle setting
resource "aws_api_gateway_method_settings" "gateway_throttle_setting" {
  rest_api_id = aws_api_gateway_rest_api.count_api.id
  stage_name  = aws_api_gateway_stage.prod_stage.stage_name
  method_path = "*/*" #To applies all path

  settings {
    throttling_rate_limit    = 200
    throttling_burst_limit   = 100
  }
}


resource "aws_s3_object" "config_js" {
  bucket = var.bucket_name
  key    = "config.js"

  content = <<EOF
window.apiConfig = {
  apiUrl: "https://${aws_api_gateway_rest_api.count_api.id}.execute-api.ap-southeast-1.amazonaws.com/prod/visitor_count"
};
EOF

  content_type = "application/javascript"
  # acl          = "public-read"
}
