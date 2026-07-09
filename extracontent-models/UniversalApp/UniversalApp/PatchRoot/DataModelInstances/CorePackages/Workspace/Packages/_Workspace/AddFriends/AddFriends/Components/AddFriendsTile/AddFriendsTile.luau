local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local CentralOverlay = require(AddFriendsParent.CentralOverlay)
local CentralOverlayType = require(AddFriendsParent.RobloxAppEnums).CentralOverlayType
local FocusNavigationUtils = require(AddFriendsParent.FocusNavigationUtils)
local Enums = require(AddFriendsParent.FriendsNetworking).Enums

require(AddFriendsParent.PlayerContextualMenu)

local ToastRodux = require(AddFriendsParent.ToastRodux)
local React = require(AddFriendsParent.React)
local ReactFocusNavigation = require(AddFriendsParent.ReactFocusNavigation)
local Responsive = require(AddFriendsParent.Responsive)
local RoactUtils = require(AddFriendsParent.RoactUtils)
local SocialCommon = require(AddFriendsParent.SocialCommon)
local SocialLuaAnalytics = require(AddFriendsParent.SocialLuaAnalytics)
local SocialStopwatch = require(AddFriendsParent.SocialStopwatch)
local UIBlox = require(AddFriendsParent.UIBlox)
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local UserProfiles = require(AddFriendsParent.UserProfiles)
local useImpressionsTagger = require(AddFriendsParent.Impressions).useImpressionsTagger
local useLocalUserId = require(AddFriendsParent.RobloxAppHooks).useLocalUserId
local useNavigation = require(AddFriendsParent.Navigation).useNavigation
local RobloxAppEnums = require(AddFriendsParent.RobloxAppEnums)
local View = require(AddFriendsParent.Foundation).View
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local FriendshipOriginSourceType = Enums.FriendshipOriginSourceType
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local PlayerTile = UIBlox.App.Tile.PlayerTile
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local usePreferredInput = Responsive.usePreferredInput
local convertUserPresenceTypeToString = SocialCommon.Utils.convertUserPresenceTypeToString
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local AppPage = RobloxAppEnums.AppPage
local AddFriendsState = require(AddFriendsParent.AddFriendsState)
local AddFriendsSelector = AddFriendsState.AddFriendsSelector
local RecommendationContextType = AddFriendsState.RoduxFriends.Enums.RecommendationContextType
local Constants = require(AddFriends.Common.Constants)
local PresenceType = AddFriendsState.RoduxPresence.Enums.PresenceType
local FriendsNetworking = AddFriendsState.Networking.FriendsNetworking
local useFireAnalyticsEvent = require(AddFriends.Analytics.useFireAnalyticsEvent)
local Analytics = require(AddFriends.Analytics)
local EventNames = Analytics.EventNames
local Namespaces = Analytics.Namespaces
local EntityTypes = SocialLuaAnalytics.Analytics.Enums.EntityTypes
local getSessionIdByKey = AddFriendsState.RoduxAnalytics.Selectors.getSessionIdByKey
local getFooterRelevanceInfo = require(script.Parent.getFooterRelevanceInfo)
local getOverlayButtons = require(script.Parent.getOverlayButtons)

require(script.Parent.getFriendRequestHandlersExtraProps)

