# Setup of testing environment

## 1. Install Docker and Docker Compose

### Arch Linux
Install Docker and Docker Compose from the offical Arch repositories:

```sh
sudo pacman -S docker docker-compose
```

### Other Linux distributions
Follow the instructions from the [offical Docker documentation](https://docs.docker.com/install/) and [offical Docker Compose documentation](https://docs.docker.com/compose/install/) to get the latest Docker version.

## 2. Manage Docker as a non-root user

To manage Docker containers as a non-root user you must be member of the `docker` group on your system. First create the group using the following command:

```sh
sudo groupadd docker
```

To add yourself to that group, run:

```sh
sudo useradd -aG docker $USER
```

The change will apply the next time you login to your shell.

## 3. Setup Docker containers
After that is done, you have to setup the Docker containers on your system. For that, we use a Docker deploy script provided by [paritytech](https://github.com/paritytech/parity-deploy). Navigate to the `parity-deploy` directory and run the deploy script.

```sh
cd parity-deploy
./deploy.sh
```

The deploy script creates three nodes with three accounts, each of them a validator of the PoA chain using the [Authority Round](https://wiki.parity.io/Aura) consensus algorithm. The private and public keys can be found in the `deployment` directory.

When deployment is done, you can start the Docker containers using following command (it might be necessary to start the Docker service before, e.g. using `systemctl start docker.service`):

```sh
docker-compose up -d
```

To test your setup, go to [localhost:3001](http://localhost:3001) for a status monitor and [localhost:3002](http://localhost:3002) for the contract web interface. To stop the Docker containers run:

```sh
docker-compose stop
```

To clean up the testing environment and remove all content you deployed before, simply run the clean script located in the same directory.

```sh
./clean.sh
```

## 4. Deployment of the smart contract

To deploy the smart contract into the blockchain, you need to have Web3 for Python 3 installed. This can be achieved by using the Python package manager pip3:

```sh
pip3 install web3
```

Next, navigate to the `contracts` directory and create a small helper Docker container which is used to compile the contract. This has to be done only once and can be created with the following command:

```sh
cd contracts
make solc
```

The output (ABI + binary) of the compilation process will be saved in the `build` directory. To compile the contract, run:

```sh
make
```

Of course the contract still needs to be deployed. The deploy script achieves that with the following command:

```sh
cd contracts
 ./deploy.py --docker --contract=Documents.sol --path=build
```

After successful deployment the Ethereum address of the smart contract is returned. You can get some tokens in your MetaMask wallet by using the send script. It uses one of the validators addresses to send tokens.
```sh
cd contracts
./send <your-wallet-address> <amount>
```
