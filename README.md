# Backup & Restore Challenge

This project is related to the [HackAttic Backup & Restore challenge](https://hackattic.com/challenges/backup_restore).

## Prerequisites

- Register on the HackAttic website and obtain your `ACCESS_TOKEN`.
- You can run this project on any device that supports Docker.
- Make sure you have Docker and Docker Compose installed and running.  
  (Most likely you will need Docker Desktop, which includes both the Docker daemon and Docker Compose.)

## Setup & Run

1. Clone this repository:

   ```
   git clone <repository_url>
   cd <repository_directory>
   ```
2. Export the necessary environment variables:

   ```
   export PGPASSWORD=your_postgres_password
   export ACCESS_TOKEN=your_hackattic_access_token
3. Build and start the containers:

    ```
    docker-compose up --build
    ```
The application will then run using the provided environment variables.
If you have any questions or issues, please feel free to reach out!
