local parent = script.Parent.Parent.Parent.Parent
local HttpService = game:GetService("HttpService")

local React = require(parent.React)

local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local FFlagMobileGameJoinCardEDPFromTitle = require(GameJoinCard.Flags.FFlagMobileGameJoinCardEDPFromTitle)
local FFlagMobileGameJoinCardEDPFromThumbnail = require(GameJoinCard.Flags.FFlagMobileGameJoinCardEDPFromThumbnail)
local FFlagGameJoinCardChatEntryPoint = require(GameJoinCard.Flags.FFlagGameJoinCardChatEntryPoint)
local SharedFlags = require(parent.SharedFlags)
local FFlagMobileGameJoinCardVideo = SharedFlags.FFlagMobileGameJoinCardVideo
local useJoinCardBannerVideoId = require(GameJoinCard.Hooks.useJoinCardBannerVideoId)

local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local GameJoinCardSurface = AnalyticsConstants.GameJoinCardSurface
local viewEDPsourceValues = AnalyticsConstants.viewEDPsourceValues
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require(script.Parent.Parent.Parent.Analytics.useGameJoinCardAnalytics)
local useAgeCheckUpsellAnalytics = require(script.Parent.Parent.Parent.Analytics.useAgeCheckUpsellAnalytics)
local useAgeCheckCompletionLogger = useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useAgeCheckPressLogger = useAgeCheckUpsellAnalytics.useAgeCheckPressLogger
local GameJoinCardTelemetry = require(script.Parent.Parent.Parent.Telemetry.GameJoinCardTelemetry)
local FFlagMobileGameJoinCardThumbnail = require(script.Parent.Parent.Parent.Flags.FFlagMobileGameJoinCardThumbnail)
local Foundation = require(parent.Foundation)
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RoactUtils = require(parent.RoactUtils)
local SocialExperienceJoin = require(parent.SocialExperienceJoin)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Navigation2 = require(parent.Navigation)
local useNavigationFocus = Navigation2.useNavigationFocus
local usePlayerName = require(GameJoinCard.Hooks.usePlayerName)

local ApolloClient = require(parent.ApolloClient)
local useQuery = ApolloClient.useQuery
local ApolloLocalState = require(parent.ApolloLocalState)
local Players = game:GetService("Players")

local UserProfiles = require(parent.UserProfiles)
local SocialCommon = require(parent.SocialCommon)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint
require(parent.VideoUtils)

local SharedFlags2 = require(parent.SharedFlags)

local FFlagSocialCarouselUseProfileStore = SharedFlags2.FFlagSocialCarouselUseProfileStore
local FFlagUserProfilePlatformProfile = SharedFlags2.FFlagUserProfilePlatformProfile
local FFlagSocialCarouselBuildPresence = SharedFlags2.FFlagSocialCarouselBuildPresence

local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags2.FFlagFriendSortedByPresenceSignalsImplementation
local FFlagEnableSplitPane = SharedFlags2.FFlagEnableSplitPane
local FFlagGameJoinCardAnalyticsCardId = SharedFlags2.FFlagGameJoinCardAnalyticsCardId
local FFlagGameJoinCardSourceAttribution = SharedFlags2.FFlagGameJoinCardSourceAttribution
local FFlagJoinabilityCTARefactor = SharedFlags2.FFlagJoinabilityCTARefactor
local FFlagJoinUserCTAsIxpEnabled = SharedFlags2.FFlagJoinUserCTAsIxpEnabled
local FStringJoinUserCTAsIxpLayer = SharedFlags2.FStringJoinUserCTAsIxpLayer
local FFlagMobileGameJoinCardGamepadSupport = SharedFlags2.FFlagMobileGameJoinCardGamepadSupport
local ixpServiceWrapper

if FFlagJoinUserCTAsIxpEnabled then
	local IXPServiceWrapper = require(parent.IXPServiceWrapper)
	ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
