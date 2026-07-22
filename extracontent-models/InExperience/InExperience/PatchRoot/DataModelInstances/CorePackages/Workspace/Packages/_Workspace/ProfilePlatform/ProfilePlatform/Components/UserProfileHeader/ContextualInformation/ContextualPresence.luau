local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local RoactAnalyticsCommonGameEvents = require(ProfilePlatformParent.RoactServiceTags).RoactAnalyticsCommonGameEvents
local useRoactService = require(ProfilePlatformParent.RobloxAppHooks).useRoactService
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local OpenGameDetails = require(ProfilePlatformParent.GameDetail).OpenGameDetails
local UIBlox = require(ProfilePlatformParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local PlayerContext = UIBlox.App.Indicator.PlayerContext
local Presence = require(ProfilePlatform.Rodux.Presence)
local PresenceType = Presence.Enums.PresenceType
local NetworkingPresence = require(ProfilePlatform.Networking.NetworkingPresence)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local convertPresenceEnum = require(ProfilePlatform.Utils.convertPresenceEnum)
local FFlagProfilePlatformImproveGameDetailsAnalytics = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformImproveGameDetailsAnalytics
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local v31 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v32 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.DataHydration).Presence.PresenceStore.get()
local t1 = {
	lastLocation = "",
	universeId = "",
	placeId = "",
	userPresenceType = PresenceType.Offline
}
local t2 = {
	skipFetch = true
}
local t3 = {
	[Enums.PresenceTypes.Offline] = Images["component_assets/circle_26_stroke_3"],
	[Enums.PresenceTypes.Online] = Images["component_assets/circle_16"],
	[Enums.PresenceTypes.InGame] = Images["icons/menu/games_small"],
	[Enums.PresenceTypes.InStudio] = Images["icons/logo/studiologo_small"]
}

