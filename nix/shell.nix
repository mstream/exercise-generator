let 
  sources = import ./sources.nix;
  pkgs = import sources.nixpkgs {};
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      openapi-generator-cli
      dhall-json
    ];
  }
