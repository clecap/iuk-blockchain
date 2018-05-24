import getopt, sys, os
from web3.auto import w3
import json

try:
    opts = getopt.getopt(sys.argv[1:], 'hc:p:', ['help', 'contract=', 'path='])
except getopt.GetoptError as e:
    print(str(e))
    usage()
    sys.exit(1)

def usage():
    print('Available options are:')
    print('  -h, --help: Print this dialog')
    print('  -c<MYCONTRACT.sol> --contract=<MYCONTRACT.sol>: name of the contract (required)')
    print('  -p<BUILD DIRECTORY>, --path=<BUILD DIRECTORY>: where to find .abi and .bin files (required)')

default_account = 0
contract_name = None
build_dir = None
for opt, arg in opts[0]:
    if opt in ('-h', '--help'):
        usage()
        sys.exit()
    elif opt in ('-c', '--contract'):
        contract_name = os.path.basename(os.path.splitext(arg)[0])
    elif opt in ('-p', '--path'):
        build_dir = arg

if not all([contract_name, build_dir]):
    usage()
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
address_file_name = contract_name + '.address'
print('Contract address: {}'.format(address))
print('Stored address in file: {}'.format(address_file_name))

with open(address_file_name, 'w') as f:
    f.write(address)
