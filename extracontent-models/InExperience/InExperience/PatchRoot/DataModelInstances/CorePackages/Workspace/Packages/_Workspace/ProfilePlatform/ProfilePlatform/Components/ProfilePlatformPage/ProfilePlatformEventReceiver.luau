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
local v21 = game:DefineFastFlag("RefreshProfileOnTrustedFriendsRtn", false)

return function() -- line: 33
	-- upvalues: useProfileWrapperContext (copy), useRoactService (copy), AppNotificationService (copy), React (copy), RobloxEventReceiver (copy), useDispatch (copy), useLocalUserId (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), useActionsComponentRequest (copy), useSelector (copy), Presence (copy), PresenceType (copy), convertPresenceEnum (copy), Enums (copy), refreshProfilePlatformActionInfo (copy), refreshProfilePlatformUserInfo (copy), v21 (copy)
	local v22 = useProfileWrapperContext()
	local v23 = useRoactService(AppNotificationService)
	local v24 = React.useMemo(function() -- line: 36
		-- upvalues: RobloxEventReceiver (copy), v23 (copy)
		return RobloxEventReceiver.new(v23)
	end, { v23 })
	local v25 = useDispatch()
	local v26 = useLocalUserId()
	local profileId = v22.profileId
	local profileType = v22.profileType
	local v29 = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else useActionsComponentRequest()
	local v30 = useSelector(function(p1) -- line: 47
		-- upvalues: Presence (copy), profileId (copy), PresenceType (copy)
		return Presence.Selectors.getUserPresenceByUserId(p1, profileId) or {
			lastLocation = "",
			userPresenceType = PresenceType.Offline
		}
	end)
	local v31 = convertPresenceEnum(v30.userPresenceType, v30.universeId)
	local v32 = React.useRef(v31)

	React.useEffect(function() -- line: 56
		-- upvalues: profileType (copy), Enums (copy), v32 (copy), v31 (copy), v25 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v29 (copy)
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		if v32.current ~= v31 then
			if v32.current == Enums.PresenceTypes.InGame or v31 == Enums.PresenceTypes.InGame then
				v25(refreshProfilePlatformActionInfo(profileId, v29))
			end

			v32.current = v31
		end
	end, {
		v31,
		v25,
		profileId,
		profileType,
		if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v29
	})
	React.useEffect(function() -- line: 77
		-- upvalues: profileType (copy), Enums (copy), v24 (copy), profileId (copy), v25 (copy), refreshProfilePlatformUserInfo (copy)
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v34 = v24:observeEvent("UserProfileNotifications", function(p2) -- line: 82
			-- upvalues: profileId (copy), Enums (copy), v25 (copy), refreshProfilePlatformUserInfo (copy)
			local str = tostring(p2.VieweeUserId)
			local p2Type = p2.Type

			if str == profileId and (p2Type == Enums.NameTypes.DisplayName or p2Type == Enums.NameTypes.Alias or p2Type == Enums.NameTypes.Username) then
				v25(refreshProfilePlatformUserInfo(str))
			end
		end)

		return function() -- line: 97
			-- upvalues: v34 (copy)
			v34:disconnect()
		end
	end, {
		v24,
		v25,
		profileId,
		profileType
	})
	React.useEffect(function() -- line: 107
		-- upvalues: profileType (copy), Enums (copy), v24 (copy), v26 (copy), profileId (copy), v25 (copy), refreshProfilePlatformActionInfo (copy), v29 (copy)
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v35 = v24:observeEvent("FriendshipNotifications", function(p3) -- line: 112
			-- upvalues: v26 (copy), profileId (copy), v25 (copy), refreshProfilePlatformActionInfo (copy), v29 (copy)
			if ((if tostring(v26) ~= tostring(p3.EventArgs.UserId1) then tostring(p3.EventArgs.UserId1) else tostring(p3.EventArgs.UserId2))) == profileId then
				v25(refreshProfilePlatformActionInfo(profileId, v29))
			end
		end)

		return function() -- line: 122
			-- upvalues: v35 (copy)
			v35:disconnect()
		end
	end, {
		v24,
		v25,
		profileId,
		v26,
		profileType,
		if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v29
	})

	if v21 then
		React.useEffect(function() -- line: 135
			-- upvalues: profileType (copy), Enums (copy), v24 (copy), v26 (copy), profileId (copy), v25 (copy), refreshProfilePlatformActionInfo (copy), v29 (copy)
			if profileType ~= Enums.ProfileTypes.User then
				return
			end

			local v36 = v24:observeEvent("TrustedConnectionNotifications", function(p4) -- line: 140
				-- upvalues: v26 (copy), profileId (copy), v25 (copy), refreshProfilePlatformActionInfo (copy), v29 (copy)
				if ((if tostring(v26) ~= tostring(p4.Actor) then tostring(p4.Actor) else tostring(p4.Target))) == profileId then
					v25(refreshProfilePlatformActionInfo(profileId, v29))
				end
			end)

			return function() -- line: 150
				-- upvalues: v36 (copy)
				v36:disconnect()
			end
		end, {
			v24,
			v25,
			profileId,
			v26,
			profileType,
			if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else v29
		})
	end
end
