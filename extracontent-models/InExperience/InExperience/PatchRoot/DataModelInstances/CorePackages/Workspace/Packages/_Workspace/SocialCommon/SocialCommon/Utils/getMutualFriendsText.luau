return function(p)
	if p.mutualFriendsCount == 0 then
		return ""
	end

	if p.mutualFriendsCount == 1 then
		return p.localized.singularMutualConnection
	end

	return p.localized.mutualConnections
end
