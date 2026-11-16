Roblox's Lua app (e.g. the mobile and desktop app) is compiled from modules into one giant script using Roblox's internal tool, LuauForge.  Tovek can't handle this and it'd be annoying to read a file that big, so my scraper splits the giant LuaApp script back into files. 

These bundled modules are only bytecode and contain no filenames. Most of them can be matched back to modules that exist elsewhere in the app, and thus retain a readable name/path. If a given file can't be matched back to a module elsewhere, it gets an auto-generated name and goes to /_unresolved.

In the latest version (v747):
- `24999` modules were un-bundled total.
- `17803` were able to be matched to another extant module outside of the Lua app.
- `7196` didn't appear elsewhere in Roblox's codebase, so they are in /_unresolved.
