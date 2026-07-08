local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local LuaSocialLibrariesDeps = require(ProfilePlatformParent.LuaSocialLibrariesDeps)
local RODUX_KEY = require(ProfilePlatform.Common.Constants).RODUX_KEY

return (LuaSocialLibrariesDeps.RoduxGames.config({
	keyPath = RODUX_KEY .. ".Games"
}))
