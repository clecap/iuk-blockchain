import getopt, sys, os
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
    print('  -v, --verbose: verbose output')
    print('  -s, --save: store address in file <CONTRACT_NAME>.address')
    print('  -c<CONTRACT_NAME.sol> --contract=<CONTRACT_NAME.sol>: name of the contract [REQUIRED]')
    print('  -p<BUILD DIRECTORY>, --path=<BUILD DIRECTORY>: where to find .abi and .bin files [REQUIRED]')

try:
    opts = getopt.getopt(sys.argv[1:], 'hvsc:p:', ['help', 'verbose', 'save', 'contract=', 'path='])
except getopt.GetoptError as e:
    print(str(e))
    usage(True)
    sys.exit(1)

default_account = 0
verbose = False
dump_addr = False
contract_name = None
build_dir = None
for opt, arg in opts[0]:
    if opt in ('-h', '--help'):
        usage()
        sys.exit()
    elif opt in ('-v', '--verbose'):
        verbose = True
    elif opt in ('-s', '--save'):
        dump_addr = True
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

w3.eth.defaultAccount = w3.eth.accounts[default_account]
contract = w3.eth.contract(abi=abi, bytecode=bytecode)
tx_hash = contract.constructor().transact()
tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)

address = tx_receipt.contractAddress

if verbose or not dump_addr:
    temp = 'Contract address: {}' if verbose else '{}'
    print(temp.format(address))

if dump_addr:
    address_file_name = contract_name + '.address'
    temp = 'Stored address in file: {}' if verbose else '{}'
    print(temp.format(address_file_name))

    with open(address_file_name, 'w') as f:
        f.write(address)
