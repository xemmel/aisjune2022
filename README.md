## Azure Integration Services
### June 2022 
### Morten la Cour
### mlc@integration-it.com
### +45 30 11 52 95


## Table of Content
1. [Logic apps](#logic-apps)
2. [Function Apps](#function-apps)
3. [Deployment](#deployment)
4. [Notes](#notes)
5. [Monitor](#monitor)
### GIT PULL

```powershell

git clone https://github.com/xemmel/aisjune2022.git


```

## Logic Apps

- Referére Trigger data TriggerOutputs()  -> TriggerBody()

- Ref -> Tidligere action outputs('[action name]') -> body('[action name]')


TriggerBody()['name']['fd']?['rrr']


Logic app syntax: 
"@TriggerBody()['name']"

"Hello @{TriggerBody()['name']}"


Compose -> const
Variable -> variable !!!!(NOT THREAD-SAFE) -> Foreach ()


[Back to top](#table-of-content)


## Function Apps

### Exercise 1

```

FunctionApp.

- Create FunctionApp i Portalen
- Create Http Trigger Function
- Get URL (From Function (Code/Test))
- Call from postman!
    - header: x-functions-key -> remove key from URL


- Storage Account from yesterday
- Create queues (messagein, messageout)
- Create Storage Queue Trigger function
    - Setup properties (queue name, new connection to storage account)

- Verify that function runs when submitting a message to the input queue

- In the function under "Integration" 
   - Add an output (Azure Queue storage, same connection, set "Queue name" to 
       messageout
   - Copy the "Message parameter name"

- In the function set (, out string outputQueueItem)

outputQueueItem = ".....";

- Save

Verify that a message is sent to messageout when function is triggered

```

[Back to top](#table-of-content)


### Function App DI

```csharp

using Microsoft.Extensions.Hosting;
var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults(
        c => c.Services.AddMyFirstIsolatedFunctionApp()
    )
    .Build();

host.Run();


//IGreetService.cs



public interface IGreetService
{
    Task<string> GetGreetingAsync(CancellationToken cancellationToken = default);
}


//HardcodedGreetService.cs

public class HardcodedGreetService : IGreetService
{
    public async  Task<string> GetGreetingAsync(CancellationToken cancellationToken = default)
    {
        return $"Hello from DI";
    }
}

//DIHelper.cs

    public static IServiceCollection AddMyFirstIsolatedFunctionApp(this IServiceCollection services)
    {
        services
                .AddScoped<IGreetService, HardcodedGreetService>()
                ;
        return services;
    }

//HttpTrigger

    public class FirstHttpTrigger
    {
        private readonly ILogger _logger;
        private readonly IGreetService _greetService;

        public FirstHttpTrigger(ILoggerFactory loggerFactory, IGreetService greetService)
        {
            _logger = loggerFactory.CreateLogger<FirstHttpTrigger>();
            _greetService = greetService;
        }

        [Function("FirstHttpTrigger")]
        public async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Function, "get")] HttpRequestData req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            string greeting = await _greetService.GetGreetingAsync();
            response.WriteString(greeting);

            return response;
        }
    }

``` 




[Back to top](#table-of-content)

## Deployment

```powershell

$rgName = "rg-your-resourceGroupName";
az group create -n $rgName -l westeurope

az deployment group create --resource-group $rgName --template-file .\Templates\logging.bicep --parameters appName=thebrandnewapp --parameters env=test

```


[Back to top](#table-of-content)

### Notes

```
Container = folder
Blob = filer



OAUTH2


Token


Http kald:
    Header:
      Authorization: Bearer [token]



```

#### Command line tools

```

Function Apps (On-prem, rigtig code)

function app cli
  -> Logged in (AZ Powershell ,AZ CLI)



(Command line Azure)

Az powershell -> Windows
Az CLI -> Linux, MAC



Powershell

Get-AzResourceGroup
New-AzResourceGroup

CLI:

az group list
az group create -ff

Login (CLI)

az login (ÅBNER DEFAULT!!! Browseren)
az login --use-device-code (ff)

Check om man er logget ind:

az account show

List subscription:

az account list -o table

Change subscription:


az account set -s 4bf83

```

[Back to top](#table-of-content)

#### Logic app syntax

```

- Referére Trigger data TriggerOutputs()  -> TriggerBody()

- Ref -> Tidligere action outputs('[action name]') -> body('[action name]')


TriggerBody()['name']['fd']?['rrr']


Logic app syntax: 
"@TriggerBody()['name']"

"Hello @{TriggerBody()['name']}"


Compose -> const
Variable -> variable !!!!(NOT THREAD-SAFE) -> Foreach ()


```

[Back to top](#table-of-content)

#### Function app CLI

```
Local Function App

Logged in in AZ!!!

az login (ÅBNER DEFAULT!!! Browseren)
az login --use-device-code (ff)

- New Folder

Create new Function App Project:

func init [projectName] --worker-runtime dotnetIsolated


Create HttpTrigger (IN PROJECT FOLDER)

func new --template HttpTrigger --name FirstHttpTrigger


func start

Get Url

Call from Postman

Create QueueTrigger

func new --template QueueTrigger --name FirstQueueTrigger

        [Function("FirstQueueTrigger")]
        public voidRun([QueueTrigger("onprem", Connection = "thecustomStorageConnection")] string myQueueItem)
        {
            _logger.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
            
        } 

local.settings.json

"thecustomStorageConnection" : "connectionString" -> Storage Account -> Access Keys -> Show ConnectionString


func start

Submit to "onprem" queue, see console log

```

[Back to top](#table-of-content)

#### Spliton

```


                "kind": "Http",
                "splitOn" : "@triggerBody()",
                "type": "Request"

```

#### Bicep/ARM deploy


```powershell

az deployment group create --resource-group $rgName --template-file .\Templates\sa.bicep --parameters .\Parameters\Prod\storageaccount.json

```
[Back to top](#table-of-content)


### Monitor

```

AppRequests
| where TimeGenerated > ago(12h)
| summarize count() by bin(TimeGenerated,10m), tostring(Success)
| render barchart 


AppRequests
| where TimeGenerated > ago(2h)
| summarize count() by bin(TimeGenerated,10m)
| render barchart 


AppRequests
| where TimeGenerated > ago(1h)
| where Success == false
| project TimeGenerated, Name, Success, DurationMs, OperationId
| order by TimeGenerated desc


AppExceptions
| where OperationId == 'cfe6e6c8f6d4cd29902e75d28c7e9a3e'


AppTraces
| where OperationId == 'cfe6e6c8f6d4cd29902e75d28c7e9a3e'

```

[Back to top](#table-of-content)
