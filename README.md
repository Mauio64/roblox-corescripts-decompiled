# Repo Info
The goal of this repo is to decompile and archive all of Roblox's CoreScripts across every available surface.
Currently doesn't touch Studio, but I hope to get that working soon.

If you are unable to locate a specific corescript here, please let me know. It may be in a bundle I don't yet handle.

> [!CAUTION]  
> Consider all code inside this repo to be unlicensed. This is provided solely as reference.
> There are valid reasons to want to look at this code (such as confirming performance issues, feature changes, or bugs), but it is NOT free-use!

Currently made possible by [Tovek Decompiler](https://github.com/Kiet1308/Tovek). 
I am using a fork capable of reading [LuauForge bundles](extracontent-models/UniversalApp/LuauForgeUnbundled/README.md).

## Quick Reference

There's a lot of things you might find interesting in here. 
Here are some of my personal highlights:

### General

General starting points.

- **Ingame:**
  - [**Client Corescripts**](extracontent-models/InExperience/InExperience/PatchRoot/CoreScripts/CoreScripts)
  - [**Server Corescripts**](extracontent-models/InExperience/InExperience/PatchRoot/CoreScripts/ServerCoreScripts)

### In-game Core UI

What you see when you play a game.

- [**Chrome**](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/Chrome): Roblox's name for the topbar. [Integrations](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/Chrome/Integrations) contains all of the features.
- [**Escape menu**](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/Settings): has all of the ingame settings, sorted by [Pages](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/Settings). Some of the newer ones are handled by [SettingsFields](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/Settings/Integrations/SettingFields), and legacy ones are handled by [GameSettings](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/Settings/Pages/GameSettings.luau).
  - There's also a React [InGameMenu](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/InGameMenu), not sure which one is in use right now.
- **Chat**:
  - [ExpChat](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CorePackages/Workspace/Packages/_Workspace/ExpChat) handles the TextChatService-based UI.
  - [ExperienceChatMain](extracontent-models/InExperience/InExperience/PatchRoot/CoreScripts/CoreScripts/ExperienceChatMain.luau) initializes everything, and things like translation branch off from it.
  - [ClientChat](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/Server/ClientChat) appears to be the old Lua chat, pre-TextChatService.
- **Voice Chat**:
  - [VoiceChatServiceManager](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/VoiceChat/VoiceChatServiceManager.luau) sets up all of the user-facing parts of Voice Chat, including moderation, button controls, etc.
  - [VoiceChatCore](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore) creates the underlying Audio instances.
- Misc: [**Leaderboard**](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/PlayerList), [**backpack**](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/BackpackScript.luau), [**emote wheel**](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/EmotesMenu), [**proximity prompt UI**](extracontent-models/InExperience/InExperience/PatchRoot/CoreScripts/CoreScripts/ProximityPrompt.luau).

### Lua App

The app that you use when using the desktop or mobile app.

- [**Root directory**](extracontent-models/UniversalApp/LuauForgeUnbundled): it all starts here. There's also a [README](extracontent-models/UniversalApp/LuauForgeUnbundled/README.md) specific to this folder, because the Lua app isn't quite as tidy as the rest of the decompilation.
- [**Home page**](extracontent-models/UniversalApp/LuauForgeUnbundled/CorePackages/Workspace/Packages/_Index/Home): what you see when you first open the app. Not much interesting to see though since it's [server-driven UI](extracontent-models/UniversalApp/LuauForgeUnbundled/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem).
- [**Catalog**](extracontent-models/UniversalApp/LuauForgeUnbundled/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog): self-explanatory.
- [**Build**](extracontent-models/UniversalApp/LuauForgeUnbundled/CorePackages/Workspace/Packages/_Workspace/BuildExperience): Roblox's ~~attempt at copying Claude Code~~ agentic game-builder AI.
- [**Profiles**](extracontent-models/UniversalApp/LuauForgeUnbundled/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform): user profiles.
- [**Moments**](extracontent-models/UniversalApp/LuauForgeUnbundled/CorePackages/Workspace/Packages/_Index/Moments): short-form videos embedded in-app. Kinda like Tiktok.
