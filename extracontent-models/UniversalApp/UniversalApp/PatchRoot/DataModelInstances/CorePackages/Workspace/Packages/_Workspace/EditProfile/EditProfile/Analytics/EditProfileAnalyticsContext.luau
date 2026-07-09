local Parent = script:FindFirstAncestor("EditProfile").Parent
local Dash = require(Parent.Dash)

return require(Parent.React).createContext({
	fireAnalyticsEvent = Dash.noop
})
