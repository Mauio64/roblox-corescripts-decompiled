local react = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies").React
local PYMKCarouselAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/PYMKCarouselAnalyticsContext")

return function()
	return react.useContext(PYMKCarouselAnalyticsContext)
end
