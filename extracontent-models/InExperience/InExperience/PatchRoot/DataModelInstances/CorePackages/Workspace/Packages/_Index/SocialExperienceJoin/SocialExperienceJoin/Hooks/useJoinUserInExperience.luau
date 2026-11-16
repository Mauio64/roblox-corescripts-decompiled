local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent

local GameLaunch = require(parent.GameLaunch)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local NavigationRodux = require(parent.NavigationRodux)
local Promise = require(parent.Promise)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local Games = require(SocialExperienceJoin.Rodux.Games)

local EventNames = require(SocialExperienceJoin.Analytics.EventNames)
local JoinExperienceStatus = require(SocialExperienceJoin.Analytics.JoinExperienceStatus)

local initializeSocialExperienceJoinAnalytics = require(SocialExperienceJoin.Analytics.initializeSocialExperienceJoinAnalytics)
local Constants = require(SocialExperienceJoin.Common.Constants)
local NetworkingGames = require(SocialExperienceJoin.Networking.NetworkingGames)
local myRoduxNetworking = require(SocialExperienceJoin.Networking.myRoduxNetworking)

local useAgeCheckUpsellState = require(script.Parent.useAgeCheckUpsellState)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local PlayabilityStatus = Games.Enums.PlayabilityStatus

local networkStatus = myRoduxNetworking.Enum.NetworkStatus
local LaunchGame = GameLaunch.LaunchGame
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local AppSessionService = RoactServiceTags.AppSessionService
local useRoactService = RobloxAppHooks.useRoactService

local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local AppGame = RoactServiceTags.AppGame

local useLocalUserId = RobloxAppHooks.useLocalUserId
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformImproveGameDetailsAnalytics = SharedFlags2.FFlagProfilePlatformImproveGameDetailsAnalytics
local SharedFlags3 = require(parent.SharedFlags)
local FFlagGameJoinCardSourceAttribution = SharedFlags3.FFlagGameJoinCardSourceAttribution
local SharedFlags4 = require(parent.SharedFlags)
local FFlagJoinabilityCTARefactor = SharedFlags4.FFlagJoinabilityCTARefactor

local FFlagSocialExperienceJoinPresenceStoreMigration = require(SocialExperienceJoin.Flags.FFlagSocialExperienceJoinPresenceStoreMigration)
local useGetPresenceByUserId

if FFlagSocialExperienceJoinPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

local defineFastFlag = game:DefineFastFlag("SocialJoinUseUnifiedPurchaseFlow", false)
local defineFastFlag2 = game:DefineFastFlag("GameJoinCardOnBeforeJoinCallback", false)
local defineFastFlag3 = game:DefineFastFlag("SocialJoinPassPlaceIdToLaunch", false)

local v = { skipFetch = true }

