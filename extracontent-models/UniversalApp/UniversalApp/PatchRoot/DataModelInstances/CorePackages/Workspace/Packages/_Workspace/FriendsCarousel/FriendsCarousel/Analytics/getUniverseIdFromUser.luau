local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local FriendsCarouselParent = FriendsCarousel.Parent

require(FriendsCarouselParent.GraphQLServer)
require(FriendsCarousel.Common.LocalTypes)

return function(p1) -- line: 9
	local universeId = nil

	if p1.__typename == "Friend" then
		local v5 = p1.presence or {}

		if v5.universeId then
			return (tonumber(v5.universeId))
		end

		return nil
	end

	if p1.isFriendWithUser then
		universeId = p1.universeId
	end

	return universeId
end
