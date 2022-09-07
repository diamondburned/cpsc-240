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
   
	nasm = pkgs.writeShellScriptBin "nasm" ''
		${pkgs.nasm}/bin/nasm -f elf64 "$@"
	'';

	nasmfmt = pkgs.buildGo118Module {
		pname = "nasmfmt";
		version = "2.0.2-004122b";

		src = pkgs.fetchFromGitHub {
			owner  = "diamondburned";
			repo   = "nasmfmt";
			rev    = "004122b";
			sha256 = "1a8sl75xpvdgrscsqpi231nfn2kmmqrbqqngd6jpahy4y9klj5sf";
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
	] ++ [
		clangd
		clang
		build
	];
}
