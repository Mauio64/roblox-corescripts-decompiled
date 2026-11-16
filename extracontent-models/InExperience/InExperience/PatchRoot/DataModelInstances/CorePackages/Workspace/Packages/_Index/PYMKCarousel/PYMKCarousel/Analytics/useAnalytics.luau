local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local react = dependencies.React
local PYMKCarouselAnalyticsContext = require(script.Parent.PYMKCarouselAnalyticsContext)

return function()
	return react.useContext(PYMKCarouselAnalyticsContext)
end
