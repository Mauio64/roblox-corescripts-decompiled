local EditProfile = script:FindFirstAncestor("EditProfile")
local EventNames = require(script.Parent.Enums.EventNames)
local EditProfileParent = EditProfile.Parent
local SupportedTelemetryBackends = require(EditProfileParent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("EditProfileAnalyticsThrottlingThousandths", 1000)
	},
	[EventNames.EditProfileLoadingStage] = {
		description = "Edit Profile Page Opened",
		lastUpdated = {
			24,
			6,
			10
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = {
				status = function(p1) -- line: 20
					return p1
				end
			}
		}}
	}
}
