import * as hre from "hardhat";

async function main() {
  const [owner] = await hre.ethers.getSigners();
  console.log("Deploying contract with the account: ", owner.address);
  const tokenContract = await hre.ethers.deployContract("Token", [
    owner.address,
    50000,
    200,
    "0xd85c9f508045B816a7dd26c5928eAC125D44682D",
  ]);
  await tokenContract.waitForDeployment();

  console.log("Smart contract token deployed successfully to: ", tokenContract);
}

main().catch((error) => {
  console.log(error);
  process.exit(1);
});
