{
	pkgs ? import <nixpkgs> {},
	fetchFromGitHub ? pkgs.fetchFromGitHub,
}:

let
	lib = pkgs.lib;

	lockedNixpkgs = fetchFromGitHub {
		owner  = "NixOS";
		repo   = "nixpkgs";
		rev    = "de32261d9f1bf17ae726e3332ab43ae0983414af";
		sha256 = "1ksibwb7b0xczf5aw2db0xa4iyizbnxs7x8mnrg9y3z80gx3xlvk";
	};

	lockedPkgs = import lockedNixpkgs {};

	llvmPackages = lockedPkgs.llvmPackages_latest;
	clang-unwrapped = llvmPackages.clang-unwrapped;
	clang = llvmPackages.clang;

	# clangd hack.
	clangd = pkgs.writeScriptBin "clangd" ''
	    #!${pkgs.stdenv.shell}
		export CPATH="$(${clang}/bin/clang -E - -v <<< "" \
			|& ${pkgs.gnugrep}/bin/grep '^ /nix' \
			|  ${pkgs.gawk}/bin/awk 'BEGIN{ORS=":"}{print substr($0, 2)}' \
			|  ${pkgs.gnused}/bin/sed 's/:$//')"
		export CPLUS_INCLUDE_PATH="$(${clang}/bin/clang++ -E - -v <<< "" \
			|& ${pkgs.gnugrep}/bin/grep '^ /nix' \
			|  ${pkgs.gawk}/bin/awk 'BEGIN{ORS=":"}{print substr($0, 2)}' \
			|  ${pkgs.gnused}/bin/sed 's/:$//')"
	    ${clang-unwrapped}/bin/clangd
	'';

	mkshell = pkgs.mkShell.override {
		stdenv = lockedPkgs.gccStdenv;
	};

	build = pkgs.writeShellScriptBin "build" (builtins.readFile ./build.sh);

	nasm = pkgs.writeShellScriptBin "nasm" ''
		${lockedPkgs.nasm}/bin/nasm -f elf64 "$@"
	'';

	nasmfmt = pkgs.buildGoModule {
		pname = "nasmfmt";
		version = "2.1.1";

		src = fetchFromGitHub {
			owner  = "diamondburned";
			repo   = "nasmfmt";
			rev    = "v2.1.1";
			sha256 = "sha256-7KAM+tjRP9d0S4yfH1K7I4ps2sABQqyhRRSP8i0uS2U=";
		};

		vendorSha256 = null;
	};

	PROJECT_ROOT   = builtins.toString ./.;
	PROJECT_SYSTEM = pkgs.system;

in mkshell {
	# Poke a PWD hole for our shell scripts to utilize.
	inherit PROJECT_ROOT PROJECT_SYSTEM;

	buildInputs = with pkgs; [
		automake
		autoconf
		curl
		gdb
		git
		nasm
		nasmfmt
		objconv
	] ++ [
		clangd
		clang
		build
	];

	hardeningDisable = [ "fortify" ];
}
