return function(t1: {[any]: any}) -- line: 14
	if t1.mutualFriendsCount == 0 then
		return ""
	end

	if t1.mutualFriendsCount == 1 then
		return t1.localized.singularMutualConnection
	end

	return t1.localized.mutualConnections
end
