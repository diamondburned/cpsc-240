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

	build = pkgs.writeShellScriptBin "build" ''
		set -e
		rm -f -- *.o *.lis *.out
		
		for f in *.asm; do
			nasm -f elf64 -o "$f.o" "$f"
		done
		for f in *.cpp; do
			g++ -g -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o "$f.o" "$f"
		done
		
		g++ -g -m64 -std=c++14 -fno-pie -no-pie -o "$(basename "$PWD").out" ./*.o
	'';

	nasm = pkgs.writeShellScriptBin "nasm" ''
		${pkgs.nasm}/bin/nasm -f elf64 "$@"
	'';

	nasmfmt = pkgs.buildGoPackage {
		pname = "nasmfmt";
		version = "94900ad";

		goPackagePath = "github.com/diamondburned/nasmfmt";

		src = pkgs.fetchFromGitHub {
			owner  = "diamondburned";
			repo   = "nasmfmt";
			rev    = "94900ad";
			sha256 = "0nmhxbpgd8w10xbwdcpvsil2jycqrfkdyhy7xqi71p2k01wf7w4a";
		};
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
