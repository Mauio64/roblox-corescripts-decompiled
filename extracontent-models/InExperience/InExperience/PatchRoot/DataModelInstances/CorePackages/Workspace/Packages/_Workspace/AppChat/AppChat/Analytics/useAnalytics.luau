local parent = script.Parent.Parent.Parent

local React = require(parent.React)

local RoactChatAnalyticsContext = require(script.Parent.RoactChatAnalyticsContext)

return function()
	return React.useContext(RoactChatAnalyticsContext)
end
