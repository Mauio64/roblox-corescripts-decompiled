local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local IXPService = game:GetService("IXPService")
local IXPServiceWrapper = require(AddFriendsParent.IXPServiceWrapper).IXPServiceWrapper
local Analytics = require(AddFriends.Analytics)
local AnalyticsSetup = Analytics.AnalyticsSetup
local EventNames = Analytics.EventNames
local Namespaces = Analytics.Namespaces
local sessionUtil = require(AddFriends.Analytics.sessionUtil)
local SocialCommon = require(AddFriendsParent.SocialCommon)
local Promise = require(AddFriendsParent.Promise)
local React = require(AddFriendsParent.React)
local Dash = require(AddFriendsParent.Dash)
local useNavigation = require(AddFriendsParent.Navigation).useNavigation
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local useSelector = require(AddFriendsParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(AddFriendsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local AddFriendsState = require(AddFriendsParent.AddFriendsState)
local AddFriendsSelector = AddFriendsState.AddFriendsSelector
local useLocalUserId = require(AddFriendsParent.RobloxAppHooks).useLocalUserId
local RoduxFriends = AddFriendsState.RoduxFriends
local RoduxAnalytics = AddFriendsState.RoduxAnalytics
local FriendsNetworking = AddFriendsState.Networking.FriendsNetworking
local NetworkingGames = require(AddFriends.Networking.NetworkingGames)
local NetworkingPresence = require(AddFriends.Networking.NetworkingPresence)
local RecommendationSourceEnum = SocialCommon.Enums.RecommendationSourceEnum
local RECOMMENDATION_SESSION_ID_KEY = require(AddFriends.Common.Constants).RECOMMENDATION_SESSION_ID_KEY
local getSessionIdByKey = RoduxAnalytics.Selectors.getSessionIdByKey
local getFriendRecommendationsFromState = require(script.Parent.getFriendRecommendationsFromState)
local getFriendRequestsFromState = require(script.Parent.getFriendRequestsFromState)
local ShowMoreSectionTypeEnum = require(AddFriends.Enums.ShowMoreSectionTypeEnum)
local SocialLuaAnalytics = require(AddFriendsParent.SocialLuaAnalytics)
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local reportPromiseLoadingTimeWrapper = SocialLuaAnalytics.Analytics.Timing.reportPromiseLoadingTimeWrapper
local Responsive = require(AddFriendsParent.Responsive)
local BreakpointConfig = Responsive.BreakpointConfig
local ToastRodux = require(AddFriendsParent.ToastRodux)
local AddFriendsPage = require(script.Parent.Parent.AddFriendsPage)
local useFAEUpsellOnAfp = require(script.Parent.Parent.FaeUpsellOnAfp.useFAEUpsellOnAfp)

require(script.Parent.Parent.AddFriendsTile.getFriendRequestHandlersExtraProps)

local AppUserLayers = require(AddFriendsParent.ExperimentLayers).AppUserLayers
local FFlagConnectionsHubLayerExposure = require(AddFriendsParent.SharedFlags).FFlagConnectionsHubLayerExposure
local FFlagFixCohubExposureLayer = require(AddFriendsParent.SharedFlags).FFlagFixCohubExposureLayer
local FFlagAddFriendsPYMKPresence = require(AddFriendsParent.SharedFlags).FFlagAddFriendsPYMKPresence
local FFlagAddFriendsPYMKPresenceAnalytics = require(AddFriendsParent.SharedFlags).FFlagAddFriendsPYMKPresenceAnalytics
local FFlagAddFriendsUserListEnabled = require(AddFriendsParent.SharedFlags).FFlagAddFriendsUserListEnabled
local FFlagAddFriendsSessionId = require(AddFriendsParent.SharedFlags).FFlagAddFriendsSessionId
local FFlagConnectionsToFriendsRename = require(AddFriendsParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagAddFriendsPageFAEUpsell = require(AddFriendsParent.SharedFlags).FFlagAddFriendsPageFAEUpsell
local FFlagAddFriendsPresenceStoreMigration = require(AddFriends.Flags.FFlagAddFriendsPresenceStoreMigration)

local function AddFriendsContainer(t1: {[any]: any}) -- line: 79
	-- upvalues: FFlagAddFriendsPageFAEUpsell (copy), useFAEUpsellOnAfp (copy), useNavigation (copy), useDispatch (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), useLocalUserId (copy), useSelector (copy), getFriendRecommendationsFromState (copy), getSessionIdByKey (copy), RECOMMENDATION_SESSION_ID_KEY (copy), getFriendRequestsFromState (copy), AddFriendsSelector (copy), React (copy), AnalyticsSetup (copy), FriendsNetworking (copy), Promise (copy), Dash (copy), FFlagAddFriendsSessionId (copy), sessionUtil (copy), NetworkingGames (copy), RecommendationSourceEnum (copy), ContextualInfoTypes (copy), RoduxFriends (copy), RoduxAnalytics (copy), FFlagAddFriendsPYMKPresence (copy), FFlagAddFriendsPresenceStoreMigration (copy), NetworkingPresence (copy), FFlagAddFriendsPYMKPresenceAnalytics (copy), EventNames (copy), BreakpointConfig (copy), Responsive (copy), ToastRodux (copy), FFlagAddFriendsUserListEnabled (copy), reportPromiseLoadingTimeWrapper (copy), Namespaces (copy), ShowMoreSectionTypeEnum (copy), FFlagConnectionsHubLayerExposure (copy), FFlagFixCohubExposureLayer (copy), IXPServiceWrapper (copy), AppUserLayers (copy), IXPService (copy), AddFriendsPage (copy)
	if FFlagAddFriendsPageFAEUpsell then
		useFAEUpsellOnAfp()
	end

	local v52 = useNavigation()
	local v53 = useDispatch()
	local v54 = useLocalization({
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		requestIgnoredText = "Feature.AddFriends.Action.RequestIgnored",
		allRequestsIgnoredText = "Feature.Profile.Action.AllRequestsIgnored",
		allRequestsIgnoredBackgroundedText = "Feature.AddFriends.Label.DeclineAllBackgrounded",
		friendAddedText = not FFlagConnectionsToFriendsRename and "Feature.Friends.Action.ConnectionAdded" or "Feature.Friends.Action.FriendAdded",
		requestSentText = not FFlagConnectionsToFriendsRename and "Feature.Friends.Action.ConnectionRequestSent" or "Feature.Friends.Action.FriendRequestSent"
	})
	local v55 = useLocalUserId()
	local v56 = useSelector(getFriendRecommendationsFromState)
	local v57 = useSelector(function(p1) -- line: 102
		-- upvalues: getSessionIdByKey (copy), RECOMMENDATION_SESSION_ID_KEY (copy)
		return getSessionIdByKey(p1)(RECOMMENDATION_SESSION_ID_KEY)
	end)
	local v58 = useSelector(getFriendRequestsFromState)
	local v59 = useSelector(function(p2) -- line: 107
		-- upvalues: AddFriendsSelector (copy)
		return AddFriendsSelector(p2, "Friends.requests.nextPageCursor")
	end)
	local v60 = React.useMemo(function() -- line: 111
		-- upvalues: AnalyticsSetup (copy), v55 (copy), v57 (copy)
		return AnalyticsSetup({
			infoForAllEvents = {
				uid = v55,
				recommendationSessionId = v57
			}
		}).fireAnalyticsEvent
	end, {
		v55,
		v57
	})
	local v61 = React.useCallback(function(p3) -- line: 120
		-- upvalues: v53 (copy), FriendsNetworking (copy)
		return v53(FriendsNetworking.GetFriendRequestsCount.API(p3))
	end, { v53 })
	local v62 = React.useCallback(function(p4) -- line: 124
		-- upvalues: v53 (copy), FriendsNetworking (copy)
		return v53(FriendsNetworking.ClearNewFriendRequests.API({
			currentUserId = p4
		}))
	end, { v53 })
	local v63 = React.useCallback(function(t2: {[any]: any}) -- line: 130
		-- upvalues: Promise (copy), Dash (copy), FFlagAddFriendsSessionId (copy), sessionUtil (copy), v53 (copy), FriendsNetworking (copy), NetworkingGames (copy)
		local function v84(p5) -- line: 132
			local t3 = {}
			local t4 = {}

			for _, v in pairs(p5) do
				table.insert(t3, v.id)

				local sourceUniverseId = v.friendRequest.sourceUniverseId

				if sourceUniverseId ~= nil and sourceUniverseId ~= 0 then
					table.insert(t4, sourceUniverseId)
				end
			end

			return {
				userIds = t3,
				universeIds = t4
			}
		end

		return Promise.new(function(resolve, reject) -- line: 148
			-- upvalues: t2 (ref), Dash (copy), FFlagAddFriendsSessionId (copy), sessionUtil (copy), v53 (copy), FriendsNetworking (copy), v84 (copy), NetworkingGames (copy), Promise (copy)
			t2 = Dash.join(t2 or {}, {
				currentUserId = t2.localUserId,
				sessionId = if not FFlagAddFriendsSessionId then nil else sessionUtil.getSessionId()
			})
			v53(FriendsNetworking.GetFriendRequests.API(t2)):andThen(function(p6) -- line: 154
				-- upvalues: v84 (copy), v53 (copy), FriendsNetworking (copy), NetworkingGames (copy), Promise (copy), resolve (copy), reject (copy)
				local v117 = v84(p6.responseBody.data)
				local t5 = {}

				if next(v117.userIds) ~= nil then
					table.insert(t5, v53(FriendsNetworking.GetFollowingExists.API({
						targetUserIds = v117.userIds
					})))
				end

				if next(v117.universeIds) ~= nil then
					table.insert(t5, v53(NetworkingGames.GetExperiencesDetails.API(v117.universeIds)))
				end

				Promise.all(t5):andThen(function() -- line: 170
					-- upvalues: resolve (copy), p6 (copy)
					resolve(p6)
				end):catch(reject)
			end):catch(reject)
		end)
	end, { v53 })
	local v64 = React.useCallback(function(t6: {[any]: any}) -- line: 179
		-- upvalues: v53 (copy), FriendsNetworking (copy), RecommendationSourceEnum (copy), Dash (copy), ContextualInfoTypes (copy), RoduxFriends (copy), RoduxAnalytics (copy), RECOMMENDATION_SESSION_ID_KEY (copy), Promise (copy), FFlagAddFriendsPYMKPresence (copy), FFlagAddFriendsPresenceStoreMigration (copy), NetworkingPresence (copy), FFlagAddFriendsPYMKPresenceAnalytics (copy), v60 (copy), EventNames (copy)
		return v53(FriendsNetworking.GetFriendRecommendationsFromUserId.API({
			targetUserId = t6.localUserId,
			source = RecommendationSourceEnum.AddFriendsPage
		})):andThen(function(p7) -- line: 184
			-- upvalues: Dash (copy), ContextualInfoTypes (copy), v53 (copy), RoduxFriends (copy), RecommendationSourceEnum (copy), RoduxAnalytics (copy), RECOMMENDATION_SESSION_ID_KEY (copy), Promise (copy)
			local data = p7.responseBody.data
			local v109 = Dash.map(data, function(p8) -- line: 186
				-- upvalues: ContextualInfoTypes (copy)
				if p8.contextType == ContextualInfoTypes.Contacts then
					return p8.contactId
				end

				return p8.id
			end)

			v53(RoduxFriends.Actions.RecommendationSourceCreated({
				source = RecommendationSourceEnum.AddFriendsPage,
				recommendationIds = v109
			}))

			local recommendationRequestId = p7.responseBody.recommendationRequestId

			v53(RoduxAnalytics.Actions.SessionIdUpdated({
				sessionKey = RECOMMENDATION_SESSION_ID_KEY,
				sessionId = recommendationRequestId
			}))

			return Promise.resolve(p7)
		end):andThen(function(p9) -- line: 203
			-- upvalues: FFlagAddFriendsPYMKPresence (copy), FFlagAddFriendsPresenceStoreMigration (copy), Dash (copy), ContextualInfoTypes (copy), v53 (copy), NetworkingPresence (copy), FFlagAddFriendsPYMKPresenceAnalytics (copy), v60 (copy), EventNames (copy), Promise (copy)
			if FFlagAddFriendsPYMKPresence and not FFlagAddFriendsPresenceStoreMigration then
				local data = p9.responseBody.data
				local v113 = Dash.reduce(data, function(p10, p11) -- line: 206
					-- upvalues: ContextualInfoTypes (copy)
					if p11.contextType ~= ContextualInfoTypes.Contacts then
						table.insert(p10, p11.id)
					end

					return p10
				end, {})

				if #v113 > 0 then
					v53(NetworkingPresence.GetPresencesFromUserIds.API(v113))

					if FFlagAddFriendsPYMKPresenceAnalytics then
						v60(EventNames.PYMKUserPresenceLoad)
					end
				end

				return Promise.resolve()
			end
		end)
	end, {
		v53,
		if not FFlagAddFriendsPYMKPresenceAnalytics then nil else v60
	})
	local v65 = useSelector(function(p12) -- line: 226
		return p12.ScreenSize
	end).X >= BreakpointConfig.getMinWidthFor(Responsive.Keys.Medium)
	local v66 = React.useCallback(function() -- line: 232
		-- upvalues: v65 (copy)
		if v65 then
			return 50
		end

		return 25
	end, { v65 })
	local v67 = React.useCallback(function(_, p14, p15) -- line: 236
		-- upvalues: v60 (copy), EventNames (copy)
		v60(EventNames.AddFriendsPageLoadingTime, {
			status = p14.status,
			loadingTime = p15,
			statValue = p15
		})

		local v90 = p14.result[3]
		local v92

		if v90 then
			local v91 = v90.responseBody.data or {}

			v92 = v91 and #v91
		else
			v92 = 0
		end

		v60(EventNames.PageLoad, {
			recommendationCount = v92,
			status = p14.status
		})
	end, { v60 })
	local v68 = React.useCallback(function(p16) -- line: 258
		-- upvalues: v53 (copy), ToastRodux (copy)
		if not p16 then
			return
		end

		v53(ToastRodux.Actions.SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = p16.toastTitle,
			toastIcon = p16.iconImage
		}))
	end, { v52 })
	local v69 = React.useCallback(function(p17, p18) -- line: 271
		-- upvalues: v68 (copy), v54 (copy)
		return function(...) -- line: 272
			-- upvalues: p17 (copy), v68 (copy), p18 (copy), v54 (copy)
			return p17(...):andThen(function() -- line: 274
				-- upvalues: v68 (copy), p18 (copy)
				v68(p18)
			end):catch(function() -- line: 277
				-- upvalues: v68 (copy), v54 (copy)
				v68({
					toastTitle = v54.networkErrorText
				})
			end)
		end
	end, {
		v68,
		v54.networkErrorText
	})
	local v70 = React.useCallback(function() -- line: 283
		-- upvalues: Promise (copy), v61 (copy), v55 (copy), v63 (copy), FFlagAddFriendsUserListEnabled (copy), v66 (copy), v64 (copy)
		return Promise.all({
			v61(v55),
			v63({
				isRefresh = true,
				localUserId = v55,
				limit = if not FFlagAddFriendsUserListEnabled then v66() else 25
			}),
			v64({
				localUserId = v55
			})
		})
	end, {})
	local v71 = React.useCallback(v69(function() -- line: 296
		-- upvalues: FFlagAddFriendsSessionId (copy), sessionUtil (copy), reportPromiseLoadingTimeWrapper (copy), v70 (copy), v67 (copy), Promise (copy)
		if FFlagAddFriendsSessionId then
			sessionUtil.initializeSession()
		end

		return reportPromiseLoadingTimeWrapper(v70, function() -- line: 302
			return {
				fetch = "add_friends_page_load"
			}
		end, {
			fireEvent = v67
		})():andThen(function(p19) -- line: 307
			-- upvalues: Promise (copy)
			return Promise.resolve(p19)
		end):catch(function(_) -- line: 310
		end)
	end), {
		v64,
		v63,
		v61,
		v55
	})
	local v72 = React.useCallback(v69(function(p21) -- line: 316
		-- upvalues: v63 (copy), FFlagAddFriendsUserListEnabled (copy), v66 (copy), v55 (copy)
		return v63({
			limit = if not FFlagAddFriendsUserListEnabled then v66() else 25,
			cursor = p21,
			localUserId = v55
		})
	end), { if not FFlagAddFriendsUserListEnabled then v66 else nil })
	local v73 = React.useCallback(function(p22) -- line: 326
		-- upvalues: v60 (copy), EventNames (copy), Namespaces (copy)
		v60(EventNames.ShowMoreBtnClick, {
			namespace = if p22 ~= Namespaces.FriendRequests then Namespaces.PYMK else Namespaces.FriendRequests
		})
	end, { v60 })
	local v74 = React.useCallback(function(p23) -- line: 332
		-- upvalues: v59 (copy), v72 (copy), v73 (copy), ShowMoreSectionTypeEnum (copy)
		if v59 then
			v72(v59, p23)
		end

		v73(ShowMoreSectionTypeEnum.FriendRequests)
	end, {
		v58,
		v72,
		v59
	})
	local v75 = React.useCallback(function() -- line: 340
		-- upvalues: v60 (copy), EventNames (copy)
		v60(EventNames.UserSearchClick)
	end, { v60 })

	React.useEffect(function() -- line: 344
		-- upvalues: FFlagConnectionsHubLayerExposure (copy), FFlagFixCohubExposureLayer (copy), IXPServiceWrapper (copy), AppUserLayers (copy), IXPService (copy), v71 (copy), v62 (copy), v55 (copy), FFlagAddFriendsSessionId (copy), sessionUtil (copy)
		if FFlagConnectionsHubLayerExposure then
			if FFlagFixCohubExposureLayer then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ConnectionsHubExposureLayer)
			else
				IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.ConnectionsHubExposureLayer)
			end
		end

		v71()
		v62(v55)

		return function() -- line: 356
			-- upvalues: v62 (copy), v55 (copy), FFlagAddFriendsSessionId (copy), sessionUtil (copy)
			v62(v55)

			if FFlagAddFriendsSessionId then
				sessionUtil.destroySession()
			end
		end
	end, {})

	local v76 = v56 and #v56 or 0
	local v77 = if not FFlagAddFriendsUserListEnabled then not (v76 > 0) and 6 or 5 else not (v76 > 0) and 25 or 10

	return React.createElement(AddFriendsPage, {
		initialRequestsRows = v77,
		requestsPageSize = if not FFlagAddFriendsUserListEnabled then v66() else 25,
		navigateToLuaAppPages = t1.navigateToLuaAppPages,
		friendRecommendationsSessionId = v57,
		friendRecommendations = v56,
		friendRequests = v58,
		handleLoadMoreRequests = v74,
		refreshPage = v71,
		fireSearchbarPressedEvent = v75,
		fireOnShowMore = v73
	})
end

return AddFriendsContainer
