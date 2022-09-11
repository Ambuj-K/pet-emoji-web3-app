<script>
    import WalletConnect from "../lib/WalletConnect.svelte";
    import PetEmoji from "../lib/PetEmoji.svelte"
    import contractAbi from "../contracts/PetEmoji.json";
    const contractAddr =  "0xc903540b1a5FCEa635E64B15Aec2673edC251366";
    export let web3Props = {
        provider : null,
        signer : null,
        account : null,
        chainId : null
    };
</script>

<div class="OUTER">
<h1>Welcome to Your Pet Emoji</h1>
</div>
{#if !web3Props.account}
<WalletConnect bind:web3Props {contractAddr} {contractAbi} />
{:else}
<PetEmoji bind:web3Props />
{/if}

<style>
    .OUTER {
        border-radius: 15px;
        padding: 20px;
        overflow: hidden;
        position: relative;
        background-color: rgb(214, 226, 43);
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
</style>