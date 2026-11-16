local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local DefaultAnalytics = require(script.Parent.DefaultAnalytics)

return React.createContext(DefaultAnalytics)