local UserTileEventHandlers = require(AddFriendsParent.UserTile).UserTileEventHandlers
local GetFFlagLuaAppEnableOpenTypeSupport = require(AddFriendsParent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local UserList = require(AddFriendsParent.UserList)
local useGetPresenceByUserId = require(AddFriendsParent.FriendsCommon).Hooks.useGetPresenceByUserId
local PresenceType2 = require(AddFriendsParent.DataHydration).Presence.PresenceEnums.PresenceType
local FFlagPPVEnabledOnConsole = require(AddFriendsParent.SharedFlags).FFlagPPVEnabledOnConsole
local FFlagAddFriendsPYMKPresence = require(AddFriendsParent.SharedFlags).FFlagAddFriendsPYMKPresence
local FFlagAddFriendsPYMKPresenceAnalytics = require(AddFriendsParent.SharedFlags).FFlagAddFriendsPYMKPresenceAnalytics
local FFlagAddFriendsRenderTileRefactor = require(AddFriendsParent.SharedFlags).FFlagAddFriendsRenderTileRefactor
local FFlagAddFriendsTileLoadFromHomeCarouselAnalytics = require(AddFriendsParent.SharedFlags).FFlagAddFriendsTileLoadFromHomeCarouselAnalytics
local FFlagAddFriendsUserListEnabled = require(AddFriendsParent.SharedFlags).FFlagAddFriendsUserListEnabled
local FFlagConnectionsToFriendsRename = require(AddFriendsParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagFriendsPageViewBtnWidth = require(AddFriendsParent.SharedFlags).FFlagFriendsPageViewBtnWidth
local FFlagAddFriendsPresenceStoreMigration = require(AddFriends.Flags.FFlagAddFriendsPresenceStoreMigration)

local function AddFriendsTile(t1: {[any]: any}) -- line: 125
	-- upvalues: useDispatch (copy), useFocusGuiObject (copy), useLastInputMode (copy), useStyle (copy), FFlagPPVEnabledOnConsole (copy), usePreferredInput (copy), React (copy), Responsive (copy), useImpressionsTagger (copy), FFlagAddFriendsRenderTileRefactor (copy), UserList (copy), RecommendationContextType (copy), useLocalUserId (copy), useSelector (copy), AddFriendsSelector (copy), FFlagAddFriendsPresenceStoreMigration (copy), useGetPresenceByUserId (copy), FFlagAddFriendsPYMKPresence (copy), getSessionIdByKey (copy), Constants (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), getFooterRelevanceInfo (copy), useFireAnalyticsEvent (copy), EntityTypes (copy), Namespaces (copy), FFlagAddFriendsPYMKPresenceAnalytics (copy), FFlagAddFriendsTileLoadFromHomeCarouselAnalytics (copy), SocialStopwatch (copy), EventNames (copy), ToastRodux (copy), FriendsNetworking (copy), Images (copy), FriendshipOriginSourceType (copy), useNavigation (copy), AppPage (copy), Contexts (copy), SetCentralOverlay (copy), CentralOverlayType (copy), convertUserPresenceTypeToString (copy), FFlagAddFriendsUserListEnabled (copy), UserProfiles (copy), PresenceType2 (copy), SocialCommon (copy), PresenceType (copy), getOverlayButtons (copy), View (copy), FFlagFriendsPageViewBtnWidth (copy), UserTileEventHandlers (copy), PlayerTile (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy)
	local v67 = useDispatch()
	local v68 = useFocusGuiObject()
	local v69 = useLastInputMode()
	local v70 = useStyle()
	local u71 = nil

	if not FFlagPPVEnabledOnConsole then
		u71 = usePreferredInput()
	end

	local v72 = React.useRef(nil)
	local v73 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v74 = React.useCallback(function() -- line: 139
		-- upvalues: t1 (copy), v69 (copy), v72 (copy), v68 (copy)
		if t1.selected and v69 == "Focus" then
			local current = v72.current

			if current then
				v68(current)
			end
		end
	end, {
		t1.selected,
		v69,
		v72,
		v68
	})

	React.useEffect(function() -- line: 148
		-- upvalues: v74 (copy)
		v74()
	end, {})
	useImpressionsTagger(v72, t1.impressionsTag, t1.position)

	local v75 = if not FFlagAddFriendsRenderTileRefactor then t1.user.contextType and t1.user.contextType == RecommendationContextType.Contacts else t1.user.type == UserList.Enums.EntityType.Contact
	local v76 = useLocalUserId()
	local v77 = useSelector(function(p1) -- line: 160
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		return AddFriendsSelector(p1, "Friends.friendshipStatus.%s", t1.user.id) or nil
	end)
	local v78 = useSelector(function(p2) -- line: 166
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		return (AddFriendsSelector(p2, "RequestsFromOriginSourceType") or {})[t1.user.id]
	end)
	local v79 = useSelector(function(p3) -- line: 171
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		local v121 = (AddFriendsSelector(p3, "Friends.requests.sourceUniverseIds") or {})[t1.user.id]

		if v121 ~= nil and v121 ~= 0 then
			return (AddFriendsSelector(p3, "Games.byGameId.%s", (tostring(v121))) or {}).name
		end

		return nil
	end)
	local v80 = if not FFlagAddFriendsRenderTileRefactor then nil else useSelector(function(p4) -- line: 183
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		return AddFriendsSelector(p4, "Friends.requests.mutualFriends.%s", t1.user.id) or {}
	end)
	local v81 = if not FFlagAddFriendsRenderTileRefactor then nil else useSelector(function(p5) -- line: 189
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		return AddFriendsSelector(p5, "Friends.contactNamesByUserId.%s", t1.user.id)
	end)
	local v82 = useSelector(function(p6) -- line: 194
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		local v125 = AddFriendsSelector(p6, "IsUserFollowing") or {}

		return not not v125[t1.user.id] and (v125[t1.user.id].isFollowing or false)
	end)
	local v83 = useSelector(function(p7) -- line: 199
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		local v127 = AddFriendsSelector(p7, "IsUserFollowing") or {}

		return not not v127[t1.user.id] and (v127[t1.user.id].isFollowed or false)
	end)
	local v84 = useSelector(function(p8) -- line: 205
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		return AddFriendsSelector(p8, "Friends.recommendations.hasIncomingFriendRequest.%s", t1.user.id) or false
	end)
	local v85 = if not FFlagAddFriendsRenderTileRefactor then nil else useSelector(function(p9) -- line: 210
		-- upvalues: AddFriendsSelector (copy), v76 (copy), t1 (copy)
		return AddFriendsSelector(p9, "Friends.recommendations.byUserId.%s.%s", v76, t1.user.id) or {}
	end)
	local v86 = if not FFlagAddFriendsRenderTileRefactor then nil else v85.contextType
	local v87 = if not FFlagAddFriendsRenderTileRefactor then nil else v85.mutualFriendsCount
	local v88 = if not FFlagAddFriendsRenderTileRefactor then nil else v85.rank
	local v89 = if not FFlagAddFriendsPresenceStoreMigration then if not FFlagAddFriendsPYMKPresence then nil else useSelector(function(p10) -- line: 221
		-- upvalues: AddFriendsSelector (copy), t1 (copy)
		return AddFriendsSelector(p10, "Presence.byUserId.%s", t1.user.id) or nil
	end) else useGetPresenceByUserId(if not v75 then t1.user.id else nil)
	local v90 = useSelector(function(p11) -- line: 226
		-- upvalues: getSessionIdByKey (copy), Constants (copy)
		return getSessionIdByKey(p11)(Constants.RECOMMENDATION_SESSION_ID_KEY)
	end)
	local v91 = useLocalization({
		youAreFollowingText = "Feature.Friends.Label.YouAreFollowing",
		followsYouText = "Feature.Friends.Label.FollowsYou",
		fromContactsText = "Feature.Friends.Description.FoundFromContactImporter",
		foundThroughQRCode = "Feature.Profile.Label.QRCodeFriendRequest",
		connectionRequests = "Feature.Friends.Label.ConnectionRequest",
		frequents = "Feature.Friends.Label.Frequent",
		fromContacts = "Feature.Friends.Description.FromContacts",
		mutualFriendsText = if not FFlagAddFriendsRenderTileRefactor then (not t1.user.mutualFriends or #t1.user.mutualFriends ~= 1) and "Feature.Friends.Label.MutualFriends" or "Feature.Friends.Label.SingularMutualFriend" else nil,
		sentFromWithContextText = {
			"Feature.Friends.Label.SentFromWithContext",
			gameName = v79 or ""
		},
		contactNameText = if not if not FFlagAddFriendsRenderTileRefactor then t1.user.contactName else v81 then nil else {
			"Feature.Friends.Description.FromContactsV2",
			contactName = if not FFlagAddFriendsRenderTileRefactor then t1.user.contactName else v81
		},
		singularMutualConnection = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.MutualConnection" or "Feature.Friends.Label.MutualFriendTitle",
		mutualConnections = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.MutualConnections" or "Feature.Friends.Label.MutualFriendsTitle",
			numConnections = if not FFlagAddFriendsRenderTileRefactor then t1.user.mutualFriendsCount or t1.user.mutualFriends and #t1.user.mutualFriends else v87 or v80 and #v80
		}
	})
	local v92, v93 = React.useMemo(function() -- line: 272
		-- upvalues: getFooterRelevanceInfo (copy), FFlagAddFriendsRenderTileRefactor (copy), v80 (copy), t1 (copy), v83 (copy), v82 (copy), v79 (copy), v78 (copy), v86 (copy), v87 (copy), v84 (copy), v70 (copy), v91 (copy)
		return getFooterRelevanceInfo({
			mutualFriends = if not FFlagAddFriendsRenderTileRefactor then t1.user.mutualFriends else v80,
			isUserFollowingMe = v83,
			amIFollowingUser = v82,
			sentFromExperienceName = v79,
			isFriendRequest = t1.isFriendRequest or false,
			isRecommendation = t1.isRecommendation,
			userPresenceType = if not FFlagAddFriendsRenderTileRefactor then t1.user.userPresenceType else nil,
			lastLocation = if not FFlagAddFriendsRenderTileRefactor then t1.user.lastLocation else nil,
			originSourceType = v78,
			contextType = if not FFlagAddFriendsRenderTileRefactor then t1.user.contextType else v86,
			mutualFriendsCount = if not FFlagAddFriendsRenderTileRefactor then t1.user.mutualFriendsCount else v87,
			hasIncomingFriendRequest = v84
		}, v70, v91)
	end, {
		t1.user,
		v83,
		v82,
		v79,
		t1.isFriendRequest,
		t1.isRecommendation,
		v78,
		v84,
		if not FFlagAddFriendsRenderTileRefactor then nil else v87,
		if not FFlagAddFriendsRenderTileRefactor then nil else v80,
		if not FFlagAddFriendsRenderTileRefactor then nil else v86,
		v70,
		v91
	})
	local v94 = useFireAnalyticsEvent({
		targetUserId = t1.user.id,
		absolutePosition = t1.position,
		rank = if not FFlagAddFriendsRenderTileRefactor then t1.user.rank else v88,
		contextType = v93,
		entityType = if not v75 then nil else EntityTypes.Contact,
		namespace = if not t1.isFriendRequest then Namespaces.PYMK else Namespaces.FriendRequests,
		friendStatus = v77,
		presence = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else (v89 or {}).userPresenceType
	})

	if FFlagAddFriendsTileLoadFromHomeCarouselAnalytics then
		React.useEffect(function() -- line: 319
			-- upvalues: SocialStopwatch (copy), v94 (copy), EventNames (copy)
			local v132 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.AFPUserTileLoadFromHomeCarousel)

			if v132 then
				v94(EventNames.AFPUserTileLoadFromHomeCarousel, {
					loadingTime = v132.timeElapsed,
					statValue = v132.timeElapsed
				})
			end
		end, {})
	end

	local v95 = React.useCallback(function(p12) -- line: 331
		-- upvalues: v67 (copy), ToastRodux (copy)
		if not p12 then
			return
		end

		v67(ToastRodux.Actions.SetCurrentToastMessage({
			toastMessage = p12.toastTitle,
			toastIcon = p12.iconImage
		}))
	end, { v67 })
	local v96 = React.useCallback(function(p13, p14) -- line: 342
		-- upvalues: v95 (copy)
		return p13:andThen(function() -- line: 344
			-- upvalues: v95 (copy), p14 (copy)
			v95(p14)
		end):catch(function() -- line: 347
			-- upvalues: v95 (copy)
			v95({
				toastTitle = "Feature.Toast.NetworkingError.SomethingIsWrong"
			})
		end)
	end, { v95 })
	local v97 = React.useCallback(function() -- line: 352
		-- upvalues: v94 (copy), EventNames (copy), v96 (copy), v67 (copy), FriendsNetworking (copy), v76 (copy), t1 (copy), FFlagConnectionsToFriendsRename (copy), Images (copy)
		v94(EventNames.AcceptFriendshipBtnClick)

		return v96(v67(FriendsNetworking.AcceptFriendRequestFromUserId.API({
			currentUserId = v76,
			targetUserId = t1.user.id
		})), {
			toastTitle = not FFlagConnectionsToFriendsRename and "Feature.Friends.Action.ConnectionAdded" or "Feature.Friends.Action.FriendAdded",
			iconImage = Images["icons/actions/friends/friendAdd"]
		})
	end, {
		t1.user.id,
		v76,
		v67,
		v96,
		v94
	})
	local v98 = React.useCallback(function() -- line: 369
		-- upvalues: v94 (copy), EventNames (copy), v96 (copy), v67 (copy), FriendsNetworking (copy), v76 (copy), t1 (copy), Images (copy)
		v94(EventNames.DeclineFriendshipBtnClick)

		return v96(v67(FriendsNetworking.DeclineFriendRequestFromUserId.API({
			currentUserId = v76,
			targetUserId = t1.user.id
		})), {
			toastTitle = "Feature.AddFriends.Action.RequestIgnored",
			iconImage = Images["icons/actions/reject"]
		})
	end, {
		t1.user.id,
		v76,
		v67,
		v96,
		v94
	})
	local v99 = React.useCallback(function() -- line: 385
		-- upvalues: v94 (copy), EventNames (copy), v75 (copy), FriendsNetworking (copy), v76 (copy), t1 (copy), FriendshipOriginSourceType (copy), v96 (copy), v67 (copy), FFlagConnectionsToFriendsRename (copy), Images (copy)
		v94(EventNames.RequestFriendshipBtnClick)

		local v136 = if not v75 then FriendsNetworking.RequestFriendshipFromUserId.API({
			currentUserId = v76,
			targetUserId = t1.user.id,
			friendshipOriginSourceType = if not t1.isRecommendation then nil else FriendshipOriginSourceType.FriendRecommendations.rawValue()
		}) else FriendsNetworking.RequestFriendshipFromContactId.API({
			currentUserId = v76,
			contactId = t1.user.id
		})

		return v96(v67(v136), {
			toastTitle = not FFlagConnectionsToFriendsRename and "Feature.Friends.Action.ConnectionRequestSent" or "Feature.Friends.Action.FriendRequestSent",
			iconImage = Images["icons/actions/friends/friendAdd"]
		})
	end, {
		v75,
		t1.isRecommendation,
		t1.user.id,
		v76,
		v67,
		v96,
		v94
	})
	local v100 = useNavigation()
	local v101 = React.useCallback(function() -- line: 414
		-- upvalues: v94 (copy), EventNames (copy), v100 (copy), AppPage (copy), t1 (copy), v75 (copy), v90 (copy), FFlagAddFriendsRenderTileRefactor (copy), v88 (copy), v77 (copy), Constants (copy), Contexts (copy), v93 (copy), v92 (copy)
		v94(EventNames.PlayerTileClick)
		v100.navigate(AppPage.ProfilePlatform, {
			detail = t1.user.id,
			extraProps = {
				profileType = if not v75 then nil else "Contact",
				recommendationSessionId = v90,
				absolutePosition = t1.position,
				rank = if not FFlagAddFriendsRenderTileRefactor then t1.user.rank else v88,
				isRecommendation = t1.isRecommendation,
				isContact = v75,
				contactProps = if not v75 then nil else {
					contactId = t1.user.entityId,
					contactname = t1.user.entityDisplayName,
					avatarImageUrl = if not FFlagAddFriendsRenderTileRefactor then t1.user.thumbnailEntities.avatarImageUrl else t1.user.thumbnailEntities and t1.user.thumbnailEntities.avatarImageUrl
				},
				friendStatus = v77,
				source = if not t1.isRecommendation then Contexts.AddFriends else Constants.AddFriendsPYMKSourceName,
				contextualInfoType = v93,
				contextualInfoDisplay = if not t1.isRecommendation then nil else v92
			}
		})
	end, {
		t1.user,
		t1.position,
		t1.isRecommendation,
		v77,
		v90,
		v75,
		v100,
		v93,
		v92,
		if not FFlagAddFriendsRenderTileRefactor then nil else v88
	})
	local v102 = React.useCallback(function() -- line: 456
		-- upvalues: t1 (copy), v77 (copy), v67 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), convertUserPresenceTypeToString (copy), FriendshipOriginSourceType (copy)
		local v137 = if not t1.isRecommendation then Enum.FriendStatus.FriendRequestReceived else v77 or Enum.FriendStatus.NotFriend

		v67(SetCentralOverlay(CentralOverlayType.PlayerContextualMenu, {
			subjectUserId = t1.user.id,
			contactId = t1.user.entityId,
			contactName = t1.user.entityDisplayName,
			recommendationContext = t1.user.contextType,
			mutualFriendsCount = t1.user.mutualFriendsCount,
			robloxFriendshipStatus = v137,
			subjectPresence = {
				locationString = t1.user.lastLocation,
				locationPlaceId = t1.user.placeId,
				locationRootPlaceId = t1.user.rootPlaceId,
				locationUniverseId = t1.user.universeId,
				status = convertUserPresenceTypeToString(t1.user.userPresenceType)
			},
			friendshipOriginSourceType = if not t1.isRecommendation then nil else FriendshipOriginSourceType.FriendRecommendations.rawValue()
		}))
	end, {
		t1.isRecommendation,
		v77,
		t1.user,
		v67
	})
	local v103 = React.useCallback(function() -- line: 484
		-- upvalues: FFlagPPVEnabledOnConsole (copy), u71 (ref), Responsive (copy), v102 (copy), v101 (copy)
		if not FFlagPPVEnabledOnConsole and u71 == Responsive.Input.Directional then
			return v102()
		end

		v101()
	end, {
		if not FFlagPPVEnabledOnConsole then u71 else nil,
		if not FFlagPPVEnabledOnConsole then v102 else nil,
		v101
	})
	local entityDisplayName = nil
	local v105 = nil
	local v106 = nil

	if not FFlagAddFriendsUserListEnabled then
		local v107 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { t1.user.id },
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds,
			skip = v75
		})

		if v75 then
			entityDisplayName = t1.user.entityDisplayName
			v105 = nil
			v106 = if not FFlagAddFriendsRenderTileRefactor then t1.user.thumbnailEntities.avatarImageUrl else t1.user.thumbnailEntities and t1.user.thumbnailEntities.avatarImageUrl
		else
			local s1 = ""
			local s2 = ""

			if v107 and v107.data then
				s1 = UserProfiles.Selectors.getCombinedNameFromId(v107.data, t1.user.id) or ""
				s2 = UserProfiles.Selectors.getUsernameFromId(v107.data, t1.user.id) or ""
			end

			entityDisplayName = s1
			v105 = if not FFlagAddFriendsRenderTileRefactor then "@" .. (t1.user.externalAppDisplayName or s2) else "@" .. s2
			v106 = string.format("rbxthumb://type=Avatar&id=%s&w=720&h=720", (tostring(t1.user.id)))
		end
	end

	local v110 = nil
	local v111 = nil

	if FFlagAddFriendsPYMKPresence then
		if FFlagAddFriendsUserListEnabled then
			v111 = React.useMemo(function() -- line: 534
				-- upvalues: FFlagAddFriendsPresenceStoreMigration (copy), v89 (copy), PresenceType2 (copy), SocialCommon (copy)
				if FFlagAddFriendsPresenceStoreMigration then
					return v89 and v89.userPresenceType or PresenceType2.Offline
				end

				if v89 and v89.userPresenceType then
					local str = tostring(v89.userPresenceType)

					return (string.gsub(str, "PresenceType%.", ""))
				end

				return SocialCommon.Enums.PresenceTypes.Offline
			end, { v89 })
		else
			local v112 = React.useMemo(function() -- line: 546
				-- upvalues: v89 (copy), FFlagAddFriendsPresenceStoreMigration (copy), PresenceType2 (copy), PresenceType (copy)
				local v139 = v89 and v89.userPresenceType or nil

				if FFlagAddFriendsPresenceStoreMigration then
					return v139 == PresenceType2.Online or (v139 == PresenceType2.InStudio or v139 == PresenceType2.InGame)
				end

				return v139 == PresenceType.Online or (v139 == PresenceType.InStudio or v139 == PresenceType.InGame)
			end, { v89 })
			local OnlineStatusColor = v70.Theme.OnlineStatus.Color

			v110 = React.useMemo(function() -- line: 563
				-- upvalues: OnlineStatusColor (copy), v112 (copy), entityDisplayName (ref)
				local v140 = `<font color="rgb({ math.round(OnlineStatusColor.R * 255) },{ math.round(OnlineStatusColor.G * 255) },{ math.round(OnlineStatusColor.B * 255) })">● </font>`

				if v112 then
					return v140 .. entityDisplayName
				end

				return entityDisplayName
			end, {
				entityDisplayName,
				v112,
				OnlineStatusColor
			})
		end
	end

	local v114 = React.useMemo(function() -- line: 575
		-- upvalues: getOverlayButtons (copy), t1 (copy), v84 (copy), v77 (copy), v99 (copy), v97 (copy), v98 (copy), v73 (copy)
		return getOverlayButtons({
			isFriendRequest = t1.isFriendRequest or false,
			hasIncomingFriendRequest = v84,
			friendStatus = v77,
			handleRequestFriendship = v99,
			handleAcceptFriendRequest = v97,
			handleDeclineFriendRequest = v98,
			shouldAddFocusEventName = v73
		})
	end, {
		t1.isFriendRequest,
		v77,
		v99,
		v97,
		v98,
		v84,
		v73
	})

	if FFlagAddFriendsUserListEnabled then
		local v115 = v114 and v114[#v114] or nil
		local v116 = v114 and v114[#v114 - 1] or nil

		return React.createElement(View, {
			tag = "size-full-0 auto-y",
			ref = v72
		}, {
			UserRow = t1.createRow({
				onRowActivated = v101,
				primaryCta = v115 and {
					type = v115.type,
					icon = v115.icon,
					isDisabled = v115.isDisabled,
					onActivated = v115.onActivated,
					minWidth = if not FFlagFriendsPageViewBtnWidth then nil else Constants.PRIMARY_CTA_BUTTON_MIN_WIDTH,
					maxWidth = if not FFlagFriendsPageViewBtnWidth then nil else Constants.PRIMARY_CTA_BUTTON_MAX_WIDTH
				},
				secondaryCta = v116 and {
					type = v116.type,
					icon = v116.icon,
					isDisabled = v116.isDisabled,
					onActivated = v116.onActivated
				},
				contextualInfo = v92 and {
					text = v92.text,
					icon = v92.icon
				},
				presence = v111
			}),
			UserTileEventHandlers = if not v73 then nil else React.createElement(UserTileEventHandlers, {
				buttons = v114,
				onTileActivated = v103,
				tileRef = v72
			})
		})
	end

	return (React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.new(0, t1.size.X, 0, t1.size.Y),
		LayoutOrder = t1.layoutOrder
	}, {
		PlayerTile = React.createElement(PlayerTile, {
			Selectable = true,
			buttonRef = v72,
			thumbnail = v106,
			title = if not FFlagAddFriendsPYMKPresence then entityDisplayName else v110,
			tileSize = UDim2.new(0, t1.size.X, 0, t1.size.Y),
			subtitle = v105,
			buttons = if not v73 then v114 else nil,
			relevancyInfo = v92,
			onActivated = v103,
			openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
		}),
		UserTileEventHandlers = if not v73 then nil else React.createElement(UserTileEventHandlers, {
			buttons = v114,
			onTileActivated = v103,
			tileRef = v72
		})
	}))
end

return AddFriendsTile
