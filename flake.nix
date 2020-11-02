{
  description = "K Semantics of the Ethereum Virtual Machine (EVM)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/76aafbf4bf4992c82da41ccefd8c6d481744524c";
  inputs.nixpkgs.flake = false;
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, utils, nixpkgs }:
    let
      name = "kevm";
      systems = [ "x86_64-darwin" "x86_64-linux" ];
      overlay = final: prev: {
        kevm.defaultPackage = final.callPackage ./package.nix {};
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
