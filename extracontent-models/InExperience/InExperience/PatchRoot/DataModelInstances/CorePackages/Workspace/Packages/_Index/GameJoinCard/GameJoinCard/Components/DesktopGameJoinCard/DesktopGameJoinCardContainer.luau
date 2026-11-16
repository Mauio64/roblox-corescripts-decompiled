local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent
local HttpService = game:GetService("HttpService")
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local GameDetail = require(parent.GameDetail)
local DataHydration = require(parent.DataHydration)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SocialCommon = require(parent.SocialCommon)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local SocialExperienceJoin = require(parent.SocialExperienceJoin)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local gameDetailReferral = DiscoveryAnalytics.Events.gameDetailReferral
local PeopleListInHomePage = DiscoveryAnalytics.Constants.Context.PeopleListInHomePage
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NotificationType = RobloxAppEnums.NotificationType

local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppSessionService = RoactServiceTags.AppSessionService
local AppGuiService = RoactServiceTags.AppGuiService
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local RobloxAppSessionization2 = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization2.SessionType
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local useDeviceType = RobloxAppHooks.useDeviceType
local ContentProvider = game:GetService("ContentProvider")
local DesktopGameJoinCard = require(script.Parent.DesktopGameJoinCard)
local GamepadJoinFocusBehavior = require(script.Parent.GamepadJoinFocusBehavior)
local OpenGameDetails = GameDetail.OpenGameDetails

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Navigation2 = require(parent.Navigation)
local useNavigationFocus = Navigation2.useNavigationFocus
local RoactUtils = require(parent.RoactUtils)
local Hooks = RoactUtils.Hooks
local dependencyArray = Hooks.dependencyArray
local useDispatch = Hooks.RoactRodux.useDispatch
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize

local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local usePreferredInput = Responsive.usePreferredInput
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local SharedFlags = require(parent.SharedFlags)
local FFlagDesktopGameJoinCardGamepadSupport = SharedFlags.FFlagDesktopGameJoinCardGamepadSupport
local FFlagConsoleOpenGameJoinCard = SharedFlags.FFlagConsoleOpenGameJoinCard
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local FFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local FFlagGameJoinCardAnalyticsCardId = SharedFlags.FFlagGameJoinCardAnalyticsCardId
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local FFlagJoinUserCTAsIxpEnabled = SharedFlags.FFlagJoinUserCTAsIxpEnabled
local FStringJoinUserCTAsIxpLayer = SharedFlags.FStringJoinUserCTAsIxpLayer
local ixpServiceWrapper

if FFlagJoinUserCTAsIxpEnabled then
	local IXPServiceWrapper = require(parent.IXPServiceWrapper)
	ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
else
	ixpServiceWrapper = nil
end

local FFlagGameJoinCardChatEntryPoint = require(GameJoinCard.Flags.FFlagGameJoinCardChatEntryPoint)
local useIsRouteOnScreen

if FFlagEnableOnScreenAPIIntegration then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	useIsRouteOnScreen = RobloxAppNavigation.useIsRouteOnScreen
else
	useIsRouteOnScreen = nil
end

local getPlatformFriendsService = require(GameJoinCard.Utils.getPlatformFriendsService)

local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local GameJoinCardSurface = AnalyticsConstants.GameJoinCardSurface
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require(script.Parent.Parent.Parent.Analytics.useGameJoinCardAnalytics)
local useAgeCheckUpsellAnalytics = require(script.Parent.Parent.Parent.Analytics.useAgeCheckUpsellAnalytics)
local useAgeCheckCompletionLogger = useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useAgeCheckPressLogger = useAgeCheckUpsellAnalytics.useAgeCheckPressLogger
local Actions = require(GameJoinCard.Components.Actions)
local containsAction = require(GameJoinCard.Components.Actions.containsAction)
local useJoinUserActions = require(GameJoinCard.Hooks.useJoinUserActions)
local useLogActionsResolveTime = require(GameJoinCard.Telemetry.useLogActionsResolveTime)

local DataStatus = DataHydration.DataStatus

