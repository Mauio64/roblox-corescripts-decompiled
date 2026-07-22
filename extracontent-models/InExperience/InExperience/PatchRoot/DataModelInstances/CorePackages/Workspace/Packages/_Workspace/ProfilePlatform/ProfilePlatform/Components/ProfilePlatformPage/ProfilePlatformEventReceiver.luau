local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local AppNotificationService = require(ProfilePlatformParent.RoactServiceTags).AppNotificationService
local convertPresenceEnum = require(ProfilePlatform.Utils.convertPresenceEnum)
local Presence = require(ProfilePlatform.Rodux.Presence)
local PresenceType = Presence.Enums.PresenceType
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local refreshProfilePlatformUserInfo = require(ProfilePlatform.Networking.refreshProfilePlatformUserInfo)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local useActionsComponentRequest = require(ProfilePlatform.Hooks.useActionsComponentRequest)
local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local RobloxEventReceiver = require(ProfilePlatformParent.RealtimeDelivery).RobloxEventReceiver
local React = require(ProfilePlatformParent.React)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local v22 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v23 = game:DefineFastFlag("RefreshProfileOnTrustedFriendsRtn", false)
local t1 = {
	skipFetch = true
}

return function() -- line: 40
	-- upvalues: useProfileWrapperContext (copy), useRoactService (copy), AppNotificationService (copy), React (copy), RobloxEventReceiver (copy), useDispatch (copy), useLocalUserId (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), useActionsComponentRequest (copy), FFlagProfilePlatformPresenceStoreMigration (copy), v22 (copy), t1 (copy), convertPresenceEnum (copy), PresenceType (copy), useSelector (copy), Presence (copy), Enums (copy), refreshProfilePlatformActionInfo (copy), refreshProfilePlatformUserInfo (copy), v23 (copy)
	local v25 = useProfileWrapperContext()
	local v26 = useRoactService(AppNotificationService)
	local v27 = React.useMemo(function() -- line: 43
		-- upvalues: RobloxEventReceiver (copy), v26 (copy)
		return RobloxEventReceiver.new(v26)
	end, { v26 })
	local v28 = useDispatch()
	local v29 = useLocalUserId()
	local profileId = v25.profileId
	local profileType = v25.profileType
	local v32 = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else useActionsComponentRequest()
	local u34

	if FFlagProfilePlatformPresenceStoreMigration then
		local v33 = v22(profileId, t1)

		u34 = convertPresenceEnum(if not v33 then PresenceType.Offline else v33.userPresenceType, if not v33 or v33.universeId == "" then nil else tonumber(v33.universeId))
	else
		local v35 = useSelector(function(p1) -- line: 62
			-- upvalues: Presence (copy), profileId (copy), PresenceType (copy)
			return Presence.Selectors.getUserPresenceByUserId(p1, profileId) or {
				lastLocation = "",
				userPresenceType = PresenceType.Offline
			}
		end)

		u34 = convertPresenceEnum(v35.userPresenceType, v35.universeId)
	end

	local v36 = React.useRef(u34)

	React.useEffect(function() -- line: 72
		-- upvalues: profileType (copy), Enums (copy), v36 (copy), u34 (ref), v28 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v32 (copy)
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		if v36.current ~= u34 then
			if v36.current == Enums.PresenceTypes.InGame or u34 == Enums.PresenceTypes.InGame then
				v28(refreshProfilePlatformActionInfo(profileId, v32))
			end

			v36.current = u34
		end
	end, {
		u34,
		v28,
		profileId,
		profileType,
		if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v32
	})
	React.useEffect(function() -- line: 93
		-- upvalues: profileType (copy), Enums (copy), v27 (copy), profileId (copy), v28 (copy), refreshProfilePlatformUserInfo (copy)
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v38 = v27:observeEvent("UserProfileNotifications", function(p2) -- line: 98
			-- upvalues: profileId (copy), Enums (copy), v28 (copy), refreshProfilePlatformUserInfo (copy)
			local str = tostring(p2.VieweeUserId)
			local p2Type = p2.Type

			if str == profileId and (p2Type == Enums.NameTypes.DisplayName or p2Type == Enums.NameTypes.Alias or p2Type == Enums.NameTypes.Username) then
				v28(refreshProfilePlatformUserInfo(str))
			end
		end)

		return function() -- line: 113
			-- upvalues: v38 (copy)
			v38:disconnect()
		end
	end, {
		v27,
		v28,
		profileId,
		profileType
	})
	React.useEffect(function() -- line: 123
		-- upvalues: profileType (copy), Enums (copy), v27 (copy), v29 (copy), profileId (copy), v28 (copy), refreshProfilePlatformActionInfo (copy), v32 (copy)
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v39 = v27:observeEvent("FriendshipNotifications", function(p3) -- line: 128
			-- upvalues: v29 (copy), profileId (copy), v28 (copy), refreshProfilePlatformActionInfo (copy), v32 (copy)
			if ((if tostring(v29) ~= tostring(p3.EventArgs.UserId1) then tostring(p3.EventArgs.UserId1) else tostring(p3.EventArgs.UserId2))) == profileId then
				v28(refreshProfilePlatformActionInfo(profileId, v32))
			end
		end)

		return function() -- line: 138
			-- upvalues: v39 (copy)
			v39:disconnect()
		end
	end, {
		v27,
		v28,
		profileId,
		v29,
		profileType,
		if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v32
	})

	if v23 then
		React.useEffect(function() -- line: 151
			-- upvalues: profileType (copy), Enums (copy), v27 (copy), v29 (copy), profileId (copy), v28 (copy), refreshProfilePlatformActionInfo (copy), v32 (copy)
			if profileType ~= Enums.ProfileTypes.User then
				return
			end

			local v40 = v27:observeEvent("TrustedConnectionNotifications", function(p4) -- line: 156
				-- upvalues: v29 (copy), profileId (copy), v28 (copy), refreshProfilePlatformActionInfo (copy), v32 (copy)
				if ((if tostring(v29) ~= tostring(p4.Actor) then tostring(p4.Actor) else tostring(p4.Target))) == profileId then
					v28(refreshProfilePlatformActionInfo(profileId, v32))
				end
			end)

			return function() -- line: 166
				-- upvalues: v40 (copy)
				v40:disconnect()
			end
		end, {
			v27,
			v28,
			profileId,
			v29,
			profileType,
			if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v32
		})
	end
end
