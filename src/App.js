import './App.css';
import {useState} from 'react';
import {ethers} from 'ethers';
import Greeter from './artifacts/contracts/Greeter.sol/Greeter.json';
import Blob from './artifacts/contracts/Blob.sol/Blob.json';

const greeterAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
const blobAddress = '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0';

function App() {
  const [greeting, setGreetingValue] = useState();
  const [blob, setBlobValue] = useState();

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

  async function fetchBlob(index) {
    if (typeof window.ethereum !== 'undefined') {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(blobAddress, Blob.abi, provider);
      try {
        const data = await contract.getTokenAtIndex(index);
        console.log('data: ', data);
      } catch (err) {
        console.log('Error: ', err);
      }
    }
  }

  async function setBlob() {
    if (!blob) return;
    if (typeof window.ethereum !== 'undefined') {
      await requestAccount();
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(blobAddress, Blob.abi, signer);
      const transaction = await contract.claim(blob);
      await transaction.wait();
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <input onChange={e => setBlobValue(Number(e.target.value))} placeholder="Blob value" />
        <button onClick={setBlob}>Set Blob</button>
        <button onClick={() => fetchBlob(1)}>Fetch Blob</button>
        <br />
        <button onClick={fetchGreeting}>Fetch Greeting</button>
        <button onClick={setGreeting}>Set Greeting</button>
        <input onChange={e => setGreetingValue(e.target.value)} placeholder="Set greeting" />
      </header>
    </div>
  );
}

export default App;
