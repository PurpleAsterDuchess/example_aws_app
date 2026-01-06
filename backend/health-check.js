module.exports.handler = async (event) => {
  console.log("Event: ", event);
  let responseMessage = "Success! The health check passed.";
  
  if (event.queryStringParameters && event.queryStringParameters["Name"]) {
    responseMessage = "Success! The health check passed, " + event.queryStringParameters["Name"] + "!";
  }

  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  };
};
