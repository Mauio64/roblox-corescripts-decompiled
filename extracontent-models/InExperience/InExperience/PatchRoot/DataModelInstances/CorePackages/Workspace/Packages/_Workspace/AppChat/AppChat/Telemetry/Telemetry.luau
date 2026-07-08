local Parent = script:FindFirstAncestor("AppChat").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)

return {
	new = SocialLuaAnalytics.Telemetry.new,
	contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
}