else
	ixpServiceWrapper = nil
end

local DataHydration = require(parent.DataHydration)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local v

if FFlagSocialCarouselUseProfileStore then
	v = UserProfiles.Stores.UserProfileStore.get()
else
	v = nil
end

local GameDetail = require(parent.GameDetail)
local useExperienceBannerImage = GameDetail.useExperienceBannerImage
local OpenGameDetails = GameDetail.OpenGameDetails
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local gameDetailReferral = DiscoveryAnalytics.Events.gameDetailReferral
local PeopleListInHomePage = DiscoveryAnalytics.Constants.Context.PeopleListInHomePage
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppGuiService = RoactServiceTags.AppGuiService
local AppSessionService = RoactServiceTags.AppSessionService
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local AppPage = RobloxAppEnums.AppPage
local NotificationType = RobloxAppEnums.NotificationType

local dependencyArray = RoactUtils.Hooks.dependencyArray
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience

local MobileGameJoinCard = require(script.Parent.MobileGameJoinCard)
local Actions = require(GameJoinCard.Components.Actions)
local containsAction = require(GameJoinCard.Components.Actions.containsAction)
local useJoinUserActions = require(GameJoinCard.Hooks.useJoinUserActions)
local useLogActionsResolveTime = require(GameJoinCard.Telemetry.useLogActionsResolveTime)

local DataStatus = DataHydration.DataStatus

local v2 = DataHydration.Presence.PresenceStore.get()

local FFlagProfileCTAHydratePresenceFromMetadata = require(parent.DataHydration.FFlagProfileCTAHydratePresenceFromMetadata)

local v3 = {
	universeId = "",
	lastLocation = "",
	userPresenceType = "",
	placeId = "",
	rootPlaceId = "",
	gameId = ""
}

local v4 = { skipFetch = true }

