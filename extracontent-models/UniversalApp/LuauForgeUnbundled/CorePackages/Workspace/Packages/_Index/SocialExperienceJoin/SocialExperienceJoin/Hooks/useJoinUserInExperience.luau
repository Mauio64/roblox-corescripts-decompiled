local GameLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/GameLaunch")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/LuaSocialLibrariesDeps")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/NavigationRodux")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/React")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppHooks")
local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppSessionization")
local Games = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Rodux/Games")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/EventNames")
local JoinExperienceStatus = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/JoinExperienceStatus")

local initializeSocialExperienceJoinAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/initializeSocialExperienceJoinAnalytics")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Common/Constants")
local NetworkingGames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/NetworkingGames")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Networking/myRoduxNetworking")

local useAgeCheckUpsellState = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Hooks/useAgeCheckUpsellState")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local playabilityStatus = Games.Enums.PlayabilityStatus

local networkStatus = myRoduxNetworking.Enum.NetworkStatus
local launchGame = GameLaunch.LaunchGame
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType
local appSessionService = RoactServiceTags.AppSessionService
local useRoactService = RobloxAppHooks.useRoactService

local appPage = RobloxAppEnums.AppPage
local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppNavigation").NavigationCommands else nil

local appGame = RoactServiceTags.AppGame

local useLocalUserId = RobloxAppHooks.useLocalUserId
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local fFlagProfilePlatformImproveGameDetailsAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FFlagProfilePlatformImproveGameDetailsAnalytics
local fFlagGameJoinCardSourceAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FFlagGameJoinCardSourceAttribution
local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FFlagJoinabilityCTARefactor

local FFlagSocialExperienceJoinPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Flags/FFlagSocialExperienceJoinPresenceStoreMigration")

local useGetPresenceByUserId = if FFlagSocialExperienceJoinPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/FriendsCommon").Hooks.useGetPresenceByUserId else nil

local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/CentralOverlay")
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local centralOverlayType = RobloxAppEnums.CentralOverlayType

local defineFastFlag = game:DefineFastFlag("SocialJoinUseUnifiedPurchaseFlow", false)
local defineFastFlag2 = game:DefineFastFlag("GameJoinCardOnBeforeJoinCallback", false)
local defineFastFlag3 = game:DefineFastFlag("SocialJoinPassPlaceIdToLaunch", false)

local v5 = { skipFetch = true }

