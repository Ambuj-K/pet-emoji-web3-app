<script>
    import {ethers} from 'ethers';
    export let web3Props = { 
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null, 
        contract: null 
    };

    $: image = '';
    $: fed_level = 0;
    $: entertained_level = 0;
    $: elation = 0;

    const getPetEmoji = async() => {
        let currentPetEmoji = await web3Props.contract.myPetEmoji();
        elation = await currentPetEmoji[0].toNumber();
        fed_level = await currentPetEmoji[1].toNumber();
        entertained_level = await currentPetEmoji[2].toNumber();
        image = await currentPetEmoji[4];

        web3Props.contract.on('EmojiUpdated', async() => {
            currentPetEmoji = await web3Props.contract.myPetEmoji();
            elation = await currentPetEmoji[0].toNumber();
            fed_level = await currentPetEmoji[1].toNumber();
            entertained_level = await currentPetEmoji[2].toNumber();
            image = await currentPetEmoji[4];
        });
    };

    const feedPetEmoji = async() => {
        await web3Props.contract.feed()
    }

    const entertainPetEmoji = async() => {
        await web3Props.contract.play()
    }

    // async function Mint() {
    //     status = "MINTING...";
    //     await web3Props.contract.requestNft({
    //         value: 60000000,
    //         gasLimit: 100000
    //     });

    //     web3Props.contract.on("mintedNFT", async (uri_no,addr) =>  { 
    //        NFT_json = await web3Props.contract.artURIsGetter(uri_no);
    //        const response = await fetch("https://api.ipfsbrowser.com/ipfs/get.php?hash="+NFT_json.split("//")[1]);
    //        const data = await response.json();
    //        image_url = "https://api.ipfsbrowser.com/ipfs/get.php?hash="+String(data.image).split("//")[1];
    //        status = "LOADED";
    //     });
    // }
    getPetEmoji();
</script>

<div class='wrapper'>
    <img class="image_div" src={image} alt="Loading..."/>
    <div class = 'fed_level'>
        fed_level: {fed_level}
        <br/>
        <button class='bttn' on:click={feedPetEmoji}>Feed</button>
    </div>
    <div class = 'entertained_level'>
        entertained: {entertained_level}
        <br/>
        <button class='bttn' on:click={entertainPetEmoji}>Play</button>
    </div>
    <div class = 'elation'>
        happiness: {elation}
    </div>
    <!-- {#if !NFT_json & status!="MINTING..."}
    <button class='bttn' on:click={Mint}>Mint An NFT</button>
    <br/>
    {:else if status=="MINTING..."}
    <div class="loading">
        {status}
    </div> 
    <br/>
    {:else}
    {#if image_url}
    <div class="loaded">
        {status}
    </div> 
    <br/>
        <img class="image_div" src={image_url} alt="Loading..."/>
    {/if}
    {/if} -->
</div>

<style>
    .wrapper {
        border-radius: 5px;
        padding: 20px;
        overflow: hidden;
        position: relative;
        background-color: wheat;
        box-shadow: 1px 4px 1px rgba(0, 0, 0, 0.178);
    }
    .bttn{
        background-color: pink;
        text-decoration: aqua;
    }
    .image_div{
        background-color: wheat;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
        width: 500px;
        height: 500px;
    }
    .fed_level{
        background-color: rgb(196, 255, 192);
        text-decoration: aqua;
        width: 200px;
        height: 40px;
        overflow: hidden;
        position: relative;
        text-align: center;
        text-shadow: 10ex;
        border-radius: 5px;
        padding: 10px;
        overflow: hidden;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
    .elation{
        background-color: rgb(200, 192, 255);
        text-decoration: aqua;
        width: 200px;
        height: 25px;
        overflow: hidden;
        position: relative;
        text-align: center;
        text-shadow: 10ex;
        border-radius: 5px;
        padding: 10px;
        overflow: hidden;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
    .entertained_level{
        background-color: rgb(255, 192, 230);
        text-decoration: aqua;
        width: 200px;
        height: 40px;
        overflow: hidden;
        position: relative;
        text-align: center;
        text-shadow: 10ex;
        border-radius: 5px;
        padding: 10px;
        overflow: hidden;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
</style>