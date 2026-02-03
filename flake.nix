{
  inputs = {
    elm2nix = {
      url = "github:dwayne/elm2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, elm2nix }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (elm2nix.lib.elm2nix pkgs) buildElmApplication;

        build = pkgs.callPackage ./nix/build.nix { inherit buildElmApplication; };

        dev = build { name = "dev"; };
        prod = build { name = "prod"; enableDebugger = false; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "elm-super-rentals";

          packages = [
            elm2nix.packages.${system}.default
            pkgs.caddy
            pkgs.elmPackages.elm
            pkgs.elmPackages.elm-format
          ];

          shellHook = ''
            export PROJECT_ROOT="$PWD"
            export PS1="($name)\n$PS1"
          '';
        };

        packages = {
          inherit dev prod;
          default = dev;
        };

        checks = {
          inherit dev prod;
        };
      }
    );
}
