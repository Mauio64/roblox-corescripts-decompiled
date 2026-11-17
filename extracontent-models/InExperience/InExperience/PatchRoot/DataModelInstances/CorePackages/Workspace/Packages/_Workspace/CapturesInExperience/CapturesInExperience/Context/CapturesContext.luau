local parent = script.Parent.Parent.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

return React.createContext({
	fireAnalyticsEvent = Dash.noop,
	chromeEnabled = nil,
	openGallery = nil
})
