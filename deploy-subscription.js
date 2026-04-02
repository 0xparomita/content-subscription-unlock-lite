const hre = require("hardhat");

async function main() {
  const Subscription = await hre.ethers.getContractFactory("ContentSubscription");
  const sub = await Subscription.deploy();

  await sub.waitForDeployment();
  console.log("Subscription Engine deployed to:", await sub.getAddress());
  console.log("30-day Key Price: 0.05 ETH");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
