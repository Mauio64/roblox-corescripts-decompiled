local parent = script:FindFirstAncestor("EditProfile").Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

local EventNames = require(script.Parent.Enums.EventNames)

return {
	[EventNames.UsernameSaved] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.UsernameSaved
	}
}
