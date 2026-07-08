local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local AnalyticsContext = require(script.Parent.AnalyticsContext)

return function() -- line: 7
	-- upvalues: React (copy), AnalyticsContext (copy)
	return React.useContext(AnalyticsContext)
end
