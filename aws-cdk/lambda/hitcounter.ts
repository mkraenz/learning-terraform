import type { APIGatewayProxyEvent, Handler } from "aws-lambda";
import { DynamoDB, Lambda } from "aws-sdk";

export interface HitCounterEnv {
  HITS_TABLE_NAME: string;
  DOWNSTREAM_FUNCTION_NAME: string;
}

export const handler: Handler<APIGatewayProxyEvent, Lambda._Blob | undefined> =
  async (event) => {
    console.log("request", event);

    const env: Partial<HitCounterEnv> = process.env;
    assertEnvSet(env);
    const dynamo = new DynamoDB();
    await dynamo
      .updateItem({
        TableName: env.HITS_TABLE_NAME,
        Key: { path: { S: event.path } },
        UpdateExpression: "ADD hits :incr",
        ExpressionAttributeValues: { ":incr": { N: "1" } },
      })
      .promise();
    const lambda = new Lambda();
    const res = await lambda
      .invoke({
        FunctionName: env.DOWNSTREAM_FUNCTION_NAME,
        Payload: JSON.stringify(event),
      })
      .promise();
    console.log("downstream response:", { res });
    return JSON.parse(res.Payload as unknown as string);
  };

function assertEnvSet(
  env: Partial<HitCounterEnv>
): asserts env is HitCounterEnv {
  if (!env.HITS_TABLE_NAME || !env.DOWNSTREAM_FUNCTION_NAME) {
    throw new Error("Missing env var");
  }
}
