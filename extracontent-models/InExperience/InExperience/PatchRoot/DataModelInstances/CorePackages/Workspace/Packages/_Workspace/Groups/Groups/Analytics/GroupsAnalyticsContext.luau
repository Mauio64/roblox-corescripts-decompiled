local parent = script:FindFirstAncestor("Groups").Parent
local React = require(parent.React)
require(script.Parent.EventNames)

return React.createContext({
	fireAnalyticsEvent = function() end
})
