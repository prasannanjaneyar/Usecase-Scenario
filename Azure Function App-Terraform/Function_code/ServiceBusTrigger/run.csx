using System;
using System.Text;

public static void Run(string mySbMsg, ILogger log)
{
    log.LogInformation($"C# ServiceBus queue trigger function processed message: {mySbMsg}");
}