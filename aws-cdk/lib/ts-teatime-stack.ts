import * as ecs from "@aws-cdk/aws-ecs";
import * as ecs_patterns from "@aws-cdk/aws-ecs-patterns";
import * as cdk from "@aws-cdk/core";

export class TsTeatimeStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // https://docs.aws.amazon.com/cdk/latest/guide/ecs_example.html
    // https://docs.aws.amazon.com/cdk/latest/guide/about_examples.html
    // https://aws.amazon.com/de/blogs/compute/access-private-applications-on-aws-fargate-using-amazon-api-gateway-privatelink/
    // https://aws.amazon.com/de/documentdb
    // https://medium.com/adobetech/deploy-microservices-using-aws-ecs-fargate-and-api-gateway-1b5e71129338
    const cluster = new ecs.Cluster(this, "ECSCluster");
    const image = ecs.ContainerImage.fromAsset(".");
    new ecs_patterns.ApplicationLoadBalancedFargateService(
      this,
      "FargateService",
      {
        cluster,
        taskImageOptions: {
          image,
        },
      }
    );
  }
}
