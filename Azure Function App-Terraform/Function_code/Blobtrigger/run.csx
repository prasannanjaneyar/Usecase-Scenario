#r "Azure.Storage.Blobs"

using System;
using System.IO;
using Microsoft.Extensions.Logging;

public static void Run(Stream myBlob, string name, ILogger log)
{
    log.LogInformation($"C# Blob trigger function processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");
}