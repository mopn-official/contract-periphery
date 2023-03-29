const { ethers } = require("hardhat");
const fs = require("fs");

describe("MOPN", function () {
  let avatarHelper;

  it("deploy ", async function () {
    const [owner] = await ethers.getSigners();

    const deployConf = loadConf();

    avatarHelper = await ethers.getContractAt("AvatarHelper", deployConf["AvatarHelper"].address);
    console.log("AvatarHelper ", avatarHelper.address);
  });

  it("test", async function () {
    console.log(await avatarHelper.getAvatarByAvatarId(1));
  });
});

function loadConf() {
  const deployConf = JSON.parse(
    fs.readFileSync("./scripts/deployconf/" + hre.network.name + ".json")
  );

  if (!deployConf) {
    console.log("no deploy config");
    console.error(error);
    process.exitCode = 1;
    return;
  }

  return deployConf;
}
