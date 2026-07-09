local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local EntityTypes = require(Parent.SocialLuaAnalytics).Analytics.Enums.EntityTypes
local getRecommendationContextualInfoType = require(Parent.SocialCommon).Utils.getRecommendationContextualInfoType
local EventNames = require(script.Parent.EventNames)
local useFireAnalyticsEvent = require(script.Parent.useFireAnalyticsEvent)
local AddFriendsState = require(Parent.AddFriendsState)
local RecommendationContextType = AddFriendsState.RoduxFriends.Enums.RecommendationContextType
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local AddFriendsSelector = AddFriendsState.AddFriendsSelector
local FFlagAddFriendsPYMKPresenceAnalytics = require(Parent.SharedFlags).FFlagAddFriendsPYMKPresenceAnalytics

return function(p1, p2, p3) -- line: 25
	-- upvalues: useFireAnalyticsEvent (copy), FFlagAddFriendsPYMKPresenceAnalytics (copy), useSelector (copy), AddFriendsSelector (copy), React (copy), RecommendationContextType (copy), getRecommendationContextualInfoType (copy), EntityTypes (copy), EventNames (copy)
	local v15 = useFireAnalyticsEvent()
	local v16 = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else useSelector(function(p4) -- line: 28
		-- upvalues: AddFriendsSelector (copy)
		return AddFriendsSelector(p4, "Presence.byUserId") or {}
	end)

	return React.useCallback(function(t1: {[any]: any}) -- line: 34
		-- upvalues: FFlagAddFriendsPYMKPresenceAnalytics (copy), p1 (copy), v16 (copy), RecommendationContextType (copy), getRecommendationContextualInfoType (copy), EntityTypes (copy), p2 (copy), v15 (copy), EventNames (copy), p3 (copy)
		local s1 = ""
		local s2 = ""
		local s3 = ""
		local s4 = ""
		local s5 = ""
		local s6 = ""
		local v25 = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else ""

		for _, v in ipairs(t1) do
			local v28 = p1[v]

			if v28 then
				local v29 = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else (v16 and v16[v28.id] or {}).userPresenceType
				local v30 = v28.contextType and v28.contextType == RecommendationContextType.Contacts

				s1 ..= (v28.id or (v28.entityId or "")) .. ","
				s2 ..= v .. ","
				s3 ..= (v28.rank or "") .. ","
				s4 ..= (getRecommendationContextualInfoType(v28) or "") .. ","
				s5 ..= (not v30 and "" or EntityTypes.Contact) .. ","
				s6 ..= math.floor((v - 1) / p2) + 1 .. ","
				v25 = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else v25 .. (v29 and tostring(v29) or "") .. ","
			end
		end

		v15(EventNames.UserTileImpression, {
			namespace = p3,
			targetUserId = s1,
			absolutePosition = s2,
			rank = s3,
			contextType = s4,
			entityType = s5,
			rowInSort = s6,
			presence = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else v25
		})
	end, {
		v15,
		p1,
		p2,
		p3,
		if not FFlagAddFriendsPYMKPresenceAnalytics then nil else v16
	})
end
