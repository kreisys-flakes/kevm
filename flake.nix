{
  description = "K Semantics of the Ethereum Virtual Machine (EVM)";

  inputs = {
    kevm = {
      url = "https://github.com/kframework/evm-semantics?submodules=true";
      type = "git";
      flake = false;
    };
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, kevm, utils, nixpkgs }:
    let
      name = "kevm";
      systems = [ "x86_64-darwin" "x86_64-linux" ];
      overlay = final: prev: {
        kevm.defaultPackage = final.callPackage ./package.nix { src = kevm; };
      };

      simpleFlake = utils.lib.simpleFlake {
        inherit name systems overlay self nixpkgs;
      };
    in
    simpleFlake // {
      inherit overlay;

      hydraJobs = self.packages;
    };
}
