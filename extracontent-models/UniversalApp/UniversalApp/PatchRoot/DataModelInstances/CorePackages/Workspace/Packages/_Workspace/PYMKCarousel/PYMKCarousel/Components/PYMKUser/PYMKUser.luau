local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local ImpressionsTagUtility = require(ParentParentParent.Impressions).ImpressionsTagUtility
local RoduxFriends = dependencies.RoduxFriends
local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local usePrimaryCta = require(ParentParent.Components.PYMKUser.usePrimaryCta)
local useContextualInfo = require(ParentParent.Components.PYMKUser.useContextualInfo)
local useUserPresence = require(ParentParent.Components.PYMKUser.useUserPresence)
local useOnActivatedTile = require(ParentParent.Components.PYMKUser.useOnActivatedTile)

require(ParentParentParent.UserList)

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: React (copy), ImpressionsTagUtility (copy), useSelector (copy), getDeepValue (copy), RoduxFriends (copy), usePrimaryCta (copy), useContextualInfo (copy), useUserPresence (copy), useOnActivatedTile (copy)
	local str = tostring(t1.entity.id)
	local v15 = React.useRef(nil)

	React.useEffect(function() -- line: 38
		-- upvalues: ImpressionsTagUtility (copy), v15 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v15, t1.impressionsTag, t1.absolutePosition)

		return function() -- line: 40
			-- upvalues: ImpressionsTagUtility (copy), v15 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v15, t1.impressionsTag, t1.absolutePosition)
		end
	end, {
		t1.impressionsTag,
		t1.absolutePosition
	})

	local v16 = useSelector(function(p1) -- line: 45
		return (tostring(p1.LocalUserId))
	end)
	local v17 = useSelector(function(p2) -- line: 48
		-- upvalues: getDeepValue (copy), str (copy)
		return getDeepValue(p2, string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", str))
	end)
	local v18 = useSelector(function(p3) -- line: 54
		-- upvalues: RoduxFriends (copy), v16 (copy), str (copy)
		return RoduxFriends.Selectors.selectRecommendationsForUserId(p3)(v16)[str] or {}
	end)
	local v19 = useSelector(function(p4) -- line: 57
		-- upvalues: RoduxFriends (copy), str (copy)
		return RoduxFriends.Selectors.selectFriendshipStatusesByUserIds(p4)({
			userId = str
		})[str] or nil
	end)
	local v20 = usePrimaryCta({
		entityId = str,
		showToast = t1.showToast,
		fireAnalyticsEvent = t1.fireAnalyticsEvent,
		absolutePosition = t1.absolutePosition,
		entityType = t1.entity.type
	})
	local v21 = useContextualInfo({
		recommendation = v18,
		hasIncomingFriendRequest = v17
	})
	local t2 = {
		subtitle = false,
		contextualInfo = v18.contextType == nil
	}
	local v23 = useUserPresence({
		userId = str
	})
	local v24 = useOnActivatedTile({
		userId = str,
		openProfilePeekView = t1.openProfilePeekView,
		absolutePosition = t1.absolutePosition,
		recommendation = v18,
		recommendationSessionId = t1.recommendationSessionId,
		fireAnalyticsEvent = t1.fireAnalyticsEvent,
		friendshipStatus = v19,
		userPresenceType = v23
	})
	local v25 = t1.createRow({
		secondaryCta = nil,
		trailingContent = nil,
		primaryCta = v20,
		contextualInfo = v21,
		loadingState = t2,
		presence = v23,
		onRowActivated = v24
	})

	if v25 then
		return React.cloneElement(v25, {
			ref = v15
		})
	end

	return nil
end
