# Multi-Machine Infrastructure Project

This project sets up a multi-machine infrastructure using Vagrant and Bash scripts. It includes a load balancer, web servers, and a master-slave database configuration.

## Project Structure

```
multi-machine-infrastructure
├── scripts
│   ├── provision-web.sh
│   ├── provision-db.sh
│   └── provision-loadbalancer.sh
├── Vagrantfile
└── README.md
```

## Virtual Machines

The following virtual machines are configured in this project:

- **lb**: Load Balancer with a static IP
- **web1**: Web Server 1 with a static IP
- **web2**: Web Server 2 with a static IP
- **db-master**: Master Database with a static IP
- **db-slave**: Slave Database with a static IP
- **monitoring**: Monitoring Server with a static IP
- **client**: Client Machine with a static IP

## Setup Instructions

1. Ensure you have Vagrant and VirtualBox installed on your machine.
2. Clone this repository to your local machine.
3. Navigate to the project directory:
   ```
   cd multi-machine-infrastructure
   ```
4. Run the following command to start the virtual machines and provision them:
   ```
   vagrant up
   ```

## Usage

After running `vagrant up`, the following services will be available:

- The load balancer will distribute traffic between the web servers.
- The web servers will serve a simple HTML page with a welcome message.
- The database setup will allow for master-slave replication.

## Scripts Overview

- **provision-web.sh**: Installs Apache and sets up a welcome page on the web servers.
- **provision-db.sh**: Configures MySQL for master-slave replication.
- **provision-loadbalancer.sh**: Installs and configures Nginx as a load balancer.

## Conclusion

This multi-machine infrastructure setup provides a scalable and efficient environment for web applications, with load balancing and database replication capabilities.