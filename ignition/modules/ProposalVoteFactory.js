const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("ProposalVoteFactoryModule", (m) => {
  const ProposalVoteFactory = m.contract("ProposalVoteFactory");

  return { ProposalVoteFactory };
});

// export default ProposalVoteFactoryModule;
