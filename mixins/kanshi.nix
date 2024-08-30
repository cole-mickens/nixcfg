{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  out_aw3418dw = "Dell Inc. Dell AW3418DW #ASPD8psOnhPd";
  out_aw2521h = "Dell Inc. Dell AW2521H #HLAYMxgwABDZ";
  out_zeph = "Thermotrex Corporation TL140ADXP01 Unknown";
  out_extdisp = "Unknown Unknown Unknown";
in
{
  config = {
    home-manager.users.cole =
      { pkgs, ... }:
      {
        services = {
          kanshi = {
            enable = true;
            systemdTarget = "graphical-session.target";
            profiles = {
              "zeph_undocked".outputs = [
                {
                  criteria = out_zeph;
                  status = "enable";
                  scale = 1.7;
                }
              ];
              "zeph_docked_both".outputs = [
                {
                  criteria = out_zeph;
                  status = "disable";
                }
                {
                  criteria = out_aw3418dw;
                  status = "enable";
                  position = "1920,0";
                  mode = "3440x1440@120Hz";
                }
                {
                  criteria = out_aw2521h;
                  status = "enable";
                  position = "0,0";
                  mode = "1920x1080@240Hz";
                }
              ];
              "zeph_docked_aw25".outputs = [
                {
                  criteria = out_zeph;
                  status = "disable";
                }
                {
                  criteria = out_aw2521h;
                  status = "enable";
                  position = "0,0";
                  mode = "1920x1080@240Hz";
                }
              ];
              "zeph_docked_aw34".outputs = [
                {
                  criteria = out_zeph;
                  status = "disable";
                }
                {
                  criteria = out_aw3418dw;
                  status = "enable";
                  position = "0,0";
                  mode = "3440x1440@120Hz";
                }
              ];
              "zeph_all".outputs = [
                {
                  criteria = out_aw2521h;
                  status = "enable";
                  position = "0,0";
                  mode = "1920x1080@240Hz";
                }
                {
                  criteria = out_aw3418dw;
                  status = "enable";
                  position = "1920,0";
                  mode = "3440x1440@120Hz";
                }
                {
                  criteria = out_zeph;
                  status = "enable";
                  position = "${builtins.toString (1920 + 3440)},0";
                }
              ];
              "zeph_portable".outputs = [
                {
                  criteria = out_zeph;
                  status = "enable";
                  position = "0,0";
                }
                {
                  criteria = out_extdisp;
                  status = "enable";
                  position = "2560,0";
                }
              ];
              "zeph_portable2".outputs = [
                {
                  criteria = out_zeph;
                  status = "enable";
                  position = "2560,0";
                }
                {
                  criteria = out_extdisp;
                  status = "enable";
                  position = "0,0";
                }
              ];
            };
          };
        };
      };
  };
}
