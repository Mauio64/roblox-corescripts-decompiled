local Parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local Dash = require(Parent.Dash)
local EventTypes = require(Parent.SocialLuaAnalytics).Analytics.Enums.EventTypes
local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.ProfileShareLinkActivated] = {
		context = "",
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = EventNames.ProfileShareLinkActivated
		},
		formatRulesForAdditionalInfo = {
			context = Dash.identity,
			shareType = Dash.identity,
			stamp = Dash.identity
		}
	}
}
