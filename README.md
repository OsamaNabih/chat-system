# README

## Running Instructions

1. Clone the repo using

    ```
    git clone https://github.com/OsamaNabih/chat-system-api
    ```

2. Run the command

    ```
    docker compose up --build -d
    ```

    *NOTE* The -d flag is for <em>detached</em> mode, which runs the services in the background. Omit to view all the logs in the same terminal.

3. If it's the first time running the app, you need to initialize the DB. <br>
    So after *ALL* the services are ready, run the following command
    ```
    docker exec -it rails_server rails db:create
    ```
    If you want some dummy data as a starter in the database, you can then run
    ```
    docker exec -it rails_server rails db:seed
    ```
    You could combine both previous commands into
    ```
    docker exec -it rails_server rails db:setup
    ```

4. You can use the Postman collection file "chat-system-api.postman_collection" to facilitate working with the API. You'll find collection variables available for your convenience.

## About

API built for a chat system using Ruby on Rails, versions 2.7.5 and 5.2.6 respectively. Redis, Elasticsearch, and Sidekiq <br>
The system has Applications, which contains Chats, each Chat has Messages inside of it. <br>
Core functionality is basic CRUD operations for the three resources as well as a _Search_ endpoint that partially matches existing messages for an Application/Chat pair with a user query string.

