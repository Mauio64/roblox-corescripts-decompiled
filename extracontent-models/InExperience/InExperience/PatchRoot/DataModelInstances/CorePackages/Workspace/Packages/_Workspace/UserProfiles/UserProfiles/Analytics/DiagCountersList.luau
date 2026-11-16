local EventNames = require(script.Parent.EventNames)

local parent = script:FindFirstAncestor("UserProfiles").Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local DiagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes
local ErrorCodesForLogging = require(script.Parent.ErrorCodesForLogging)

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
		name = game:DefineFastString("UserProfilesRequestFailAfterRetry", "UserProfilesRequestFailAfterRetry")
	},
	[EventNames.UserProfilesRequestSuccessAfterRetry] = {
		name = game:DefineFastString("UserProfilesRequestSuccessAfterRetry", "UserProfilesRequestSuccessAfterRetry")
	},
	[EventNames.UserProfilesErrorCode] = {
		type = DiagEventTypes.Counter,
		name = function(p)
			local status = tostring(p.status)
			local userProfilesErrorCode = EventNames.UserProfilesErrorCode

			if ErrorCodesForLogging[status] then
				return userProfilesErrorCode .. status
			end

			return userProfilesErrorCode .. "Other"
		end
	},
	[EventNames.UserProfilesUnmountEarly] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("UserProfilesUnmountEarly", "UserProfilesUnmountEarly")
	}
}
