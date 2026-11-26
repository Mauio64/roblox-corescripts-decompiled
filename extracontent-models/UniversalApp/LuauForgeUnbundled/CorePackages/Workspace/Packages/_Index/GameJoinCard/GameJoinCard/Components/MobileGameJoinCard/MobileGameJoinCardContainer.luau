local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")

local FFlagMobileGameJoinCardEDPFromTitle = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardEDPFromTitle")
local FFlagMobileGameJoinCardEDPFromThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardEDPFromThumbnail")
local FFlagGameJoinCardChatEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagGameJoinCardChatEntryPoint")
local fFlagMobileGameJoinCardVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagMobileGameJoinCardVideo
local useJoinCardBannerVideoId = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/useJoinCardBannerVideoId")

local AnalyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants")
local gameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local gameJoinCardSurface = AnalyticsConstants.GameJoinCardSurface
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")
local useAgeCheckUpsellAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useAgeCheckUpsellAnalytics")
local useAgeCheckCompletionLogger = useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useAgeCheckPressLogger = useAgeCheckUpsellAnalytics.useAgeCheckPressLogger
local GameJoinCardTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/GameJoinCardTelemetry")
local FFlagMobileGameJoinCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardThumbnail")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailType = Foundation.Enums.ThumbnailType
local thumbnailSize = Foundation.Enums.ThumbnailSize
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppEnums")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RoactUtils")
local SocialExperienceJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SocialExperienceJoin")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Navigation").useNavigation
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Navigation").useNavigationFocus
local usePlayerName = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/usePlayerName")

local useQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/ApolloClient").useQuery
local ApolloLocalState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/ApolloLocalState")
local Players = game:GetService("Players")

local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserProfiles")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SocialCommon")
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local enteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint
require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/VideoUtils")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")

local fFlagSocialCarouselUseProfileStore = SharedFlags.FFlagSocialCarouselUseProfileStore
local fFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local fFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local fFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagGameJoinCardAnalyticsCardId = SharedFlags.FFlagGameJoinCardAnalyticsCardId
local fFlagGameJoinCardSourceAttribution = SharedFlags.FFlagGameJoinCardSourceAttribution
local fFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local fFlagJoinUserCTAsIxpEnabled = SharedFlags.FFlagJoinUserCTAsIxpEnabled
local fStringJoinUserCTAsIxpLayer = SharedFlags.FStringJoinUserCTAsIxpLayer
local fFlagMobileGameJoinCardGamepadSupport = SharedFlags.FFlagMobileGameJoinCardGamepadSupport

local ixpServiceWrapper = if fFlagJoinUserCTAsIxpEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/IxpServiceWrapper").IXPServiceWrapper else nil

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization").Hooks.useLocalization
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SignalsReact")

local v5 = if fFlagSocialCarouselUseProfileStore then UserProfiles.Stores.UserProfileStore.get() else nil

local GameDetail = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/GameDetail")
local useExperienceBannerImage = GameDetail.useExperienceBannerImage
local openGameDetails = GameDetail.OpenGameDetails
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DiscoveryAnalytics")
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local gameDetailReferral = DiscoveryAnalytics.Events.gameDetailReferral
local peopleListInHomePage = DiscoveryAnalytics.Constants.Context.PeopleListInHomePage
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RoactServiceTags")
local appEventIngestService = RoactServiceTags.AppEventIngestService
local appGuiService = RoactServiceTags.AppGuiService
local appSessionService = RoactServiceTags.AppSessionService
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppHooks").useRoactService
local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppSessionization")
local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/UniversalAppPolicy").useAppPolicy

local appPage = RobloxAppEnums.AppPage
local notificationType = RobloxAppEnums.NotificationType

local dependencyArray = RoactUtils.Hooks.dependencyArray
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience

local MobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/MobileGameJoinCard")
local Actions = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions")
local containsAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/containsAction")
local useJoinUserActions = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/useJoinUserActions")
local useLogActionsResolveTime = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/useLogActionsResolveTime")