return function(p: string, data)
	local v2 = useDispatch()
	local v3 = useRoactService(AppSessionService)
	local v4 = useRoactService(AppGame)
	local v5 = React.useMemo(function()
		return initializeSocialExperienceJoinAnalytics(data.analyticProps)
	end, {})
	local uid = useLocalUserId()
	local v6

	if FFlagSocialExperienceJoinPresenceStoreMigration then
		v6 = useGetPresenceByUserId(p, v)
	else
		v6 = nil
	end

	local v7 = useSelector(function(p2)
		local v7

		if data.presence then
			v7 = data.presence
		elseif FFlagSocialExperienceJoinPresenceStoreMigration then
			v7 = v6
		else
			v7 = getDeepValue(p2, `{Constants.RODUX_KEY}.Presence.byUserId.{p}`)
		end

		local universeId = not (v7 and v7.universeId) and "" or tostring(v7.universeId)
		local isLoading

		if universeId == "" then
			isLoading = false
		else
			isLoading = NetworkingGames.GetExperiencesPlayabilityStatus.getStatus(p2, universeId) == networkStatus.Fetching
				or NetworkingGames.GetExperiencesDetails.getStatus(p2, universeId) == networkStatus.Fetching
				or NetworkingGames.GetExperiencesProductInfo.getStatus(p2, universeId) == networkStatus.Fetching
		end

		local v8 = {
			universeId = universeId,
			presenceType = not (v7 and v7.userPresenceType) and "" or v7.userPresenceType,
			lastLocation = 0,
			placeId = 0,
			rootPlaceId = 0,
			gameId = 0,
			isLoading = 0
		}
		local lastLocation

		if v7 and v7.lastLocation then
			lastLocation = v7.lastLocation
		end

		v8.lastLocation = lastLocation
		v8.placeId = not (v7 and v7.placeId) and "" or tostring(v7.placeId)
		v8.rootPlaceId = not (v7 and v7.rootPlaceId) and "" or tostring(v7.rootPlaceId)
		v8.gameId = not (v7 and v7.gameId) and "" or tostring(v7.gameId)
		v8.isLoading = isLoading
		return v8
	end)

	local v8 = useAgeCheckUpsellState(v7.universeId, data.onAgeCheckCompletion)

	local useCallback = React.useCallback
	local function fn(flag: boolean)
		local function fn2(universeId: string)
			return v2(NetworkingGames.GetExperiencesProductInfo.API({ universeId }))
		end

		local function fn3()
			local purchaseRequired = JoinExperienceStatus.PurchaseRequired;
			(function(joinAttemptId: string?)
				SetGamePlaySession(v3, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				local fireAnalyticsEvent = v5.fireAnalyticsEvent
				local joinExperience = EventNames.JoinExperience
				local v9 = {
					placeId = v7.placeId,
					rootPlaceId = v7.rootPlaceId,
					gameInstanceId = v7.gameId,
					profileUserId = p,
					uid = uid,
					joinAttemptId = joinAttemptId,
					status = purchaseRequired,
					followUser = 0,
					isHomePageCarousel = 0,
					absolutePosition = 0,
					friendId = 0
				}
				local followUser

				if FFlagJoinabilityCTARefactor then
					followUser = tostring(flag)
				end

				v9.followUser = followUser

				v9.isHomePageCarousel = data.isHomePageCarousel or false
				v9.absolutePosition = data.homepageCarouselAbsolutePosition
				local friendId

				if FFlagProfilePlatformImproveGameDetailsAnalytics then
					friendId = p
				end

				v9.friendId = friendId
				fireAnalyticsEvent(joinExperience, v9)
			end)()
			local all = Promise.all
			local v9 = { v7.universeId }
			all(v2(NetworkingGames.GetExperiencesDetails.API(v9)), fn2(v7.universeId)):andThen(function()
				if defineFastFlag then
					local lastLocation = v7.lastLocation or ""

					local experienceIconUrl = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", v7.universeId)

					v2(SetCentralOverlay(CentralOverlayType.UnifiedProductPurchaseModal, {
						productPayload = {
							universeId = v7.universeId,
							kind = "Experience",
							experienceName = lastLocation,
							experienceIconUrl = experienceIconUrl
						},
						purchaseCallbacks = {
							onFlowComplete = function()
								v2(CloseCentralOverlay())
							end,
							onPurchaseSuccess = function()
								if v8 then
									v8.refetchPlayability()
								end
							end
						},
						purchaseAnalyticsMetadata = { surface = "JoinUserInExperience" }
					}))
				else
					local v10 = {
						name = AppPage.SocialPurchaseExperience,
						detail = v7.universeId,
						extraProps = { userId = p, analyticProps = data.analyticProps }
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v10))
					else
						v2(NavigateDown(v10))
					end
				end
			end)
		end

		local function fn4()
			local status

			if defineFastFlag then
				status = JoinExperienceStatus.Unable
			else
				status = JoinExperienceStatus.PurchaseRequired
			end

			(function(joinAttemptId: string?)
				SetGamePlaySession(v3, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				local fireAnalyticsEvent = v5.fireAnalyticsEvent
				local joinExperience = EventNames.JoinExperience
				local v9 = {
					placeId = v7.placeId,
					rootPlaceId = v7.rootPlaceId,
					gameInstanceId = v7.gameId,
					profileUserId = p,
					uid = uid,
					joinAttemptId = joinAttemptId,
					status = status,
					followUser = 0,
					isHomePageCarousel = 0,
					absolutePosition = 0,
					friendId = 0
				}
				local followUser

				if FFlagJoinabilityCTARefactor then
					followUser = tostring(flag)
				end

				v9.followUser = followUser

				v9.isHomePageCarousel = data.isHomePageCarousel or false
				v9.absolutePosition = data.homepageCarouselAbsolutePosition
				local friendId

				if FFlagProfilePlatformImproveGameDetailsAnalytics then
					friendId = p
				end

				v9.friendId = friendId
				fireAnalyticsEvent(joinExperience, v9)
			end)(JoinExperienceStatus.Unable)

			local v9 = {
				name = AppPage.SocialUnableToJoinExperience,
				detail = v7.universeId,
				extraProps = {
					userId = p,
					analyticProps = data.analyticProps,
					openGameDetailsPeekViewClosed = data.openGameDetailsPeekViewClosed
				}
			}

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v9))
			else
				v2(NavigateDown(v9))
			end
		end

		(function(p2: string)
			if v8 and v8.cachedPlayabilityStatus then
				return Promise.resolve(v8.cachedPlayabilityStatus)
			end

			return v2(NetworkingGames.GetExperiencesPlayabilityStatus.API({ p2 })):andThen(function(p3)
				return p3.responseBody[1].playabilityStatus
			end)
		end)(v7.universeId):andThen(function(p2)
			if p2 == PlayabilityStatus.PurchaseRequired.rawValue() then
				fn3()
			elseif p2 == PlayabilityStatus.Playable.rawValue() then
				if defineFastFlag2 and data.onBeforeJoin then
					data.onBeforeJoin()
				end

				local success = JoinExperienceStatus.Success

				local function fn5(joinAttemptId: string?)
					SetGamePlaySession(v3, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
					local fireAnalyticsEvent = v5.fireAnalyticsEvent
					local joinExperience = EventNames.JoinExperience
					local v9 = {
						placeId = v7.placeId,
						rootPlaceId = v7.rootPlaceId,
						gameInstanceId = v7.gameId,
						profileUserId = p,
						uid = uid,
						joinAttemptId = joinAttemptId,
						status = success,
						followUser = 0,
						isHomePageCarousel = 0,
						absolutePosition = 0,
						friendId = 0
					}
					local followUser

					if FFlagJoinabilityCTARefactor then
						followUser = tostring(flag)
					end

					v9.followUser = followUser

					v9.isHomePageCarousel = data.isHomePageCarousel or false
					v9.absolutePosition = data.homepageCarouselAbsolutePosition
					local friendId

					if FFlagProfilePlatformImproveGameDetailsAnalytics then
						friendId = p
					end

					v9.friendId = friendId
					fireAnalyticsEvent(joinExperience, v9)
				end

				local v9

				if FFlagJoinabilityCTARefactor and not flag then
					v9 = v7.rootPlaceId
				elseif defineFastFlag3 and v7.placeId ~= "" then
					v9 = v7.placeId
				end

				local v10

				if FFlagGameJoinCardSourceAttribution then
					v10 = data.joinAttemptOrigin or Constants.AnalyticsContext.PeopleListInHomePage
				else
					v10 = Constants.AnalyticsContext.PeopleListInHomePage
				end

				LaunchGame(v9, nil, flag and { userId = p } or nil, v4, v10, fn5)
			elseif v8 and v8.ageCheckRequired then
				v8.joinAgeCheckUpsellFlow()
			else
				fn4()
			end
		end):catch(function()
			local failure = JoinExperienceStatus.Failure;
			(function(joinAttemptId: string?)
				SetGamePlaySession(v3, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				local fireAnalyticsEvent = v5.fireAnalyticsEvent
				local joinExperience = EventNames.JoinExperience
				local v9 = {
					placeId = v7.placeId,
					rootPlaceId = v7.rootPlaceId,
					gameInstanceId = v7.gameId,
					profileUserId = p,
					uid = uid,
					joinAttemptId = joinAttemptId,
					status = failure,
					followUser = 0,
					isHomePageCarousel = 0,
					absolutePosition = 0,
					friendId = 0
				}
				local followUser

				if FFlagJoinabilityCTARefactor then
					followUser = tostring(flag)
				end

				v9.followUser = followUser

				v9.isHomePageCarousel = data.isHomePageCarousel or false
				v9.absolutePosition = data.homepageCarouselAbsolutePosition
				local friendId

				if FFlagProfilePlatformImproveGameDetailsAnalytics then
					friendId = p
				end

				v9.friendId = friendId
				fireAnalyticsEvent(joinExperience, v9)
			end)()
		end)
	end

	local v9

	if defineFastFlag then
		v9 = {
			v2,
			v7.universeId,
			v7.placeId,
			v7.rootPlaceId,
			v7.gameId,
			v7.lastLocation,
			p,
			uid,
			v5,
			v3,
			v4,
			data.isHomePageCarousel,
			data.homepageCarouselAbsolutePosition,
			data.analyticProps,
			data.openGameDetailsPeekViewClosed,
			data.onBeforeJoin,
			nil,
			nil
		}
		local v10

		if FFlagGameJoinCardSourceAttribution then
			v10 = data.joinAttemptOrigin
		end

		v9[17], v9[18] = v10, v8
	else
		v9 = {
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

		local universeId = v7.universeId
		local placeId = v7.placeId
		local rootPlaceId = v7.rootPlaceId
		local gameId = v7.gameId

		local isHomePageCarousel = data.isHomePageCarousel
		local homepageCarouselAbsolutePosition = data.homepageCarouselAbsolutePosition
		local v10

		if FFlagGameJoinCardSourceAttribution then
			v10 = data.joinAttemptOrigin
		end

		v9[1], v9[2], v9[3], v9[4], v9[5], v9[6], v9[7], v9[8], v9[9], v9[10], v9[11], v9[12], v9[13], v9[14] = v2, universeId, placeId, rootPlaceId, gameId, p, uid, v5, v3, v4, isHomePageCarousel, homepageCarouselAbsolutePosition, v10, v8
	end

	local v10 = useCallback(fn, v9)

	local joinExperience = React.useCallback(function()
		v10(true)
	end, { v10 })
	local v11

	if FFlagJoinabilityCTARefactor then
		v11 = React.useCallback(function()
			v10(false)
		end, { v10 })
	else
		v11 = nil
	end

	local isInExperience = v7.presenceType and v7.lastLocation and v7.universeId ~= "" and true or false
	local isLoading

	if v8 then
		isLoading = v7.isLoading or not v8.playabilityChecked or v8.pendingParentalControlsResolution
	else
		isLoading = v7.isLoading
	end

	local useMemo = React.useMemo
	local function fn2()
		local v12 = {
			joinExperience = joinExperience,
			playExperience = nil,
			joinAgeCheckUpsellFlow = 0,
			ageCheckRequired = 0,
			cachedPlayabilityStatus = 0,
			playabilityFromCache = 0,
			isInExperience = 0,
			isLoading = 0
		}
		local playExperience

		if FFlagJoinabilityCTARefactor then
			playExperience = v11
		end

		v12.playExperience = playExperience
		v12.joinAgeCheckUpsellFlow = not v8 and function() end or v8.joinAgeCheckUpsellFlow
		local ageCheckRequired

		if v8 then
			ageCheckRequired = v8.ageCheckRequired
		else
			ageCheckRequired = false
		end

		v12.ageCheckRequired = ageCheckRequired
		local cachedPlayabilityStatus

		if v8 then
			cachedPlayabilityStatus = v8.cachedPlayabilityStatus
		end

		v12.cachedPlayabilityStatus = cachedPlayabilityStatus
		local playabilityFromCache

		if v8 then
			playabilityFromCache = v8.playabilityFromCache
		else
			playabilityFromCache = false
		end

		v12.playabilityFromCache = playabilityFromCache
		v12.isInExperience = isInExperience
		v12.isLoading = isLoading
		return v12
	end

	local v12

	if defineFastFlag then
		v12 = { nil, nil, nil, nil, nil, nil }
		local v13

		if FFlagJoinabilityCTARefactor then
			v13 = v11
		end

		v12[1], v12[2], v12[3], v12[4], v12[5], v12[6] = joinExperience, v13, isInExperience, isLoading, v8, isInExperience
	else
		v12 = { nil, nil, nil, nil, nil, nil, nil }
		local presenceType = v7.presenceType
		local lastLocation = v7.lastLocation
		local v13

		if FFlagJoinabilityCTARefactor then
			v13 = v11
		end

		v12[1], v12[2], v12[3], v12[4], v12[5], v12[6], v12[7] = presenceType, lastLocation, joinExperience, v13, isLoading, v8, isInExperience
	end

	return useMemo(fn2, v12)
end
