{ pkgs, inputs, ... }:
{
  home-manager.users.huzch = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "compact";
          position = "top";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "WiFi";
              }
              {
                id = "MediaMini";
              }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "Volume";
              }
              {
                id = "Brightness";
              }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
          };
        };
        ui = {
          fontDefault = "Inter";
        };
        colorSchemes.predefinedScheme = "Monochrome";
        general = {
          avatarImage = "";
          radiusRatio = 0.2;
        };
        location = {
          monthBeforeDay = true;
          name = "Guangzhou, China";
        };
        wallpaper = {
          enable = true;
          directory = "~/wallpapers";
        };
      };
    };
  };
}
