# Generated by pip2nix 0.8.0.dev1
# See https://github.com/nix-community/pip2nix

{ pkgs, fetchurl, fetchgit, fetchhg }:

self: super: {
  "PyYAML" = super.buildPythonPackage rec {
    pname = "PyYAML";
    version = "6.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz";
      sha256 = "18imkjacvpxfgg1lbpraqywx3j7hr5dv99d242byqvrh2jf53yv8";
    };
    format = "setuptools";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "colorama" = super.buildPythonPackage rec {
    pname = "colorama";
    version = "0.4.6";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/d1/d6/3965ed04c63042e047cb6a3e6ed1a63a35087b6a609aa3a15ed8ac56c221/colorama-0.4.6-py2.py3-none-any.whl";
      sha256 = "1ijz53xpmxds2qf02l9yf0rnp7bznwh3ci4xkw8wmh5cyn8rj7ag";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "intervaltree" = super.buildPythonPackage rec {
    pname = "intervaltree";
    version = "3.1.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz";
      sha256 = "0bcm6c6r4ck9nfj9xwz4rm2swc5lrjvmw3lyl6rgj639jf41nawh";
    };
    format = "setuptools";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      self."sortedcontainers"
    ];
  };
  "n64img" = super.buildPythonPackage rec {
    pname = "n64img";
    version = "0.3.3";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/87/6d/9480bcb7a31d6e96a0a8923c9b64812db0e480921bc988fcbfbce3ddf7a4/n64img-0.3.3-py3-none-any.whl";
      sha256 = "08brjhb2lw459f3xpwfqq7vzlkvh44i846d3fnw08d0g63inkdax";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      self."pypng"
    ];
  };
  "pygfxd" = super.buildPythonPackage rec {
    pname = "pygfxd";
    version = "1.0.1";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/6b/00/0c6c19ee548b3c2b1e29b2cf55fc5a7fc4ba6f74befabceefce67ad4c00e/pygfxd-1.0.1.tar.gz";
      sha256 = "00sqvqffz04g5r3hcxjabz5klwaykr8mb7w9ji46maksfzdfm3vm";
    };
    format = "setuptools";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "pylibyaml" = super.buildPythonPackage rec {
    pname = "pylibyaml";
    version = "0.1.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/c9/1a/3ae773a0d4cc0b787d1b7307786c666de0729df2c4159ec964e8ba45d06d/pylibyaml-0.1.0.tar.gz";
      sha256 = "0gk2a0wspcsz8b9qp07hh9gczxs9q4zbdyimkrl08g4hc6hdwn1v";
    };
    format = "setuptools";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "pypng" = super.buildPythonPackage rec {
    pname = "pypng";
    version = "0.20220715.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/3e/b9/3766cc361d93edb2ce81e2e1f87dd98f314d7d513877a342d31b30741680/pypng-0.20220715.0-py3-none-any.whl";
      sha256 = "0b4hxpz4qapknpapz59zdb6l3qy7iqd6qlqmljrazapmp1lyjhsa";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "rabbitizer" = super.buildPythonPackage rec {
    pname = "rabbitizer";
    version = "1.7.4";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/3c/ca/9b3c0f13af224bd99cad86b784c75df27d78b85dd3425a5d28a57704b7bd/rabbitizer-1.7.4.tar.gz";
      sha256 = "19ayfnnjgjw7v20qppm0rl1y5xnilm87yki85bjm8p8915wfrahk";
    };
    format = "setuptools";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "sortedcontainers" = super.buildPythonPackage rec {
    pname = "sortedcontainers";
    version = "2.4.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/32/46/9cb0e58b2deb7f82b84065f37f3bffeb12413f947f9388e4cac22c4621ce/sortedcontainers-2.4.0-py2.py3-none-any.whl";
      sha256 = "1q3y4gdrb1d3595sxqlpk0j783hr8n9a6mz9hla0470gvspdqqx1";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
  "spimdisasm" = super.buildPythonPackage rec {
    pname = "spimdisasm";
    version = "1.15.3";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/56/7a/3239f70bd13e744479befc3787b5c7e95a280340e899cd1289095462aceb/spimdisasm-1.15.3-py3-none-any.whl";
      sha256 = "1acpmjnjsm4b7d2jrymg5xxw4537g626sx7si79p1l825xqg79ng";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      self."rabbitizer"
    ];
  };
  "tqdm" = super.buildPythonPackage rec {
    pname = "tqdm";
    version = "4.65.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/e6/02/a2cff6306177ae6bc73bc0665065de51dfb3b9db7373e122e2735faf0d97/tqdm-4.65.0-py3-none-any.whl";
      sha256 = "0wcnkv4ysw5a61p2w71qp7hzzs0vccic1vmwba0k5q9pzqbkmxf4";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
}
