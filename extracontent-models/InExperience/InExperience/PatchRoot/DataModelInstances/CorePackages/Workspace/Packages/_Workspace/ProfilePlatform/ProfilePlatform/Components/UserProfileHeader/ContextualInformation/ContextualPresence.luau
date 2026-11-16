local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RoactUtils = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local GameDetail = require(parent.GameDetail)
local OpenGameDetails = GameDetail.OpenGameDetails
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local PlayerContext = UIBlox.App.Indicator.PlayerContext

local Presence = require(ProfilePlatform.Rodux.Presence)
local PresenceType = Presence.Enums.PresenceType
local NetworkingPresence = require(ProfilePlatform.Networking.NetworkingPresence)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local convertPresenceEnum = require(ProfilePlatform.Utils.convertPresenceEnum)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformImproveGameDetailsAnalytics = SharedFlags.FFlagProfilePlatformImproveGameDetailsAnalytics

local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local useGetPresenceByUserId

if FFlagProfilePlatformPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local v

if FFlagProfilePlatformPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	v = DataHydration.Presence.PresenceStore.get()
else
	v = nil
end

local v2 = {
	userPresenceType = PresenceType.Offline,
	lastLocation = "",
	universeId = "",
	placeId = ""
}

local v3 = { skipFetch = true }

local v4 = {
	[Enums.PresenceTypes.Offline] = Images["component_assets/circle_26_stroke_3"],
	[Enums.PresenceTypes.Online] = Images["component_assets/circle_16"],
	[Enums.PresenceTypes.InGame] = Images["icons/menu/games_small"],
	[Enums.PresenceTypes.InStudio] = Images["icons/logo/studiologo_small"]
}

local function contextualPresence(p)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = useStyle()
	local v8 = useProfileAnalyticsContext()
	local v9

	if FFlagProfilePlatformImproveGameDetailsAnalytics then
		v9 = useRoactService(RoactAnalyticsCommonGameEvents)
	else
		v9 = nil
	end

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)

	local profileId = useProfileWrapperContext().profileId
	local v10

	if FFlagProfilePlatformPresenceStoreMigration then
		useEffectOnMount(function()
			v.RefreshPresenceByUserId((tostring(profileId)))
		end)
		local v11, v12 = useGetPresenceByUserId(profileId, v3)

		v10 = v11 or p.presenceInfoOverride or v2

		React.useEffect(function()
			if ref2.current or v12 ~= "Ready" and v12 ~= "Failed" then
				return
			end

			ref2.current = true

			local userPresenceType = v10.userPresenceType
			local v13

			if v10.universeId then
				v13 = tonumber(v10.universeId)
			end

			local presenceType = convertPresenceEnum(userPresenceType, v13)

			v8.fireAnalyticsEvent(EventNames.ProfilePresenceLoaded, {
				presenceType = presenceType,
				universeId = v10.universeId
			})
		end, { v10, v12, v8 })
	else
		useEffectOnMount(function()
			v5(NetworkingPresence.GetPresencesFromUserIds.API({ profileId })):andThen(function()
				ref.current = true
			end):catch(function(_) end)
		end)

		v10 = useSelector(function(p2)
			return Presence.Selectors.getUserPresenceByUserId(p2, profileId)
				or { userPresenceType = PresenceType.Offline, lastLocation = "" }
		end)

		v10 = not ref.current and p.presenceInfoOverride or v10

		React.useEffect(function()
			if not ref.current or ref2.current then
				return
			end

			ref2.current = true

			local presenceType = convertPresenceEnum(v10.userPresenceType, v10.universeId)
			v8.fireAnalyticsEvent(EventNames.ProfilePresenceLoaded, {
				presenceType = presenceType,
				universeId = v10.universeId
			})
		end, { v10 })
	end

	local userPresenceType = v10.userPresenceType
	local universeId

	if FFlagProfilePlatformPresenceStoreMigration then
		if v10.universeId then
			universeId = tonumber(v10.universeId)
		end
	else
		universeId = v10.universeId
	end

	local v11 = convertPresenceEnum(userPresenceType, universeId)

	local text = v10.lastLocation
	local universeId2 = v10.universeId

	local v12 = React.useCallback(function()
		v8.fireAnalyticsEvent(EventNames.GameDetailsButton)

		if FFlagProfilePlatformImproveGameDetailsAnalytics then
			v9.reportOpenGameDetailFromProfileContext(
				v10.placeId,
				v10.universeId,
				AppPage.ProfilePlatform,
				profileId,
				"ProfilePlatformContextualPresence"
			)
		end

		v5(OpenGameDetails(universeId2, v6, { mountAsFullView = true, showBackButton = true }))
	end, { universeId2, v6, v8 })

	local v13 = useLocalization({
		[Enums.PresenceTypes.Online] = TextKeys.Online,
		[Enums.PresenceTypes.Offline] = TextKeys.Offline,
		[Enums.PresenceTypes.InStudio] = TextKeys.InStudio
	})

	local onActivated = nil
	local icon, color, transparency, textColorStyle, v14

	if v10 then
		if v11 == Enums.PresenceTypes.Online then
			icon = v4[Enums.PresenceTypes.Online]
			color = v7.Theme.OnlineStatus.Color
			transparency = v7.Theme.OnlineStatus.Transparency
			text = v13.Online
			textColorStyle = v7.Theme.TextMuted
			v14 = 12
		elseif v11 == Enums.PresenceTypes.InGame then
			icon = v4[Enums.PresenceTypes.InGame]
			color = v7.Theme.IconEmphasis.Color
			transparency = v7.Theme.IconEmphasis.Transparency

			textColorStyle = v7.Theme.TextEmphasis
			v14 = getIconSize(IconSize.Small)
			onActivated = v12
		elseif v11 == Enums.PresenceTypes.InStudio then
			icon = v4[Enums.PresenceTypes.InStudio]
			color = v7.Theme.TextDefault.Color
			transparency = v7.Theme.TextDefault.Transparency
			text = v13.InStudio
			textColorStyle = v7.Theme.TextMuted
			v14 = getIconSize(IconSize.Small)
		else
			icon = v4[Enums.PresenceTypes.Offline]
			color = v7.Theme.OfflineStatus.Color
			transparency = v7.Theme.OfflineStatus.Transparency

			text = v13.Offline
			textColorStyle = v7.Theme.TextMuted
			v14 = 12
		end
	else
		text = nil
	end

	return React.createElement(PlayerContext, {
		fontStyle = v7.Font.CaptionBody,
		icon = icon,
		iconColor = color,
		iconSize = UDim2.fromOffset(v14, v14),
		iconTransparency = transparency,
		layoutOrder = 2,
		text = text,
		textColorStyle = textColorStyle,
		onActivated = onActivated
	})
end

return contextualPresence
