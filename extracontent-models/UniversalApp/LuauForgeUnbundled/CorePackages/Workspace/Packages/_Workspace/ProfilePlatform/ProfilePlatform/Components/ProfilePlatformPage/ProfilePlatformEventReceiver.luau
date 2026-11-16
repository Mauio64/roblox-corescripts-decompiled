local appNotificationService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").AppNotificationService

local convertPresenceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/convertPresenceEnum")
local Presence = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Presence")
local presenceType = Presence.Enums.PresenceType
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local refreshProfilePlatformUserInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformUserInfo")
local refreshProfilePlatformActionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local useActionsComponentRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useActionsComponentRequest")

local FFlagProfilePlatformRefreshActionsRespectPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformRefreshActionsRespectPolicies")
local robloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RealtimeDelivery").RobloxEventReceiver
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local FFlagProfilePlatformPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformPresenceStoreMigration")

local useGetPresenceByUserId = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FriendsCommon").Hooks.useGetPresenceByUserId else nil

local defineFastFlag = game:DefineFastFlag("RefreshProfileOnTrustedFriendsRtn", false)

local v5 = { skipFetch = true }

return function()
	local v6 = useProfileWrapperContext()
	local v7 = useRoactService(appNotificationService)
	local v8 = React.useMemo(function()
		return robloxEventReceiver.new(v7)
	end, { v7 })
	local v9 = useDispatch()
	local v10 = useLocalUserId()
	local profileId = v6.profileId
	local profileType = v6.profileType

	local v11 = if FFlagProfilePlatformRefreshActionsRespectPolicies then useActionsComponentRequest() else nil
	local v12

	if FFlagProfilePlatformPresenceStoreMigration then
		local v13 = useGetPresenceByUserId(profileId, v5)

		local v15 = if v13 then v13.userPresenceType else presenceType.Offline
		local v16 = if v13 and v13.universeId ~= "" then tonumber(v13.universeId) else nil
		v12 = convertPresenceEnum(v15, v16)
	else
		local v13 = useSelector(function(p2)
			return Presence.Selectors.getUserPresenceByUserId(p2, profileId)
				or { userPresenceType = presenceType.Offline, lastLocation = "" }
		end)

		v12 = convertPresenceEnum(v13.userPresenceType, v13.universeId)
	end

	local ref = React.useRef(v12)
	local function fn()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		if ref.current ~= v12 then
			if ref.current == Enums.PresenceTypes.InGame or v12 == Enums.PresenceTypes.InGame then
				v9(refreshProfilePlatformActionInfo(profileId, v11))
			end

			ref.current = v12
		end
	end

	React.useEffect(fn, {
		v12,
		v9,
		profileId,
		profileType,
		if FFlagProfilePlatformRefreshActionsRespectPolicies then v11 else nil
	})

	React.useEffect(function()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v16 = v8:observeEvent("UserProfileNotifications", function(p2)
			local vieweeUserId = tostring(p2.VieweeUserId)
			local kind = p2.Type

			if
				profileId == vieweeUserId
				and (kind == Enums.NameTypes.DisplayName or kind == Enums.NameTypes.Alias or kind == Enums.NameTypes.Username)
			then
				v9(refreshProfilePlatformUserInfo(vieweeUserId))
			end
		end)

		return function()
			v16:disconnect()
		end
	end, { v8, v9, profileId, profileType })

	local function fn2()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v16 = v8:observeEvent("FriendshipNotifications", function(p2)
			local v17

			if tostring(v10) == tostring(p2.EventArgs.UserId1) then
				v17 = tostring(p2.EventArgs.UserId2)
			else
				v17 = tostring(p2.EventArgs.UserId1)
			end

			if profileId == v17 then
				v9(refreshProfilePlatformActionInfo(profileId, v11))
			end
		end)

		return function()
			v16:disconnect()
		end
	end

	React.useEffect(fn2, {
		v8,
		v9,
		profileId,
		v10,
		profileType,
		if FFlagProfilePlatformRefreshActionsRespectPolicies then v11 else nil
	})

	if defineFastFlag then
		local function fn3()
			if profileType ~= Enums.ProfileTypes.User then
				return
			end

			local v18 = v8:observeEvent("TrustedConnectionNotifications", function(p2)
				local v19 = if tostring(v10) == tostring(p2.Actor) then tostring(p2.Target) else tostring(p2.Actor)

				if profileId == v19 then
					v9(refreshProfilePlatformActionInfo(profileId, v11))
				end
			end)

			return function()
				v18:disconnect()
			end
		end

		React.useEffect(fn3, {
			v8,
			v9,
			profileId,
			v10,
			profileType,
			if FFlagProfilePlatformRefreshActionsRespectPolicies then v11 else nil
		})
	end
end
