## Testing environment setup

The Ethereum blockchain for the IuK-Chair runs on Docker. In order to install Docker on your system, simply run

    sudo apt-get install docker docker-compose

if you are on Ubuntu, or

    sudo pacman -S docker docker-compose

if you are on Arch-Linux.

To use docker you must be member of the "docker" group on your system. To add yourself to that group, run

    sudo useradd -G docker <username>

After that is done, you will have to deploy the docker image on your system. For that, we use a docker deploy script provided by [paritytech](https://github.com/paritytech/parity-deploy). Navigate to the parity-deploy directory and run the deploy script. When deployment is done, you can run the docker image using the run script:

    cd parity-deploy
    bash deploy.sh
    bash run.sh

Now, to test your setup, got to [localhost:3001](https://localhost:3001) for a status monitor and [localhost:3002](https://localhost:3002) for the contract web interface. To stop the all nodes, run

    docker-compose stop

and if you want to remove all docker content you deployed before, simply run the cleanup script located in the same directory

    bash clean.sh

## Deployment the contract

coming soon...