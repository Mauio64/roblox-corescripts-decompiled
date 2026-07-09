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
local CentralOverlay = require(SocialExperienceJoinParent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local v46 = game:DefineFastFlag("SocialJoinUseUnifiedPurchaseFlow", false)
local v47 = game:DefineFastFlag("GameJoinCardOnBeforeJoinCallback", false)
local v48 = game:DefineFastFlag("SocialJoinPassPlaceIdToLaunch", false)

return function(s1: string, t1: {[any]: any}) -- line: 66
	-- upvalues: useDispatch (copy), useRoactService (copy), AppSessionService (copy), AppGame (copy), React (copy), initializeSocialExperienceJoinAnalytics (copy), useLocalUserId (copy), useSelector (copy), FFlagEnableDesktopGameJoinCard (copy), FFlagEnableMobileGameJoinCard (copy), FFlagProfilePlatformPassPresenceToJoinUserInExperience (copy), getDeepValue (copy), Constants (copy), NetworkingGames (copy), NetworkStatus (copy), FFlagJoinCardAgeCheckUpsell (copy), useAgeCheckUpsellState (copy), SetGamePlaySession (copy), SessionType (copy), EventNames (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), JoinExperienceStatus (copy), Promise (copy), v46 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), NavigateDown (copy), PlayabilityStatus (copy), v47 (copy), LaunchGame (copy), v48 (copy)
	local v51 = useDispatch()
	local v52 = useRoactService(AppSessionService)
	local v53 = useRoactService(AppGame)
	local v54 = React.useMemo(function() -- line: 84
		-- upvalues: initializeSocialExperienceJoinAnalytics (copy), t1 (copy)
		return initializeSocialExperienceJoinAnalytics(t1.analyticProps)
	end, {})
	local v55 = useLocalUserId()
	local v56 = useSelector(function(p1) -- line: 89
		-- upvalues: FFlagEnableDesktopGameJoinCard (copy), FFlagEnableMobileGameJoinCard (copy), FFlagProfilePlatformPassPresenceToJoinUserInExperience (copy), t1 (copy), getDeepValue (copy), Constants (copy), s1 (copy), NetworkingGames (copy), NetworkStatus (copy)
		local v62 = if not FFlagEnableDesktopGameJoinCard and (not FFlagEnableMobileGameJoinCard and not FFlagProfilePlatformPassPresenceToJoinUserInExperience) or not t1.presence then getDeepValue(p1, `{ Constants.RODUX_KEY }.Presence.byUserId.{ s1 }`) else t1.presence
		local v63 = (not v62 or not v62.universeId) and "" or tostring(v62.universeId)
		local v64 = v63 ~= "" and (NetworkingGames.GetExperiencesPlayabilityStatus.getStatus(p1, v63) == NetworkStatus.Fetching or (NetworkingGames.GetExperiencesDetails.getStatus(p1, v63) == NetworkStatus.Fetching or NetworkingGames.GetExperiencesProductInfo.getStatus(p1, v63) == NetworkStatus.Fetching))

		return {
			universeId = v63,
			presenceType = (not v62 or not v62.userPresenceType) and "" or v62.userPresenceType,
			lastLocation = if not v62 or not v62.lastLocation then nil else v62.lastLocation,
			placeId = (not v62 or not v62.placeId) and "" or tostring(v62.placeId),
			rootPlaceId = (not v62 or not v62.rootPlaceId) and "" or tostring(v62.rootPlaceId),
			gameId = (not v62 or not v62.gameId) and "" or tostring(v62.gameId),
			isLoading = v64
		}
	end)
	local v57 = if not FFlagJoinCardAgeCheckUpsell then nil else useAgeCheckUpsellState(v56.universeId, t1.onAgeCheckCompletion)
	local v58 = React.useCallback(function() -- line: 124
		-- upvalues: v51 (copy), NetworkingGames (copy), SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), t1 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), JoinExperienceStatus (copy), Promise (copy), v46 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), v57 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), NavigateDown (copy), PlayabilityStatus (copy), v47 (copy), LaunchGame (copy), v48 (copy), v53 (copy), Constants (copy)
		local function v65(s2: string) -- line: 129
			-- upvalues: v51 (copy), NetworkingGames (copy)
			return v51(NetworkingGames.GetExperiencesProductInfo.API({ s2 }))
		end
		local function v66() -- line: 153
			-- upvalues: JoinExperienceStatus (copy), SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), t1 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), Promise (copy), v51 (copy), NetworkingGames (copy), v65 (copy), v46 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), v57 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), NavigateDown (copy)
			local PurchaseRequired = JoinExperienceStatus.PurchaseRequired;

			(function(s3: string?) -- line: 134
				-- upvalues: SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), PurchaseRequired (copy), t1 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
				SetGamePlaySession(v52, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				v54.fireAnalyticsEvent(EventNames.JoinExperience, {
					placeId = v56.placeId,
					rootPlaceId = v56.rootPlaceId,
					gameInstanceId = v56.gameId,
					profileUserId = s1,
					uid = v55,
					joinAttemptId = s3,
					status = PurchaseRequired,
					isHomePageCarousel = t1.isHomePageCarousel or false,
					absolutePosition = t1.homepageCarouselAbsolutePosition,
					friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else s1
				})
			end)()

			local all = Promise.all
			local universeId = v56.universeId

			all(v51(NetworkingGames.GetExperiencesDetails.API({ universeId })), v65(v56.universeId)):andThen(function() -- line: 161
				-- upvalues: v46 (copy), v56 (copy), v51 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy), v57 (copy), AppPage (copy), s1 (copy), t1 (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), NavigateDown (copy)
				if v46 then
					local v82 = v56.lastLocation or ""
					local v83 = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", v56.universeId)

					v51(SetCentralOverlay(CentralOverlayType.UnifiedProductPurchaseModal, {
						productPayload = {
							kind = "Experience",
							universeId = v56.universeId,
							experienceName = v82,
							experienceIconUrl = v83
						},
						purchaseCallbacks = {
							onFlowComplete = function() -- line: 175
								-- upvalues: v51 (copy), CloseCentralOverlay (copy)
								v51(CloseCentralOverlay())
							end,
							onPurchaseSuccess = function() -- line: 178
								-- upvalues: v57 (copy)
								if v57 then
									v57.refetchPlayability()
								end
							end
						},
						purchaseAnalyticsMetadata = {
							surface = "JoinUserInExperience"
						}
					}))

					return
				end

				local t2 = {
					name = AppPage.SocialPurchaseExperience,
					detail = v56.universeId,
					extraProps = {
						userId = s1,
						analyticProps = t1.analyticProps
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v33.down(v33.fromLegacyPage(t2))

					return
				end

				v51(NavigateDown(t2))
			end)
		end
		local function v67() -- line: 206
			-- upvalues: v46 (copy), JoinExperienceStatus (copy), SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), t1 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v33 (copy), v51 (copy), NavigateDown (copy)
			local v74 = if not v46 then JoinExperienceStatus.PurchaseRequired else JoinExperienceStatus.Unable;

			(function(s4: string?) -- line: 134
				-- upvalues: SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), v74 (copy), t1 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
				SetGamePlaySession(v52, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				v54.fireAnalyticsEvent(EventNames.JoinExperience, {
					placeId = v56.placeId,
					rootPlaceId = v56.rootPlaceId,
					gameInstanceId = v56.gameId,
					profileUserId = s1,
					uid = v55,
					joinAttemptId = s4,
					status = v74,
					isHomePageCarousel = t1.isHomePageCarousel or false,
					absolutePosition = t1.homepageCarouselAbsolutePosition,
					friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else s1
				})
			end)(JoinExperienceStatus.Unable)

			local t3 = {
				name = AppPage.SocialUnableToJoinExperience,
				detail = v56.universeId,
				extraProps = {
					userId = s1,
					analyticProps = t1.analyticProps,
					openGameDetailsPeekViewClosed = t1.openGameDetailsPeekViewClosed
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v33.down(v33.fromLegacyPage(t3))

				return
			end

			v51(NavigateDown(t3))
		end;

		(function(s5: string) -- line: 232
			-- upvalues: v57 (copy), Promise (copy), v51 (copy), NetworkingGames (copy)
			if v57 and v57.cachedPlayabilityStatus then
				return Promise.resolve(v57.cachedPlayabilityStatus)
			end

			return v51(NetworkingGames.GetExperiencesPlayabilityStatus.API({ s5 })):andThen(function(p2) -- line: 237
				return p2.responseBody[1].playabilityStatus
			end)
		end)(v56.universeId):andThen(function(p3) -- line: 244
			-- upvalues: PlayabilityStatus (copy), v66 (copy), v47 (copy), t1 (copy), JoinExperienceStatus (copy), SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), LaunchGame (copy), v48 (copy), v53 (copy), Constants (copy), v57 (copy), v67 (copy)
			if p3 == PlayabilityStatus.PurchaseRequired.rawValue() then
				v66()

				return
			end

			if p3 == PlayabilityStatus.Playable.rawValue() then
				if v47 and t1.onBeforeJoin then
					t1.onBeforeJoin()
				end

				local Success = JoinExperienceStatus.Success

				LaunchGame(if not v48 or v56.placeId == "" then nil else v56.placeId, nil, {
					userId = s1
				}, v53, Constants.AnalyticsContext.PeopleListInHomePage, function(s6: string?) -- line: 134
					-- upvalues: SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), Success (copy), t1 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
					SetGamePlaySession(v52, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
					v54.fireAnalyticsEvent(EventNames.JoinExperience, {
						placeId = v56.placeId,
						rootPlaceId = v56.rootPlaceId,
						gameInstanceId = v56.gameId,
						profileUserId = s1,
						uid = v55,
						joinAttemptId = s6,
						status = Success,
						isHomePageCarousel = t1.isHomePageCarousel or false,
						absolutePosition = t1.homepageCarouselAbsolutePosition,
						friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else s1
					})
				end)

				return
			end

			if v57 and v57.ageCheckRequired then
				v57.joinAgeCheckUpsellFlow()

				return
			end

			v67()
		end):catch(function() -- line: 269
			-- upvalues: JoinExperienceStatus (copy), SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), t1 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
			local Failure = JoinExperienceStatus.Failure;

			(function(s7: string?) -- line: 134
				-- upvalues: SetGamePlaySession (copy), v52 (copy), SessionType (copy), v54 (copy), EventNames (copy), v56 (copy), s1 (copy), v55 (copy), Failure (copy), t1 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy)
				SetGamePlaySession(v52, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
				v54.fireAnalyticsEvent(EventNames.JoinExperience, {
					placeId = v56.placeId,
					rootPlaceId = v56.rootPlaceId,
					gameInstanceId = v56.gameId,
					profileUserId = s1,
					uid = v55,
					joinAttemptId = s7,
					status = Failure,
					isHomePageCarousel = t1.isHomePageCarousel or false,
					absolutePosition = t1.homepageCarouselAbsolutePosition,
					friendId = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else s1
				})
			end)()
		end)
	end, if not v46 then {
		v51,
		v56.universeId,
		v56.placeId,
		v56.rootPlaceId,
		v56.gameId,
		s1,
		v55,
		v54,
		v52,
		v53,
		t1.isHomePageCarousel,
		t1.homepageCarouselAbsolutePosition,
		v57
	} else {
		v51,
		v56.universeId,
		v56.placeId,
		v56.rootPlaceId,
		v56.gameId,
		v56.lastLocation,
		s1,
		v55,
		v54,
		v52,
		v53,
		t1.isHomePageCarousel,
		t1.homepageCarouselAbsolutePosition,
		t1.analyticProps,
		t1.openGameDetailsPeekViewClosed,
		t1.onBeforeJoin,
		v57
	})
	local v59 = not not v56.presenceType and (not not v56.lastLocation and v56.universeId ~= "")
	local v60 = if not v57 then v56.isLoading else v56.isLoading or (not v57.playabilityChecked or v57.pendingParentalControlsResolution)

	return React.useMemo(function() -- line: 324
		-- upvalues: v58 (copy), v57 (copy), v59 (copy), v60 (copy)
		return {
			joinExperience = v58,
			joinAgeCheckUpsellFlow = not v57 and function() -- line: 329
			end or v57.joinAgeCheckUpsellFlow,
			ageCheckRequired = not not v57 and v57.ageCheckRequired,
			cachedPlayabilityStatus = if not v57 then nil else v57.cachedPlayabilityStatus,
			playabilityFromCache = not not v57 and v57.playabilityFromCache,
			isInExperience = v59,
			isLoading = v60
		}
	end, if not v46 then {
		v56.presenceType,
		v56.lastLocation,
		v58,
		v60,
		v57,
		v59
	} else {
		v58,
		v59,
		v60,
		v57,
		v59
	})
end
