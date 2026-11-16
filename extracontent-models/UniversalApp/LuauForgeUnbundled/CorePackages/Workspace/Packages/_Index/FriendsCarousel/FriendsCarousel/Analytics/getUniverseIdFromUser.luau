require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/GraphQLServer")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Common/LocalTypes")

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
