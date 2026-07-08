local EventNames = require(script.Parent.EventNames)
local Parent = script:FindFirstAncestor("UserProfiles").Parent
local DiagEventTypes = require(Parent.SocialLuaAnalytics).Analytics.Enums.DiagEventTypes
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
		name = function(p1) -- line: 31
			-- upvalues: EventNames (copy), ErrorCodesForLogging (copy)
			local str = tostring(p1.status)
			local UserProfilesErrorCode = EventNames.UserProfilesErrorCode

			if ErrorCodesForLogging[str] then
				return UserProfilesErrorCode .. str
			end

			return UserProfilesErrorCode .. "Other"
		end
	},
	[EventNames.UserProfilesUnmountEarly] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("UserProfilesUnmountEarly", "UserProfilesUnmountEarly")
	}
}
