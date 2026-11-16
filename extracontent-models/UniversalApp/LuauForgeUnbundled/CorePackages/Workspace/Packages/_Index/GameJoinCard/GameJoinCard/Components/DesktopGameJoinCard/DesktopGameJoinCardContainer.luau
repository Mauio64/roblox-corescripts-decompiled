local HttpService = game:GetService("HttpService")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Responsive")
local GameDetail = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/GameDetail")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization").Hooks.useLocalization
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SocialCommon")
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local enteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DiscoveryAnalytics")
local SocialExperienceJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SocialExperienceJoin")
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local gameDetailReferral = DiscoveryAnalytics.Events.gameDetailReferral
local peopleListInHomePage = DiscoveryAnalytics.Constants.Context.PeopleListInHomePage
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppEnums")
local appPage = RobloxAppEnums.AppPage
local notificationType = RobloxAppEnums.NotificationType

local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RoactServiceTags")
local appEventIngestService = RoactServiceTags.AppEventIngestService
local appSessionService = RoactServiceTags.AppSessionService
local appGuiService = RoactServiceTags.AppGuiService
local setGamePlaySession = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppSessionization").SetGamePlaySession
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppSessionization").SessionType
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppHooks")
local useRoactService = RobloxAppHooks.useRoactService
local useDeviceType = RobloxAppHooks.useDeviceType
local ContentProvider = game:GetService("ContentProvider")
local DesktopGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/DesktopGameJoinCard/DesktopGameJoinCard")
local GamepadJoinFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/DesktopGameJoinCard/GamepadJoinFocusBehavior")
local openGameDetails = GameDetail.OpenGameDetails

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Navigation").useNavigation
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Navigation").useNavigationFocus
local hooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RoactUtils").Hooks
local dependencyArray = hooks.dependencyArray
local useDispatch = hooks.RoactRodux.useDispatch
local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailType = Foundation.Enums.ThumbnailType
local thumbnailSize = Foundation.Enums.ThumbnailSize

local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local usePreferredInput = Responsive.usePreferredInput
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/UniversalAppPolicy").useAppPolicy

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/FocusNavigationUtils")
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")
local fFlagDesktopGameJoinCardGamepadSupport = SharedFlags.FFlagDesktopGameJoinCardGamepadSupport
local fFlagConsoleOpenGameJoinCard = SharedFlags.FFlagConsoleOpenGameJoinCard
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local fFlagGameJoinCardAnalyticsCardId = SharedFlags.FFlagGameJoinCardAnalyticsCardId
local fFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local fFlagJoinUserCTAsIxpEnabled = SharedFlags.FFlagJoinUserCTAsIxpEnabled
local fStringJoinUserCTAsIxpLayer = SharedFlags.FStringJoinUserCTAsIxpLayer

local ixpServiceWrapper = if fFlagJoinUserCTAsIxpEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/IxpServiceWrapper").IXPServiceWrapper else nil

local FFlagGameJoinCardChatEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagGameJoinCardChatEntryPoint")

local useIsRouteOnScreen = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppNavigation").useIsRouteOnScreen else nil

local getPlatformFriendsService = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Utils/getPlatformFriendsService")

local AnalyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants")
local gameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local gameJoinCardSurface = AnalyticsConstants.GameJoinCardSurface
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")
local useAgeCheckUpsellAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useAgeCheckUpsellAnalytics")
local useAgeCheckCompletionLogger = useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useAgeCheckPressLogger = useAgeCheckUpsellAnalytics.useAgeCheckPressLogger
local Actions = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions")
local containsAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/containsAction")
local useJoinUserActions = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/useJoinUserActions")
local useLogActionsResolveTime = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/useLogActionsResolveTime")

local dataStatus = DataHydration.DataStatus

