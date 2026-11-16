local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType

local _ = {
	SingularMutualFriend = "Feature.Friends.Label.SingularMutualFriend",
	MutualFriends = "Feature.Friends.Label.MutualFriends",
	PlayedTogether = "Feature.Friends.Label.Frequent"
}

local function fn(p) -- 1 equivalent call inferred from this helper
	if p.mutualFriendsCount then
		return p.mutualFriendsCount
	end

	return p.mutualFriendsList and #p.mutualFriendsList or 0
end

return function(p)
	local icon = nil
	local textKey = nil

	local fn2
	local v

	if p.contextType then
		v = p.contextType.rawValue() or nil
	end

	local v2 = fn(p) -- inferred equivalent call

	if v == recommendationContextType.MutualFriends.rawValue() and v2 > 0 then
		textKey = v2 == 1 and "Feature.Friends.Label.SingularMutualFriend" or "Feature.Friends.Label.MutualFriends"

		icon = { path = "icons/status/player/friend" }

		fn2 = function(value)
			if value then
				return tostring(v2) .. " " .. string.lower(value)
			end

			return nil
		end
	elseif v == recommendationContextType.Frequents.rawValue() then
		textKey = "Feature.Friends.Label.Frequent"
	end

	return {
		icon = icon,
		label = { formatter = fn2, text = nil, textKey = textKey }
	}
end
