local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local GameLaunch = require(SocialExperienceJoinParent.GameLaunch)
local LuaSocialLibrariesDeps = require(SocialExperienceJoinParent.LuaSocialLibrariesDeps)
local NavigationRodux = require(SocialExperienceJoinParent.NavigationRodux)
local Promise = require(SocialExperienceJoinParent.Promise)
local React = require(SocialExperienceJoinParent.React)
local RoactServiceTags = require(SocialExperienceJoinParent.RoactServiceTags)
local RoactUtils = require(SocialExperienceJoinParent.RoactUtils)
local RobloxAppEnums = require(SocialExperienceJoinParent.RobloxAppEnums)
local RobloxAppHooks = require(SocialExperienceJoinParent.RobloxAppHooks)
local RobloxAppSessionization = require(SocialExperienceJoinParent.RobloxAppSessionization)
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
local NetworkStatus = myRoduxNetworking.Enum.NetworkStatus
local LaunchGame = GameLaunch.LaunchGame
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local AppSessionService = RoactServiceTags.AppSessionService
local useRoactService = RobloxAppHooks.useRoactService
local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(SocialExperienceJoinParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v33 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialExperienceJoinParent.RobloxAppNavigation).NavigationCommands
local AppGame = RoactServiceTags.AppGame
local useLocalUserId = RobloxAppHooks.useLocalUserId
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local FFlagProfilePlatformImproveGameDetailsAnalytics = require(SocialExperienceJoinParent.SharedFlags).FFlagProfilePlatformImproveGameDetailsAnalytics
local FFlagEnableMobileGameJoinCard = require(SocialExperienceJoinParent.SharedFlags).FFlagEnableMobileGameJoinCard
local FFlagEnableDesktopGameJoinCard = require(SocialExperienceJoinParent.SharedFlags).FFlagEnableDesktopGameJoinCard
local FFlagProfilePlatformPassPresenceToJoinUserInExperience = require(SocialExperienceJoinParent.SharedFlags).FFlagProfilePlatformPassPresenceToJoinUserInExperience
local FFlagJoinCardAgeCheckUpsell = require(SocialExperienceJoinParent.SharedFlags).FFlagJoinCardAgeCheckUpsell
local FFlagSocialExperienceJoinPresenceStoreMigration = require(SocialExperienceJoin.Flags.FFlagSocialExperienceJoinPresenceStoreMigration)
local v43 = if not FFlagSocialExperienceJoinPresenceStoreMigration then nil else require(SocialExperienceJoinParent.FriendsCommon).Hooks.useGetPresenceByUserId
local CentralOverlay = require(SocialExperienceJoinParent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local v48 = game:DefineFastFlag("SocialJoinUseUnifiedPurchaseFlow", false)
local v49 = game:DefineFastFlag("GameJoinCardOnBeforeJoinCallback", false)
local v50 = game:DefineFastFlag("SocialJoinPassPlaceIdToLaunch", false)
local t1 = {
	skipFetch = true
}

return function(s1: string, t2: {[any]: any}) -- line: 74
	-- upvalues: useDispatch (copy), useRoactService (copy), AppSessionService (copy), AppGame (copy), React (copy), initializeSocialExperienceJoinAnalytics (copy), useLocalUserId (copy), FFlagSocialExperienceJoinPresenceStoreMigration (copy), v43 (copy), t1 (copy), useSelector (copy), FFlagEnableDesktopGameJoinCard (copy), FFlagEnableMobileGameJoinCard (copy), FFlagProfilePlatformPassPresenceToJoinUserInExperience (copy), getDeepValue (copy), Constants (copy), NetworkingGames (copy), NetworkStatus (copy), FFlagJoinCardAgeCheckUpsell (copy), useAgeCheckUpsellState (copy), SetGamePlaySession (copy), SessionType (copy), EventNames (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), JoinExperienceStatus (copy), Promise (copy), v48 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), NavigateDown (copy), PlayabilityStatus (copy), v49 (copy), LaunchGame (copy), v50 (copy)
	local v54 = useDispatch()
	local v55 = useRoactService(AppSessionService)
	local v56 = useRoactService(AppGame)
	local v57 = React.useMemo(function() -- line: 92
		-- upvalues: initializeSocialExperienceJoinAnalytics (copy), t2 (copy)
		return initializeSocialExperienceJoinAnalytics(t2.analyticProps)
	end, {})
	local v58 = useLocalUserId()
	local u59 = nil

	if FFlagSocialExperienceJoinPresenceStoreMigration then
		u59 = v43(s1, t1)
	end

	local v60 = useSelector(function(p1) -- line: 103
		-- upvalues: FFlagEnableDesktopGameJoinCard (copy), FFlagEnableMobileGameJoinCard (copy), FFlagProfilePlatformPassPresenceToJoinUserInExperience (copy), t2 (copy), FFlagSocialExperienceJoinPresenceStoreMigration (copy), u59 (ref), getDeepValue (copy), Constants (copy), s1 (copy), NetworkingGames (copy), NetworkStatus (copy)
		local v66 = if not FFlagEnableDesktopGameJoinCard and (not FFlagEnableMobileGameJoinCard and not FFlagProfilePlatformPassPresenceToJoinUserInExperience) or not t2.presence then if not FFlagSocialExperienceJoinPresenceStoreMigration then getDeepValue(p1, `{ Constants.RODUX_KEY }.Presence.byUserId.{ s1 }`) else u59 else t2.presence
		local v67 = (not v66 or not v66.universeId) and "" or tostring(v66.universeId)
		local v68 = v67 ~= "" and (NetworkingGames.GetExperiencesPlayabilityStatus.getStatus(p1, v67) == NetworkStatus.Fetching or (NetworkingGames.GetExperiencesDetails.getStatus(p1, v67) == NetworkStatus.Fetching or NetworkingGames.GetExperiencesProductInfo.getStatus(p1, v67) == NetworkStatus.Fetching))

		return {
			universeId = v67,
			presenceType = (not v66 or not v66.userPresenceType) and "" or v66.userPresenceType,
			lastLocation = if not v66 or not v66.lastLocation then nil else v66.lastLocation,
			placeId = (not v66 or not v66.placeId) and "" or tostring(v66.placeId),
			rootPlaceId = (not v66 or not v66.rootPlaceId) and "" or tostring(v66.rootPlaceId),
			gameId = (not v66 or not v66.gameId) and "" or tostring(v66.gameId),
			isLoading = v68
		}
	end)
	local v61 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckUpsellState(v60.universeId, t2.onAgeCheckCompletion)
	local v62 = React.useCallback(function() -- line: 140
		-- upvalues: v54 (copy), NetworkingGames (copy), SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), t2 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), JoinExperienceStatus (copy), Promise (copy), v48 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), v61 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), NavigateDown (copy), PlayabilityStatus (copy), v49 (copy), LaunchGame (copy), v50 (copy), v56 (copy), Constants (copy)
		local function v69(s2: string) -- line: 145
			-- upvalues: v54 (copy), NetworkingGames (copy)
			return v54(NetworkingGames.GetExperiencesProductInfo.API({ s2 }))
		end
		local function v70() -- line: 169
			-- upvalues: JoinExperienceStatus (copy), SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), t2 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), Promise (copy), v54 (copy), NetworkingGames (copy), v69 (copy), v48 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), v61 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), NavigateDown (copy)
			local PurchaseRequired = JoinExperienceStatus.PurchaseRequired;

			(function(s3: string?) -- line: 150
				-- upvalues: SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), PurchaseRequired (copy), t2 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
				SetGamePlaySession(v55, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				v57.fireAnalyticsEvent(EventNames.JoinExperience, {
					placeId = v60.placeId,
					rootPlaceId = v60.rootPlaceId,
					gameInstanceId = v60.gameId,
					profileUserId = s1,
					uid = v58,
					joinAttemptId = s3,
					status = PurchaseRequired,
					isHomePageCarousel = t2.isHomePageCarousel or false,
					absolutePosition = t2.homepageCarouselAbsolutePosition,
					friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else s1
				})
			end)()

			local all = Promise.all
			local universeId = v60.universeId

			all(v54(NetworkingGames.GetExperiencesDetails.API({ universeId })), v69(v60.universeId)):andThen(function() -- line: 177
				-- upvalues: v48 (copy), v60 (copy), v54 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), v61 (copy), AppPage (copy), s1 (copy), t2 (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), NavigateDown (copy)
				if v48 then
					local v86 = v60.lastLocation or ""
					local v87 = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", v60.universeId)

					v54(SetCentralOverlay(CentralOverlayType.UnifiedProductPurchaseModal, {
						productPayload = {
							kind = "Experience",
							universeId = v60.universeId,
							experienceName = v86,
							experienceIconUrl = v87
						},
						purchaseCallbacks = {
							onFlowComplete = function() -- line: 191
								-- upvalues: v54 (copy), CloseCentralOverlay (copy)
								v54(CloseCentralOverlay())
							end,
							onPurchaseSuccess = function() -- line: 194
								-- upvalues: v61 (copy)
								if v61 then
									v61.refetchPlayability()
								end
							end
						},
						purchaseAnalyticsMetadata = {
							surface = "JoinUserInExperience"
						}
					}))

					return
				end

				local t3 = {
					name = AppPage.SocialPurchaseExperience,
					detail = v60.universeId,
					extraProps = {
						userId = s1,
						analyticProps = t2.analyticProps
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v33.down(v33.fromLegacyPage(t3))

					return
				end

				v54(NavigateDown(t3))
			end)
		end
		local function v71() -- line: 222
			-- upvalues: v48 (copy), JoinExperienceStatus (copy), SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), t2 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), v54 (copy), NavigateDown (copy)
			local v78 = if not v48 then JoinExperienceStatus.PurchaseRequired else JoinExperienceStatus.Unable;

			(function(s4: string?) -- line: 150
				-- upvalues: SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), v78 (copy), t2 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
				SetGamePlaySession(v55, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				v57.fireAnalyticsEvent(EventNames.JoinExperience, {
					placeId = v60.placeId,
					rootPlaceId = v60.rootPlaceId,
					gameInstanceId = v60.gameId,
					profileUserId = s1,
					uid = v58,
					joinAttemptId = s4,
					status = v78,
					isHomePageCarousel = t2.isHomePageCarousel or false,
					absolutePosition = t2.homepageCarouselAbsolutePosition,
					friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else s1
				})
			end)(JoinExperienceStatus.Unable)

			local t4 = {
				name = AppPage.SocialUnableToJoinExperience,
				detail = v60.universeId,
				extraProps = {
					userId = s1,
					analyticProps = t2.analyticProps,
					openGameDetailsPeekViewClosed = t2.openGameDetailsPeekViewClosed
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v33.down(v33.fromLegacyPage(t4))

				return
			end

			v54(NavigateDown(t4))
		end;

		(function(s5: string) -- line: 248
			-- upvalues: v61 (copy), Promise (copy), v54 (copy), NetworkingGames (copy)
			if v61 and v61.cachedPlayabilityStatus then
				return Promise.resolve(v61.cachedPlayabilityStatus)
			end

			return v54(NetworkingGames.GetExperiencesPlayabilityStatus.API({ s5 })):andThen(function(p2) -- line: 253
				return p2.responseBody[1].playabilityStatus
			end)
		end)(v60.universeId):andThen(function(p3) -- line: 260
			-- upvalues: PlayabilityStatus (copy), v70 (copy), v49 (copy), t2 (copy), JoinExperienceStatus (copy), SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), LaunchGame (copy), v50 (copy), v56 (copy), Constants (copy), v61 (copy), v71 (copy)
			if p3 == PlayabilityStatus.PurchaseRequired.rawValue() then
				v70()

				return
			end

			if p3 == PlayabilityStatus.Playable.rawValue() then
				if v49 and t2.onBeforeJoin then
					t2.onBeforeJoin()
				end

				local Success = JoinExperienceStatus.Success

				LaunchGame(if not v50 or v60.placeId == "" then nil else v60.placeId, nil, {
					userId = s1
				}, v56, Constants.AnalyticsContext.PeopleListInHomePage, function(s6: string?) -- line: 150
					-- upvalues: SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), Success (copy), t2 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
					SetGamePlaySession(v55, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
					v57.fireAnalyticsEvent(EventNames.JoinExperience, {
						placeId = v60.placeId,
						rootPlaceId = v60.rootPlaceId,
						gameInstanceId = v60.gameId,
						profileUserId = s1,
						uid = v58,
						joinAttemptId = s6,
						status = Success,
						isHomePageCarousel = t2.isHomePageCarousel or false,
						absolutePosition = t2.homepageCarouselAbsolutePosition,
						friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else s1
					})
				end)

				return
			end

			if v61 and v61.ageCheckRequired then
				v61.joinAgeCheckUpsellFlow()

				return
			end

			v71()
		end):catch(function() -- line: 285
			-- upvalues: JoinExperienceStatus (copy), SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), t2 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
			local Failure = JoinExperienceStatus.Failure;

			(function(s7: string?) -- line: 150
				-- upvalues: SetGamePlaySession (copy), v55 (copy), SessionType (copy), v57 (copy), EventNames (copy), v60 (copy), s1 (copy), v58 (copy), Failure (copy), t2 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
				SetGamePlaySession(v55, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				v57.fireAnalyticsEvent(EventNames.JoinExperience, {
					placeId = v60.placeId,
					rootPlaceId = v60.rootPlaceId,
					gameInstanceId = v60.gameId,
					profileUserId = s1,
					uid = v58,
					joinAttemptId = s7,
					status = Failure,
					isHomePageCarousel = t2.isHomePageCarousel or false,
					absolutePosition = t2.homepageCarouselAbsolutePosition,
					friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else s1
				})
			end)()
		end)
	end, if not v48 then {
		v54,
		v60.universeId,
		v60.placeId,
		v60.rootPlaceId,
		v60.gameId,
		s1,
		v58,
		v57,
		v55,
		v56,
		t2.isHomePageCarousel,
		t2.homepageCarouselAbsolutePosition,
		v61
	} else {
		v54,
		v60.universeId,
		v60.placeId,
		v60.rootPlaceId,
		v60.gameId,
		v60.lastLocation,
		s1,
		v58,
		v57,
		v55,
		v56,
		t2.isHomePageCarousel,
		t2.homepageCarouselAbsolutePosition,
		t2.analyticProps,
		t2.openGameDetailsPeekViewClosed,
		t2.onBeforeJoin,
		v61
	})
	local v63 = not not v60.presenceType and (not not v60.lastLocation and v60.universeId ~= "")
	local v64 = if not v61 then v60.isLoading else v60.isLoading or (not v61.playabilityChecked or v61.pendingParentalControlsResolution)

	return React.useMemo(function() -- line: 340
		-- upvalues: v62 (copy), v61 (copy), v63 (copy), v64 (copy)
		return {
			joinExperience = v62,
			joinAgeCheckUpsellFlow = not v61 and function() -- line: 345
			end or v61.joinAgeCheckUpsellFlow,
			ageCheckRequired = not not v61 and v61.ageCheckRequired,
			cachedPlayabilityStatus = if not v61 then nil else v61.cachedPlayabilityStatus,
			playabilityFromCache = not not v61 and v61.playabilityFromCache,
			isInExperience = v63,
			isLoading = v64
		}
	end, if not v48 then {
		v60.presenceType,
		v60.lastLocation,
		v62,
		v64,
		v61,
		v63
	} else {
		v62,
		v63,
		v64,
		v61,
		v63
	})
end
