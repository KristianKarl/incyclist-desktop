{
  description = "Incyclist desktop development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          runtimeLibraries = with pkgs; [
            alsa-lib
            atk
            at-spi2-atk
            cairo
            cups
            dbus
            expat
            gdk-pixbuf
            glib
            gtk3
            libdrm
            libGL
            libgbm
            libnotify
            libsecret
            libusb1
            libX11
            libXScrnSaver
            libXcomposite
            libXcursor
            libXdamage
            libXext
            libXfixes
            libXi
            libXrandr
            libXrender
            libxcb
            libxkbcommon
            libxshmfence
            mesa
            nspr
            nss
            pango
            stdenv.cc.cc.lib
            systemd
          ];
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              gcc
              gnumake
              libusb1
              nodejs_24
              pkg-config
              python3
              systemd
            ];

            shellHook = ''
              export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibraries}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
              export NIX_LD="${pkgs.stdenv.cc.bintools.dynamicLinker}"
              export NIX_LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibraries}''${NIX_LD_LIBRARY_PATH:+:$NIX_LD_LIBRARY_PATH}"
              echo "Welcome to the Incyclist development environment. Run npm ci once, then npm run dev to start the app."
            '';
          };
        });
    };
}