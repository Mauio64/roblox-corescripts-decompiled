local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local Dash = require(Parent.Dash)

return require(Parent.React).createContext({
	fireAnalyticsEvent = Dash.noop
})
