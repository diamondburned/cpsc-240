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

		CXXFLAGS+="-g -m64 -std=c++17 -fsanitize=address -fstack-protector -fno-pie -no-pie"
		
		for f in *.asm; do
			nasm -f elf64 -o "$f.o" "$f"
		done
		for f in *.cpp; do
			g++ -c -Wall $CXXFLAGS -o "$f.o" "$f"
		done
		
		g++ $CXXFLAGS -o "$(basename "$PWD").out" ./*.o
	'';

	nasm = pkgs.writeShellScriptBin "nasm" ''
		${pkgs.nasm}/bin/nasm -f elf64 "$@"
	'';

	nasmfmt = pkgs.buildGo118Module {
		pname = "nasmfmt";
		version = "2.0.1-1026bf3";

		src = pkgs.fetchFromGitHub {
			owner  = "diamondburned";
			repo   = "nasmfmt";
			rev    = "1026bf3";
			sha256 = "18mbijf0llz2yfbf0l6jv4micsqd3pb9l91hbl62c5hwv3la73sq";
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
