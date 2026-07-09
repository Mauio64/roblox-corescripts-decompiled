local ParentParent = script.Parent.Parent
local React = require(ParentParent.dependencies).React
local FriendsCarouselAnalyticsContext = require(script.Parent.FriendsCarouselAnalyticsContext)

return function() -- line: 6
	-- upvalues: React (copy), FriendsCarouselAnalyticsContext (copy)
	return React.useContext(FriendsCarouselAnalyticsContext)
end
