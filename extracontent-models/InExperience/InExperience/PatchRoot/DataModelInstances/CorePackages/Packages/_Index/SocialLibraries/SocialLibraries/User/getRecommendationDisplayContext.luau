local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local RecommendationContextType = require(SocialLibraries.dependencies).RoduxFriends.Enums.RecommendationContextType
local _ = {
	SingularMutualFriend = "Feature.Friends.Label.SingularMutualFriend",
	MutualFriends = "Feature.Friends.Label.MutualFriends",
	PlayedTogether = "Feature.Friends.Label.Frequent"
}

return function(t1: {[any]: any}) -- line: 55
	-- upvalues: RecommendationContextType (copy)
	local t2 = nil
	local v7 = nil
	local v8 = nil
	local v9 = t1.contextType and t1.contextType.rawValue() or nil
	local v10 = if not t1.mutualFriendsCount then t1.mutualFriendsList and #t1.mutualFriendsList or 0 else t1.mutualFriendsCount

	if v9 == RecommendationContextType.MutualFriends.rawValue() and v10 > 0 then
		function v8(p1) -- line: 65
			-- upvalues: v10 (copy)
			if p1 then
				return tostring(v10) .. " " .. string.lower(p1)
			end

			return nil
		end

		v7 = v10 ~= 1 and "Feature.Friends.Label.MutualFriends" or "Feature.Friends.Label.SingularMutualFriend"
		t2 = {
			path = "icons/status/player/friend"
		}
	elseif v9 == RecommendationContextType.Frequents.rawValue() then
		v7 = "Feature.Friends.Label.Frequent"
	end

	return {
		icon = t2,
		label = {
			text = nil,
			formatter = v8,
			textKey = v7
		}
	}
end