local function DesktopGameJoinCardContainer(props)
	local dispatch = useDispatch()
	local navigation = useNavigation()
	local v

	if FFlagEnableOnScreenAPIIntegration then
		v = useIsRouteOnScreen()
	else
		v = useNavigationFocus() ~= false
	end

	local state, setState

	if FFlagGameJoinCardAnalyticsCardId then
		state, setState = React.useState(nil)
	else
		state = nil
		setState = nil
	end

	local layoutOrder = props.layoutOrder
	local playerName = props.playerName
	local platformName = props.platformName
	local presence = props.presence
	local universeId = tostring(presence.universeId)
	local lastLocation = presence.lastLocation
	local gameIconUrl = React.useMemo(function()
		return getRbxThumb(ThumbnailType.GameIcon, universeId, ThumbnailSize.Small)
	end, { universeId })
	local state2, setState2 = React.useState(Enum.AssetFetchStatus.None)
	React.useEffect(function()
		setState2(ContentProvider:GetAssetFetchStatus(gameIconUrl))
	end, { gameIconUrl })
	React.useEffect(function()
		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(gameIconUrl):Connect(setState2)
		return function()
			connection:Disconnect()
		end
	end, { gameIconUrl })

	local onAgeCheckCompletion = useAgeCheckCompletionLogger(universeId)
	local v2 = useJoinUserInExperience(props.userId, {
		isHomePageCarousel = true,
		homepageCarouselAbsolutePosition = props.homepageCarouselAbsolutePosition,
		presence = props.presence,
		onAgeCheckCompletion = onAgeCheckCompletion
	})

	local v3 = {
		userId = props.userId,
		universeId = universeId,
		absolutePosition = props.homepageCarouselAbsolutePosition,
		joinGameCardId = 0,
		joinAgeCheckUpsellFlow = 0
	}
	local joinGameCardId

	if FFlagGameJoinCardAnalyticsCardId then
		joinGameCardId = state
	end

	v3.joinGameCardId = joinGameCardId
	v3.joinAgeCheckUpsellFlow = v2.joinAgeCheckUpsellFlow
	local onAgeCheckPressed = useAgeCheckPressLogger(v3)
	local v4, v5, localized

	if FFlagJoinabilityCTARefactor then
		local formatted = `{tostring(presence.userPresenceType)}:{tostring(presence.universeId)}:{tostring(presence.placeId)}:{tostring(presence.rootPlaceId)}:{tostring(v2.ageCheckRequired)}`

		local userId = props.userId
		local v6 = props.isOpen == true and v
		v4, v5 = useJoinUserActions(userId, v6, formatted)
		localized = useLocalization(Actions.TextKeys)
	end

	local v6

	if FFlagJoinabilityCTARefactor then
		v6 = v5
	end

	useLogActionsResolveTime(v6, props.isOpen == true and v, GameJoinCardSurface.Desktop)
	local v7

	if FFlagJoinabilityCTARefactor then
		if v5 == DataStatus.Ready then
			v7 = containsAction(v4, UserCtaAction.UnlockExperience)
		else
			v7 = false
		end
	else
		v7 = v2.ageCheckRequired == true
	end

	local ref = React.useRef(false)
	React.useEffect(function()
		local current = props.isOpen == true and v

		if current and not ref.current then
			local joinGameCardId2

			if FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = HttpService:GenerateGUID(false)
			end

			if FFlagGameJoinCardAnalyticsCardId then
				setState(joinGameCardId2)
			end

			if FFlagJoinUserCTAsIxpEnabled then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringJoinUserCTAsIxpLayer)
			end

			local universeId2 = props.presence.universeId
			local logGameJoinCardPageLoaded = useGameJoinCardAnalytics.logGameJoinCardPageLoaded
			local v8 = {
				friendId = props.userId,
				universeId = 0,
				absolutePosition = 0,
				joinGameCardId = 0
			}
			local universeId3

			if not (universeId2 == nil or tostring(universeId2) == "") then
				universeId3 = tostring(universeId2)
			end

			v8.universeId = universeId3

			v8.absolutePosition = props.homepageCarouselAbsolutePosition

			if not FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = nil
			end

			v8.joinGameCardId = joinGameCardId2
			logGameJoinCardPageLoaded(v8)
		end

		ref.current = current
	end, dependencyArray(props.isOpen, v, props.userId, props.presence, props.homepageCarouselAbsolutePosition))

	React.useEffect(function()
		if props.isOpen and not v then
			props.onClose()
		end
	end, dependencyArray(v, props))

	React.useEffect(function()
		if not (props.isOpen and v and v7) then
			return
		end

		local logJoinCardAgeCheckUpsellImpression = useGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression
		local universeId2

		if universeId ~= "" then
			universeId2 = universeId
		end

		logJoinCardAgeCheckUpsellImpression({ universeId = universeId2 })
	end, dependencyArray(props.isOpen, v, v7, universeId))

	local isLoading = universeId == ""
		or lastLocation == nil
		or lastLocation == ""
		or state2 == Enum.AssetFetchStatus.Loading

	local v8 = usePreferredInput()
	local v9

	if FFlagDesktopGameJoinCardGamepadSupport then
		v9 = useDeviceType()
	end

	local isConsole

	if v8 == Responsive.Input.Directional then
		isConsole = not FFlagDesktopGameJoinCardGamepadSupport or v9 ~= RobloxAppEnums.DeviceType.Desktop
	else
		isConsole = false
	end

	if props.isConsole ~= nil then
		isConsole = props.isConsole
	end

	local platformProfileId = props.platformProfileId
	local onPlatformProfilePressed = React.useCallback(function()
		if getPlatformFriendsService == nil or platformProfileId == nil or platformProfileId == "" then
			return
		end

		getPlatformFriendsService:ShowProfile(platformProfileId)
	end, { platformProfileId })

	local v10 = useAppFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = false,
		isFocusable = props.isFocused == true and v
	})

	local ref2 = React.useRef(nil)
	local v11 = ((not FFlagDesktopGameJoinCardGamepadSupport or isConsole) and true or false)
		and not (FFlagConsoleOpenGameJoinCard and isConsole)
	local focusRootRef = React.useCallback(function(current)
		ref2.current = current

		if v10 and v11 then
			v10(current)
		end

		if props.onCardGuiObjectChanged then
			props.onCardGuiObjectChanged(current)
		end
	end, { v10, props.onCardGuiObjectChanged, v11 })

	local eventIngest = useRoactService(AppEventIngestService)
	local v12 = useRoactService(AppSessionService)
	local guiService = useRoactService(AppGuiService)

	local v13 = useAppPolicy(function(p)
		return p.getCanUsePlatformChat()
	end)
	local areActionsLoading, joinCardActions

	if FFlagJoinabilityCTARefactor then
		areActionsLoading = v5 == DataStatus.NotReady
		joinCardActions = {}

		if v5 == DataStatus.Ready and localized ~= nil then
			local resolveJoinCardActions = Actions.resolveJoinCardActions
			local v14 = {
				localized = localized,
				userId = props.userId,
				telemetry = 0,
				presence = 0,
				experience = 0,
				eventIngest = 0,
				dispatch = 0,
				guiService = 0,
				navigation = 0,
				joinAgeCheckUpsellFlow = 0
			}
			local universeId2

			if universeId ~= "" then
				universeId2 = universeId
			end

			local telemetry = {
				universeId = universeId2,
				absolutePosition = props.homepageCarouselAbsolutePosition,
				joinGameCardId = 0
			}
			local joinGameCardId2

			if FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = state
			end

			telemetry.joinGameCardId = joinGameCardId2
			v14.telemetry = telemetry
			local placeId

			if presence.placeId ~= nil then
				placeId = tostring(presence.placeId)
			end

			local rootPlaceId

			if presence.rootPlaceId ~= nil then
				rootPlaceId = tostring(presence.rootPlaceId)
			end

			v14.presence = { placeId = placeId, rootPlaceId = rootPlaceId }

			v14.experience = {
				isLoading = isLoading,
				isInExperience = v2.isInExperience,
				joinExperience = v2.joinExperience,
				playExperience = v2.playExperience
			}

			v14.eventIngest = eventIngest
			v14.dispatch = dispatch
			v14.guiService = guiService
			v14.navigation = navigation
			v14.joinAgeCheckUpsellFlow = v2.joinAgeCheckUpsellFlow
			local joinCardActions2 = resolveJoinCardActions(v4, v14)

			for _, joinCardAction in joinCardActions2 do
				if joinCardAction.id ~= UserCtaAction.Chat or v13 then
					table.insert(joinCardActions, joinCardAction)
				end
			end
		end
	else
		areActionsLoading = false
	end

	local v14 = React.useCallback(function()
		local userId = props.userId

		if userId == "" then
			return
		end

		local placeId = (presence.placeId == nil or tostring(presence.placeId) == "") and ""
			or tostring(presence.placeId)

		local rootPlaceId = tonumber(presence.rootPlaceId)

		if placeId == "" or rootPlaceId == nil then
			return
		end

		gamePlayIntent(eventIngest, PeopleListInHomePage, {
			placeId = placeId,
			rootPlaceId = rootPlaceId,
			friendId = userId,
			joinAttemptId = HttpService:GenerateGUID(false)
		})
	end, dependencyArray(props.userId, presence))

	local v15 = React.useCallback(function()
		if universeId == "" then
			return
		end

		local rootPlaceId = presence.rootPlaceId
		local pid

		if rootPlaceId == nil or tostring(rootPlaceId) == "" then
			pid = universeId
		else
			pid = tostring(rootPlaceId)
		end

		local homepageCarouselAbsolutePosition = props.homepageCarouselAbsolutePosition or 0

		if v12 then
			SetGamePlaySession(v12, SessionType.StructuralIdentifier.GameDetailSource, false)
		end

		gameDetailReferral(eventIngest, "home", {
			ad = "no",
			friendId = props.userId,
			pg = "home",
			pid = pid,
			pos = homepageCarouselAbsolutePosition,
			rowOnPage = 1,
			sortPos = props.layoutOrder,
			tis = 1,
			universeId = universeId
		})

		dispatch(OpenGameDetails(universeId, navigation))
	end, dependencyArray(
		dispatch,
		navigation,
		universeId,
		presence,
		props.homepageCarouselAbsolutePosition,
		props.layoutOrder,
		props.userId
	))

	local onViewExperienceDetails = React.useCallback(function(p)
		if universeId == "" then
			return
		end

		if props.userId ~= "" then
			local v16 = {
				friendId = props.userId,
				universeId = 0,
				absolutePosition = 0,
				joinGameCardId = 0
			}
			local universeId2

			if universeId ~= "" then
				universeId2 = universeId
			end

			v16.universeId = universeId2
			v16.absolutePosition = props.homepageCarouselAbsolutePosition
			local joinGameCardId2

			if FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = state
			end

			v16.joinGameCardId = joinGameCardId2

			if p == viewEDPsourceValues.Thumbnail then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.ViewExperienceDetailsFromThumbnail,
					v16
				)
			elseif p == viewEDPsourceValues.Title then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.ViewExperienceDetailsFromTitle,
					v16
				)
			end
		end

		v15()
	end, dependencyArray(v15, universeId, props.userId, props.homepageCarouselAbsolutePosition, state))

	local v16 = React.useCallback(function()
		if props.userId ~= "" then
			local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
			local joinGame = GameJoinCardButtonAction.JoinGame
			local v16 = {
				friendId = props.userId,
				universeId = 0,
				absolutePosition = 0,
				joinGameCardId = 0
			}
			local universeId2

			if universeId ~= "" then
				universeId2 = universeId
			end

			v16.universeId = universeId2
			v16.absolutePosition = props.homepageCarouselAbsolutePosition
			local joinGameCardId2

			if FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = state
			end

			v16.joinGameCardId = joinGameCardId2
			logGameJoinCardButtonEvent(joinGame, v16)
		end

		v14()
		v2.joinExperience()
		props.onClose()
	end, dependencyArray(
		v14,
		v2.joinExperience,
		props.userId,
		universeId,
		props.homepageCarouselAbsolutePosition,
		props.onClose,
		state
	))

	local onViewProfile = React.useCallback(function(p)
		if props.userId ~= "" then
			local v17 = {
				friendId = props.userId,
				universeId = 0,
				absolutePosition = 0,
				joinGameCardId = 0
			}
			local universeId2

			if universeId ~= "" then
				universeId2 = universeId
			end

			v17.universeId = universeId2
			v17.absolutePosition = props.homepageCarouselAbsolutePosition
			local joinGameCardId2

			if FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = state
			end

			v17.joinGameCardId = joinGameCardId2

			if p == viewProfileSourceValues.UserTile then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.OpenProfileFromUserTile,
					v17
				)
			elseif p == viewProfileSourceValues.ViewProfileButton then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.OpenProfileFromViewProfile,
					v17
				)
			end
		end

		local v17

		if FFlagEnableSplitPane then
			v17 = navigation.push
		else
			v17 = navigation.navigate
		end

		v17(AppPage.ProfilePlatform, { detail = props.userId })

		props.onClose()
	end, dependencyArray(
		navigation,
		props.userId,
		universeId,
		props.homepageCarouselAbsolutePosition,
		props.onClose,
		state
	))

	local onChat = React.useCallback(function()
		if props.userId == "" then
			return
		end

		local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
		local chat = GameJoinCardButtonAction.Chat
		local v17 = {
			friendId = props.userId,
			universeId = 0,
			absolutePosition = 0,
			joinGameCardId = 0
		}
		local universeId2

		if universeId ~= "" then
			universeId2 = universeId
		end

		v17.universeId = universeId2
		v17.absolutePosition = props.homepageCarouselAbsolutePosition
		local joinGameCardId2

		if FFlagGameJoinCardAnalyticsCardId then
			joinGameCardId2 = state
		end

		v17.joinGameCardId = joinGameCardId2
		logGameJoinCardButtonEvent(chat, v17)

		if FFlagGameJoinCardChatEntryPoint then
			dispatch(EnteredChatFromEntryPoint(ChatEntryPointNames.GameJoinCard))
		end

		guiService:BroadcastNotification(props.userId, NotificationType.LAUNCH_CONVERSATION)
		props.onClose()
	end, dependencyArray(
		props.userId,
		universeId,
		props.homepageCarouselAbsolutePosition,
		guiService,
		props.onClose,
		state,
		dispatch
	))

	local createElement = React.createElement
	local v17 = {
		layoutOrder = layoutOrder,
		playerName = playerName,
		experienceName = lastLocation,
		gameIconUrl = gameIconUrl,
		isLoading = isLoading,
		onJoin = v16,
		onViewExperienceDetails = onViewExperienceDetails,
		anchorRef = props.anchorRef,
		isOpen = props.isOpen and v,
		onClose = props.onClose,
		isConsole = isConsole,
		consolePlatformLabel = platformName,
		focusRootRef = focusRootRef,
		ageCheckRequired = v2.ageCheckRequired,
		onAgeCheckPressed = onAgeCheckPressed,
		onPlatformProfilePressed = 0,
		onChat = 0,
		onViewProfile = 0,
		actions = 0,
		areActionsLoading = 0
	}

	if not isConsole then
		onPlatformProfilePressed = nil
	end

	v17.onPlatformProfilePressed = onPlatformProfilePressed

	if isConsole or not v13 then
		onChat = nil
	end

	v17.onChat = onChat

	if isConsole then
		onViewProfile = nil
	end

	v17.onViewProfile = onViewProfile
	v17.actions = not FFlagJoinabilityCTARefactor and {} or joinCardActions

	if not FFlagJoinabilityCTARefactor then
		areActionsLoading = nil
	end

	v17.areActionsLoading = areActionsLoading
	local element = createElement(DesktopGameJoinCard, v17)

	if props.showGamepadJoinFocus then
		return React.createElement(React.Fragment, nil, {
			GamepadJoinFocus = React.createElement(GamepadJoinFocusBehavior, {
				tileRef = props.anchorRef,
				cardRef = ref2,
				joinExperience = v16
			}),
			Card = element
		})
	end

	return element
end

return DesktopGameJoinCardContainer
