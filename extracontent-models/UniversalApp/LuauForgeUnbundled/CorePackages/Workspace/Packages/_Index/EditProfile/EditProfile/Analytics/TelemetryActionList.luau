require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SocialLuaAnalytics")

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("EditProfileAnalyticsThrottlingThousandths", 1000),
		links = ""
	}
}
