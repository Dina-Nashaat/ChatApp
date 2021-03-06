# README
ChatApp is a RESTful API that enables clients to create Applications, Chats associated to 
those applications and Messages. The project primarly aims to demonstrate how to scale and optimize a project using Redis, ElasticSearch, and Active Jobs (with sidekiq as backend).

* Ruby version
2.5.5

* Rails Version
5.2

## Features:
- Run as Multi-tenant application  
Each Application is independant, and has its own collection of chats and messages. To enforce this restriction, `acts_as_tenant` was used to scope chats/messages queries

- Run queries in a separate process  
Use `Redis/Sideqik` through `Active Job's` interface to send Chat Creation/ Message Creation straight to `Sideqik` to be peformed later. There are 4 separate queues enabled [Chats, Messages, Default, Searchkick]. The rationale behind using 3 queues was to give chat queue a higher priority than messages to lessen the possibility of messages being created before chats, since `Sideqik` runs concurrently. Using concurrency of 1 for `Sidekiq` was not an option since it is pointless and does not play well for a large scale. The [default] queue is mainly used to update chat counts and messages counts in Application and Chat Models respectively.

- Redis HashSet  
Instead of persisting directly to the database, Redis HashSet with HINCRBY were utilized to increment
messages and chats to return immediately a number for the user to utilize in future requests. HINCRBY is an atomic
opeartion, which ensures no two resources can access the same key to increment.

- Message search through ElasticSearch  
Using `ElasticSearch` and `SearchKick` to partially search for messages belonging to a certain chat. Partial text means a whole word in between the text.

- Cron Job to update ElasticSearch indices ```Model.reindex```  
A cron job that runs every 1 minute to update ElasticSearch indices.

## Endpoint Documentation
[- Postman Collection](https://www.getpostman.com/collections/2e7b12c5dba2eb1898c0)  
Postman Collection is automated. All you have to do is press `Send`. Updating environment variables is handled automatically from json response.
[- Postman Documentation](https://documenter.getpostman.com/view/4811662/SVSGQAnL?version=latest#6093b686-8d77-4e29-b6c6-16d6e19b6730)

## How to start
### Docker
* Configuration
Run the application through docker: ```docker-compose up```
The application contains 5 containers [MySql, Redis, ElasticSearch, App, Sidekiq]

### Local Machine
* Bundle Install
* Configure Database:
    - Install mysql-client
    - Cofigure ```database.yml``` with the correct mysql host, username, and password
- Run the Migration files ```rails db:create db:migrate```
- Remove {url: .. } from ````config/environment/development.rb``` from redis_cache to use the default localhost and port (default: 6379)

* Services (job queues, cache servers, search engines, etc.)  
To enable background services:
- install and run Redis
- install and run Elastic-Search
- run sidekiq

## TODO:
- Rspec
- Validations and Error Handling
- Deploy on AWS