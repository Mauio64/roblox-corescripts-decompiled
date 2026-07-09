local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local PYMKCarouselParent = PYMKCarousel.Parent
local RODUX_KEY = require(PYMKCarousel.Common.Constants).RODUX_KEY

return (require(PYMKCarouselParent.LuaSocialLibrariesDeps).RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
}))
