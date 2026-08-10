{...}: {
  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
    config.plugins = {
      betterFolders.enable = true;
      fakeNitro.enable = true;
      messageLogger.enable = true;
      noTypingAnimation.enable = true;
      clearUrls.enable = true;
      imageZoom.enable = true;
      fixCodeblockGap.enable = true;
      volumeBooster.enable = true;
      biggerStreamPreview.enable = true;
      betterSettings.enable = true;
      pinDms.enable = true;
      platformIndicators.enable = true;
      memberCount.enable = true;
    };
  };
}
