# README
ChatApp is a RESTful API that enables clients to create Applications, Chats associated to 
those applications and Messages. The project primarly aims to demonstrate how to scale and optimize a project using Redis, ElasticSearch, and Active Jobs (with sidekiq as backend).

## Features:
- Run as Multi-tenant application
Each Application is independant, and has its own collection of chats and messages. To enforce this restriction, `acts_as_tenant` was used to scope chats/messages queries
- Run queries in a separate process
Use `Redis/Sideqik` through `Active Job's` interface to send Chat Creation/ Message Creation straight to `Sideqik` to be peformed later. There are 3 separate queues enabled [Chats, Messages, Default]. The rationale behind using 3 queues was to give chat queue a higher priority than messages to lessen the possibility of messages being created before chats, since `Sideqik` runs concurrently. Using concurrency of 1 for `Sidekiq` was not an option since it is pointless and does not play well for a large scale. The [default] queue is mainly used to update chat counts and messages counts in Application and Chat Models respectively.
- Message search through ElasticSearch
Using `ElasticSearch` and `SearchKick` to partially search for messages belonging to a certain chat.

## Endpoint Documentation
- Postman Collection: https://www.getpostman.com/collections/2e7b12c5dba2eb1898c0
Postman Collection is automated. All you have to do is press `Send`. Updating environment variables is handled automatically.
- Postman Documentation: https://documenter.getpostman.com/view/4811662/SVSGQAnL?version=latest#6093b686-8d77-4e29-b6c6-16d6e19b6730

* Ruby version
2.5.5

* Rails Version
5.2

* Configuration
Run the application through docker: ```docker-compose up```
The application contains 4 containers [MySql, Redis, ElasticSearch, App, Sidekiq] 

* Database creation
To configure the project locally:
- install mysql
- cofigure ```database.yml``` with the correct mysql host, username, password
- You may leave the default configuration and run ```docker-compose up mysql```
run ```rails db:create db:migrate```

* Services (job queues, cache servers, search engines, etc.)
To enable background services:
- install and run Redis OR ```docker-compose up Redis```
- install and run Elastic-Search OR ```docker-compose up ElasticSearch```
- run sidekiq

