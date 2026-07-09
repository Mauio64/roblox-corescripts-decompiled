local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local Roact = dependencies.Roact
local React = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local FocusNavigationEventNameEnum = require(ParentParentParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local HoldDetector = require(ParentParentParent.HoldToPlay).HoldDetector
local useStyle = require(ParentParentParent.UIBlox).Core.Style.useStyle
local RoduxFriends = dependencies.RoduxFriends
local SocialLibraries = dependencies.SocialLibraries
local SocialCommon = require(ParentParentParent.SocialCommon)
local PresenceType = require(ParentParent.installReducer.RoduxPresence).Enums.PresenceType
local getDeepValue = SocialLibraries.Dictionary.getDeepValue
local PYMKCarouselUserContextualInfo = require(script.Parent.PYMKCarouselUserContextualInfo)
local usePYMKCarouselUserButtons = require(script.Parent.usePYMKCarouselUserButtons)
local Analytics = require(ParentParent.Analytics)
local getFriendStatus = require(ParentParent.Analytics.getFriendStatus)
local EventNames = Analytics.EventNames
local Constants = require(ParentParent.Common.Constants)
local RecommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local ImpressionsTagUtility = require(ParentParentParent.Impressions).ImpressionsTagUtility
local getRecommendationContextualInfoType = SocialCommon.Utils.getRecommendationContextualInfoType
local CarouselUserTile = SocialCommon.Components.CarouselUserTile.CarouselUserTile
local FFlagHomepagePYMKPresence = require(ParentParentParent.SharedFlags).FFlagHomepagePYMKPresence
local FFlagHomepagePYMKPresenceAnalytics = require(ParentParentParent.SharedFlags).FFlagHomepagePYMKPresenceAnalytics

return function(t1: {[any]: any}) -- line: 54
	-- upvalues: React (copy), ImpressionsTagUtility (copy), SocialStopwatch (copy), EventNames (copy), useSelector (copy), getDeepValue (copy), RoduxFriends (copy), FFlagHomepagePYMKPresence (copy), usePYMKCarouselUserButtons (copy), RecommendationContextType (copy), FFlagHomepagePYMKPresenceAnalytics (copy), FocusNavigationEventNameEnum (copy), PYMKCarouselUserContextualInfo (copy), Constants (copy), getRecommendationContextualInfoType (copy), getFriendStatus (copy), HttpService (copy), PresenceType (copy), useStyle (copy), Roact (copy), CarouselUserTile (copy), HoldDetector (copy)
	local v30 = React.useRef(nil)

	React.useEffect(function() -- line: 56
		-- upvalues: ImpressionsTagUtility (copy), v30 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v30, t1.impressionsTag, t1.LayoutOrder)

		return function() -- line: 58
			-- upvalues: ImpressionsTagUtility (copy), v30 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v30, t1.impressionsTag, t1.LayoutOrder)
		end
	end, {
		v30,
		t1.impressionsTag,
		t1.LayoutOrder
	})
	React.useEffect(function() -- line: 63
		-- upvalues: SocialStopwatch (copy), t1 (copy), EventNames (copy)
		local v54 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.PYMKCarouselLoaded)

		if v54 then
			t1.fireAnalyticsEvent(EventNames.PYMKCarouselLoadingTime, {
				loadingTime = v54.timeElapsed
			})
		end
	end, {})

	local v31 = useSelector(function(p1) -- line: 72
		return (tostring(p1.LocalUserId))
	end)
	local str = tostring(t1.userId)
	local v33 = useSelector(function(p2) -- line: 78
		-- upvalues: getDeepValue (copy), str (copy)
		return getDeepValue(p2, string.format("PYMKCarousel.Users.byUserId.%s", str))
	end)
	local v34 = useSelector(function(p3) -- line: 82
		-- upvalues: RoduxFriends (copy), str (copy)
		return RoduxFriends.Selectors.selectFriendshipStatusesByUserIds(p3)({ str })[str] or nil
	end)
	local v35 = useSelector(function(p4) -- line: 86
		-- upvalues: getDeepValue (copy), str (copy)
		return getDeepValue(p4, string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", str))
	end)
	local v36 = useSelector(function(p5) -- line: 93
		-- upvalues: RoduxFriends (copy), v31 (copy), str (copy)
		return RoduxFriends.Selectors.selectRecommendationsForUserId(p5)(v31)[str] or {}
	end)
	local u37 = nil

	if FFlagHomepagePYMKPresence then
		local v38 = useSelector(function(p6) -- line: 99
			-- upvalues: getDeepValue (copy), str (copy)
			return getDeepValue(p6, string.format("PYMKCarousel.Presence.byUserId.%s", str)) or {}
		end)

		u37 = v38 and v38.userPresenceType or nil
	end

	local v39 = usePYMKCarouselUserButtons({
		userId = str,
		showToast = t1.showToast,
		fireAnalyticsEvent = t1.fireAnalyticsEvent,
		absolutePosition = t1.absolutePosition,
		contactId = if v36.contextType ~= RecommendationContextType.Contacts then nil else v36.entityId,
		userPresenceType = if not FFlagHomepagePYMKPresenceAnalytics then nil else u37
	})
	local v40 = React.useRef(false)

	React.useEffect(function() -- line: 117
		-- upvalues: v40 (copy)
		v40.current = true

		return function() -- line: 119
			-- upvalues: v40 (copy)
			v40.current = false
		end
	end, {})

	local v41 = React.useRef(false)
	local v42 = React.useCallback(function(b1: boolean) -- line: 125
		-- upvalues: v41 (copy)
		v41.current = b1
	end, {})
	local v43 = React.useRef(nil)
	local v44 = not v34 or v34 == Enum.FriendStatus.NotFriend
	local v45 = if not v35 then if not v44 then nil else FocusNavigationEventNameEnum.HoldToAddFriend else FocusNavigationEventNameEnum.HoldToAcceptFriendRequest
	local v46 = React.useMemo(function() -- line: 136
		-- upvalues: v39 (copy)
		return function() -- line: 137
			-- upvalues: v39 (copy)
			local v63 = v39()

			if #v63 > 0 and v63[1].onActivated then
				v63[1].onActivated()
			end
		end
	end, { v39 })
	local v47 = if not v36.mutualFriendsCount then if not v36.mutualFriendsList then nil else #v36.mutualFriendsList else v36.mutualFriendsCount

	local function v48() -- line: 157
		-- upvalues: t1 (copy), str (copy), Constants (copy), v47 (copy), v36 (copy), getRecommendationContextualInfoType (copy), RecommendationContextType (copy)
		t1.openProfilePeekView(str, {
			isRecommendation = true,
			absolutePosition = t1.absolutePosition,
			source = Constants.HomepagePYMKCarouselSourceName,
			mutualFriendsCount = v47,
			recommendationSessionId = t1.recommendationSessionId,
			recommendationRank = v36.rank,
			recommendationContextType = v36.contextType.rawValue(),
			contextualInfoType = getRecommendationContextualInfoType(v36),
			contactProps = if v36.contextType ~= RecommendationContextType.Contacts or not v36.entityId then nil else {
				contactId = v36.entityId,
				avatarImageUrl = if not v36.thumbnailEntities then nil else v36.thumbnailEntities.avatarImageUrl,
				contactName = v36.entityDisplayName
			},
			profileType = if v36.contextType ~= RecommendationContextType.Contacts then nil else "FromContacts"
		})
	end
	local function v49() -- line: 186
		-- upvalues: v41 (copy), v40 (copy), v48 (copy), t1 (copy), EventNames (copy), str (copy), getFriendStatus (copy), v34 (copy), v35 (copy), v36 (copy), RecommendationContextType (copy), FFlagHomepagePYMKPresenceAnalytics (copy), u37 (ref), HttpService (copy)
		if v41.current or not v40.current then
			return
		end

		v48()
		t1.fireAnalyticsEvent(EventNames.UserPressed, {
			recommendationId = str,
			friendStatus = getFriendStatus(v34, v35),
			recommendationContextType = v36.contextType,
			recommendationRank = v36.rank,
			absolutePosition = t1.absolutePosition,
			positionInRow = t1.absolutePosition,
			contactId = if v36.contextType ~= RecommendationContextType.Contacts then nil else v36.entityId,
			presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else u37,
			interactionUuid = HttpService:GenerateGUID(false)
		})
	end

	local v50 = nil

	if FFlagHomepagePYMKPresence then
		local v51 = React.useMemo(function() -- line: 209
			-- upvalues: v36 (copy), RecommendationContextType (copy), v33 (copy)
			if v36.contextType == RecommendationContextType.Contacts then
				return v36.entityDisplayName or ""
			end

			return (v33 or {}).displayName or ""
		end, {
			v33,
			v36
		})
		local v52 = React.useMemo(function() -- line: 215
			-- upvalues: u37 (ref), PresenceType (copy)
			return u37 == PresenceType.Online or (u37 == PresenceType.InStudio or u37 == PresenceType.InGame)
		end, { u37 })
		local OnlineStatusColor = useStyle().Theme.OnlineStatus.Color

		v50 = React.useMemo(function() -- line: 225
			-- upvalues: OnlineStatusColor (copy), v52 (copy), v51 (copy)
			local v62 = `<font color="rgb({ math.round(OnlineStatusColor.R * 255) },{ math.round(OnlineStatusColor.G * 255) },{ math.round(OnlineStatusColor.B * 255) })">● </font>`

			if v52 then
				return v62 .. v51
			end

			return v51
		end, {
			v51,
			v52,
			OnlineStatusColor
		})
	end

	return Roact.createFragment({
		PYMKCarouselUserTile = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, t1.tileWidth, 0, t1.tileWidth),
			LayoutOrder = t1.LayoutOrder,
			ref = v30
		}, {
			CarouselUserTile = Roact.createElement(CarouselUserTile, {
				headshotImageUrl = if not v36.thumbnailEntities then nil else v36.thumbnailEntities.headshotImageUrl,
				userId = str,
				userName = if not FFlagHomepagePYMKPresence then if v36.contextType ~= RecommendationContextType.Contacts then (v33 or {}).displayName or "" else v36.entityDisplayName or "" else v50,
				tileSize = t1.tileWidth,
				renderContextualInfo = function() -- line: 145
					-- upvalues: PYMKCarouselUserContextualInfo (copy), t1 (copy), v36 (copy)
					return PYMKCarouselUserContextualInfo({
						lineWidth = t1.tileWidth,
						userId = t1.userId,
						contextType = v36.contextType
					})
				end,
				renderButtons = if t1.hideButtons then nil else v39,
				onActivatedTile = v49,
				onActivatedContextual = v49,
				buttonRef = v43
			}),
			HoldDetector = if not v43.current then nil else Roact.createElement(HoldDetector, {
				guiObject = v43.current,
				onHoldDetected = v46,
				onRegularActivated = v49,
				setDisabledForHold = v42,
				keyCode = Enum.KeyCode.ButtonA,
				focusNavigationEventName = v45
			})
		})
	})
end