local function MobileGameJoinCardContainer()
	local dispatch

	if
		FFlagMobileGameJoinCardEDPFromTitle
		or FFlagMobileGameJoinCardEDPFromThumbnail
		or FFlagGameJoinCardChatEntryPoint
		or FFlagJoinabilityCTARefactor
	then
		dispatch = useDispatch()
	else
		dispatch = nil
	end

	local navigation = useNavigation()
	local isNavigationFocused

	if FFlagMobileGameJoinCardGamepadSupport then
		isNavigationFocused = useNavigationFocus()
	end

	local v5 = navigation.getParam("userId") or ""
	local param = navigation.getParam("homepageCarouselAbsolutePosition")
	local v6

	if FFlagGameJoinCardSourceAttribution then
		v6 = navigation.getParam("joinSource")
	else
		v6 = nil
	end

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local v7

	if FFlagGameJoinCardAnalyticsCardId then
		v7 = React.useMemo(function()
			return HttpService:GenerateGUID(false)
		end, {})
	else
		v7 = nil
	end

	local eventIngest = useRoactService(AppEventIngestService)
	local guiService = useRoactService(AppGuiService)
	local v8

	if FFlagMobileGameJoinCardEDPFromTitle or FFlagMobileGameJoinCardEDPFromThumbnail then
		v8 = useRoactService(AppSessionService)
	else
		v8 = nil
	end

	local canUsePlatformChat = useAppPolicy(function(p)
		return p.getCanUsePlatformChat()
	end)

	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or "")
	local v9

	if FFlagFriendSortedByPresenceSignalsImplementation then
		local v10 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local getPresenceByUserId = v2.GetPresenceByUserId
				local v10

				if FFlagJoinabilityCTARefactor and FFlagProfileCTAHydratePresenceFromMetadata then
					v10 = v4
				end

				return getPresenceByUserId(v5, v10).data(p)
			end)
		end, { v5 })

		v9 = SignalsReact.useSignalState(v10)
	else
		local v10 = useQuery(ApolloLocalState.queries.onlineFriendsByUserId, {
			fetchPolicy = "cache-only",
			variables = { userId = userId, sort = 1 }
		})

		v9 = React.useMemo(function()
			local onlineFriendsByUserId = v10.data and v10.data.onlineFriendsByUserId

			if not onlineFriendsByUserId then
				return nil
			end

			for _, onlineFriend in onlineFriendsByUserId do
				if onlineFriend.id == v5 then
					return onlineFriend.presence
				end
			end

			return nil
		end, { v10.data, v5 })
	end

	local state, setState = React.useState({ universeId = "", experienceName = "" })

	React.useEffect(function()
		if not v9 or tostring(v9.universeId) == "" then
			return
		end

		setState({ universeId = tostring(v9.universeId), experienceName = v9.lastLocation })
	end, { v9 })

	local universeId = state.universeId
	local experienceName = state.experienceName

	React.useEffect(function()
		if v5 == "" then
			return
		end

		local universeId2

		if v9 and v9.universeId ~= nil and tostring(v9.universeId) ~= "" then
			universeId2 = tostring(v9.universeId)
		end

		if FFlagJoinUserCTAsIxpEnabled then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringJoinUserCTAsIxpLayer)
		end

		local logGameJoinCardPageLoaded = useGameJoinCardAnalytics.logGameJoinCardPageLoaded
		local v10 = {
			friendId = v5,
			universeId = universeId2,
			absolutePosition = param,
			joinGameCardId = nil
		}
		local joinGameCardId

		if FFlagGameJoinCardAnalyticsCardId then
			joinGameCardId = v7
		end

		v10.joinGameCardId = joinGameCardId
		logGameJoinCardPageLoaded(v10)
	end, {})
	local playerName

	if FFlagSocialCarouselBuildPresence then
		playerName = usePlayerName(v5)
	elseif FFlagSocialCarouselUseProfileStore then
		local v10 = React.useMemo(function()
			return v.fetchNamesByUserIds({ v5 })
		end, { v5 })

		local v11 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local v11 = v10(p)
				local v12 = v11 and v11.data and v11.data[1]

				if v12 and v12.names then
					return (v12.names.getCombinedName(p))
				end

				return nil
			end)
		end, { v10 })

		playerName = SignalsReact.useSignalState(v11) or ""
	else
		local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
		local v10 = {
			userIds = { v5 },
			query = 0
		}
		local query

		if FFlagUserProfilePlatformProfile then
			query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
		else
			query = UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds
		end

		v10.query = query
		local v11 = useUserProfilesFetch(v10)

		playerName = React.useMemo(function()
			if v11.data then
				return UserProfiles.Selectors.getCombinedNameFromId(v11.data, v5) or ""
			end

			return ""
		end, { v11.data, v5 })
	end

	local rootPlaceId

	if v9 and v9.rootPlaceId ~= nil then
		rootPlaceId = tostring(v9.rootPlaceId)
	end

	local v10 = useExperienceBannerImage(universeId, rootPlaceId)
	local thumbnailImageUrl

	if FFlagMobileGameJoinCardThumbnail and universeId ~= "" then
		thumbnailImageUrl = getRbxThumb(ThumbnailType.GameIcon, universeId, ThumbnailSize.Medium)
	end

	React.useEffect(function()
		if universeId == "" then
			return
		end

		GameJoinCardTelemetry.logBannerLoadResult(v10.status)
	end, { v10.status, universeId })

	local onBeforeJoin = React.useCallback(function()
		if not FFlagJoinabilityCTARefactor then
			navigation.goBack()
		end
	end, { navigation })

	local onAgeCheckCompletion = useAgeCheckCompletionLogger(universeId)
	local analyticProps

	if FFlagGameJoinCardSourceAttribution then
		analyticProps = React.useMemo(function()
			if v6 == nil then
				return nil
			end

			return { context = v6.surface, subpage = v6.subpage }
		end, { v6 })
	end

	local v11 = {
		isHomePageCarousel = not FFlagGameJoinCardSourceAttribution or v6 == nil,
		analyticProps = analyticProps,
		joinAttemptOrigin = 0,
		presence = 0,
		onBeforeJoin = 0,
		onAgeCheckCompletion = 0
	}
	local joinAttemptOrigin

	if FFlagGameJoinCardSourceAttribution and v6 ~= nil then
		joinAttemptOrigin = v6.surface
	end

	v11.joinAttemptOrigin = joinAttemptOrigin

	v11.presence = v9 or v3
	v11.onBeforeJoin = onBeforeJoin
	v11.onAgeCheckCompletion = onAgeCheckCompletion
	local v12 = useJoinUserInExperience(v5, v11)
	local bannerVideoId

	if FFlagMobileGameJoinCardVideo then
		bannerVideoId = useJoinCardBannerVideoId(
			universeId,
			v12.cachedPlayabilityStatus,
			navigation.getParam("isBannerVideoEnabled") == true
		)
	end

	local bannerVideoPlaybackContext

	if FFlagMobileGameJoinCardVideo then
		bannerVideoPlaybackContext = navigation.getParam("videoPlaybackContext")
	end

	local v13, v14, localized

	if FFlagJoinabilityCTARefactor then
		v13, v14 = useJoinUserActions(
			v5,
			true,
			`{tostring(v9 and v9.userPresenceType)}:{tostring(v9 and v9.universeId)}:{tostring(v9 and v9.placeId)}:{tostring(v9 and v9.rootPlaceId)}:{tostring(v12.ageCheckRequired)}`
		)
		localized = useLocalization(Actions.TextKeys)
	end

	local v15

	if FFlagJoinabilityCTARefactor then
		v15 = v14
	end

	useLogActionsResolveTime(v15, true, GameJoinCardSurface.Mobile)

	local v16 = {
		userId = v5,
		universeId = universeId,
		absolutePosition = param,
		joinGameCardId = nil,
		joinAgeCheckUpsellFlow = 0
	}
	local joinGameCardId

	if FFlagGameJoinCardAnalyticsCardId then
		joinGameCardId = v7
	end

	v16.joinGameCardId = joinGameCardId
	v16.joinAgeCheckUpsellFlow = v12.joinAgeCheckUpsellFlow
	local onAgeCheckPressed = useAgeCheckPressLogger(v16)
	local v17

	if FFlagJoinabilityCTARefactor then
		if v14 == DataStatus.Ready then
			v17 = containsAction(v13, UserCtaAction.UnlockExperience)
		else
			v17 = false
		end
	else
		v17 = v12.ageCheckRequired == true
	end

	React.useEffect(function()
		if not v17 or universeId == "" then
			return
		end

		useGameJoinCardAnalytics.logJoinCardAgeCheckUpsellImpression({ universeId = universeId })
	end, { v17, universeId })

	local v18 = React.useCallback(function()
		local friendId = v5

		if friendId ~= "" then
			local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
			local joinGame = GameJoinCardButtonAction.JoinGame
			local universeId2

			if universeId ~= "" then
				universeId2 = universeId
			end

			local v18 = {
				friendId = friendId,
				universeId = universeId2,
				absolutePosition = param,
				joinGameCardId = nil
			}
			local joinGameCardId2

			if FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = v7
			end

			v18.joinGameCardId = joinGameCardId2
			logGameJoinCardButtonEvent(joinGame, v18)
		end

		if friendId == "" or not v9 then
			return
		end

		local placeId = (v9.placeId == nil or tostring(v9.placeId) == "") and "" or tostring(v9.placeId)

		local rootPlaceId2 = tonumber(v9.rootPlaceId)

		if placeId == "" or rootPlaceId2 == nil then
			return
		end

		gamePlayIntent(eventIngest, PeopleListInHomePage, {
			placeId = placeId,
			rootPlaceId = rootPlaceId2,
			friendId = friendId,
			joinAttemptId = HttpService:GenerateGUID(false)
		})
	end, dependencyArray(v5, universeId, param, v9))

	local v19 = React.useCallback(function()
		local v19

		if FFlagEnableSplitPane then
			v19 = navigation.push
		else
			v19 = navigation.navigate
		end

		v19(AppPage.ProfilePlatform, { detail = v5 })
	end, { navigation, v5 })

	local onViewProfile = React.useCallback(function(p)
		if v5 ~= "" then
			local v20 = {
				friendId = v5,
				universeId = nil,
				absolutePosition = nil,
				joinGameCardId = nil
			}
			local universeId2

			if universeId ~= "" then
				universeId2 = universeId
			end

			v20.universeId = universeId2
			v20.absolutePosition = param
			local joinGameCardId2

			if FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = v7
			end

			v20.joinGameCardId = joinGameCardId2

			if p == viewProfileSourceValues.UserTile then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.OpenProfileFromUserTile,
					v20
				)
			elseif p == viewProfileSourceValues.ViewProfileButton then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.OpenProfileFromViewProfile,
					v20
				)
			end
		end

		v19()
	end, dependencyArray(v19, v5, universeId, param))
	local v20

	if FFlagMobileGameJoinCardEDPFromTitle or FFlagMobileGameJoinCardEDPFromThumbnail then
		v20 = React.useCallback(function()
			local rootPlaceId2 = v9 and v9.rootPlaceId
			local pid

			if rootPlaceId2 == nil or tostring(rootPlaceId2) == "" then
				pid = universeId
			else
				pid = tostring(rootPlaceId2)
			end

			local v21 = param or 0

			if v8 then
				SetGamePlaySession(v8, SessionType.StructuralIdentifier.GameDetailSource, false)
			end

			gameDetailReferral(eventIngest, "home", {
				ad = "no",
				friendId = v5,
				pg = "home",
				pid = pid,
				pos = v21,
				rowOnPage = 1,
				sortPos = v21,
				tis = 1,
				universeId = universeId
			})

			dispatch(OpenGameDetails(universeId, navigation))
		end, { dispatch, navigation, universeId, v9, param, v5, eventIngest, v8 })
	else
		v20 = nil
	end

	local onViewExperienceDetails

	if FFlagMobileGameJoinCardEDPFromTitle or FFlagMobileGameJoinCardEDPFromThumbnail then
		onViewExperienceDetails = React.useCallback(function(p)
			if v5 ~= "" then
				local v21 = {
					friendId = v5,
					universeId = nil,
					absolutePosition = nil,
					joinGameCardId = nil
				}
				local universeId2

				if universeId ~= "" then
					universeId2 = universeId
				end

				v21.universeId = universeId2
				v21.absolutePosition = param
				local joinGameCardId2

				if FFlagGameJoinCardAnalyticsCardId then
					joinGameCardId2 = v7
				end

				v21.joinGameCardId = joinGameCardId2
				local v22

				if p == viewEDPsourceValues.Thumbnail then
					v22 = GameJoinCardButtonAction.ViewExperienceDetailsFromThumbnail
				elseif p == viewEDPsourceValues.Title then
					v22 = GameJoinCardButtonAction.ViewExperienceDetailsFromTitle
				end

				if v22 then
					useGameJoinCardAnalytics.logGameJoinCardButtonEvent(v22, v21)
				end
			end

			if universeId ~= "" then
				v20()
			end
		end, { v20, universeId, v5, param, v7 })
	end

	local onJoin = React.useCallback(function()
		v18()
		v12.joinExperience()
	end, dependencyArray(v18, v12))

	local onChat = React.useCallback(function()
		if v5 == "" then
			return
		end

		local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
		local chat = GameJoinCardButtonAction.Chat
		local v21 = {
			friendId = v5,
			universeId = nil,
			absolutePosition = nil,
			joinGameCardId = nil
		}
		local universeId2

		if universeId ~= "" then
			universeId2 = universeId
		end

		v21.universeId = universeId2
		v21.absolutePosition = param
		local joinGameCardId2

		if FFlagGameJoinCardAnalyticsCardId then
			joinGameCardId2 = v7
		end

		v21.joinGameCardId = joinGameCardId2
		logGameJoinCardButtonEvent(chat, v21)

		if FFlagGameJoinCardChatEntryPoint then
			dispatch(EnteredChatFromEntryPoint(ChatEntryPointNames.GameJoinCard))
		end

		guiService:BroadcastNotification(v5, NotificationType.LAUNCH_CONVERSATION)
	end, dependencyArray(v5, universeId, param, navigation, guiService, dispatch))
	local areActionsLoading, joinCardActions

	if FFlagJoinabilityCTARefactor then
		areActionsLoading = v14 == DataStatus.NotReady
		joinCardActions = {}

		if v14 == DataStatus.Ready and localized ~= nil then
			local resolveJoinCardActions = Actions.resolveJoinCardActions
			local v21 = {
				localized = localized,
				userId = v5,
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
				absolutePosition = param,
				joinGameCardId = nil
			}
			local joinGameCardId2

			if FFlagGameJoinCardAnalyticsCardId then
				joinGameCardId2 = v7
			end

			telemetry.joinGameCardId = joinGameCardId2
			v21.telemetry = telemetry
			local placeId

			if v9 and v9.placeId ~= nil then
				placeId = tostring(v9.placeId)
			end

			v21.presence = { placeId = placeId, rootPlaceId = rootPlaceId }

			v21.experience = {
				isLoading = v12.isLoading,
				isInExperience = v12.isInExperience,
				joinExperience = v12.joinExperience,
				playExperience = v12.playExperience
			}

			v21.eventIngest = eventIngest
			v21.dispatch = dispatch
			v21.guiService = guiService
			v21.navigation = navigation
			v21.joinAgeCheckUpsellFlow = v12.joinAgeCheckUpsellFlow
			local joinCardActions2 = resolveJoinCardActions(v13, v21)

			for _, joinCardAction in joinCardActions2 do
				if not (joinCardAction.id ~= UserCtaAction.Chat or canUsePlatformChat) then
					continue
				end

				if joinCardAction.id == UserCtaAction.ViewProfile or joinCardAction.id == UserCtaAction.Chat then
					joinCardAction.keepOpenOnActivate = true
				end

				table.insert(joinCardActions, joinCardAction)
			end
		end
	else
		areActionsLoading = false
	end

	local createElement = React.createElement
	local v21 = {
		isNavigationFocused = isNavigationFocused,
		onClose = onClose,
		onJoin = onJoin,
		onViewProfile = onViewProfile,
		onViewExperienceDetails = onViewExperienceDetails,
		onChat = onChat,
		canUsePlatformChat = canUsePlatformChat,
		userId = v5,
		universeId = universeId,
		homepageCarouselAbsolutePosition = param,
		playerName = playerName,
		experienceName = experienceName,
		bannerImageUrl = v10.url,
		thumbnailImageUrl = thumbnailImageUrl,
		bannerVideoId = bannerVideoId,
		bannerVideoPlaybackContext = bannerVideoPlaybackContext,
		isLoading = v12.isLoading,
		isInExperience = v12.isInExperience,
		ageCheckRequired = v12.ageCheckRequired,
		onAgeCheckPressed = onAgeCheckPressed,
		wasPlayabilityCached = v12.playabilityFromCache,
		actions = not FFlagJoinabilityCTARefactor and {} or joinCardActions,
		areActionsLoading = 0
	}

	if not FFlagJoinabilityCTARefactor then
		areActionsLoading = nil
	end

	v21.areActionsLoading = areActionsLoading
	return createElement(MobileGameJoinCard, v21)
end

return MobileGameJoinCardContainer
