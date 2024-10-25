import { ethers } from "hardhat";

async function main() {
  console.log("Deploying contracts...");

  // Deploy the ProposalVote contract first
  const ProposalVote = await ethers.getContractFactory("ProposalVote");
  const proposalVote = await ProposalVote.deploy();
  await proposalVote.waitForDeployment();
  console.log("ProposalVote deployed to:", await proposalVote.getAddress());

  // Deploy the Factory
  const ProposalVoteFactory = await ethers.getContractFactory(
    "ProposalVoteFactory"
  );
  const factory = await ProposalVoteFactory.deploy();
  await factory.waitForDeployment();
  console.log("ProposalVoteFactory deployed to:", await factory.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
