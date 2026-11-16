local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local Constants = require(UserList.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

return LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
})
