local parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local Dash = require(parent.Dash)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.ProfileShareLinkActivated] = {
		context = "",
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = EventNames.ProfileShareLinkActivated },
		formatRulesForAdditionalInfo = {
			context = Dash.identity,
			shareType = Dash.identity,
			stamp = Dash.identity
		}
	}
}
