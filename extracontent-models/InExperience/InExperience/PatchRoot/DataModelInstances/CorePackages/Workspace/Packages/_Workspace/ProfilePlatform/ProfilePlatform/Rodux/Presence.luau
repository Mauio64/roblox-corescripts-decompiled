local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local Constants = require(ProfilePlatform.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

return (LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
}))
