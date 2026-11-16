local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useSelector
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserProfiles").Hooks.useIsRobloxSubscriber
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableBlackbirdCheck

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")

local function useHasPaidTradingAccess(p2)
	local v5 = useIsRobloxSubscriber(p2)
	local v6 = useSelector(function(p3): boolean
		if not p2 then
			return false
		end

		local users = p3.Users
		local v7 = users and users[p2]

		if v7 then
			return v7.membership == Enum.MembershipType.Premium
		end

		return false
	end)

	local v7 = useProfileWrapperContext()
	local v8 = useProfileJsonComponent(Enums.Components.UserProfileHeader)
	local v9 = tostring(v7.profileId) == tostring(p2) and v8.isPremium == true

	return v6 or v9 or fFlagEnableBlackbirdCheck and v5
end

return useHasPaidTradingAccess
