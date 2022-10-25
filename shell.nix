{ systemPkgs ? import <nixpkgs> {} }:

let lib  = systemPkgs.lib;
	pkgs = systemPkgs;

	# clangd hack.
	llvmPackages = pkgs.llvmPackages_latest;
	clang-unwrapped = llvmPackages.clang-unwrapped;
	clang  = llvmPackages.clang;
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
		stdenv = pkgs.gccStdenv;
	};

	build = pkgs.writeShellScriptBin "build" (builtins.readFile ./build.sh);

	nasm_2_14-pkgs = import (pkgs.fetchFromGitHub {
		owner  = "NixOS";
		repo   = "nixpkgs";
		rev    = "de32261d9f1bf17ae726e3332ab43ae0983414af";
		sha256 = "1ksibwb7b0xczf5aw2db0xa4iyizbnxs7x8mnrg9y3z80gx3xlvk";
	}) {};
   
	nasm = pkgs.writeShellScriptBin "nasm" ''
		${nasm_2_14-pkgs.nasm}/bin/nasm -f elf64 "$@"
	'';

	nasmfmt = pkgs.buildGo118Module {
		pname = "nasmfmt";
		version = "2.0.2-004122b";

		src = pkgs.fetchFromGitHub {
			owner  = "diamondburned";
			repo   = "nasmfmt";
			rev    = "ad0ca007ee82098d2d1547bc55748d4201875191";
			sha256 = "1sglpf5jsld00g4wnpa10v9g8pvhbh7nbnpbq7hwk03jpqj9vbza";
		};

		vendorSha256 = null;
	};

	# nasmfmt = pkgs.writeShellScriptBin "nasmfmt" ''
	# 	/home/diamond/Scripts/nasmfmt2/nasmfmt "$@"
	# '';

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
