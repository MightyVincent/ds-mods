# Modding

## Mod Structure

- anim - Animations
- bigportrait - The portrait of the character selection screen.
- fonts - The fonts used in game
- fx - Word Effects like rain or snow
- images - Menuicons, Images
- levels - Terrains, tiles and their textures
- minimap - everything to show up at map
- models - A model like a Model
- scripts - all scripts. prefabs, a.i. , languages
- shaders
- sounds

## modicon.tex

Making a mod icon
Make your mod icon using any image editor of your choice. Try to make it relevant to your mod. It’s dimensions (width and height) must be powers of two ( .. 16, 32, 64, 128 .. ). Then follow the steps below to convert your image to a tex file. You will need Matt’s Tex Tools.

Run TEXCreator.exe
Make sure your settings match these:
Pixel format : DXT5
Texture type : 2D
Mipmap resize filters : default
[Generate Mipmaps]: Ticked
[Pre-multiply Alpha]: Ticked
Click “Add” and browse to your image file
Click “Open”. It should be selected and the path will be visible in the “Selected Textures” section. You can convert more than one at a time by multi-selecting them or browsing for more.
Type in your desired destination folder, or click the “…” button to browse there.
Click “Convert”. The output path(s) will display when it’s completed.

## modicon.xml

```xml
<Atlas>
	<Texture filename="modicon.tex" />
	<Elements>
		<Element name="modicon.tex" u1="0" u2="1" v1="0" v2="1" />
	</Elements>
</Atlas>
```

## Modinfo.lua

Bold are required. Italics are only those that are exclusively related to DST.

**name** - (required) The name of the mod. What is displayed in the list of mods in the game. If you support several languages ​​in your mod, it is advisable not to translate the name, because this is confusing.
**description** - (required) A short description of the mod.
**author** - The name of the author.
**version** - Version of the mod. If you publish a new version, then this value needs to be increased. This can be any string or number (preferably using a number).
**forumthread** - Link to the forum.
_version_compatible_ - Compatibility version with the current version. Applies to DST only.
**api_version** - The API version of the game with which the mod is compatible.
_api_version_dst_ - API version of the game for DST. This property is not necessary at all. It is only needed if you are making a universal mod for DS and DST. If this property is present, then DST will use it, not api_version. Normal DS ignores this property.
priority - The priority of loading the mod in the general queue of mods. The parameter is needed for compatibility with other mods, as affects the loading order of mods.
dont_starve_compatible - true / false Compatible with Vanilla (Don't Starve without DLC)
reign_of_giants_compatible - true / false RoG compatibility
shipwrecked_compatible - true / false Compatible with SW
dst_compatible - true / false DST compatible
icon_atlas - Markup file for the mod icon.
icon - A texture file containing the mod icon. The mod icon is displayed in the game in the list of mods as a picture.
_all_clients_require_mod_ - true / false Indicates that the mod must be synchronized between all players. Applies to DST only.
_client_only_mod_ - true / false Indicates that the mod is used only locally. Theoretically, such a mod can also be used on the server, although this is not provided (and so is done to hide the mod from the list of mods on the server).
_server_filter_tags_ - Enumeration of server tags. Used in DST to help find servers. For example, if you specify that the server is PvP, then the tag "pvp" is automatically added, so when searching for servers, you can type "pvp" in the search bar.
configuration_options - Mod settings .
standalone - true or false , no other mods allowed?
restart_require - after enabling this mod. true or false

### all_clients_require_mod

This option says that the mod used on the server should be copied to all players who want to connect to the server. Fortunately, Steam automatically does this “copy” when it connects to the server. More precisely, there is a hidden subscription to the mod with its subsequent download and inclusion in the game. After exiting the server, the mod is turned off and remains only in the cached mods folder, so as not to load the next time.

That is, if a player connects to the server and does not have any of the "all_clients_require_mod" mods installed, then all these mods are downloaded. That is why the first connection to a server with many heavy mods takes a long time.

This type must have mods that contain any of the following:

- New character.
- New item.
- New structure.
- New recipes or change old recipes.
- Changing the names of objects, descriptions of recipes (if this is not a client mod as intended).
- Other changes related to the client part of the game.

### version_compatible

This property is relevant only for mods of the type all_clients_require_mod.

If you made minor changes, then indicate the old compatible version. For example, if you update and publish your mod, then running servers will not necessarily immediately restart and download the new version. But new players, when connected to the server, will be able to download only the new version. The Steam does not store old versions of mods. Therefore, a conflict of versions of mods is possible when the player has a new version of the mod, and the server has an old version of the mod.

This problem cannot be fixed once and for all, because It occurs with every update of the mod. Therefore, the game provides a mechanism to warn players that some mod has been updated and the server needs to be restarted.

However, if the changes are minor and the old and new versions are compatible (for example, if you corrected a typo in the description of the item), then this can be indicated. In this case, the game will allow players with a new version to enter (there will still be warnings if the admin does not use mods like "Stop Spam").

Older players usually retain the ability to access the server. The fact is that previously downloaded modes (when entering different servers) are cached on the player’s computer. Therefore, if the version of the mod does not match, then the game searches for the appropriate version in the cache folder. Not only is an exact match checked by the version property, but the match by version_compatible is also taken into account.

It is advisable to use this property only if you understand which changes are compatible and which are not. If you are a beginner or even an average modeler and have not completely penetrated with the details of the lua language and the intricacies of network synchronization in DST, then do not use this property at all (to avoid false compatibility, leading to errors during the game).

Discussion and description of this feature on the official forum: http://forums.kleientertainment.com/topic/58961-info-new-version_compatible-feature/

