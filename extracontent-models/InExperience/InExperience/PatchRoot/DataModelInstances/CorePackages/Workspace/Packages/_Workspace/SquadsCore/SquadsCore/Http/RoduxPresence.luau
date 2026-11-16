local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Constants = require(SquadsCore.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

return (LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
}))
