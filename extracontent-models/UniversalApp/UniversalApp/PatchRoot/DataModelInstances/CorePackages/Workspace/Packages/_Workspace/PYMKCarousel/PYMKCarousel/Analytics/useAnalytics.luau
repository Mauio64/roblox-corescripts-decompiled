local ParentParent = script.Parent.Parent
local React = require(ParentParent.dependencies).React
local PYMKCarouselAnalyticsContext = require(script.Parent.PYMKCarouselAnalyticsContext)

return function() -- line: 6
	-- upvalues: React (copy), PYMKCarouselAnalyticsContext (copy)
	return React.useContext(PYMKCarouselAnalyticsContext)
end
