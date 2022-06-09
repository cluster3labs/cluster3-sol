import Web3 from "web3";
import {abi as badgeNftAbi} from "./BadgeNftAbi"

/**
 * BEFORE USING THIS SCRIPT MAKE SURE TO REPLACE:
 * - <YOUR_CONTRACT_ABI>
 * - <YOUR_CONTRACT_ADDRESS>
 * - CONTRACT_ADDRESS variable value
 * - YOUR_READ_FUNCTION_NAME method name
 * - YOUR_WRITE_FUNCTION_NAME method name
 */

const ACCOUNT_PRIVATE_KEY = '0x2706b50f3a2cdad3d712817548be983022ef2a6d26f2af7d9fe304adc0ae3c9c'; // Replace this with your Ethereum private key with funds on Layer 2.
const CONTRACT_ABI = badgeNftAbi; // this should be an Array []
const CONTRACT_ADDRESS = '0x5Ee9Cae4C2B1dC34228695741C809785ecf8bc8e';

const web3 = new Web3('https://godwoken-testnet-v1.ckbapp.dev');

const account = web3.eth.accounts.wallet.add(ACCOUNT_PRIVATE_KEY);

async function readCall() {
    const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);

    const callResult = await contract.methods.YOUR_READ_FUNCTION_NAME().call({
        from: account.address
    });

    console.log(`Read call result: ${callResult}`);
}

async function writeCall() {
    const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);

    const tx = contract.methods.YOUR_WRITE_FUNCTION_NAME().send(
        {
            from: account.address,
            gas: 6000000
        }
    );

    tx.on('transactionHash', hash => console.log(`Write call transaction hash: ${hash}`));

    const receipt = await tx;

    console.log('Write call transaction receipt: ', receipt);
}

(async () => {
    const balance = BigInt(await web3.eth.getBalance(account.address));

    if (balance === 0n) {
        console.log(`Insufficient balance. Can't issue a smart contract call. Please deposit funds to your Ethereum address: ${account.address}`);
        return;
    }

    console.log('Calling contract...');

    // Check smart contract state before state change.
    await readCall();

    // Change smart contract state.
    await writeCall();

    // Check smart contract state after state change.
    await readCall();
})();
