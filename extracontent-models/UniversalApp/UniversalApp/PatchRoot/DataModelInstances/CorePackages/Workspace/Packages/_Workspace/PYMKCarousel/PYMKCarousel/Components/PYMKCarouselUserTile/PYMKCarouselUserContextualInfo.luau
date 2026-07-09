local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local SocialCommon = require(ParentParentParent.SocialCommon)
local Roact = dependencies.Roact
local React = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local useLocalization = dependencies.Hooks.useLocalization
local RoduxFriends = dependencies.RoduxFriends
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local TextKeys = require(ParentParent.Common.TextKeys)
local CarouselUserContextualInfo = SocialCommon.Components.CarouselUserTile.CarouselUserContextualInfo
local useRecommendationContextualInfoDisplay = SocialCommon.Hooks.useRecommendationContextualInfoDisplay
local RecommendationContextType = RoduxFriends.Enums.RecommendationContextType
local FFlagConnectionsToFriendsRename = require(ParentParentParent.SharedFlags).FFlagConnectionsToFriendsRename

local function v16(t1: {[any]: any}) -- line: 34
	-- upvalues: useLocalization (copy)
	local v18 = useLocalization({
		contextualText = t1.textKey
	})
	local v19 = if not t1.textKey then t1.text else v18.contextualText

	if t1.formatter then
		return (t1.formatter(v19))
	end

	return v19
end

return function(p1) -- line: 43
	-- upvalues: useSelector (copy), RoduxFriends (copy), getDeepValue (copy), useRecommendationContextualInfoDisplay (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), RecommendationContextType (copy), React (copy), v16 (copy), Roact (copy), CarouselUserContextualInfo (copy)
	local str = tostring(p1.userId)
	local v22 = useSelector(function(p2) -- line: 45
		return (tostring(p2.LocalUserId))
	end)
	local v23 = useSelector(function(p3) -- line: 49
		-- upvalues: RoduxFriends (copy), v22 (copy), str (copy)
		return RoduxFriends.Selectors.selectRecommendationsForUserId(p3)(v22)[str] or {}
	end)
	local v24 = useSelector(function(p4) -- line: 53
		-- upvalues: getDeepValue (copy), str (copy)
		return getDeepValue(p4, string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", str)) or false
	end)
	local t2 = {
		text = useRecommendationContextualInfoDisplay(v23).text
	}

	if v24 then
		t2 = {
			textKey = if not FFlagConnectionsToFriendsRename then TextKeys.ConnectionRequestContext else TextKeys.FriendRequestContext
		}
	end

	if p1.contextType == RecommendationContextType.Contacts then
		t2 = {
			textKey = TextKeys.FromContacts
		}
	end

	local v26 = React.useCallback(v16(t2), { t2 })

	return Roact.createElement(CarouselUserContextualInfo, {
		label = {
			text = v26,
			font = t2.font,
			colorStyle = t2.colorStyle
		},
		lineWidth = p1.lineWidth
	})
end
