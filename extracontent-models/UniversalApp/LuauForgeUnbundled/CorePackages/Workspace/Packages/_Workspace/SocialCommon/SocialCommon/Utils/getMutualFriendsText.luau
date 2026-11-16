return function(p2)
	if p2.mutualFriendsCount == 0 then
		return ""
	end

	if p2.mutualFriendsCount == 1 then
		return p2.localized.singularMutualConnection
	end

	return p2.localized.mutualConnections
end
