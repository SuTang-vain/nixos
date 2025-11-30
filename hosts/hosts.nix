[
  {
    host = "my-nixos";
    user = "sutang";
    extraOSModules = [ ./inspiron/os.nix ];
    extraHomeModules = [ ./inspiron/home.nix ];
    extraHomeArgs = {
      nixosVersion = "unstable";
      homeManagerVersion = "master";
    };
    publicKey = " ";
  }
]