local dataStatus = DataHydration.DataStatus

local v6 = DataHydration.Presence.PresenceStore.get()

local FFlagProfileCTAHydratePresenceFromMetadata = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/DataHydration/FFlagProfileCTAHydratePresenceFromMetadata")

local v7 = {
	universeId = "",
	lastLocation = "",
	userPresenceType = "",
	placeId = "",
	rootPlaceId = "",
	gameId = ""
}

local v8 = { skipFetch = true }

local function MobileGameJoinCardContainer()
	local v9

	if FFlagMobileGameJoinCardEDPFromTitle or FFlagMobileGameJoinCardEDPFromThumbnail or FFlagGameJoinCardChatEntryPoint or fFlagJoinabilityCTARefactor then
		v9 = useDispatch()
	else
		v9 = nil
	end

	local v10 = useNavigation()

	local v11 = if fFlagMobileGameJoinCardGamepadSupport then useNavigationFocus() else nil
	local v12 = v10.getParam("userId") or ""
	local param = v10.getParam("homepageCarouselAbsolutePosition")

	local v13 = if fFlagGameJoinCardSourceAttribution then v10.getParam("joinSource") else nil

	local v14 = React.useCallback(function()
		v10.goBack()
	end, { v10 })
	local v15

	if fFlagGameJoinCardAnalyticsCardId then
		v15 = React.useMemo(function()
			return HttpService:GenerateGUID(false)
		end, {})
	else
		v15 = nil
	end

	local v16 = useRoactService(appEventIngestService)
	local v17 = useRoactService(appGuiService)

	local v18 = if FFlagMobileGameJoinCardEDPFromTitle or FFlagMobileGameJoinCardEDPFromThumbnail then useRoactService(appSessionService) else nil

	local v19 = useAppPolicy(function(p2)
		return p2.getCanUsePlatformChat()
	end)

	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or "")
	local v20

	if fFlagFriendSortedByPresenceSignalsImplementation then
		local v21 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local getPresenceByUserId = v6.GetPresenceByUserId
				local v23 = if fFlagJoinabilityCTARefactor and FFlagProfileCTAHydratePresenceFromMetadata then v8 else nil
				return getPresenceByUserId(v12, v23).data(p2)
			end)
		end, { v12 })

		v20 = SignalsReact.useSignalState(v21)
	else
		local v21 = useQuery(ApolloLocalState.queries.onlineFriendsByUserId, {
			fetchPolicy = "cache-only",
			variables = { userId = userId, sort = 1 }
		})

		v20 = React.useMemo(function()
			local onlineFriendsByUserId = v21.data and v21.data.onlineFriendsByUserId

			if not onlineFriendsByUserId then
				return nil
			end

			for k, onlineFriend in onlineFriendsByUserId do
				if onlineFriend.id == v12 then
					return onlineFriend.presence
				end
			end

			return nil
		end, { v21.data, v12 })
	end

	local state, setState = React.useState({ universeId = "", experienceName = "" })

	React.useEffect(function()
		if not v20 or tostring(v20.universeId) == "" then
			return
		end

		setState({
			universeId = tostring(v20.universeId),
			experienceName = v20.lastLocation
		})
	end, { v20 })

	local universeId = state.universeId
	local experienceName = state.experienceName

	React.useEffect(function()
		if v12 == "" then
			return
		end

		local universeId2

		if v20 and v20.universeId ~= nil and tostring(v20.universeId) ~= "" then
			universeId2 = tostring(v20.universeId)
		end

		if fFlagJoinUserCTAsIxpEnabled then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringJoinUserCTAsIxpLayer)
		end

		useGameJoinCardAnalytics.logGameJoinCardPageLoaded({
			friendId = v12,
			universeId = universeId2,
			absolutePosition = param,
			joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then v15 else nil
		})
	end, {})
	local v21

	if fFlagSocialCarouselBuildPresence then
		v21 = usePlayerName(v12)
	elseif fFlagSocialCarouselUseProfileStore then
		local v22 = React.useMemo(function()
			return v5.fetchNamesByUserIds({ v12 })
		end, { v12 })

		local v23 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v24 = v22(p2)
				local v25 = v24 and v24.data and v24.data[1]

				if v25 and v25.names then
					return (v25.names.getCombinedName(p2))
				end

				return nil
			end)
		end, { v22 })

		v21 = SignalsReact.useSignalState(v23) or ""
	else
		local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
		local v22 = {
			userIds = { v12 },
			query = 0
		}

		local v23 = if fFlagUserProfilePlatformProfile then UserProfiles.Queries.userProfilesCombinedNameByUserIds else UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds
		v22.query = v23
		local v24 = useUserProfilesFetch(v22)

		v21 = React.useMemo(function()
			if v24.data then
				return UserProfiles.Selectors.getCombinedNameFromId(v24.data, v12) or ""
			end

			return ""
		end, { v24.data, v12 })
	end

	local rootPlaceId = if v20 and v20.rootPlaceId ~= nil then tostring(v20.rootPlaceId) else nil

	local v22 = useExperienceBannerImage(universeId, rootPlaceId)
	local v23

	if FFlagMobileGameJoinCardThumbnail and universeId ~= "" then
		v23 = getRbxThumb(thumbnailType.GameIcon, universeId, thumbnailSize.Medium)
	end

	React.useEffect(function()
		if universeId == "" then
			return
		end

		GameJoinCardTelemetry.logBannerLoadResult(v22.status)
	end, { v22.status, universeId })

	local v24 = React.useCallback(function()
		if not fFlagJoinabilityCTARefactor then
			v10.goBack()
		end
	end, { v10 })

	local v25 = useAgeCheckCompletionLogger(universeId)
	local v26

	if fFlagGameJoinCardSourceAttribution then
		v26 = React.useMemo(function()
			if v13 == nil then
				return nil
			end

			return { context = v13.surface, subpage = v13.subpage }
		end, { v13 })
	end

	local v28 = {
		isHomePageCarousel = not fFlagGameJoinCardSourceAttribution or v13 == nil,
		analyticProps = v26,
		joinAttemptOrigin = 0,
		presence = 0,
		onBeforeJoin = 0,
		onAgeCheckCompletion = 0
	}

	local v29 = if fFlagGameJoinCardSourceAttribution and v13 ~= nil then v13.surface else nil
	v28.joinAttemptOrigin = v29

	v28.presence = v20 or v7
	v28.onBeforeJoin = v24
	v28.onAgeCheckCompletion = v25
	local v30 = useJoinUserInExperience(v12, v28)
	local v31

	if fFlagMobileGameJoinCardVideo then
		v31 = useJoinCardBannerVideoId(universeId, v30.cachedPlayabilityStatus, v10.getParam("isBannerVideoEnabled") == true)
	end

	local v32 = if fFlagMobileGameJoinCardVideo then v10.getParam("videoPlaybackContext") else nil
	local v33, v34, v35

	if fFlagJoinabilityCTARefactor then
		v33, v34 = useJoinUserActions(
			v12,
			true,
			`{tostring(v20 and v20.userPresenceType)}:{tostring(v20 and v20.universeId)}:{tostring(v20 and v20.placeId)}:{tostring(v20 and v20.rootPlaceId)}:{tostring(v30.ageCheckRequired)}`
		)
		v35 = useLocalization(Actions.TextKeys)
	end

	useLogActionsResolveTime(if fFlagJoinabilityCTARefactor then v34 else nil, true, gameJoinCardSurface.Mobile)

	local v41 = useAgeCheckPressLogger({
		userId = v12,
		universeId = universeId,
		absolutePosition = param,
		joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then v15 else nil,
		joinAgeCheckUpsellFlow = v30.joinAgeCheckUpsellFlow
	})
	local v42

	if fFlagJoinabilityCTARefactor then
		v42 = v34 == dataStatus.Ready and containsAction(v33, userCtaAction.UnlockExperience)
	else
		v42 = v30.ageCheckRequired == true
	end

	React.useEffect(function()
		if not v42 or universeId == "" then
			return
		end

		useGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression({ universeId = universeId })
	end, { v42, universeId })

	local v43 = React.useCallback(function()
		local v44 = v12

		if v44 ~= "" then
			local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
			local joinGame = gameJoinCardButtonAction.JoinGame
			local v46 = if universeId ~= "" then universeId else nil
			logGameJoinCardButtonEvent(joinGame, {
				friendId = v44,
				universeId = v46,
				absolutePosition = param,
				joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then v15 else nil
			})
		end

		if v44 == "" or not v20 then
			return
		end

		local v45 = (v20.placeId == nil or tostring(v20.placeId) == "") and "" or tostring(v20.placeId)

		local rootPlaceId2 = tonumber(v20.rootPlaceId)

		if v45 == "" or rootPlaceId2 == nil then
			return
		end

		gamePlayIntent(v16, peopleListInHomePage, {
			placeId = v45,
			rootPlaceId = rootPlaceId2,
			friendId = v44,
			joinAttemptId = HttpService:GenerateGUID(false)
		})
	end, dependencyArray(v12, universeId, param, v20))

	local v44 = React.useCallback(function()
		local v45 = if fFlagEnableSplitPane then v10.push else v10.navigate
		v45(appPage.ProfilePlatform, { detail = v12 })
	end, { v10, v12 })

	local v45 = React.useCallback(function(p2)
		if v12 ~= "" then
			local v46 = {
				friendId = v12,
				universeId = nil,
				absolutePosition = nil,
				joinGameCardId = nil
			}
			local v47 = if universeId ~= "" then universeId else nil
			v46.universeId = v47
			v46.absolutePosition = param
			v46.joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then v15 else nil

			if p2 == viewProfileSourceValues.UserTile then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(gameJoinCardButtonAction.OpenProfileFromUserTile, v46)
			elseif p2 == viewProfileSourceValues.ViewProfileButton then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(gameJoinCardButtonAction.OpenProfileFromViewProfile, v46)
			end
		end

		v44()
	end, dependencyArray(v44, v12, universeId, param))
	local v46

	if FFlagMobileGameJoinCardEDPFromTitle or FFlagMobileGameJoinCardEDPFromThumbnail then
		v46 = React.useCallback(function()
			local rootPlaceId2 = v20 and v20.rootPlaceId
			local v47

			if rootPlaceId2 == nil or tostring(rootPlaceId2) == "" then
				v47 = universeId
			else
				v47 = tostring(rootPlaceId2)
			end

			local v48 = param or 0

			if v18 then
				setGamePlaySession(v18, sessionType.StructuralIdentifier.GameDetailSource, false)
			end

			gameDetailReferral(v16, "home", {
				ad = "no",
				friendId = v12,
				pg = "home",
				pid = v47,
				pos = v48,
				rowOnPage = 1,
				sortPos = v48,
				tis = 1,
				universeId = universeId
			})

			v9(openGameDetails(universeId, v10))
		end, { v9, v10, universeId, v20, param, v12, v16, v18 })
	else
		v46 = nil
	end

	local v47

	if FFlagMobileGameJoinCardEDPFromTitle or FFlagMobileGameJoinCardEDPFromThumbnail then
		v47 = React.useCallback(function(p2)
			if v12 ~= "" then
				local v48 = {
					friendId = v12,
					universeId = nil,
					absolutePosition = nil,
					joinGameCardId = nil
				}
				local v49 = if universeId ~= "" then universeId else nil
				v48.universeId = v49
				v48.absolutePosition = param
				v48.joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then v15 else nil
				local v51

				if p2 == viewEDPsourceValues.Thumbnail then
					v51 = gameJoinCardButtonAction.ViewExperienceDetailsFromThumbnail
				elseif p2 == viewEDPsourceValues.Title then
					v51 = gameJoinCardButtonAction.ViewExperienceDetailsFromTitle
				end

				if v51 then
					useGameJoinCardAnalytics.logGameJoinCardButtonEvent(v51, v48)
				end
			end

			if universeId ~= "" then
				v46()
			end
		end, { v46, universeId, v12, param, v15 })
	end

	local v48 = React.useCallback(function()
		v43()
		v30.joinExperience()
	end, dependencyArray(v43, v30))

	local v49 = React.useCallback(function()
		if v12 == "" then
			return
		end

		local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
		local chat = gameJoinCardButtonAction.Chat
		local v50 = {
			friendId = v12,
			universeId = nil,
			absolutePosition = nil,
			joinGameCardId = nil
		}
		local v51 = if universeId ~= "" then universeId else nil
		v50.universeId = v51
		v50.absolutePosition = param
		v50.joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then v15 else nil
		logGameJoinCardButtonEvent(chat, v50)

		if FFlagGameJoinCardChatEntryPoint then
			v9(enteredChatFromEntryPoint(chatEntryPointNames.GameJoinCard))
		end

		v17:BroadcastNotification(v12, notificationType.LAUNCH_CONVERSATION)
	end, dependencyArray(v12, universeId, param, v10, v17, v9))
	local v50, joinCardActions

	if fFlagJoinabilityCTARefactor then
		v50 = v34 == dataStatus.NotReady
		joinCardActions = {}

		if v34 == dataStatus.Ready and v35 ~= nil then
			local resolveJoinCardActions = Actions.resolveJoinCardActions
			local v51 = {
				localized = v35,
				userId = v12,
				telemetry = 0,
				presence = 0,
				experience = 0,
				eventIngest = 0,
				dispatch = 0,
				guiService = 0,
				navigation = 0,
				joinAgeCheckUpsellFlow = 0
			}
			local v53 = if universeId ~= "" then universeId else nil
			v51.telemetry = {
				universeId = v53,
				absolutePosition = param,
				joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then v15 else nil
			}

			local v56 = if v20 and v20.placeId ~= nil then tostring(v20.placeId) else nil
			v51.presence = { placeId = v56, rootPlaceId = rootPlaceId }

			v51.experience = {
				isLoading = v30.isLoading,
				isInExperience = v30.isInExperience,
				joinExperience = v30.joinExperience,
				playExperience = v30.playExperience
			}

			v51.eventIngest = v16
			v51.dispatch = v9
			v51.guiService = v17
			v51.navigation = v10
			v51.joinAgeCheckUpsellFlow = v30.joinAgeCheckUpsellFlow
			local joinCardActions2 = resolveJoinCardActions(v33, v51)

			for k, joinCardAction in joinCardActions2 do
				if not (joinCardAction.id ~= userCtaAction.Chat or v19) then
					continue
				end

				if
					joinCardAction.id == userCtaAction.ViewProfile
					or joinCardAction.id == userCtaAction.Chat
				then
					joinCardAction.keepOpenOnActivate = true
				end

				table.insert(joinCardActions, joinCardAction)
			end
		end
	else
		v50 = false
	end

	local createElement = React.createElement
	local v52 = {
		isNavigationFocused = v11,
		onClose = v14,
		onJoin = v48,
		onViewProfile = v45,
		onViewExperienceDetails = v47,
		onChat = v49,
		canUsePlatformChat = v19,
		userId = v12,
		universeId = universeId,
		homepageCarouselAbsolutePosition = param,
		playerName = v21,
		experienceName = experienceName,
		bannerImageUrl = v22.url,
		thumbnailImageUrl = v23,
		bannerVideoId = v31,
		bannerVideoPlaybackContext = v32,
		isLoading = v30.isLoading,
		isInExperience = v30.isInExperience,
		ageCheckRequired = v30.ageCheckRequired,
		onAgeCheckPressed = v41,
		wasPlayabilityCached = v30.playabilityFromCache,
		actions = not fFlagJoinabilityCTARefactor and {} or joinCardActions,
		areActionsLoading = 0
	}

	if not fFlagJoinabilityCTARefactor then
		v50 = nil
	end

	v52.areActionsLoading = v50
	return createElement(MobileGameJoinCard, v52)
end

return MobileGameJoinCardContainer
