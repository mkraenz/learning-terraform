import * as gateway from "@aws-cdk/aws-apigateway";
import * as lambda from "@aws-cdk/aws-lambda";
import * as cdk from "@aws-cdk/core";

export class AwsCdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here
    const helloLambda = new lambda.Function(this, "hello-lambda", {
      code: lambda.Code.fromAsset("lambda"),
      runtime: lambda.Runtime.NODEJS_14_X,
      handler: "hello.handler", // hello.js = filename, handler = exported function
    });
    new gateway.LambdaRestApi(this, "endpoint", {
      handler: helloLambda,
    });
  }
}
