local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Analytics/EventNames")

local diagEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SocialLuaAnalytics").Analytics.Enums.DiagEventTypes
local ErrorCodesForLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Analytics/ErrorCodesForLogging")

return {
	[EventNames.UserProfilesRequestBegin] = {
		name = game:DefineFastString("UserProfilesRequestBegin", "UserProfilesRequestBegin")
	},
	[EventNames.UserProfilesRequestSuccess] = {
		name = game:DefineFastString("UserProfilesRequestSuccess", "UserProfilesRequestSuccess")
	},
	[EventNames.UserProfilesRequestFail] = {
		name = game:DefineFastString("UserProfilesRequestFail", "UserProfilesRequestFail")
	},
	[EventNames.UserProfilesRequestFailAfterRetry] = {
		name = game:DefineFastString(
			"UserProfilesRequestFailAfterRetry",
			"UserProfilesRequestFailAfterRetry"
		)
	},
	[EventNames.UserProfilesRequestSuccessAfterRetry] = {
		name = game:DefineFastString(
			"UserProfilesRequestSuccessAfterRetry",
			"UserProfilesRequestSuccessAfterRetry"
		)
	},
	[EventNames.UserProfilesErrorCode] = {
		type = diagEventTypes.Counter,
		name = function(p2)
			local status = tostring(p2.status)
			local userProfilesErrorCode = EventNames.UserProfilesErrorCode

			if ErrorCodesForLogging[status] then
				return userProfilesErrorCode .. status
			end

			return userProfilesErrorCode .. "Other"
		end
	},
	[EventNames.UserProfilesUnmountEarly] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("UserProfilesUnmountEarly", "UserProfilesUnmountEarly")
	}
}
