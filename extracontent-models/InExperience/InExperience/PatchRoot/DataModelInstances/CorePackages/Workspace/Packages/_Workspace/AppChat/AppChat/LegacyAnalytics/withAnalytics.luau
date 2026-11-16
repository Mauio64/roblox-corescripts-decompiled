local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local AnalyticsConsumer = require(script.Parent.AnalyticsConsumer)

return function(render)
	assert(type(render) == "function", "Expect renderCallback to be a function.")
	return Roact.createElement(AnalyticsConsumer, { render = render })
end
