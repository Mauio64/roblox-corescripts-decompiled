local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local RoactChatAnalyticsConsumer = require(script.Parent.RoactChatAnalyticsConsumer)

return function(p1) -- line: 12
	-- upvalues: Roact (copy), RoactChatAnalyticsConsumer (copy)
	assert(type(p1) == "function", "Expect renderCallback to be a function.")

	return Roact.createElement(RoactChatAnalyticsConsumer, {
		render = p1
	})
end
