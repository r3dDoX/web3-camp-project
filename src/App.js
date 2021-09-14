import './App.css';
import {useState} from 'react';
import {ethers} from 'ethers';
import Wands from './artifacts/contracts/Wands.sol/Wands.json';
import wandsAddress from './wands-contract-address.json';

function App() {
  const [wands, setWands] = useState([]);

  async function requestAccount() {
    await window.ethereum.request({method: 'eth_requestAccounts'});
  }

  async function mintWand() {
    if (typeof window.ethereum !== 'undefined') {
      await requestAccount();
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(wandsAddress, Wands.abi, signer);
      const transaction = await contract.safeMint(await signer.getAddress());
      await transaction.wait();
    }
  }

  async function fetchWands() {
    if (!window.ethereum) {
      return;
    }

    await requestAccount();
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(wandsAddress, Wands.abi, signer);
    const address = await signer.getAddress();
    const balance = await contract.balanceOf(address);

    setWands([]);

    for (let i = 0; i < balance; i++) {
      const token = await contract.tokenOfOwnerByIndex(address, i);
      const wand = await contract.getWand(token);
      setWands((prevWands) => [...prevWands, {tokenId: parseInt(token._hex), ...wand}]);
    }
  }

  return (
    <div className="App">
      <button onClick={mintWand}>Mint Wand</button>
      <button onClick={fetchWands}>Fetch Wands</button>
      <div className="blobs">
        {wands.map((wand, index) => (
          <p key={index}>
            Wand #{wand.tokenId}<br /><br />
            Fire: {wand.fire}<br />
            Frost: {wand.frost}<br />
            Arcane: {wand.arcane}<br />
            Style: {wand.style}<br />
          </p>
        ))}
      </div>
    </div>
  );
}

export default App;
