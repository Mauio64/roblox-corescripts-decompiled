local parent = script:FindFirstAncestor("EditProfile").Parent
require(parent.SocialLuaAnalytics)

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("EditProfileAnalyticsThrottlingThousandths", 1000),
		links = ""
	}
}