return function(p2, data)
	local v6 = useDispatch()
	local v7 = useRoactService(appSessionService)
	local v8 = useRoactService(appGame)
	local v9 = React.useMemo(function()
		return initializeSocialExperienceJoinAnalytics(data.analyticProps)
	end, {})
	local v10 = useLocalUserId()

	local v11 = if FFlagSocialExperienceJoinPresenceStoreMigration then useGetPresenceByUserId(p2, v5) else nil

	local v12 = useSelector(function(p3)
		local v13

		if data.presence then
			v13 = data.presence
		else
			v13 = if FFlagSocialExperienceJoinPresenceStoreMigration then v11 else getDeepValue(p3, `{module15.RODUX_KEY}.Presence.byUserId.{p2}`)
		end

		local v14 = not (v13 and v13.universeId) and "" or tostring(v13.universeId)
		local v15

		if v14 == "" then
			v15 = false
		else
			v15 = NetworkingGames.GetExperiencesPlayabilityStatus.getStatus(p3, v14) == networkStatus.Fetching
				or NetworkingGames.GetExperiencesDetails.getStatus(p3, v14) == networkStatus.Fetching
				or NetworkingGames.GetExperiencesProductInfo.getStatus(p3, v14) == networkStatus.Fetching
		end

		local v16 = {
			universeId = v14,
			presenceType = not (v13 and v13.userPresenceType) and "" or v13.userPresenceType,
			lastLocation = 0,
			placeId = 0,
			rootPlaceId = 0,
			gameId = 0,
			isLoading = 0
		}
		local v17 = if v13 and v13.lastLocation then v13.lastLocation else nil
		v16.lastLocation = v17
		v16.placeId = not (v13 and v13.placeId) and "" or tostring(v13.placeId)
		v16.rootPlaceId = not (v13 and v13.rootPlaceId) and "" or tostring(v13.rootPlaceId)
		v16.gameId = not (v13 and v13.gameId) and "" or tostring(v13.gameId)
		v16.isLoading = v15
		return v16
	end)

	local v13 = useAgeCheckUpsellState(v12.universeId, data.onAgeCheckCompletion)

	local useCallback = React.useCallback
	local function fn(p3)
		local function fn2(universeId)
			return v6(NetworkingGames.GetExperiencesProductInfo.API({ universeId }))
		end

		local function fn3()
			local purchaseRequired = JoinExperienceStatus.PurchaseRequired;
			(function(p4)
				setGamePlaySession(v7, sessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				local fireAnalyticsEvent = v9.fireAnalyticsEvent
				local joinExperience = EventNames.JoinExperience
				local v14 = {
					placeId = v12.placeId,
					rootPlaceId = v12.rootPlaceId,
					gameInstanceId = v12.gameId,
					profileUserId = p2,
					uid = v10,
					joinAttemptId = p4,
					status = purchaseRequired,
					followUser = 0,
					isHomePageCarousel = 0,
					absolutePosition = 0,
					friendId = 0
				}

				local v15 = if fFlagJoinabilityCTARefactor then tostring(p3) else nil
				v14.followUser = v15

				v14.isHomePageCarousel = data.isHomePageCarousel or false
				v14.absolutePosition = data.homepageCarouselAbsolutePosition
				v14.friendId = if fFlagProfilePlatformImproveGameDetailsAnalytics then p2 else nil
				fireAnalyticsEvent(joinExperience, v14)
			end)()
			local all = Promise.all
			local v14 = { v12.universeId }
			all(v6(NetworkingGames.GetExperiencesDetails.API(v14)), fn2(v12.universeId)):andThen(function()
				if defineFastFlag then
					local lastLocation = v12.lastLocation or ""

					local v15 = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", v12.universeId)

					v6(setCentralOverlay(centralOverlayType.UnifiedProductPurchaseModal, {
						productPayload = {
							universeId = v12.universeId,
							kind = "Experience",
							experienceName = lastLocation,
							experienceIconUrl = v15
						},
						purchaseCallbacks = {
							onFlowComplete = function()
								v6(closeCentralOverlay())
							end,
							onPurchaseSuccess = function()
								if v13 then
									v13.refetchPlayability()
								end
							end
						},
						purchaseAnalyticsMetadata = { surface = "JoinUserInExperience" }
					}))
				else
					local v15 = {
						name = appPage.SocialPurchaseExperience,
						detail = v12.universeId,
						extraProps = { userId = p2, analyticProps = data.analyticProps }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v15))
					else
						v6(navigateDown(v15))
					end
				end
			end)
		end

		local function fn4()
			local v14 = if defineFastFlag then JoinExperienceStatus.Unable else JoinExperienceStatus.PurchaseRequired;
			(function(p4)
				setGamePlaySession(v7, sessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				local fireAnalyticsEvent = v9.fireAnalyticsEvent
				local joinExperience = EventNames.JoinExperience
				local v15 = {
					placeId = v12.placeId,
					rootPlaceId = v12.rootPlaceId,
					gameInstanceId = v12.gameId,
					profileUserId = p2,
					uid = v10,
					joinAttemptId = p4,
					status = v14,
					followUser = 0,
					isHomePageCarousel = 0,
					absolutePosition = 0,
					friendId = 0
				}

				local v16 = if fFlagJoinabilityCTARefactor then tostring(p3) else nil
				v15.followUser = v16

				v15.isHomePageCarousel = data.isHomePageCarousel or false
				v15.absolutePosition = data.homepageCarouselAbsolutePosition
				v15.friendId = if fFlagProfilePlatformImproveGameDetailsAnalytics then p2 else nil
				fireAnalyticsEvent(joinExperience, v15)
			end)(JoinExperienceStatus.Unable)

			local v15 = {
				name = appPage.SocialUnableToJoinExperience,
				detail = v12.universeId,
				extraProps = {
					userId = p2,
					analyticProps = data.analyticProps,
					openGameDetailsPeekViewClosed = data.openGameDetailsPeekViewClosed
				}
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v15))
			else
				v6(navigateDown(v15))
			end
		end

		(function(p4)
			if v13 and v13.cachedPlayabilityStatus then
				return Promise.resolve(v13.cachedPlayabilityStatus)
			end

			return v6(NetworkingGames.GetExperiencesPlayabilityStatus.API({ p4 })):andThen(function(p5)
				return p5.responseBody[1].playabilityStatus
			end)
		end)(v12.universeId):andThen(function(p4)
			if p4 == playabilityStatus.PurchaseRequired.rawValue() then
				fn3()
			elseif p4 == playabilityStatus.Playable.rawValue() then
				if defineFastFlag2 and data.onBeforeJoin then
					data.onBeforeJoin()
				end

				local success = JoinExperienceStatus.Success

				local function fn5(p5)
					setGamePlaySession(v7, sessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
					local fireAnalyticsEvent = v9.fireAnalyticsEvent
					local joinExperience = EventNames.JoinExperience
					local v14 = {
						placeId = v12.placeId,
						rootPlaceId = v12.rootPlaceId,
						gameInstanceId = v12.gameId,
						profileUserId = p2,
						uid = v10,
						joinAttemptId = p5,
						status = success,
						followUser = 0,
						isHomePageCarousel = 0,
						absolutePosition = 0,
						friendId = 0
					}

					local v15 = if fFlagJoinabilityCTARefactor then tostring(p3) else nil
					v14.followUser = v15

					v14.isHomePageCarousel = data.isHomePageCarousel or false
					v14.absolutePosition = data.homepageCarouselAbsolutePosition
					v14.friendId = if fFlagProfilePlatformImproveGameDetailsAnalytics then p2 else nil
					fireAnalyticsEvent(joinExperience, v14)
				end

				local v15

				if fFlagJoinabilityCTARefactor and not p3 then
					v15 = v12.rootPlaceId
				elseif defineFastFlag3 and v12.placeId ~= "" then
					v15 = v12.placeId
				end

				local v19 = if fFlagGameJoinCardSourceAttribution then data.joinAttemptOrigin or Constants.AnalyticsContext.PeopleListInHomePage else Constants.AnalyticsContext.PeopleListInHomePage
				launchGame(v15, nil, p3 and { userId = p2 } or nil, v8, v19, fn5)
			elseif v13 and v13.ageCheckRequired then
				v13.joinAgeCheckUpsellFlow()
			else
				fn4()
			end
		end):catch(function()
			local failure = JoinExperienceStatus.Failure;
			(function(p4)
				setGamePlaySession(v7, sessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				local fireAnalyticsEvent = v9.fireAnalyticsEvent
				local joinExperience = EventNames.JoinExperience
				local v14 = {
					placeId = v12.placeId,
					rootPlaceId = v12.rootPlaceId,
					gameInstanceId = v12.gameId,
					profileUserId = p2,
					uid = v10,
					joinAttemptId = p4,
					status = failure,
					followUser = 0,
					isHomePageCarousel = 0,
					absolutePosition = 0,
					friendId = 0
				}

				local v15 = if fFlagJoinabilityCTARefactor then tostring(p3) else nil
				v14.followUser = v15

				v14.isHomePageCarousel = data.isHomePageCarousel or false
				v14.absolutePosition = data.homepageCarouselAbsolutePosition
				v14.friendId = if fFlagProfilePlatformImproveGameDetailsAnalytics then p2 else nil
				fireAnalyticsEvent(joinExperience, v14)
			end)()
		end)
	end

	local v14

	if defineFastFlag then
		v14 = {
			v6,
			v12.universeId,
			v12.placeId,
			v12.rootPlaceId,
			v12.gameId,
			v12.lastLocation,
			p2,
			v10,
			v9,
			v7,
			v8,
			data.isHomePageCarousel,
			data.homepageCarouselAbsolutePosition,
			data.analyticProps,
			data.openGameDetailsPeekViewClosed,
			data.onBeforeJoin,
			nil,
			nil
		}
		v14[17], v14[18] = if fFlagGameJoinCardSourceAttribution then data.joinAttemptOrigin else nil, v13
	else
		v14 = {
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil
		}

		local universeId = v12.universeId
		local placeId = v12.placeId
		local rootPlaceId = v12.rootPlaceId
		local gameId = v12.gameId

		local isHomePageCarousel = data.isHomePageCarousel
		local homepageCarouselAbsolutePosition = data.homepageCarouselAbsolutePosition
		local v15 = if fFlagGameJoinCardSourceAttribution then data.joinAttemptOrigin else nil
		v14[1], v14[2], v14[3], v14[4], v14[5], v14[6], v14[7], v14[8], v14[9], v14[10], v14[11], v14[12], v14[13], v14[14] = v6, universeId, placeId, rootPlaceId, gameId, p2, v10, v9, v7, v8, isHomePageCarousel, homepageCarouselAbsolutePosition, v15, v13
	end

	local v15 = useCallback(fn, v14)

	local v16 = React.useCallback(function()
		v15(true)
	end, { v15 })
	local v17

	if fFlagJoinabilityCTARefactor then
		v17 = React.useCallback(function()
			v15(false)
		end, { v15 })
	else
		v17 = nil
	end

	local v18 = v12.presenceType and v12.lastLocation and v12.universeId ~= "" and true or false
	local isLoading

	if v13 then
		isLoading = v12.isLoading or not v13.playabilityChecked or v13.pendingParentalControlsResolution
	else
		isLoading = v12.isLoading
	end

	local useMemo = React.useMemo
	local function fn2()
		local v19 = {
			joinExperience = v16,
			playExperience = if fFlagJoinabilityCTARefactor then v17 else nil,
			joinAgeCheckUpsellFlow = not v13 and function() end or v13.joinAgeCheckUpsellFlow,
			ageCheckRequired = 0,
			cachedPlayabilityStatus = 0,
			playabilityFromCache = 0,
			isInExperience = 0,
			isLoading = 0
		}
		local v21 = if v13 then v13.ageCheckRequired else false
		v19.ageCheckRequired = v21
		local v22 = if v13 then v13.cachedPlayabilityStatus else nil
		v19.cachedPlayabilityStatus = v22
		local v23 = if v13 then v13.playabilityFromCache else false
		v19.playabilityFromCache = v23
		v19.isInExperience = v18
		v19.isLoading = isLoading
		return v19
	end

	local v19

	if defineFastFlag then
		v19 = { nil, nil, nil, nil, nil, nil }

		v19[1], v19[2], v19[3], v19[4], v19[5], v19[6] = v16, if fFlagJoinabilityCTARefactor then v17 else nil, v18, isLoading, v13, v18
	else
		v19 = { nil, nil, nil, nil, nil, nil, nil }
		v19[1], v19[2], v19[3], v19[4], v19[5], v19[6], v19[7] = v12.presenceType, v12.lastLocation, v16, if fFlagJoinabilityCTARefactor then v17 else nil, isLoading, v13, v18
	end

	return useMemo(fn2, v19)
end
