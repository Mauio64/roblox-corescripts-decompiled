local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local Constants = require(UserSearch.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

return LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
})
