{config, pkgs, inputs, ...}:
let
  home-dir = "/home/david";
in {
  
  home.username ="david";
  home.homeDirectory = home-dir;

  home.packages = with pkgs; [
    spotify
    slack
    evolution
    nautilus
    
    rustup
    gcc

    fira-code
    # only the hinted version seem to render `=>` correctly
    maple-mono.truetype-autohint
    maple-mono.NF
    maple-mono.NF-CN

    vscodium
    typst
    coursier
    jdk21
    jetbrains.idea
  ];

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/niri";
    recursive = true;
  };

  xdg.configFile."ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/ghostty";
    recursive = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-aplication-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-aplication-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk21}";
  };

  home.sessionPath = [
    "$HOME/.local/share/coursier/bin"
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    history.size = 10000;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      conf = "hx /etc/nixos/configuration.nix";
      home = "hx /etc/nixos/home.nix";
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "dvdvgt";
      user.email = "40773635+dvdvgt@users.noreply.github.com";
      color.ui = "auto";
      core.editor = "hx";
      push.default = "simple";
      pull.rebase = true;
      rebase.autoStash = true;
      diff = {
        colorMoved = "zebra";
        mnemonicprefix = true;
      };      
      init.defaultBranch = "main";
      submodule.recurse = true;
      fetch.recurseSubmodules = true;
    };
    aliases = {
      st = "status";
      co = "checkout";
      cob = "checkout -b";
      undo = "reset HEAD~1 --mixed";
      discard = "restore --worktree --";
      unstage = "restore --staged --";
      lg = "log --oneline --graph --all --decorate --abbrev-commit --date=relative --pretty=format:'%C(auto)%C(bold green)%h%C(reset): %s %C(dim white)- [%an, %ad]%C(reset)%C(bold red)%d%C(reset)%C(auto)'";
      br = "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate";
    };
  };

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      /* ---- EXTENSIONS ---- */
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        #"*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  home.stateVersion = "25.11";  
}
