local react = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/dependencies").React
local FriendsCarouselAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/FriendsCarouselAnalyticsContext")

return function()
	return react.useContext(FriendsCarouselAnalyticsContext)
end
