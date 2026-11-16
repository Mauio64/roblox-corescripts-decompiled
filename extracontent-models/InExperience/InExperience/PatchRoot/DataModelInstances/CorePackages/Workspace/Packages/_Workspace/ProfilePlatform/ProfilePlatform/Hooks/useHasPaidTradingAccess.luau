local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

local function useHasPaidTradingAccess(p: string?)
	local v = useIsRobloxSubscriber(p)
	local v2 = useSelector(function(p2): boolean
		if not p then
			return false
		end

		local users = p2.Users
		local v2 = users and users[p]

		if v2 then
			return v2.membership == Enum.MembershipType.Premium
		end

		return false
	end)

	local v3 = useProfileWrapperContext()
	local v4 = useProfileJsonComponent(Enums.Components.UserProfileHeader)
	local v5

	if tostring(v3.profileId) == tostring(p) then
		v5 = v4.isPremium == true
	else
		v5 = false
	end

	return v2 or v5 or FFlagEnableBlackbirdCheck and v
end

return useHasPaidTradingAccess
