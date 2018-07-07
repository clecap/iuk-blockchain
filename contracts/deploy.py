#!/usr/bin/env python3

import getopt, sys, os, subprocess
from web3.auto import w3
import json

def usage(failure = False):
    if not failure:
        print('Deploys contract to web3.py\'s default node '
              'and prints the address and / or the file name where the address is stored.')
    else:
        print('Error: Invalid usage!')

    print('\nAvailable options are:')
    print('  -h, --help: print help dialog')
    print('  -s, --write: write new address to web interface files')
    print('  -d, --docker: use local docker parity  network')
    print('  -c<CONTRACT_NAME.sol> --contract=<CONTRACT_NAME.sol>: name of the contract [REQUIRED]')
    print('  -p<BUILD DIRECTORY>, --path=<BUILD DIRECTORY>: where to find .abi and .bin files [REQUIRED]')

try:
    opts = getopt.getopt(sys.argv[1:], 'hwdc:p:', ['help', 'write', 'docker', 'contract=', 'path='])
except getopt.GetoptError as e:
    print(str(e))
    usage(True)
    sys.exit(1)

default_account = 0
write = False
docker = False
contract_name = None
build_dir = None
for opt, arg in opts[0]:
    if opt in ('-h', '--help'):
        usage()
        sys.exit()
    elif opt in ('-w', '--write'):
        write = True
    elif opt in ('-d', '--docker'):
        docker = True
    elif opt in ('-c', '--contract'):
        contract_name = os.path.basename(os.path.splitext(arg)[0])
    elif opt in ('-p', '--path'):
        build_dir = arg

if not all([contract_name, build_dir]):
    usage(True)
    exit(1)


suffxs = ['abi', 'bin']
file_names = {t: os.path.join(build_dir, contract_name + '.' + t) for t in suffxs}
for f in suffxs:
    assert os.path.isfile(file_names[f])


def read_file(file_name):
    with open(file_name, 'r') as f:
        yield from f.readlines()

abi_json = list(read_file(file_names['abi']))[0]
abi = json.loads(abi_json)
bytecode = list(read_file(file_names['bin']))[0]

if docker:
    fo = open('../parity-deploy/deployment/1/address.txt', 'r')
    address = fo.read()
    fo.close()
    fo = open('../parity-deploy/deployment/1/password', 'r')
    password = fo.read()
    fo.close()

    address = w3.toChecksumAddress(address.replace('\n', ''))
    password = password.replace('\n', '')

    tx_hash = w3.personal.sendTransaction({'from' : address, 'data': bytecode}, password)
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
else:
    w3.eth.defaultAccount = w3.eth.accounts[default_account]
    contract = w3.eth.contract(abi=abi, bytecode=bytecode)
    tx_hash = contract.constructor().transact()
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)

address = tx_receipt.contractAddress
print("Contract address: %s" % address)

if write:
    replace_command = "find ../client/ -type f -exec sed -i -E \"s/contractAddress = '(.+)'/contractAddress = '%s'/g\" {} \;" % (address)
    ret = subprocess.call([replace_command], shell=True)
    if ret == 0:
        print("Successfully changed contract address in web interface files")
    else:
        print("Failed to change contract address in web interface files")
