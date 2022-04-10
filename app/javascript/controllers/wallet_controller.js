import { Controller } from "@hotwired/stimulus"
import { ethers } from 'ethers';

export default class extends Controller {
  static targets = [ "form", "address", "sig", "message", "nonce" ]

  establishConnection(event) {
    event.preventDefault();

    if (typeof window.ethereum !== 'undefined') {
      this.signMessage();
    } else {
      alert('MetaMask not installled...');
    }
  }

  async signMessage() {
    const message = `
      Welcome to PROOF Profiles
      =========================
      An unofficial PROOF community project

      Please sign this transaction with an account
      with a valid PROOF collective NFT to sign in

      nonce:<${this.nonceTarget.value}>
    `
    await ethereum.request({ method: 'eth_requestAccounts' });
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const signature = await signer.signMessage(message);
    const address = await signer.getAddress();

    this.setValuesAndSubmit(address, signature, message);
  }

  setValuesAndSubmit(address, sig, message) {
    this.sigTarget.value = sig;
    this.addressTarget.value = address;
    this.messageTarget.value = message;

    this.formTarget.submit();
  }
}
