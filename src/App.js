import './App.css';
import {useRef, useState} from 'react';
import {ethers} from 'ethers';
import Wands from './artifacts/contracts/Wands.sol/Wands.json';

let wandsAddress;
if (process.env.REACT_APP_CONTRACT_ADDRESS) {
  wandsAddress = process.env.REACT_APP_CONTRACT_ADDRESS;
} else {
  import('./wands-contract-address.json').then(module => wandsAddress = module.default);
}

function App() {
  const textInput = useRef(null);
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
      const transaction = await contract.safeMint(await signer.getAddress(), textInput.current.value);
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
      const encodedToken = await contract.tokenURI(token);
      const decodedToken = JSON.parse(atob(encodedToken.split(',')[1]));
      const wand = await contract.getWand(token);
      setWands((prevWands) => [...prevWands, { tokenId: parseInt(token._hex), ...decodedToken, ...wand}]);
    }
  }

  return (
    <div className="App">
      <input ref={textInput} placeholder="Token to mint" />
      <button onClick={mintWand}>Mint Wand</button>
      <button onClick={fetchWands}>Fetch Wands</button>
      <div className="blobs">
        {wands.map((wand, index) => (
          <div key={index}>
            <img src={wand.image} alt={wand.name} />
            <p>
              Wand #{wand.tokenId}<br/><br/>
              Fire: {wand.fire}<br/>
              Frost: {wand.frost}<br/>
              Arcane: {wand.arcane}<br/>
              Style: {wand.style}<br/>
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
