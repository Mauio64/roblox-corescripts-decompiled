local parent = script:FindFirstAncestor("EditProfile").Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

return React.createContext({ fireAnalyticsEvent = Dash.noop })
