# README

## Running Instructions

1. Clone the repo using

    ```
    git clone https://github.com/OsamaNabih/chat-system
    ```

2. Run the command inside the cloned repo (This may take a while)

    ```
    docker compose up --build -d
    ```

    *NOTE* The -d flag is for <em>detached</em> mode, which runs the services in the background. Omit to view all the logs in the same terminal.

3. *OPTIONAL*
    If you want some starter dummy data, you can run
    *NOTE*: If you ran the _up_ command in the foreground, you'll need to open a new terminal for the following commands. <br>
    ```
    docker exec -it rails_server rails db:seed
    ```

4. You can use the Postman collection file "chat-system.postman_collection" to facilitate working with the API. You'll find collection variables available for your convenience.

## Re-runs 
1. To flush the Redis cache, you can run
  ```
  docker exec -it redis redis-cli FLUSHALL
  ```
2. To remove all data from Elasticsearch, run the appropriate Request for that in the Postman collection.

## About

API built for a chat system using Ruby on Rails, versions 2.7.5 and 5.2.6 respectively. Redis, Elasticsearch, and Sidekiq <br>
The system has Applications, which contains Chats, each Chat has Messages inside of it. <br>
Core functionality is basic CRUD operations for the three resources as well as a _Search_ endpoint that partially matches existing messages for an Application/Chat pair with a user query string.

