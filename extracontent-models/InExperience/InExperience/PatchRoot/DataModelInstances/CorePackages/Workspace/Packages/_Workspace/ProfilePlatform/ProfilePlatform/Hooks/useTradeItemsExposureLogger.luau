local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useHasPaidTradingAccess = require(ProfilePlatform.Hooks.useHasPaidTradingAccess)
local logTradeItemsExposureIfEligible = require(ProfilePlatform.Utils.logTradeItemsExposureIfEligible)

local function useTradeItemsExposureLogger()
	local v = useProfileWrapperContext()
	local profileId = v.profileId
	local v2 = v.profileType == Enums.ProfileTypes.User
	local localUserId = tostring((useLocalUserId()))
	local localHasPaidTradingAccess = useHasPaidTradingAccess(localUserId)
	local v3

	if v2 then
		v3 = profileId
	end

	local otherHasPaidTradingAccess = useHasPaidTradingAccess(v3)

	return React.useCallback(function()
		if not v2 then
			return
		end

		logTradeItemsExposureIfEligible({
			profileId = tostring(profileId),
			localUserId = localUserId,
			localHasPaidTradingAccess = localHasPaidTradingAccess,
			otherHasPaidTradingAccess = otherHasPaidTradingAccess
		})
	end, { profileId, localUserId, localHasPaidTradingAccess, otherHasPaidTradingAccess, v2 })
end

return useTradeItemsExposureLogger
