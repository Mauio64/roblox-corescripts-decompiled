local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").RoactAnalyticsCommonGameEvents
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useRoactService

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation

local openGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameDetail").OpenGameDetails
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local playerContext = UIBlox.App.Indicator.PlayerContext

local Presence = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Presence")
local presenceType = Presence.Enums.PresenceType
local module5 = require("@luauforge/bundled/fdi")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local convertPresenceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/convertPresenceEnum")

local fFlagProfilePlatformImproveGameDetailsAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformImproveGameDetailsAnalytics

local FFlagProfilePlatformPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformPresenceStoreMigration")

local useGetPresenceByUserId = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FriendsCommon").Hooks.useGetPresenceByUserId else nil

local v5 = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration").Presence.PresenceStore.get() else nil

local v6 = {
	userPresenceType = presenceType.Offline,
	lastLocation = "",
	universeId = "",
	placeId = ""
}

local v7 = { skipFetch = true }

local v8 = {
	[Enums.PresenceTypes.Offline] = images["component_assets/circle_26_stroke_3"],
	[Enums.PresenceTypes.Online] = images["component_assets/circle_16"],
	[Enums.PresenceTypes.InGame] = images["icons/menu/games_small"],
	[Enums.PresenceTypes.InStudio] = images["icons/logo/studiologo_small"]
}

local function contextualPresence(p2)
	local v9 = useDispatch()
	local v10 = useNavigation()
	local v11 = useStyle()
	local v12 = useProfileAnalyticsContext()
	local v13

	if fFlagProfilePlatformImproveGameDetailsAnalytics then
		v13 = useRoactService(roactAnalyticsCommonGameEvents)
	else
		v13 = nil
	end

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)

	local profileId = useProfileWrapperContext().profileId
	local v14

	if FFlagProfilePlatformPresenceStoreMigration then
		useEffectOnMount(function()
			v5.RefreshPresenceByUserId((tostring(profileId)))
		end)
		local v15, v16 = useGetPresenceByUserId(profileId, v7)

		v14 = v15 or p2.presenceInfoOverride or v6

		React.useEffect(function()
			if ref2.current or v16 ~= "Ready" and v16 ~= "Failed" then
				return
			end

			ref2.current = true

			local userPresenceType = v14.userPresenceType
			local v18 = if v14.universeId then tonumber(v14.universeId) else nil
			local v19 = convertPresenceEnum(userPresenceType, v18)

			v12.fireAnalyticsEvent(EventNames.ProfilePresenceLoaded, {
				presenceType = v19,
				universeId = v14.universeId
			})
		end, { v14, v16, v12 })
	else
		useEffectOnMount(function()
			v9(module5.GetPresencesFromUserIds.API({ profileId })):andThen(function()
				ref.current = true
			end):catch(function(p3) end)
		end)

		v14 = useSelector(function(p3)
			return Presence.Selectors.getUserPresenceByUserId(p3, profileId)
				or { userPresenceType = presenceType.Offline, lastLocation = "" }
		end)

		v14 = not ref.current and p2.presenceInfoOverride or v14

		React.useEffect(function()
			if not ref.current or ref2.current then
				return
			end

			ref2.current = true

			local v15 = convertPresenceEnum(v14.userPresenceType, v14.universeId)
			v12.fireAnalyticsEvent(EventNames.ProfilePresenceLoaded, {
				presenceType = v15,
				universeId = v14.universeId
			})
		end, { v14 })
	end

	local userPresenceType = v14.userPresenceType
	local universeId

	if FFlagProfilePlatformPresenceStoreMigration then
		if v14.universeId then
			universeId = tonumber(v14.universeId)
		end
	else
		universeId = v14.universeId
	end

	local v16 = convertPresenceEnum(userPresenceType, universeId)

	local v17 = v14.lastLocation
	local universeId2 = v14.universeId

	local v18 = React.useCallback(function()
		v12.fireAnalyticsEvent(EventNames.GameDetailsButton)

		if fFlagProfilePlatformImproveGameDetailsAnalytics then
			v13.reportOpenGameDetailFromProfileContext(
				v14.placeId,
				v14.universeId,
				appPage.ProfilePlatform,
				profileId,
				"ProfilePlatformContextualPresence"
			)
		end

		v9(openGameDetails(universeId2, v10, {
			mountAsFullView = true,
			showBackButton = true
		}))
	end, { universeId2, v10, v12 })

	local v21 = useLocalization({
		[Enums.PresenceTypes.Online] = TextKeys.Online,
		[Enums.PresenceTypes.Offline] = TextKeys.Offline,
		[Enums.PresenceTypes.InStudio] = TextKeys.InStudio
	})

	local v22 = nil
	local v23, color, transparency, v24, v25

	if v14 then
		if v16 == Enums.PresenceTypes.Online then
			v23 = v8[Enums.PresenceTypes.Online]
			color = v11.Theme.OnlineStatus.Color
			transparency = v11.Theme.OnlineStatus.Transparency
			v17 = v21.Online
			v24 = v11.Theme.TextMuted
			v25 = 12
		elseif v16 == Enums.PresenceTypes.InGame then
			v23 = v8[Enums.PresenceTypes.InGame]
			color = v11.Theme.IconEmphasis.Color
			transparency = v11.Theme.IconEmphasis.Transparency

			v24 = v11.Theme.TextEmphasis
			v25 = getIconSize(iconSize.Small)
			v22 = v18
		elseif v16 == Enums.PresenceTypes.InStudio then
			v23 = v8[Enums.PresenceTypes.InStudio]
			color = v11.Theme.TextDefault.Color
			transparency = v11.Theme.TextDefault.Transparency
			v17 = v21.InStudio
			v24 = v11.Theme.TextMuted
			v25 = getIconSize(iconSize.Small)
		else
			v23 = v8[Enums.PresenceTypes.Offline]
			color = v11.Theme.OfflineStatus.Color
			transparency = v11.Theme.OfflineStatus.Transparency

			v17 = v21.Offline
			v24 = v11.Theme.TextMuted
			v25 = 12
		end
	else
		v17 = nil
	end

	return React.createElement(playerContext, {
		fontStyle = v11.Font.CaptionBody,
		icon = v23,
		iconColor = color,
		iconSize = UDim2.fromOffset(v25, v25),
		iconTransparency = transparency,
		layoutOrder = 2,
		text = v17,
		textColorStyle = v24,
		onActivated = v22
	})
end

return contextualPresence
