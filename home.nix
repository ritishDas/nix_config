{ config, pkgs, lib, ... }:

let
configDir = ./configs;
apps = [ "assets" "wlogout" "dunst" "gammastep" "tofi" "waybar" "hypr" "alacritty" "nvim" ];
in
{
	home.username = "ritish";
	home.homeDirectory = "/home/ritish";
	home.stateVersion = "25.05";

	home.sessionVariables = {
		EDITOR = "nvim";
		NIXPKGS_ALLOW_UNFREE = "1";
	};


	home.file.".local/share/fonts".source = ./fonts;


	home.file.".local/share/applications/open-terminal-here.desktop".text = ''
		[Desktop Entry]
		Name=Open Terminal Here
			Icon=${./icons/terminal.svg}
	Exec=alacritty --working-directory %f
		Type=Application
		Terminal=false
		NoDisplay=false
		MimeType=inode/directory;
	'';

	home.file.".local/share/applications/Neovim.desktop".text = ''
		[Desktop Entry]
		Name=Neovim
			Icon=${./icons/nvim.png}
	Exec=alacritty -e nvim %f
		Type=Application
		Terminal=false
		NoDisplay=false
		MimeType=inode/directory;
	'';

	home.file.".local/share/applications/open-github.desktop".text = ''
		[Desktop Entry]
		Name=GitHub
			Exec=firefox https://github.com
			Icon=firefox
			Type=Application
			Categories=Network;WebBrowser;
	'';

	home.file.".local/share/applications/open-chatgpt.desktop".text = ''
		[Desktop Entry]
		Name=Chatgpt
			Exec=firefox https://chatgpt.com
			Icon=firefox
			Type=Application
			Categories=Network;WebBrowser;
	'';

	home.file.".local/share/applications/whatsapp.desktop".text = ''
		[Desktop Entry]
		Name=Whatsapp
			Exec=firefox https://web.whatsapp.com/
			Icon=firefox
			Type=Application
			Categories=Network;WebBrowser;
	'';

	home.file.".bashrc".text = ''
		eval "$(direnv hook bash)"
		'';



	home.activation.updateConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
		update_config() {
			local name="$1"
				local src="${configDir}/$name"
				local dest="$HOME/.config/$name"

				rm -rf "$dest"
				cp -r "$src" "$dest"
				chown -R ritish:users "$dest"
				chmod -R u+rwX "$dest"
		}

	${lib.concatStringsSep "\n" (map (app: "update_config ${app}") apps)}
	'';

}

