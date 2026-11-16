local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local react = dependencies.React
local FriendsCarouselAnalyticsContext = require(script.Parent.FriendsCarouselAnalyticsContext)

return function()
	return react.useContext(FriendsCarouselAnalyticsContext)
end
