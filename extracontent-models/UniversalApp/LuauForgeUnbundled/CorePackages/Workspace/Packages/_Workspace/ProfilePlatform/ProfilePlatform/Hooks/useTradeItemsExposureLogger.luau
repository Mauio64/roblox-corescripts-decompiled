local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useHasPaidTradingAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useHasPaidTradingAccess")
local logTradeItemsExposureIfEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/logTradeItemsExposureIfEligible")

local function useTradeItemsExposureLogger()
	local v5 = useProfileWrapperContext()
	local profileId = v5.profileId
	local v6 = v5.profileType == Enums.ProfileTypes.User
	local v7 = tostring((useLocalUserId()))
	local v8 = useHasPaidTradingAccess(v7)
	local v10 = if v6 then profileId else nil
	local v11 = useHasPaidTradingAccess(v10)

	return React.useCallback(function()
		if not v6 then
			return
		end

		logTradeItemsExposureIfEligible({
			profileId = tostring(profileId),
			localUserId = v7,
			localHasPaidTradingAccess = v8,
			otherHasPaidTradingAccess = v11
		})
	end, { profileId, v7, v8, v11, v6 })
end

return useTradeItemsExposureLogger
