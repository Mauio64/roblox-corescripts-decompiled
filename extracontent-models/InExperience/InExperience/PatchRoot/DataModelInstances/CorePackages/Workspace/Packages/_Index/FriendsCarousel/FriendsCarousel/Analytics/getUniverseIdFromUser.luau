local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local parent = FriendsCarousel.Parent

require(parent.GraphQLServer)

require(FriendsCarousel.Common.LocalTypes)

return function(data)
	local universeId = nil

	if data.__typename == "Friend" then
		local presence = data.presence or {}

		if presence.universeId then
			return (tonumber(presence.universeId))
		end

		return nil
	end

	if data.isFriendWithUser then
		universeId = data.universeId
	end

	return universeId
end
