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
local t1 = {
	[Enums.PresenceTypes.Offline] = Images["component_assets/circle_26_stroke_3"],
	[Enums.PresenceTypes.Online] = Images["component_assets/circle_16"],
	[Enums.PresenceTypes.InGame] = Images["icons/menu/games_small"],
	[Enums.PresenceTypes.InStudio] = Images["icons/logo/studiologo_small"]
}

local function contextualPresence(t2: {[any]: any}) -- line: 54
	-- upvalues: useDispatch (copy), useNavigation (copy), useStyle (copy), useProfileAnalyticsContext (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), React (copy), useProfileWrapperContext (copy), useEffectOnMount (copy), NetworkingPresence (copy), useSelector (copy), Presence (copy), PresenceType (copy), convertPresenceEnum (copy), EventNames (copy), AppPage (copy), OpenGameDetails (copy), useLocalization (copy), Enums (copy), TextKeys (copy), t1 (copy), getIconSize (copy), IconSize (copy), PlayerContext (copy)
	local v33 = useDispatch()
	local v34 = useNavigation()
	local v35 = useStyle()
	local v36 = useProfileAnalyticsContext()
	local v37 = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else useRoactService(RoactAnalyticsCommonGameEvents)
	local v38 = React.useRef(false)
	local v39 = React.useRef(false)
	local profileId = useProfileWrapperContext().profileId

	useEffectOnMount(function() -- line: 68
		-- upvalues: v33 (copy), NetworkingPresence (copy), profileId (copy), v38 (copy)
		v33(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):andThen(function() -- line: 70
			-- upvalues: v38 (copy)
			v38.current = true
		end):catch(function(_) -- line: 73
		end)
	end)

	local v41 = useSelector(function(p2) -- line: 76
		-- upvalues: Presence (copy), profileId (copy), PresenceType (copy)
		return Presence.Selectors.getUserPresenceByUserId(p2, profileId) or {
			lastLocation = "",
			userPresenceType = PresenceType.Offline
		}
	end)
	local v42 = if v38.current then v41 else t2.presenceInfoOverride or v41

	React.useEffect(function() -- line: 87
		-- upvalues: v38 (copy), v39 (copy), convertPresenceEnum (copy), v42 (copy), v36 (copy), EventNames (copy)
		if not v38.current or v39.current then
			return
		end

		v39.current = true

		local v56 = convertPresenceEnum(v42.userPresenceType, v42.universeId)

		v36.fireAnalyticsEvent(EventNames.ProfilePresenceLoaded, {
			presenceType = v56,
			universeId = v42.universeId
		})
	end, { v42 })

	local v43 = convertPresenceEnum(v42.userPresenceType, v42.universeId)
	local lastLocation = v42.lastLocation
	local universeId = v42.universeId
	local v46 = React.useCallback(function() -- line: 104
		-- upvalues: v36 (copy), EventNames (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), v37 (copy), v42 (copy), AppPage (copy), profileId (copy), v33 (copy), OpenGameDetails (copy), universeId (copy), v34 (copy)
		v36.fireAnalyticsEvent(EventNames.GameDetailsButton)

		if FFlagProfilePlatformImproveGameDetailsAnalytics then
			v37.reportOpenGameDetailFromProfileContext(v42.placeId, v42.universeId, AppPage.ProfilePlatform, profileId, "ProfilePlatformContextualPresence")
		end

		v33(OpenGameDetails(universeId, v34, {
			mountAsFullView = true,
			showBackButton = true
		}))
	end, {
		universeId,
		v34,
		v36
	})
	local v47 = useLocalization({
		[Enums.PresenceTypes.Online] = TextKeys.Online,
		[Enums.PresenceTypes.Offline] = TextKeys.Offline,
		[Enums.PresenceTypes.InStudio] = TextKeys.InStudio
	})
	local v48 = nil
	local OnlineStatusColor = nil
	local OnlineStatusTransparency = nil
	local Online = nil
	local TextMuted = nil
	local n1 = nil
	local v54 = nil

	if v42 then
		if v43 == Enums.PresenceTypes.Online then
			v48 = t1[Enums.PresenceTypes.Online]
			OnlineStatusColor = v35.Theme.OnlineStatus.Color
			OnlineStatusTransparency = v35.Theme.OnlineStatus.Transparency
			Online = v47.Online
			TextMuted = v35.Theme.TextMuted
			n1 = 12
		elseif v43 == Enums.PresenceTypes.InGame then
			v48 = t1[Enums.PresenceTypes.InGame]
			OnlineStatusColor = v35.Theme.IconEmphasis.Color
			OnlineStatusTransparency = v35.Theme.IconEmphasis.Transparency
			Online = lastLocation
			TextMuted = v35.Theme.TextEmphasis
			n1 = getIconSize(IconSize.Small)
			v54 = v46
		elseif v43 == Enums.PresenceTypes.InStudio then
			v48 = t1[Enums.PresenceTypes.InStudio]
			OnlineStatusColor = v35.Theme.TextDefault.Color
			OnlineStatusTransparency = v35.Theme.TextDefault.Transparency
			Online = v47.InStudio
			TextMuted = v35.Theme.TextMuted
			n1 = getIconSize(IconSize.Small)
		else
			v48 = t1[Enums.PresenceTypes.Offline]
			OnlineStatusColor = v35.Theme.OfflineStatus.Color
			OnlineStatusTransparency = v35.Theme.OfflineStatus.Transparency
			n1 = 12
			Online = v47.Offline
			TextMuted = v35.Theme.TextMuted
		end
	end

	return React.createElement(PlayerContext, {
		layoutOrder = 2,
		fontStyle = v35.Font.CaptionBody,
		icon = v48,
		iconColor = OnlineStatusColor,
		iconSize = UDim2.fromOffset(n1, n1),
		iconTransparency = OnlineStatusTransparency,
		text = Online,
		textColorStyle = TextMuted,
		onActivated = v54
	})
end

return contextualPresence
