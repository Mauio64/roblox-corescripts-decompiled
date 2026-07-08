local Parent = script:FindFirstAncestor("Groups").Parent
local React = require(Parent.React)

require(script.Parent.EventNames)

return React.createContext({
	fireAnalyticsEvent = function() -- line: 15
	end
})
