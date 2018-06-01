# working-with-azure-cosmos-db

Tutorial illustrating how to work with Azure Cosmos DB

![Final Environment](https://user-images.githubusercontent.com/3911650/40856764-3b026130-6596-11e8-9cff-a39e35117397.png)

## Getting Started

An Azure RM template is included in `infrastructure/` to create the environment:

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Flrakai%2Fworking-with-azure-cosmos-db%2Fmaster%2Finfrastructure%2Farm-template.json">
    <img src="https://camo.githubusercontent.com/536ab4f9bc823c2e0ce72fb610aafda57d8c6c12/687474703a2f2f61726d76697a2e696f2f76697375616c697a65627574746f6e2e706e67" data-canonical-src="http://armviz.io/visualizebutton.png" style="max-width:100%;">
</a>

Using Azure PowerShell, do the following to provision the resources:

```ps1
.\startup.ps1
```

Alternatively, you can perform a one-click deploy with the following button:

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Flrakai%2Fworking-with-azure-cosmos-db%2Fmaster%2Finfrastructure%2Farm-template.json">
    <img src="https://camo.githubusercontent.com/9285dd3998997a0835869065bb15e5d500475034/687474703a2f2f617a7572656465706c6f792e6e65742f6465706c6f79627574746f6e2e706e67" data-canonical-src="http://azuredeploy.net/deploybutton.png" style="max-width:100%;">
</a>

## Following Along

1. Create a MongoDB API Cosmos DB account replicated in the regions you desire
1. Create a stocks database and a ticker collection
1. Create a custom Azure function with a Cosmos DB trigger
1. Replace the default run.csx C# script with the following function:
    ```csharp
    #r "Microsoft.Azure.Documents.Client"
    #r "Newtonsoft.Json"
    using System;
    using System.Collections.Generic;
    using Microsoft.Azure.Documents;

    public static void Run(IReadOnlyList<Document> documents, TraceWriter log)
    {
        if (documents != null && documents.Count > 0)
        {
            log.Verbose($"Documents modified {documents.Count}");
            log.Verbose($"First document: {documents[0].ToString()}");
            var doc = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(documents[0].ToString());
            var symbol = doc["$v"]["id"]["$v"].ToString();
            if (symbol == "ABC") {
                var price = (double)doc["$v"]["price"]["$v"];
                if (price > 15) {
                    log.Info("Sell ABC!");
                }
                else if (price < 10) {
                    log.Info("Buy ABC!");
                }
            }
        }
    }
    ```
1. Insert the following document into the MongoDB collection:
    ```json
    {
        "id": "ABC",
        "price": 22.13
    }
    ```
1. Check the Function monitoring log for the buy/sell signal

## Tearing Down

When finished, remove the Azure resources with:

```ps1
.\teardown.ps1
```