local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local RoactServiceTags = require(parent.RoactServiceTags)
local AppNotificationService = RoactServiceTags.AppNotificationService

local convertPresenceEnum = require(ProfilePlatform.Utils.convertPresenceEnum)
local Presence = require(ProfilePlatform.Rodux.Presence)
local PresenceType = Presence.Enums.PresenceType
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local refreshProfilePlatformUserInfo = require(ProfilePlatform.Networking.refreshProfilePlatformUserInfo)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local useActionsComponentRequest = require(ProfilePlatform.Hooks.useActionsComponentRequest)

local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RobloxEventReceiver = RealtimeDelivery.RobloxEventReceiver
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RoactUtils = require(parent.RoactUtils)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Enums = require(ProfilePlatform.Common.Enums)

local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local useGetPresenceByUserId

if FFlagProfilePlatformPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local v = { skipFetch = true }

return function()
	local v2 = useProfileWrapperContext()
	local v3 = useRoactService(AppNotificationService)
	local v4 = React.useMemo(function()
		return RobloxEventReceiver.new(v3)
	end, { v3 })
	local v5 = useDispatch()
	local v6 = useLocalUserId()
	local profileId = v2.profileId
	local profileType = v2.profileType
	local v7

	if FFlagProfilePlatformRefreshActionsRespectPolicies then
		v7 = useActionsComponentRequest()
	else
		v7 = nil
	end

	local current

	if FFlagProfilePlatformPresenceStoreMigration then
		local v8 = useGetPresenceByUserId(profileId, v)
		local v9

		if v8 then
			v9 = v8.userPresenceType
		else
			v9 = PresenceType.Offline
		end

		local v10

		if v8 and v8.universeId ~= "" then
			v10 = tonumber(v8.universeId)
		end

		current = convertPresenceEnum(v9, v10)
	else
		local v8 = useSelector(function(p)
			return Presence.Selectors.getUserPresenceByUserId(p, profileId)
				or { userPresenceType = PresenceType.Offline, lastLocation = "" }
		end)

		current = convertPresenceEnum(v8.userPresenceType, v8.universeId)
	end

	local ref = React.useRef(current)
	local useEffect = React.useEffect
	local function fn()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		if ref.current ~= current then
			if ref.current == Enums.PresenceTypes.InGame or current == Enums.PresenceTypes.InGame then
				v5(refreshProfilePlatformActionInfo(profileId, v7))
			end

			ref.current = current
		end
	end

	local v8

	if FFlagProfilePlatformRefreshActionsRespectPolicies then
		v8 = v7
	end

	useEffect(fn, { current, v5, profileId, profileType, v8 })

	React.useEffect(function()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v9 = v4:observeEvent("UserProfileNotifications", function(p)
			local vieweeUserId = tostring(p.VieweeUserId)
			local kind = p.Type

			if
				profileId == vieweeUserId
				and (kind == Enums.NameTypes.DisplayName or kind == Enums.NameTypes.Alias or kind == Enums.NameTypes.Username)
			then
				v5(refreshProfilePlatformUserInfo(vieweeUserId))
			end
		end)

		return function()
			v9:disconnect()
		end
	end, { v4, v5, profileId, profileType })

	local useEffect2 = React.useEffect
	local function fn2()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v9 = v4:observeEvent("FriendshipNotifications", function(p)
			local v9

			if tostring(v6) == tostring(p.EventArgs.UserId1) then
				v9 = tostring(p.EventArgs.UserId2)
			else
				v9 = tostring(p.EventArgs.UserId1)
			end

			if profileId == v9 then
				v5(refreshProfilePlatformActionInfo(profileId, v7))
			end
		end)

		return function()
			v9:disconnect()
		end
	end

	local v9

	if FFlagProfilePlatformRefreshActionsRespectPolicies then
		v9 = v7
	end

	useEffect2(fn2, { v4, v5, profileId, v6, profileType, v9 })

	local useEffect3 = React.useEffect
	local function fn3()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v10 = v4:observeEvent("TrustedConnectionNotifications", function(p)
			local v10

			if tostring(v6) == tostring(p.Actor) then
				v10 = tostring(p.Target)
			else
				v10 = tostring(p.Actor)
			end

			if profileId == v10 then
				v5(refreshProfilePlatformActionInfo(profileId, v7))
			end
		end)

		return function()
			v10:disconnect()
		end
	end

	local v10

	if FFlagProfilePlatformRefreshActionsRespectPolicies then
		v10 = v7
	end

	useEffect3(fn3, { v4, v5, profileId, v6, profileType, v10 })
end
