## Project file

```xml

  <ItemGroup>
    <PackageReference Include="Microsoft.Azure.Relay" Version="2.0.15596" />
  </ItemGroup>

```

## Program.cs

```csharp

// See https://aka.ms/new-console-template for more information
using System.Text.Json;
using Microsoft.Azure.Relay;
using relayapp;

Console.WriteLine("Hello, World!");


string keyName = "Listener";
string key = "87xlMd48TLHuje0sAX0HiWWwV+vttZZlrwsmhDmKVeI=";

string hybridName = "myonpremendpoint";
string relayName = "copenhagen";


var list = GetListener();

list.Connecting += (o, e) => { Console.WriteLine("Connecting..."); };
list.Online += (o, e) => { Console.WriteLine("Online..."); };

list.RequestHandler = SomebodyCalled;

await list.OpenAsync();

await Console.In.ReadLineAsync();

async void SomebodyCalled(RelayedHttpListenerContext context)
{

    Request? req = await JsonSerializer
                           .DeserializeAsync<Request>(
                               utf8Json: context.Request.InputStream,
                               options: new JsonSerializerOptions { PropertyNameCaseInsensitive = true });


    System.Console.WriteLine($"Somebody called. Using method: {req.Method}");

    string response = "here is the file content";
    context.Response.Headers.Add("content-type", "text/plain");

    using (var sw = new StreamWriter(context.Response.OutputStream))
    {
        await sw.WriteLineAsync(response);
    }
    context.Response.Close();
}

HybridConnectionListener GetListener()
{
    string ns = $"{relayName}.servicebus.windows.net";
    string hc = hybridName;

    var listener = new HybridConnectionListener
        (new Uri(String.Format("sb://{0}/{1}", ns, hc)),
        GetTokenProvider());
    return listener;
}

TokenProvider GetTokenProvider()
{
    string kn = keyName;
    string k = key;
    var result = TokenProvider.CreateSharedAccessSignatureTokenProvider(kn, k);
    return result;
}

```csharp

## Request.cs

```csharp

namespace relayapp;

public class Request
{
    public string Method { get; set; }
}


```