local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Common.Constants)
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local llama = dependencies.llama
local React = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local EventNames = require(script.Parent.EventNames)
local getFriendStatus = require(script.Parent.getFriendStatus)
local RecommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry
local FFlagHomepagePYMKPresenceAnalytics = require(ParentParentParent.SharedFlags).FFlagHomepagePYMKPresenceAnalytics

return function(p1: ((...any) -> ...any)) -- line: 17
	-- upvalues: React (copy), useSelector (copy), getDeepValue (copy), Constants (copy), FFlagHomepagePYMKPresenceAnalytics (copy), getFFlagPYMKAddFriendsEntry (copy), EventNames (copy), RecommendationContextType (copy), getFriendStatus (copy), llama (copy)
	local v15 = React.useRef({})
	local v16 = useSelector(function(p2) -- line: 19
		-- upvalues: getDeepValue (copy), Constants (copy)
		return getDeepValue(p2, string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY)) or {}
	end)
	local v17 = useSelector(function(p3) -- line: 22
		-- upvalues: getDeepValue (copy), Constants (copy)
		return getDeepValue(p3, string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY))
	end) or {}
	local v18 = if not FFlagHomepagePYMKPresenceAnalytics then nil else useSelector(function(p4) -- line: 30
		-- upvalues: getDeepValue (copy)
		return getDeepValue(p4, "PYMKCarousel.Presence.byUserId") or {}
	end)

	return React.useMemo(function() -- line: 35
		-- upvalues: v15 (copy), getFFlagPYMKAddFriendsEntry (copy), p1 (copy), EventNames (copy), RecommendationContextType (copy), getFriendStatus (copy), v16 (copy), v17 (copy), FFlagHomepagePYMKPresenceAnalytics (copy), v18 (copy), llama (copy)
		return {{
			viewabilityConfig = {
				itemVisiblePercentThreshold = 50,
				waitForInteraction = false
			},
			onViewableItemsChanged = function(p5) -- line: 42
				-- upvalues: v15 (copy), getFFlagPYMKAddFriendsEntry (copy), p1 (copy), EventNames (copy), RecommendationContextType (copy), getFriendStatus (copy), v16 (copy), v17 (copy), FFlagHomepagePYMKPresenceAnalytics (copy), v18 (copy), llama (copy)
				for _, v in pairs(p5.changed) do
					local item = v.item
					local v26 = v15.current or {}
					local v27 = not v26[item.id]

					if getFFlagPYMKAddFriendsEntry() then
						v27 = not v26[item.id] and (not item.isTooltip and not item.isButtonTile)
					end

					if v27 then
						p1(EventNames.UserSeen, {
							userId = item.id,
							contactId = if item.recommendationContextType ~= RecommendationContextType.Contacts then nil else item.id,
							friendStatus = getFriendStatus(v16[item.id], v17[item.id]),
							recommendationContextType = item.recommendationContextType,
							recommendationRank = item.recommendationRank,
							absolutePosition = item.absolutePosition,
							presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else (v18[item.id] or {}).userPresenceType
						})
						v15.current = llama.Dictionary.join(v15.current, {
							[item.id] = true
						})
					end
				end
			end
		}}
	end, { if not FFlagHomepagePYMKPresenceAnalytics then nil else v18 })
end
