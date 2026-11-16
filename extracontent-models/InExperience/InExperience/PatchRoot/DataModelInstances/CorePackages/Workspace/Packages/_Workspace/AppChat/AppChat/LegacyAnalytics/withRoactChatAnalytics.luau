local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)

local RoactChatAnalyticsConsumer = require(script.Parent.RoactChatAnalyticsConsumer)

return function(render)
	assert(type(render) == "function", "Expect renderCallback to be a function.")
	return Roact.createElement(RoactChatAnalyticsConsumer, { render = render })
end
