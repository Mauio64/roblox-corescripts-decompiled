local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local AnalyticsContext = require(script.Parent.AnalyticsContext)

return function()
	return React.useContext(AnalyticsContext)
end
