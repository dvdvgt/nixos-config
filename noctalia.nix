{ pkgs, inputs, ...}: {
  # environment.systemPackages = with pkgs; [
  #    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  # ];

  home-manager.users.david = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell.enable = true;
    programs.noctalia-shell.systemd.enable = true;
  };

  #imports = [
  #  inputs.noctalia.nixosModules.default
  #];
  #services.noctalia-shell.enable = true;
}