local function DesktopGameJoinCardContainer(props)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7

	if fFlagEnableOnScreenAPIIntegration then
		v7 = useIsRouteOnScreen()
	else
		v7 = useNavigationFocus() ~= false
	end

	local state, setState

	if fFlagGameJoinCardAnalyticsCardId then
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
	local v8 = React.useMemo(function()
		return getRbxThumb(thumbnailType.GameIcon, universeId, thumbnailSize.Small)
	end, { universeId })
	local state2, setState2 = React.useState(Enum.AssetFetchStatus.None)
	React.useEffect(function()
		setState2(ContentProvider:GetAssetFetchStatus(v8))
	end, { v8 })
	React.useEffect(function()
		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(v8):Connect(setState2)
		return function()
			connection:Disconnect()
		end
	end, { v8 })

	local v9 = useAgeCheckCompletionLogger(universeId)
	local v10 = useJoinUserInExperience(props.userId, {
		isHomePageCarousel = true,
		homepageCarouselAbsolutePosition = props.homepageCarouselAbsolutePosition,
		presence = props.presence,
		onAgeCheckCompletion = v9
	})

	local v14 = useAgeCheckPressLogger({
		userId = props.userId,
		universeId = universeId,
		absolutePosition = props.homepageCarouselAbsolutePosition,
		joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then state else nil,
		joinAgeCheckUpsellFlow = v10.joinAgeCheckUpsellFlow
	})
	local v15, v16, v17

	if fFlagJoinabilityCTARefactor then
		local formatted = `{tostring(presence.userPresenceType)}:{tostring(presence.universeId)}:{tostring(presence.placeId)}:{tostring(presence.rootPlaceId)}:{tostring(v10.ageCheckRequired)}`

		local userId = props.userId
		local v19 = props.isOpen == true and v7
		v15, v16 = useJoinUserActions(userId, v19, formatted)
		v17 = useLocalization(Actions.TextKeys)
	end

	local v19 = if fFlagJoinabilityCTARefactor then v16 else nil
	useLogActionsResolveTime(v19, props.isOpen == true and v7, gameJoinCardSurface.Desktop)
	local v21

	if fFlagJoinabilityCTARefactor then
		v21 = v16 == dataStatus.Ready and containsAction(v15, userCtaAction.UnlockExperience)
	else
		v21 = v10.ageCheckRequired == true
	end

	local ref = React.useRef(false)
	React.useEffect(function()
		local v22 = props.isOpen == true and v7

		if v22 and not ref.current then
			local v23 = if fFlagGameJoinCardAnalyticsCardId then HttpService:GenerateGUID(false) else nil

			if fFlagGameJoinCardAnalyticsCardId then
				setState(v23)
			end

			if fFlagJoinUserCTAsIxpEnabled then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringJoinUserCTAsIxpLayer)
			end

			local universeId2 = props.presence.universeId
			local logGameJoinCardPageLoaded = useGameJoinCardAnalytics.logGameJoinCardPageLoaded
			local v24 = {
				friendId = props.userId,
				universeId = 0,
				absolutePosition = 0,
				joinGameCardId = 0
			}
			local v25 = if universeId2 ~= nil and tostring(universeId2) ~= "" then tostring(universeId2) else nil
			v24.universeId = v25

			v24.absolutePosition = props.homepageCarouselAbsolutePosition

			if not fFlagGameJoinCardAnalyticsCardId then
				v23 = nil
			end

			v24.joinGameCardId = v23
			logGameJoinCardPageLoaded(v24)
		end

		ref.current = v22
	end, dependencyArray(
		props.isOpen,
		v7,
		props.userId,
		props.presence,
		props.homepageCarouselAbsolutePosition
	))

	React.useEffect(function()
		if props.isOpen and not v7 then
			props.onClose()
		end
	end, dependencyArray(v7, props))

	React.useEffect(function()
		if not (props.isOpen and v7 and v21) then
			return
		end

		local logJoinCardAgeCheckUpsellImpression = useGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression
		local v23 = if universeId ~= "" then universeId else nil
		logJoinCardAgeCheckUpsellImpression({ universeId = v23 })
	end, dependencyArray(props.isOpen, v7, v21, universeId))

	local v22 = universeId == ""
		or lastLocation == nil
		or lastLocation == ""
		or state2 == Enum.AssetFetchStatus.Loading

	local v23 = usePreferredInput()
	local v24 = if fFlagDesktopGameJoinCardGamepadSupport then useDeviceType() else nil
	local v25

	if v23 == Responsive.Input.Directional then
		v25 = not fFlagDesktopGameJoinCardGamepadSupport or v24 ~= RobloxAppEnums.DeviceType.Desktop
	else
		v25 = false
	end

	if props.isConsole ~= nil then
		v25 = props.isConsole
	end

	local platformProfileId = props.platformProfileId
	local v26 = React.useCallback(function()
		if getPlatformFriendsService == nil or platformProfileId == nil or platformProfileId == "" then
			return
		end

		getPlatformFriendsService:ShowProfile(platformProfileId)
	end, { platformProfileId })

	local v30 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = false,
		isFocusable = props.isFocused == true and v7
	})

	local ref2 = React.useRef(nil)
	local v31 = ((not fFlagDesktopGameJoinCardGamepadSupport or v25) and true or false)
		and not (fFlagConsoleOpenGameJoinCard and v25)
	local v32 = React.useCallback(function(current)
		ref2.current = current

		if v30 and v31 then
			v30(current)
		end

		if props.onCardGuiObjectChanged then
			props.onCardGuiObjectChanged(current)
		end
	end, { v30, props.onCardGuiObjectChanged, v31 })

	local v33 = useRoactService(appEventIngestService)
	local v34 = useRoactService(appSessionService)
	local v35 = useRoactService(appGuiService)

	local v36 = useAppPolicy(function(p2)
		return p2.getCanUsePlatformChat()
	end)
	local v37, joinCardActions

	if fFlagJoinabilityCTARefactor then
		v37 = v16 == dataStatus.NotReady
		joinCardActions = {}

		if v16 == dataStatus.Ready and v17 ~= nil then
			local resolveJoinCardActions = Actions.resolveJoinCardActions
			local v38 = {
				localized = v17,
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
			local v40 = if universeId ~= "" then universeId else nil
			v38.telemetry = {
				universeId = v40,
				absolutePosition = props.homepageCarouselAbsolutePosition,
				joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then state else nil
			}

			local v43 = if presence.placeId ~= nil then tostring(presence.placeId) else nil
			local v44 = if presence.rootPlaceId ~= nil then tostring(presence.rootPlaceId) else nil
			v38.presence = { placeId = v43, rootPlaceId = v44 }

			v38.experience = {
				isLoading = v22,
				isInExperience = v10.isInExperience,
				joinExperience = v10.joinExperience,
				playExperience = v10.playExperience
			}

			v38.eventIngest = v33
			v38.dispatch = v5
			v38.guiService = v35
			v38.navigation = v6
			v38.joinAgeCheckUpsellFlow = v10.joinAgeCheckUpsellFlow
			local joinCardActions2 = resolveJoinCardActions(v15, v38)

			for k, joinCardAction in joinCardActions2 do
				if joinCardAction.id ~= userCtaAction.Chat or v36 then
					table.insert(joinCardActions, joinCardAction)
				end
			end
		end
	else
		v37 = false
	end

	local v38 = React.useCallback(function()
		local userId = props.userId

		if userId == "" then
			return
		end

		local v39 = (presence.placeId == nil or tostring(presence.placeId) == "") and ""
			or tostring(presence.placeId)

		local rootPlaceId = tonumber(presence.rootPlaceId)

		if v39 == "" or rootPlaceId == nil then
			return
		end

		gamePlayIntent(v33, peopleListInHomePage, {
			placeId = v39,
			rootPlaceId = rootPlaceId,
			friendId = userId,
			joinAttemptId = HttpService:GenerateGUID(false)
		})
	end, dependencyArray(props.userId, presence))

	local v39 = React.useCallback(function()
		if universeId == "" then
			return
		end

		local rootPlaceId = presence.rootPlaceId
		local v40

		if rootPlaceId == nil or tostring(rootPlaceId) == "" then
			v40 = universeId
		else
			v40 = tostring(rootPlaceId)
		end

		local homepageCarouselAbsolutePosition = props.homepageCarouselAbsolutePosition or 0

		if v34 then
			setGamePlaySession(v34, sessionType.StructuralIdentifier.GameDetailSource, false)
		end

		gameDetailReferral(v33, "home", {
			ad = "no",
			friendId = props.userId,
			pg = "home",
			pid = v40,
			pos = homepageCarouselAbsolutePosition,
			rowOnPage = 1,
			sortPos = props.layoutOrder,
			tis = 1,
			universeId = universeId
		})

		v5(openGameDetails(universeId, v6))
	end, dependencyArray(
		v5,
		v6,
		universeId,
		presence,
		props.homepageCarouselAbsolutePosition,
		props.layoutOrder,
		props.userId
	))

	local v40 = React.useCallback(function(p2)
		if universeId == "" then
			return
		end

		if props.userId ~= "" then
			local v41 = {
				friendId = props.userId,
				universeId = 0,
				absolutePosition = 0,
				joinGameCardId = 0
			}
			local v42 = if universeId ~= "" then universeId else nil
			v41.universeId = v42
			v41.absolutePosition = props.homepageCarouselAbsolutePosition
			v41.joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then state else nil

			if p2 == viewEDPsourceValues.Thumbnail then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					gameJoinCardButtonAction.ViewExperienceDetailsFromThumbnail,
					v41
				)
			elseif p2 == viewEDPsourceValues.Title then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					gameJoinCardButtonAction.ViewExperienceDetailsFromTitle,
					v41
				)
			end
		end

		v39()
	end, dependencyArray(v39, universeId, props.userId, props.homepageCarouselAbsolutePosition, state))

	local v41 = React.useCallback(function()
		if props.userId ~= "" then
			local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
			local joinGame = gameJoinCardButtonAction.JoinGame
			local v42 = {
				friendId = props.userId,
				universeId = 0,
				absolutePosition = 0,
				joinGameCardId = 0
			}
			local v43 = if universeId ~= "" then universeId else nil
			v42.universeId = v43
			v42.absolutePosition = props.homepageCarouselAbsolutePosition
			v42.joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then state else nil
			logGameJoinCardButtonEvent(joinGame, v42)
		end

		v38()
		v10.joinExperience()
		props.onClose()
	end, dependencyArray(
		v38,
		v10.joinExperience,
		props.userId,
		universeId,
		props.homepageCarouselAbsolutePosition,
		props.onClose,
		state
	))

	local v42 = React.useCallback(function(p2)
		if props.userId ~= "" then
			local v43 = {
				friendId = props.userId,
				universeId = 0,
				absolutePosition = 0,
				joinGameCardId = 0
			}
			local v44 = if universeId ~= "" then universeId else nil
			v43.universeId = v44
			v43.absolutePosition = props.homepageCarouselAbsolutePosition
			v43.joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then state else nil

			if p2 == viewProfileSourceValues.UserTile then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(gameJoinCardButtonAction.OpenProfileFromUserTile, v43)
			elseif p2 == viewProfileSourceValues.ViewProfileButton then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					gameJoinCardButtonAction.OpenProfileFromViewProfile,
					v43
				)
			end
		end

		local v43 = if fFlagEnableSplitPane then v6.push else v6.navigate
		v43(appPage.ProfilePlatform, { detail = props.userId })

		props.onClose()
	end, dependencyArray(
		v6,
		props.userId,
		universeId,
		props.homepageCarouselAbsolutePosition,
		props.onClose,
		state
	))

	local v43 = React.useCallback(function()
		if props.userId == "" then
			return
		end

		local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
		local chat = gameJoinCardButtonAction.Chat
		local v44 = {
			friendId = props.userId,
			universeId = 0,
			absolutePosition = 0,
			joinGameCardId = 0
		}
		local v45 = if universeId ~= "" then universeId else nil
		v44.universeId = v45
		v44.absolutePosition = props.homepageCarouselAbsolutePosition
		v44.joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then state else nil
		logGameJoinCardButtonEvent(chat, v44)

		if FFlagGameJoinCardChatEntryPoint then
			v5(enteredChatFromEntryPoint(chatEntryPointNames.GameJoinCard))
		end

		v35:BroadcastNotification(props.userId, notificationType.LAUNCH_CONVERSATION)
		props.onClose()
	end, dependencyArray(
		props.userId,
		universeId,
		props.homepageCarouselAbsolutePosition,
		v35,
		props.onClose,
		state,
		v5
	))

	local createElement = React.createElement
	local v45 = {
		layoutOrder = layoutOrder,
		playerName = playerName,
		experienceName = lastLocation,
		gameIconUrl = v8,
		isLoading = v22,
		onJoin = v41,
		onViewExperienceDetails = v40,
		anchorRef = props.anchorRef,
		isOpen = props.isOpen and v7,
		onClose = props.onClose,
		isConsole = v25,
		consolePlatformLabel = platformName,
		focusRootRef = v32,
		ageCheckRequired = v10.ageCheckRequired,
		onAgeCheckPressed = v14,
		onPlatformProfilePressed = 0,
		onChat = 0,
		onViewProfile = 0,
		actions = 0,
		areActionsLoading = 0
	}

	if not v25 then
		v26 = nil
	end

	v45.onPlatformProfilePressed = v26

	if v25 or not v36 then
		v43 = nil
	end

	v45.onChat = v43

	if v25 then
		v42 = nil
	end

	v45.onViewProfile = v42
	v45.actions = not fFlagJoinabilityCTARefactor and {} or joinCardActions

	if not fFlagJoinabilityCTARefactor then
		v37 = nil
	end

	v45.areActionsLoading = v37
	local element = createElement(DesktopGameJoinCard, v45)

	if props.showGamepadJoinFocus then
		return React.createElement(React.Fragment, nil, {
			GamepadJoinFocus = React.createElement(GamepadJoinFocusBehavior, {
				tileRef = props.anchorRef,
				cardRef = ref2,
				joinExperience = v41
			}),
			Card = element
		})
	end

	return element
end

return DesktopGameJoinCardContainer
