local parent = script:FindFirstAncestor("AppChat").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

return {
	new = SocialLuaAnalytics.Telemetry.new,
	contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
}
