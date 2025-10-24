{ config, pkgs, lib, ... }:

let
configDir = ./dummyconfigs;
apps = [ "assets" "wlogout" "dunst" "tofi" "waybar" "hypr" "alacritty" "nvim" ];
in
{
	home.username = "dummy";
	home.homeDirectory = "/home/dummy";
	home.stateVersion = "25.05";

	home.sessionVariables = {
		EDITOR = "nvim";
		NIXPKGS_ALLOW_UNFREE = "1";
	};

	home.file.".local/share/fonts".source = ./fonts;



	home.activation.updateConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
		update_config() {
			local name="$1"
				local src="${configDir}/$name"
				local dest="$HOME/.config/$name"

				rm -rf "$dest"
				cp -r "$src" "$dest"
				chown -R dummy:users "$dest"
				chmod -R u+rwX "$dest"
		}

	${lib.concatStringsSep "\n" (map (app: "update_config ${app}") apps)}
	'';

}

