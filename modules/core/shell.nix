{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  users.users.tahmid.shell = pkgs.zsh;

  home-manager.users.tahmid = {
    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "bira";
      };
    };
  };
}
