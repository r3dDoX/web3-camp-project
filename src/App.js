import './App.css';
import {useState} from 'react';
import {ethers} from 'ethers';
import Blob from './artifacts/contracts/Blob.sol/Blob.json';
import blobAddress from './blob-contract-address.json';

function App() {
  const [blobs, setBlobs] = useState([]);

  async function requestAccount() {
    await window.ethereum.request({method: 'eth_requestAccounts'});
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
      const tokenUri = await contract.tokenURI(token);
      const decodedToken = JSON.parse(atob(tokenUri.split(',')[1]));
      setBlobs((prevBlobs) => [...prevBlobs, decodedToken]);
    }
  }

  return (
    <div className="App">
      <button onClick={mintBlob}>Mint Blob</button>
      <button onClick={fetchBlobs}>Fetch Blobs</button>
      <div className="blobs">
        {blobs.map((blob, index) => <img key={index} src={blob.image} alt={blob.name}/>)}
      </div>
    </div>
  );
}

export default App;
