{pkgs, ...}: {
  console = {
    font = "ter-v20b";
    keyMap = "us";
    packages = [pkgs.terminus_font];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-icons
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-lgc-plus
      noto-fonts-color-emoji
      liberation_ttf
      freefont_ttf
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Serif CJK SC"];
      sansSerif = ["Noto Sans" "Noto Sans CJK SC"];
      monospace = ["Iosevka Nerd Font" "Noto Sans Mono CJK SC"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
