User (Browser(port 80))
      ↓
EC2 Instance (Ubuntu Server)
      ↓
Docker Engine
      ↓
┌─────────────────────────────┐
│     Docker Containers       │
│                             │
│  WordPress  ←→  MySQL (db)  │
└──────────────┬──────────────┘
               ↓
        EBS Volume (/mnt/mysql-data)

        An EBS volume is used instead of container because docker container stores MySQL data temporarily and if anything like maybe if the data is stopped ,destroyedor removed, the data is lost. But when EDS volume is used it stores the data beyond the containers to the point that even if the MySQL container crashes, it still retains the data

        I opened port 22 and port 80. Port 22 enables me to SSH into the server and port 80 allows users to access the website(wordpress). I also enabled port 22 to allow all IP addresses and this makes the server to become prone to attacks and the server is not encrypted because HTTPS wasn't enabled and this can make the users to have unauthorised access to some sensitive information.

        If the EC2 instance crashes, the users will not be able to access the website and the data inside the docker containers will be lost. But the data stored in EBS volume will survive.

        I think a load balancer and multiple EC2 instance should be created to reduce the traffic because the load balancer will help to distribute each traffic across multiple EC2 instances
