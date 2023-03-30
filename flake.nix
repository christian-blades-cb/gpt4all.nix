{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    src = {
      url = "github:zanussbaum/gpt4all.cpp";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          packages = {
            default = pkgs.stdenv.mkDerivation {
              pname = "gpt4all.cpp";
              version = "0.0.1";            
              
              inherit src;

              nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config ];
              buildInputs = [ pkgs.openblas ];

              dontConfigure = true;
              
              makeFlags = [ "LLAMA_OPENBLAS=1" ];

              installPhase = ''
                runHook preInstall

                install -Dm 555 chat $out/bin/chat
                install -Dm 555 quantize $out/bin/quantize

                runHook postInstall
              '';
            };
          };
        }
    );
}
