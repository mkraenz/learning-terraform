import { Bucket } from "@aws-cdk/aws-s3";
import * as cdk from "@aws-cdk/core";

export class AwsCdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    new Bucket(this, "awscdkbucket", {
      versioned: true,
      bucketName: "my-bucket-name",
    });

    // The code that defines your stack goes here
  }
}
