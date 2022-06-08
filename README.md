## Azure Integration Services
### June 2022 
### Morten la Cour
### mlc@integration-it.com
### +45 30 11 52 95


## Table of Content
1. [Logic apps](#logic-apps)
2. [Function Apps](#function-apps)



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
