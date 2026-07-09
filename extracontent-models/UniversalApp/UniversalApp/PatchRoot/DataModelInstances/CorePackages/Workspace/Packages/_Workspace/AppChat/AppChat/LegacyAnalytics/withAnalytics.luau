local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local AnalyticsConsumer = require(script.Parent.AnalyticsConsumer)

return function(p1) -- line: 11
	-- upvalues: Roact (copy), AnalyticsConsumer (copy)
	assert(type(p1) == "function", "Expect renderCallback to be a function.")

	return Roact.createElement(AnalyticsConsumer, {
		render = p1
	})
end
