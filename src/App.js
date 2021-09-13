import './App.css';
import {useState} from 'react';
import {ethers} from 'ethers';
import Greeter from './artifacts/contracts/Greeter.sol/Greeter.json';
import Blob from './artifacts/contracts/Blob.sol/Blob.json';
import version from './blob-contract-address.json'

const greeterAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
const blobAddress = version;

function App() {
  const [greeting, setGreetingValue] = useState();

  async function requestAccount() {
    await window.ethereum.request({method: 'eth_requestAccounts'});
  }

  async function fetchGreeting() {
    if (typeof window.ethereum !== 'undefined') {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, provider);
      try {
        const data = await contract.greet();
        console.log('data: ', data);
      } catch (err) {
        console.log('Error: ', err);
      }
    }
  }

  // call the smart contract, send an update
  async function setGreeting() {
    if (!greeting) return;
    if (typeof window.ethereum !== 'undefined') {
      await requestAccount();
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, signer);
      const transaction = await contract.setGreeting(greeting);
      await transaction.wait();
      fetchGreeting();
    }
  }

  async function mintBlob() {
    if (typeof window.ethereum !== 'undefined') {
      await requestAccount();
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(blobAddress, Blob.abi, signer);
      const transaction = await contract.safeMint(await signer.getAddress());
      await transaction.wait();
    }
  }

  async function fetchBlobs() {
    if (!window.ethereum) {
      return;
    }

    await requestAccount();
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(blobAddress, Blob.abi, signer);
    const address = await signer.getAddress();
    const balance = await contract.balanceOf(address);

    for (let i = 0; i < balance; i++) {
      const token = await contract.tokenOfOwnerByIndex(address, i);
      console.log("token URI:", await contract.tokenURI(token));
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <button onClick={mintBlob}>Mint Blob</button>
        <button onClick={fetchBlobs}>Fetch Blobs</button>
        <br />
        <button onClick={fetchGreeting}>Fetch Greeting</button>
        <button onClick={setGreeting}>Set Greeting</button>
        <input onChange={e => setGreetingValue(e.target.value)} placeholder="Set greeting" />
      </header>
    </div>
  );
}

export default App;
