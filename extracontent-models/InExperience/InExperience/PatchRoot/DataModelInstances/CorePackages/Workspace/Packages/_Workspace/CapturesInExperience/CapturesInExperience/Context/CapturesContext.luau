local ParentParent = script.Parent.Parent.Parent
local Dash = require(ParentParent.Dash)

return require(ParentParent.React).createContext({
	chromeEnabled = nil,
	fireAnalyticsEvent = Dash.noop
})
