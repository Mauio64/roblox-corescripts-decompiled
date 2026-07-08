> [!CAUTION]  
> Updates run on a gifted Oracle API key (thanks @fgdfg!) that expires **2026-08-07** (30 days from 2026-07-08). After that, decompilation will break and this repo will stop updating until a new decompiler is set up.
>
> If you see this and the repo is still broken past that date, harass me to figure out another decompiler.

---

# Repo Info
A full decompilation of every CoreScript Roblox currently ships in the client.

> [!CAUTION]  
> Consider all code inside this repo to be unlicensed. This is provided solely as reference.

> [!NOTE]  
> Keep in mind that this code is decompiled. You're going to find a lot of things that don't make a lot of sense.
> - If you see a function with name `_` and a comment saying `[[ Name: NAME ]]`, it most likely got inlined (and thus orphaned) by the bytecode compiler. To find where that function may have been called, look for areas where its logic is duplicated.
> - A LOT of variable names are ugly. In the future I'd like to do a postprocess to clean things up; out of scope for now.

Made possible by the [Oracle Decompiler.](https://discord.gg/prHW9TA4QW)

# Quick Reference

There's a lot of things you might find interesting in here. 
All of it lives in `extracontent-models`:

[**In-Game UI Modules**](extracontent-models/InExperience/InExperience/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/) - topbar, Chrome, escape menu, settings, leaderboard, chat, voice chat, emotes, backpack, dev console, and more.

[**In-Game CoreScript Entry Points**](extracontent-models/InExperience/InExperience/PatchRoot/CoreScripts/CoreScripts/) - the scripts that bootstrap chat, voice, notifications, proximity prompts, etc.

[**CoreScripts Container**](extracontent-models/InExperience/InExperience/PatchRoot/CoreScripts/) - lots of misc. CoreScript related stuff, including an entry point for the server-side CoreScripts & its related modules.

[**Universal App Modules**](extracontent-models/UniversalApp/UniversalApp/PatchRoot/DataModelInstances/CoreGui/RobloxGui/Modules/) - app topbar, avatar editor, home feed, catalog, search, settings, and console/10-foot UI.

[**Shared Core Packages**](extracontent-models/UniversalApp/UniversalApp/PatchRoot/DataModelInstances/CorePackages/) - React/Roact, Rodux, networking, UI component libraries.

[extracontent-places](extracontent-places/) seems like test or dead code; it is kept for completeness.
