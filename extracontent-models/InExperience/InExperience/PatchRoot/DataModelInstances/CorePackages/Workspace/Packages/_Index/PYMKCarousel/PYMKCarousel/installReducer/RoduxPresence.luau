local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local parent = PYMKCarousel.Parent

local Constants = require(PYMKCarousel.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
return (LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
}))
