## Testing environment setup

The Ethereum blockchain for the IuK-Chair runs on Docker. To install Docker, use one of the following commands depending on your packet manager

    apt-get install docker docker-compose
    pacman -S docker docker-compose

or download pre-build binaries directly from GitHub

    wget https://github.com/docker/app/releases/download/v0.2.0/docker-app-linux.tar.gz
    tar xf docker-app-linux.tar.gz
    cp docker-app-linux /usr/local/bin/docker-app

To use docker you must be member of the "docker" group on your system. To add yourself to that group, run

    useradd -G docker <username>

After that is done, you will have to deploy the docker image on your system. For that, we use a docker deploy script provided by [paritytech](https://github.com/paritytech/parity-deploy). Navigate to the parity-deploy directory and run the deploy script. When deployment is done, you can run the docker image using the run script:

    cd parity-deploy
    ./deploy.sh
    ./run.sh

Now, to test your setup, got to [localhost:3001](localhost:3001) for a status monitor and [localhost:3002](localhost:3002) for the contract web interface. To stop the all nodes, run

    docker-compose stop

and if you want to remove all docker content you deployed before, simply run the cleanup script located in the same directory

    ./clean.sh

## Deployment the contract

Now, to get a custom contract into the blockchain, we need to have web3 for Python3 installed. This can be achieved by using pip3

    pip3 install web3

Then, navigate to the contracts directory and use Make to compile the contract

    cd contracts
    make solc

Of course the contract still needs to be deployed. The Docker deploy script achieves that with the following command

    cd ../parity-deploy
    ./deploy.sh --docker --contract=Documents.sol --path=<build-path>

This also returns the Ethereum adress of the contract. To make the web interface work with the deployed contract, paste that address in the HTML files appropriately.
