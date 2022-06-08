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