local function contextualPresence(t4: {[any]: any}) -- line: 73
	-- upvalues: useDispatch (copy), useNavigation (copy), useStyle (copy), useProfileAnalyticsContext (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), React (copy), useProfileWrapperContext (copy), FFlagProfilePlatformPresenceStoreMigration (copy), useEffectOnMount (copy), v32 (copy), v31 (copy), t2 (copy), t1 (copy), convertPresenceEnum (copy), EventNames (copy), NetworkingPresence (copy), useSelector (copy), Presence (copy), PresenceType (copy), AppPage (copy), OpenGameDetails (copy), useLocalization (copy), Enums (copy), TextKeys (copy), t3 (copy), getIconSize (copy), IconSize (copy), PlayerContext (copy)
	local v38 = useDispatch()
	local v39 = useNavigation()
	local v40 = useStyle()
	local v41 = useProfileAnalyticsContext()
	local v42 = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else useRoactService(RoactAnalyticsCommonGameEvents)
	local v43 = React.useRef(false)
	local v44 = React.useRef(false)
	local profileId = useProfileWrapperContext().profileId
	local u48

	if FFlagProfilePlatformPresenceStoreMigration then
		useEffectOnMount(function() -- line: 89
			-- upvalues: v32 (copy), profileId (copy)
			v32.RefreshPresenceByUserId((tostring(profileId)))
		end)

		local v46, v47 = v31(profileId, t2)

		u48 = v46 or (t4.presenceInfoOverride or t1)
		React.useEffect(function() -- line: 96
			-- upvalues: v44 (copy), v47 (copy), convertPresenceEnum (copy), u48 (ref), v41 (copy), EventNames (copy)
			if v44.current then
				return
			end

			if v47 ~= "Ready" and v47 ~= "Failed" then
				return
			end

			v44.current = true

			local v62 = convertPresenceEnum(u48.userPresenceType, if not u48.universeId then nil else tonumber(u48.universeId))

			v41.fireAnalyticsEvent(EventNames.ProfilePresenceLoaded, {
				presenceType = v62,
				universeId = u48.universeId
			})
		end, {
			u48,
			v47,
			v41
		})
	else
		useEffectOnMount(function() -- line: 116
			-- upvalues: v38 (copy), NetworkingPresence (copy), profileId (copy), v43 (copy)
			v38(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):andThen(function() -- line: 118
				-- upvalues: v43 (copy)
				v43.current = true
			end):catch(function(_) -- line: 121
			end)
		end)

		local v49 = useSelector(function(p2) -- line: 124
			-- upvalues: Presence (copy), profileId (copy), PresenceType (copy)
			return Presence.Selectors.getUserPresenceByUserId(p2, profileId) or {
				lastLocation = "",
				userPresenceType = PresenceType.Offline
			}
		end)

		u48 = if v43.current then v49 else t4.presenceInfoOverride or v49
		React.useEffect(function() -- line: 135
			-- upvalues: v43 (copy), v44 (copy), convertPresenceEnum (copy), u48 (ref), v41 (copy), EventNames (copy)
			if not v43.current or v44.current then
				return
			end

			v44.current = true

			local v64 = convertPresenceEnum(u48.userPresenceType, u48.universeId)

			v41.fireAnalyticsEvent(EventNames.ProfilePresenceLoaded, {
				presenceType = v64,
				universeId = u48.universeId
			})
		end, { u48 })
	end

	local v50 = convertPresenceEnum(u48.userPresenceType, if not FFlagProfilePlatformPresenceStoreMigration then u48.universeId else if not u48.universeId then nil else tonumber(u48.universeId))
	local lastLocation = u48.lastLocation
	local universeId = u48.universeId
	local v53 = React.useCallback(function() -- line: 159
		-- upvalues: v41 (copy), EventNames (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), v42 (copy), u48 (ref), AppPage (copy), profileId (copy), v38 (copy), OpenGameDetails (copy), universeId (copy), v39 (copy)
		v41.fireAnalyticsEvent(EventNames.GameDetailsButton)

		if FFlagProfilePlatformImproveGameDetailsAnalytics then
			v42.reportOpenGameDetailFromProfileContext(u48.placeId, u48.universeId, AppPage.ProfilePlatform, profileId, "ProfilePlatformContextualPresence")
		end

		v38(OpenGameDetails(universeId, v39, {
			mountAsFullView = true,
			showBackButton = true
		}))
	end, {
		universeId,
		v39,
		v41
	})
	local v54 = useLocalization({
		[Enums.PresenceTypes.Online] = TextKeys.Online,
		[Enums.PresenceTypes.Offline] = TextKeys.Offline,
		[Enums.PresenceTypes.InStudio] = TextKeys.InStudio
	})
	local v55 = nil
	local OnlineStatusColor = nil
	local OnlineStatusTransparency = nil
	local Online = nil
	local TextMuted = nil
	local n1 = nil
	local v61 = nil

	if u48 then
		if v50 == Enums.PresenceTypes.Online then
			v55 = t3[Enums.PresenceTypes.Online]
			OnlineStatusColor = v40.Theme.OnlineStatus.Color
			OnlineStatusTransparency = v40.Theme.OnlineStatus.Transparency
			Online = v54.Online
			TextMuted = v40.Theme.TextMuted
			n1 = 12
		elseif v50 == Enums.PresenceTypes.InGame then
			v55 = t3[Enums.PresenceTypes.InGame]
			OnlineStatusColor = v40.Theme.IconEmphasis.Color
			OnlineStatusTransparency = v40.Theme.IconEmphasis.Transparency
			Online = lastLocation
			TextMuted = v40.Theme.TextEmphasis
			n1 = getIconSize(IconSize.Small)
			v61 = v53
		elseif v50 == Enums.PresenceTypes.InStudio then
			v55 = t3[Enums.PresenceTypes.InStudio]
			OnlineStatusColor = v40.Theme.TextDefault.Color
			OnlineStatusTransparency = v40.Theme.TextDefault.Transparency
			Online = v54.InStudio
			TextMuted = v40.Theme.TextMuted
			n1 = getIconSize(IconSize.Small)
		else
			v55 = t3[Enums.PresenceTypes.Offline]
			OnlineStatusColor = v40.Theme.OfflineStatus.Color
			OnlineStatusTransparency = v40.Theme.OfflineStatus.Transparency
			n1 = 12
			Online = v54.Offline
			TextMuted = v40.Theme.TextMuted
		end
	end

	return React.createElement(PlayerContext, {
		layoutOrder = 2,
		fontStyle = v40.Font.CaptionBody,
		icon = v55,
		iconColor = OnlineStatusColor,
		iconSize = UDim2.fromOffset(n1, n1),
		iconTransparency = OnlineStatusTransparency,
		text = Online,
		textColorStyle = TextMuted,
		onActivated = v61
	})
end

return contextualPresence
