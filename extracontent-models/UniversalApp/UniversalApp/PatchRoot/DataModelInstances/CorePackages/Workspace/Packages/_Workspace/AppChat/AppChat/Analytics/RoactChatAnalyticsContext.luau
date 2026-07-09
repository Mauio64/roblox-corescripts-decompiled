local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local DefaultAnalytics = require(script.Parent.DefaultAnalytics)

return React.createContext(DefaultAnalytics)
